require 'rubygems'
require 'activesupport'

# call-seq:
#  instrument("ClassName#instance_method") { |instance, time, *args| ... }
#  instrument("ClassName::class_method") { |klass, time, *args| ... }
#  instrument("ClassName.class_method") { |klass, time, *args| ... }
#
# Add a handler to be called every time a method is invoked
def instrument(raw_target, &handler)
  SimpleInstrumentation.add(raw_target, &handler)
end

module SimpleInstrumentation
        
  class AttachmentError < ::NameError; end

  def self.handlers
    @handlers ||= []
  end
  
  # Clear all handlers (use with caution)
  def self.clear
    handlers.clear
  end

  def self.add(raw_target, &handler)
    obj, meth = case raw_target
    when /^(.+)#(.+)$/
      [$1.constantize, $2]
    when /^(.+)(?:\.|::)(.+)$/
      [(class << $1.constantize; self; end), $2]
    else
      raise ArgumentError, "Bad target format: #{raw_target}"
    end
    instrument(obj, meth, &handler)
  end  
    
  #######
  private
  #######

  def self.instrument(obj, meth, &handler)
    handlers << handler
    offset = handlers.size - 1
    code = wrapping meth, :simple_instrumentation |without|
      <<-CONTENTS
        # Invoke and time
        _start = Time.now
        _result = #{without}(*args, &block)
        _time = Time.now - _start
        # Call handler (don't change *args!)
        _instrumentation.handlers[#{offset}].call(self, _time, *args)
        # Return the original result
        _result
      CONTENTS
    end
    obj.module_eval code
  rescue => e
    raise AttachmentError, "Could not attach (#{e.message})"
  end

  def self.wrapping(meth, feature)
    format = meth =~ /^(.*?)(\?|!|=)$/ ? "#{$1}_%s_#{feature}#{$2}" : "#{meth}_%s_#{feature}" 
    <<-DYNAMIC
      if instance_methods.include?("#{format % :without}")
        # Skip instrumentation
      else
        def #{format % :with}(*args, &block)
          _instrumentation = ::SimpleInstrumentation
          #{yield(format % :without)}
        end
        alias_method_chain :#{meth}, :#{feature}
      end
    DYNAMIC
  end
      
end