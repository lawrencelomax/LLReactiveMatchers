Pod::Spec.new do |s|
  s.ios.deployment_target = "6.0"
  s.requires_arc = true
  
  s.name         = "LLReactiveMatchers"
  s.version      = "0.0.1"  
  s.summary      = "Expecta matchers for ReactiveCocoa."
  s.description  = "Expecta matchers for ReactiveCocoa. Yay."
  s.homepage     = "https://github.com/lawrencelomax/LLReactiveMatchers"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Lawrence Lomax" => "lomax.lawrence@gmail.com" }
  s.source       = { :git => "https://github.com/lawrencelomax/LLReactiveMatchers.git", :commit => "db86084d6445df422c15150adc689f0c9e6ba7a1" }

  s.source_files  = 'LLReactiveMatchers/**/*.{h,m}'
  s.prefix_header_file = 'LLReactiveMatchers/LLReactiveMatchers-Prefix.pch'

  s.frameworks   = 'Foundation', 'XCTest'  

  s.dependency 'ReactiveCocoa', '~>2.0'
  s.dependency 'Expecta'
  s.dependency 'Specta'
end
