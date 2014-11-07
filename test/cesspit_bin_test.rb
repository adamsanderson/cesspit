require 'minitest/autorun'

class CesspitBinTest < Minitest::Test
  ROOT_PATH    = File.dirname(__FILE__) + "/../"
  FIXTURE_PATH = ROOT_PATH + "test/fixtures/"
  BIN_PATH     = ENV['BIN_PATH'] || ROOT_PATH + "bin/cesspit"  
  
  def test_scans_input_files
    css_path  = FIXTURE_PATH + "colors.css"
    html_path = FIXTURE_PATH + "blue.html"
    
    out = bin("--css #{css_path}", "--html #{html_path}")
    
    assert out.include?(".red"), "Should report that .red is not used.\n#{out.inspect}"
  end
  
  def test_scans_file_stream
    css_path  = FIXTURE_PATH + "colors.css"

    stdin = ["red.html", "blue.html"].map do |path|
      open(FIXTURE_PATH + path, "r"){|io| io.read }
    end
    
    out = pipe("--css #{css_path}", stdin.join(Cesspit::FILE_DELIMITER) )
    assert out.strip.empty?, "Should have read both html files and matched all selectors."
  end
  
  def test_prints_version
    out = bin("--version")
    
    assert_equal Cesspit::VERSION, out
  end
  
  def test_prints_usage_in_help
    out = bin("--help")
    
    assert_includes out, BIN_PATH
  end
  
  private
  
  def bin(*arguments)
    stdout = `#{BIN_PATH} #{arguments.join(' ')}`
    stdout.chomp
  end
  
  def pipe(*arguments)
    stdin = arguments.pop
    IO.popen "#{BIN_PATH} #{arguments.join(' ')}", "r+" do |io|
      io.write(stdin)
      io.close_write
      io.read
    end  
  end
  
end