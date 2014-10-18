require 'nokogiri'
require 'css_parser'
require_relative './version'

class Cesspit
  # http://en.wikipedia.org/wiki/Delimiter#ASCII_delimited_text
  FILE_DELIMITER = 28.chr
  
  attr_reader :selectors_by_source
  
  def initialize
    @selectors_by_source = {}
  end
  
  def read_css(path)
    open(path, "r") do |io|
      add_css(io.read, path)
    end
  end
  
  def add_css(text, path=nil)
    path ||= "anonymous_#{selectors_by_source.length}.css"
    
    if !has_css_path?(path)
      @selectors_by_source[path] = extract_selectors(text)
    end
  end
  
  def has_css_path?(path)
    selectors_by_source.has_key? path
  end
  
  def read_html(path)
    open(path, "r") do |io|
      scan_html(io.read)
    end
  end
  
  def scan_html(html)
    doc = Nokogiri::HTML(html)
    
    selectors_by_source.each do |path, selectors|
      selectors.reject! do |selector|
        doc.at_css(selector)
      end
    end
  end
  
  def unmatched_selectors
    selectors_by_source.values.flatten
  end
  
  def to_s
    out = []
    selectors_by_source.each do |path, selectors|
      if !selectors.empty?
        out << path
        
        selectors.each do |selector|
          out << "\t#{selector}"
        end
      end
    end
    
    out.join("\n")
  end
  
  private
  
  def extract_selectors(text)
    parser = CssParser::Parser.new(
      :absolute_paths => false,
      :import => false
    )
    
    all_selectors = []
    parser.add_block!(text)
    parser.each_selector do |selector, declarations, specificity, media_types|
      all_selectors << selector
    end
    
    all_selectors
  end
end