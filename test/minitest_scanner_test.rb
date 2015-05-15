# encoding: UTF-8

require 'minitest/autorun'
require 'minitest/mock'
require_relative '../lib/cesspit'
require_relative '../lib/cesspit/minitest_scanner'

class MinitestIntegrationTest < Minitest::Test
  
  def setup
    @cesspit = Minitest::Mock.new
    Cesspit::MinitestScanner.cesspit = @cesspit
  end
  
  def teardown
    @cesspit.verify
    @cesspit = nil
    Cesspit::MinitestScanner.cesspit = nil
  end
  
  def test_scans_generated_response
    @cesspit.expect(:scan_html, nil, [String]) 
    execute_fake_test :test_html_response
  end
  
  def test_ignores_empty_response
    execute_fake_test :test_empty_response
  end
  
  def test_ignores_non_html_responses
    execute_fake_test :test_non_html_response
  end
  
  def test_ignores_redirects
    execute_fake_test :test_redirect
  end
  
  private
  
  def execute_fake_test(name)
    test_suite = FakeTest.new
    
    test_suite.send name
    test_suite.before_teardown
    test_suite.teardown
  end
  
  # This class should look just enough like a Minitest::Test to pass for
  # our purposes.
  # 
  class FakeTest
    include Minitest::Test::LifecycleHooks
    include Cesspit::MinitestScanner
    DummyResponse = Struct.new(:body, :status, :content_type)
  
    attr_reader :response

    def teardown
      @response = nil
    end
  
    def test_html_response
      @response = DummyResponse.new(<<-HTML, 200, "text/html")
        <html>
          <body>
            <p class='red'> Red! </p>
          </body>
        </html>
      HTML
    end
    
    def test_empty_response
      @response = nil
    end
    
    def test_non_html_response
      @response = DummyResponse.new(<<-TEXT, 200, "text/plain")
      Quacks like a Response!
           `.
              <[' )
               /  \         <p class='red'> Red! </p>
              |  v |         ^-- Don't want to match this.
              `----'
               _/_|
      TEXT
    end
    
    def test_redirect
      @response = DummyResponse.new(<<-TEXT, 302, "text/html")
        <p class='red'>
          Redirected to localhost
        </p>
      TEXT
    end
  end
  
end