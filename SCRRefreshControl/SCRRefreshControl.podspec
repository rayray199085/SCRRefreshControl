Pod::Spec.new do |spec|
  spec.name         = "SCRRefreshControl"
  spec.version      = "0.0.8"
  spec.summary      = "Custom Refresh Control"
  spec.homepage     = "https://github.com/rayray199085/SCRRefreshControl"
  spec.license      = "MIT"
  spec.author       = { "Rui Cao" => "rayray199085@gmail.com" }
  spec.platform     = :ios, "9.0"
  spec.source       = { :git => "https://github.com/rayray199085/SCRRefreshControl.git", :tag => spec.version }
  spec.source_files  = "SCRRefreshControl", "SCRRefreshControl/MyFrame/**/*.{swift,xib}"
  spec.requires_arc = true
  spec.swift_version = '4.0'
  spec.resources = "SCRRefreshControl/MyFrame/Resources.bundle"
end
