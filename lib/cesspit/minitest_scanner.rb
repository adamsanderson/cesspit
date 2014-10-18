module Cesspit::MinitestScanner
  
  def enable!(*css_paths)
    raise ArgumentError, "Cesspit is already enabled." if enabled?
    cesspit = Cesspit.new
    css_paths.each{|path| cesspit.read_css(path) }
    
    yield cesspit if block_given?
    self.cesspit= cesspit
    
    at_exit do
      STD_OUT
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
    
    if respond_to?(:response)              &&
       response.respond_to?(:body)         &&
       response.respond_to?(:content_type) &&
       response.respond_to?(:status_code)
    
      if response.content_type.downcase == "text/html" &&
         (response.status_code/100 != 3)
       
         Cesspit::MinitestScanner.cesspit.scan_html(response.body)
      end
    end
  
    super
  end
  
end