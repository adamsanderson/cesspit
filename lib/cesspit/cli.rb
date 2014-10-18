class Cesspit::CLI
  attr_reader :cesspit
  attr_reader :in, :out
  
  def initialize(options)
    @cesspit = Cesspit.new
    @in  = options[:in]
    @out = options[:out] || STDOUT
    
    options[:css_paths].each do |path| 
      cesspit.read_css(path)
    end
    
    if options[:html_paths]
      options[:html_paths].each do |path|
        cesspit.read_html(path)
      end
    end
    
  end
  
  def read_from(stream)
    stream.each(Cesspit::FILE_DELIMITER) do |html|
      cesspit.scan_html(html)
    end
  end
  
  def report
    out.puts(cesspit.to_s)
  end
  
end