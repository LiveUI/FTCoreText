Pod::Spec.new do |s|

  s.name         = "FTCoreText"
  s.version      = "1.0"
  s.summary      = "An open source Objective-C interface component that makes use of the CoreText framework to render static text content using a highly customisable markup syntax."
  s.homepage     = "https://github.com/FuerteInternational/FTCoreText"
  s.screenshots  = "https://raw.github.com/FuerteInternational/FTCoreText/documentation/screenshots/ftcoretext-screenshot-1.png", "https://raw.github.com/FuerteInternational/FTCoreText/documentation/screenshots/ftcoretext-screenshot-1.png", "https://raw.github.com/FuerteInternational/FTCoreText/documentation/screenshots/ftcoretext-screenshot-3.png"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Fuerte International" => "open-source@fuerteint.com" }
  s.platform     = :ios, '3.2'
  s.source       = {
  	:git => "https://github.com/FuerteInternational/FTCoreText.git",
  	:tag => "1.0"
  }
  s.source_files  = 'FTCoreText/*.{h,m}'
  s.framework  = 'CoreText'

end
