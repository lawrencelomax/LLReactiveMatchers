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
  s.source       = { :git => "https://github.com/lawrencelomax/LLReactiveMatchers.git", :commit => "6900ce27d9141f6824d2a3d632b5f03f76844579" }

  s.source_files  = 'LLReactiveMatchers/**/*.{h,m}'
  s.prefix_header_file = 'LLReactiveMatchers/LLReactiveMatchers-Prefix.pch'

  s.frameworks   = 'Foundation', 'XCTest'  

  s.dependency 'ReactiveCocoa', '>=2.1.7'
  s.dependency 'Expecta'
  s.dependency 'Specta'
end
