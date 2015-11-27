Pod::Spec.new do |s|
  s.name         = "AnimatedStackView"
  s.version      = "0.0.2"
  s.summary      = "Transition between UIViews with custom animations"
  s.description  = <<-DESC
AnimatedStackView allows you to transition between UIViews using your own custom animations. You can push and pop any views onto the stack and the framework will animate between the them by using the properties you've defined. You can animate between the frame, transform and alpha.
                   DESC
  s.homepage     = "https://github.com/rechsteiner/AnimatedStackView"  
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author    = "Martin Rechsteiner"
  s.social_media_url   = "http://twitter.com/rechsteiner"
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/rechsteiner/AnimatedStackView.git", :tag => "0.0.2" }
  s.source_files  = "AnimatedStackView/*.swift"
  s.requires_arc = true
end
