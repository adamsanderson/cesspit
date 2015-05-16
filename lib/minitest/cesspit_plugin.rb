require_relative '../cesspit/minitest_scanner'

# Minitest Plugin for Minitest 5.x
module Minitest
  def self.plugin_cesspit_options(opts, options)
    opts.on "--cesspit PATHS", Array, "Enable Cesspit response scanning" do |paths|
      options[:cesspit] = paths
    end
  end

  def self.plugin_cesspit_init(options)
    paths = options[:cesspit] || []
    if !paths.empty?
      # Include hooks for MinitestScanner
      Minitest::Test.send :include, Cesspit::MinitestScanner
      cesspit = Cesspit::MinitestScanner.cesspit
      
      paths.each{|path| cesspit.read_css(path) }
      
      # Set up CesspitReporter
      self.reporter << CesspitReporter.new(options[:io], options)
    end
  end
  
  class CesspitReporter < Minitest::Reporter
    def report
      io.puts Cesspit::MinitestScanner.cesspit
    end
  end
  
end