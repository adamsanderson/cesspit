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

If you're using the Minitest, include `Cesspit::MinitestScanner`.  For instance, in Rails, add this to your `test_helper.rb` file:

~~~ ruby
# Include Cesspit's MinitestScanner:
include Cesspit::MinitestScanner

# Enable Cesspit
Cesspit::MinitestScanner.enable! do |cesspit|
  # Assuming your compiled CSS file is called `application.css`:
  cesspit.add_css Rails.application.config.assets['application.css'], 'application.css'
end
~~~

When your tests complete, Cesspit will print out all the selectors that weren't used.

Other Frameworks 
----------------

If you are interested in extending Cesspit to support other test frameworks such as rspec or cucumber, let me know.

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