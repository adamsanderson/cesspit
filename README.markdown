Cesspit
=======

Clean up your stinking pit of css.

Cesspit finds unused CSS by comparing your css to examples of your HTML.  You can either provide HTML files, or integrate Cesspit with existing test suites.

Standalone Usage 
----------------

You can analyze CSS using the standalone `cesspit` script:

~~~ shell
$ cesspit --css test/fixtures/colors.css --html test/fixtures/red.html
test/fixtures/colors.css
	.blue
~~~

You may pass as many CSS and HTML documents as you like in.  When Cesspit is done, it will print out unused selectors and the CSS files they were declared in.

Test Integration 
----------------

Why bother generating piles of HTML documents when your tests already do it for you?

If you're using the Minitest, use the `Cesspit::MinitestScanner`.  For instance, in Rails, add this to your `test_helper.rb` file:

~~~ ruby
require 'cesspit/minitest_scanner'

# Enable Cesspit
Cesspit::MinitestScanner.enable! do |cesspit|
  # Add a normal stylesheet:
  cesspit.read_css  "public/stylesheets/reset.css"
end
~~~

When your tests complete, Cesspit will print out all the selectors that weren't used.

To conditionally run Cesspit, you can wrap its configuration in an environment variable:

~~~ ruby
require 'cesspit/minitest_scanner'

# Run with: `CESSPIT=1 rake test`
if ENV["CESSPIT"]
  Cesspit::MinitestScanner.enable! do |cesspit|
    cesspit.add_all_assets
  end
end
~~~

TODO
----

* Add better hooks for Rails intercepting rails requests.
* Add support for other test frameworks.

LICENSE:
--------

(The MIT License)

Copyright (c) Adam Sanderson

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


-----

Adam Sanderson, http://www.monkeyandcrow.com