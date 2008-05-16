require File.dirname(__FILE__) << "/test_helper"
require 'stringio'

module Fake
  class Widget
    def turn
    end
  end
  class FancyWidget < Widget
    def screw(direction)
      turn
    end
  end
  class Cat
    def meow
    end
  end
  class Dog
    def bark
    end
    def woof
    end
  end
  
  class TargetA
  end

  class TargetB
    def exists
    end
  end

  class TargetC
    def exists
    end
  end

  class TargetD
    def exists
    end
  end
  
end


class InstrumentFake < Test::Unit::TestCase

  context "Correct Behavior" do
  
    setup do
      Instrument.handlers.clear
    end
  
    should "executes hooks" do
  
      turns = []
    
        instrument 'Fake::Widget#turn' do
          turns << :turn
        end
        instrument 'Fake::FancyWidget#screw' do
          turns << :screw
        end
  
      widget = Fake::FancyWidget.new
      4.times { widget.turn }
      widget.screw(:in)
      widget.screw(:out)
    
      assert_equal 8, turns.size
      assert_equal 6, turns.select { |t| t == :turn }.size
        
    end
  
    should "works with multiple targets" do
      calls = 0
      instrument 'Fake::Dog#bark', 'Fake::Dog#woof' do
        calls += 1
      end
      dog = Fake::Dog.new
      dog.bark
      dog.woof
      assert_equal 2, calls
      assert_equal 1, Instrument.handlers.size
    end
  
  end

  context "Errors" do
  
    setup do
      @output = StringIO.new
    end
  
    should "raise exceptions on bad targets" do
      assert_raises NameError do
        instrument 'Fake::BadConstant#does_not_exist' do
        end
      end
      assert_raises Instrument::Error do
        instrument 'Fake::TargetA#does_not_exist' do
        end
      end
    end
  
    should "silently fail to reinstrument already instrumented methods" do
      foo = 0
      bar = 0
      instrument 'Fake::TargetD#exists' do
        foo += 1
      end
      Fake::TargetD.new.exists
      assert_equal 1, foo
      assert_equal 0, bar
      instrument 'Fake::TargetD#exists' do
        bar += 1
      end
      Fake::TargetD.new.exists
      assert_equal 2, foo
      assert_equal 0, bar
    end
  
  end

end