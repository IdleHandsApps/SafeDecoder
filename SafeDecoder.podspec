Pod::Spec.new do |s|
  s.name             = "SafeDecoder"
  s.version          = "1.2"
  s.summary          = "A Codable extension to decode arrays and to catch & log all decoding failures"

  s.description      = <<-DESC
SafeDecoder makes two improvements for Codable models:
When decoding arrays it can skip over invalid objects, allowing your app to show just valid objects
It can also collect all the decoding errors and send them to your logging class or service
                       DESC

  s.homepage         = "https://github.com/IdleHandsApps/SafeDecoder/"
  s.license          = { :type => "MIT" }

  s.author           = { "Fraser Scott-Morrison" => "fraserscottmorrison@me.com" }

  s.ios.deployment_target = "9.0"

  s.swift_version = "5.0"

  s.source           = { :git => "https://github.com/IdleHandsApps/SafeDecoder.git", :tag => s.version.to_s }

  s.source_files = "Sources/*.swift"

  s.framework       = "UIKit"
  s.requires_arc    = true
end
