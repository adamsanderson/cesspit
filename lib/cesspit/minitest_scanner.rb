require_relative '../cesspit'

module Cesspit::MinitestScanner
  
  def self.cesspit= cesspit
    @cesspit = cesspit
  end
  
  def self.cesspit
    @cesspit ||= Cesspit.new
  end
  
  def before_teardown
    response = instance_variable_get(:@response)
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