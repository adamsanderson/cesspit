require_relative '../cesspit'

module Cesspit::MinitestScanner
  
  def self.enable!(*css_paths)
    raise ArgumentError, "Cesspit is already enabled." if enabled?
    cesspit = Cesspit.new
    css_paths.each{|path| cesspit.read_css(path) }
    
    yield cesspit if block_given?
    self.cesspit= cesspit
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
end