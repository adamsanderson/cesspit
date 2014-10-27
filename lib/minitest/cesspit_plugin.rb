# Minitest Plugin for Minitest 5.x
module Minitest
  def self.plugin_cesspit_options(opts, options)
    opts.on "--cesspit", "Enable Cesspit response scanning" do
      options[:cesspit] = true
    end
  end

  def self.plugin_cesspit_init(options)
    if options[:cesspit] || Cesspit::MinitestScanner.enabled?
      # Include hooks for MinitestScanner
      Minitest::Test.send :include, Cesspit::MinitestScanner
      
      # Set up CesspitReporter
      self.reporter << CesspitReporter.new(options[:io], options)
    end
  end
  
  begin 
    class CesspitReporter < Minitest::Reporter
      def report
        io.puts Cesspit::MinitestScanner.cesspit
      end
    end
    
  rescue NameError
  end
end