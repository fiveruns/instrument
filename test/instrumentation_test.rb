require File.dirname(__FILE__) << "/test_helper"
require 'stringio'

module Test
  class Widget
    def turn
    end
  end
  class FancyWidget < Widget
    def screw(direction)
      turn
    end
  end
end

module Test
  class Cat
    def meow
    end
  end
end

module Test
  class Dog
    def bark
    end
    def woof
    end
  end
end

context "Instrumentation" do
  
  def setup
    SimpleInstrumentation.clear
  end
  
  specify "executes hooks" do
  
    turns = []
    
      instrument 'Test::Widget#turn' do
        turns << :turn
      end
      instrument 'Test::FancyWidget#screw' do
        turns << :screw
      end
  
    widget = Test::FancyWidget.new
    4.times { widget.turn }
    widget.screw(:in)
    widget.screw(:out)
    
    assert_equal 8, turns.size
    assert_equal 6, turns.select { |t| t == :turn }.size
        
  end
  
  specify "works with multiple targets" do
    calls = 0
      instrument 'Test::Dog#bark', 'Test::Dog#woof' do
        calls += 1
      end
    dog = Test::Dog.new
    dog.bark
    dog.woof
    assert_equal 2, calls
    assert_equal 1, SimpleInstrumentation.handlers.size
  end
  
end

class Test::TargetA
end

class Test::TargetB
  def exists
  end
end

class Test::TargetC
  def exists
  end
end

class Test::TargetD
  def exists
  end
end


context "Gracefulness" do
  
  def setup
    @output = StringIO.new
  end
  
  specify "raises exception unless :graceful is set" do
    assert_raises SimpleInstrumentation::AttachmentError do
      instrument 'Test::BadConstant#does_not_exist' do
      end
    end
    assert_raises SimpleInstrumentation::AttachmentError do
      instrument 'Test::TargetA#does_not_exist' do
      end
    end
  end
  
  specify "silently fails to reinstrument already instrumented method" do
    foo = 0
    bar = 0
    instrument 'Test::TargetD#exists' do
      foo += 1
    end
    Test::TargetD.new.exists
    assert_equal 1, foo
    assert_equal 0, bar
    instrument 'Test::TargetD#exists' do
      bar += 1
    end
    Test::TargetD.new.exists
    assert_equal 1, foo
    assert_equal 1, bar
  end
  
end