require File.dirname(__FILE__) + '/setup'

require 'log4jruby'

logger = Log4jruby::Logger.get('test', :trace => true, :level => :debug)

logger.debug("hello world")

class MyClass
  def initialize
    @logger = Log4jruby::Logger.get(self.class.name, :level => :debug, :trace => true)
  end
  
  def foo
    @logger.debug("hello from foo")
    raise "foo error"
  end

  def bar
    @logger.debug("hello from bar")
    foo
  end

  def baz
    @logger.debug("hello from baz")
    begin
      bar
    rescue => e
      @logger.error(e)
    end
  end
end

o = MyClass.new
o.baz

logger.debug("changing log level for MyClass to ERROR directly through log4j")

myclass_logger = Log4jruby::Logger['MyClass']
myclass_logger.level = :error

logger.debug("calling baz again")
o.baz

