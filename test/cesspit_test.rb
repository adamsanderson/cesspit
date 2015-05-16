# encoding: UTF-8

require 'minitest/autorun'
require 'stringio'
require_relative '../lib/cesspit'

class CesspitTest < Minitest::Test
  attr_accessor :cesspit

  def setup
    @cesspit = Cesspit.new
    @cesspit.io = StringIO.new
  end
  
  def test_all_selectors_are_unmatched_initially
    cesspit.add_css <<-CSS
      p.red  {color: red;}
      p.blue {color: blue;}
    CSS
    
    assert_equal 2, cesspit.unmatched_selectors.length
    assert_equal ["p.red", "p.blue"], cesspit.unmatched_selectors
  end
  
  def test_selectors_are_matched_when_they_are_found
    cesspit.add_css "p.red, p.blue {color: purple}"
    
    cesspit.scan_html <<-HTML
      <div>
        <p class='red'>Red</p>
      </div>
    HTML
    
    assert_equal ["p.blue"], cesspit.unmatched_selectors
  end
  
  def test_can_match_multiple_selectors_per_document
    cesspit.add_css "p.red, p.blue, p.yellow {color: white}"
    
    cesspit.scan_html <<-HTML
      <div>
        <p class='red'>Red</p>
        <p class='blue'>Blue</p>
      </div>
    HTML
    
    assert_equal ["p.yellow"], cesspit.unmatched_selectors
  end
  
  def test_ignores_invalid_selectors
    cesspit.add_css "p.red, yum(yellow), p.blue {color: white}"
    cesspit.add_css "hello x(world) {color: white}"
    
    cesspit.scan_html <<-HTML
      <div>
        <p class='red'>Red</p>
      </div>
    HTML
    
    assert_equal ["p.blue"], cesspit.unmatched_selectors
  end
  
  def test_warns_on_invalid_selectors
    cesspit.add_css "x(y) {color: white}"
    
    cesspit.scan_html <<-HTML
      <div>
        <p class='red'>Red</p>
      </div>
    HTML
    
    assert_equal 'Could not process "x(y)"', cesspit.io.string.chomp
  end
  
  def test_can_scan_multiple_html_documents
    cesspit.add_css "p.red, p.blue, p.yellow {color: pink}"
    
    cesspit.scan_html <<-HTML
      <div>
        <p class='red'>Red</p>
      </div>
    HTML
    
    cesspit.scan_html <<-HTML
      <div>
        <p class='blue'>Blue</p>
      </div>
    HTML
    
    assert_equal ["p.yellow"], cesspit.unmatched_selectors
  end
  
  def test_ignores_invalid_html
    cesspit.add_css "p.red, p.blue {color: pink}"
    
    cesspit.scan_html <<-HTML
      <div>
        <p class='blue'>
        <<p ><class='red'>Red</p>
      </div>
    HTML
    
    assert_equal ["p.red"], cesspit.unmatched_selectors
  end
  
  def test_anonymous_css_can_be_added_multiple_times
    cesspit.add_css <<-CSS
      p.red  {color: red;}
    CSS
    
    cesspit.add_css <<-CSS
      p.blue {color: blue;}
    CSS
    
    assert_equal 2, cesspit.unmatched_selectors.length
    assert_equal ["p.red", "p.blue"], cesspit.unmatched_selectors
  end
  
  def test_css_paths_are_only_added_once
    cesspit.add_css <<-CSS, "test.css"
      p.red  {color: red;}
    CSS
    
    cesspit.add_css <<-CSS, "test.css"
      p.blue {color: blue;}
    CSS
    
    assert_equal 1, cesspit.unmatched_selectors.length
    assert_equal ["p.red"], cesspit.unmatched_selectors
  end
  
  def test_stateful_pseudo_selectors_are_rewritten
    cesspit.add_css "a:focus {color: red}"
    assert_equal ["a"], cesspit.unmatched_selectors
  end
  
  def test_pseudo_selectors_after_attribute_matches_are_rewritten
    cesspit.add_css "[type=input]:focus {color: red}"
    assert_equal ["[type=input]"], cesspit.unmatched_selectors
  end
  
  def test_bare_pseudo_selectors_are_rewritten_as_wildcards
    cesspit.add_css ":focus {color: red}"
    assert_equal ["*"], cesspit.unmatched_selectors
  end
  
  def test_pseudo_elements_are_rewritten
    cesspit.add_css "div ::-ms-check {color: red}"
    assert_equal ["div *"], cesspit.unmatched_selectors
  end
  
end