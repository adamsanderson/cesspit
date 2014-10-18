# encoding: UTF-8

require 'minitest/autorun'
require_relative '../lib/cesspit'

class CesspitTest < Minitest::Test
  
  def test_all_selectors_are_unmatched_initially
    pit = Cesspit.new
    pit.add_css <<-CSS
      p.red  {color: red;}
      p.blue {color: blue;}
    CSS
    
    assert_equal 2, pit.unmatched_selectors.length
    assert_equal ["p.red", "p.blue"], pit.unmatched_selectors
  end
  
  def test_selectors_are_matched_when_they_are_found
    pit = Cesspit.new
    pit.add_css "p.red, p.blue {color: purple}"
    pit.scan_html <<-HTML
      <div>
        <p class='red'>Red</p>
      </div>
    HTML
    
    assert_equal ["p.blue"], pit.unmatched_selectors
  end
  
  def test_anonymous_css_can_be_added_multiple_times
    pit = Cesspit.new
    pit.add_css <<-CSS
      p.red  {color: red;}
    CSS
    
    pit.add_css <<-CSS
      p.blue {color: blue;}
    CSS
    
    assert_equal 2, pit.unmatched_selectors.length
    assert_equal ["p.red", "p.blue"], pit.unmatched_selectors
  end
  
  def test_css_paths_are_only_added_once
    pit = Cesspit.new
    pit.add_css <<-CSS, "test.css"
      p.red  {color: red;}
    CSS
    
    pit.add_css <<-CSS, "test.css"
      p.blue {color: blue;}
    CSS
    
    assert_equal 1, pit.unmatched_selectors.length
    assert_equal ["p.red"], pit.unmatched_selectors
  end
    
end