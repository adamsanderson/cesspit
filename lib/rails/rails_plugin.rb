module Cesspit::RailsPlugin
  
  def add_asset(path)
    css = assets[path].to_s
    add_css(css, path)
  end
  
  def add_all_assets
    all_paths   = assets.each_logical_path.select{|path| path.ends_with? '.css' }
    child_paths = all_paths.map{|p| assets[p].dependencies.map{|d| d.logical_path } }.flatten
    
    (all_paths - child_paths).each do |path|
      add_asset(path)
    end
  end
  
  def assets
    Rails.application.assets
  end
  
end

Cesspit.send :include, Cesspit::RailsPlugin