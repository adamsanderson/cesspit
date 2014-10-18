# encoding: UTF-8

require 'minitest/autorun'
require_relative '../lib/cesspit'
require_relative '../lib/cesspit/cli'

class CLITest < Minitest::Test
  FIXTURE_DIR = File.join(File.dirname(__FILE__), 'fixtures')
  FILE_DELIMITER = Cesspit::FILE_DELIMITER
  
  def setup
    @out = StringIO.new
  end
  
  def test_reports_unused_selectors
    cli = Cesspit::CLI.new({
      :css_paths  => [fixture_path("colors.css")],
      :html_paths => [fixture_path("red.html")],
      :out        => @out
    })
    
    cli.report
    assert_includes output, ".blue"
  end
  
  def test_reports_paths_of_unused_css
    cli = Cesspit::CLI.new({
      :css_paths  => [fixture_path("colors.css")],
      :html_paths => [fixture_path("red.html")],
      :out        => @out
    })
    
    cli.report
    assert_includes output, fixture_path("colors.css")
  end
  
  def test_reports_nothing_when_all_selectors_are_used
    cli = Cesspit::CLI.new({
      :css_paths  => [fixture_path("colors.css")],
      :html_paths => [fixture_path("red.html"), fixture_path("blue.html")],
      :out        => @out
    })
    
    cli.report
    assert_equal "", output
  end
  
  def test_reads_files_from_io_stream
    cli = Cesspit::CLI.new({
      :css_paths  => [fixture_path("colors.css")],
      :out        => @out
    })
    
    in_io = StringIO.new
    
    open(fixture_path("red.html"),"r"){|io| in_io << io.read}
    in_io << FILE_DELIMITER
    open(fixture_path("blue.html"),"r"){|io| in_io << io.read}
    in_io << FILE_DELIMITER
    in_io.rewind
    
    cli.read_from(in_io)
    cli.report
    
    assert_equal "", output
  end
  
  private
  
  def fixture_path(name)
    File.join(FIXTURE_DIR,name)
  end
  
  def output
    @out.rewind
    @out.read.strip
  end
end