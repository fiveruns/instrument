fiveruns-core
    FiveRuns Corporation
    RDoc, Gems: http://fiveruns.rubyforge.org/fiveruns-core
    Source: http://github.com/fiveruns/fiveruns-core

== DESCRIPTION:

Basic DSL-style API for instrumenting Ruby methods.

== FEATURES/PROBLEMS:

TODO

== SYNOPSIS:

  class Foo
    def go
      sleep(rand(10) / 10)
    end
  end
  
  invocations = []
  Fiveruns::Core::Instrumentation.new do
    instrument 'Foo#go' do |obj, time, *args|
      invocations << time
    end
  end
  
  foo = Foo.new
  5.times { foo.go }
  invocations.size # => 5
  invocations.max # => the max time spent invoking Foo#go

== REQUIREMENTS:

* activesupport

== INSTALL:

* sudo gem install fiveruns-core

== LICENSE:

(The FiveRuns License)

Copyright (c) 2008 FiveRuns Corporation

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
