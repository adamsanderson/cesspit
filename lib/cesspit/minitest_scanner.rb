require_relative '../cesspit'

if defined?(Minitest)
  require_relative '../minitest/cesspit_plugin'
end

module Cesspit::MinitestScanner
  
  def self.enable!(*css_paths)
    raise ArgumentError, "Cesspit is already enabled." if enabled?
    cesspit = Cesspit.new
    css_paths.each{|path| cesspit.read_css(path) }
    
    yield cesspit if block_given?
    self.cesspit= cesspit
    
    if !defined?(Minitest) && defined(MiniTest)
      init_minitest_4x_integration 
    end
  end
  
  def self.enabled?
    !cesspit.nil?
  end
  
  def self.cesspit= cesspit
    @cesspit = cesspit
  end
  
  def self.cesspit
    @cesspit
  end
  
  def before_teardown
    return super unless Cesspit::MinitestScanner.enabled?
    
    response = instance_variable_get(:@repsonse)
    response ||= self.response if respond_to?(:response)

    if response &&
       response.respond_to?(:body)         &&
       response.respond_to?(:content_type) &&
       response.respond_to?(:status)
    
      if response.content_type.to_s.downcase == "text/html" &&
         (response.status/100 != 3)
       
         Cesspit::MinitestScanner.cesspit.scan_html(response.body)
      end
    end
  
    super
  end
  
  private
  
  def self.init_minitest_4x_integration
    MiniTest::Unit::TestCase.send :include, Cesspit::MinitestScanner

    # Inelegant, but patch the status method for MiniTest < 5.x
    MiniTest::Unit.class_eval do
      alias_method :status_without_cesspit, :status

      def status io = self.output
        io.puts Cesspit::MinitestScanner.cesspit
        status_without_cesspit(io)
      end
    end
  end
  
end