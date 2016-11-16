Pod::Spec.new do |s|
  s.name             = 'WebyclipSDK'
  s.version          = '0.6.3'
  s.summary          = 'iOS SDK for Webyclip widgets'
  s.description      = 'A native iOS SDK to show webyclip curated videos based on app content using the Webyclip Service'
  s.homepage         = 'https://github.com/enbaya/WebyclipSDK'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Nimrod Ben Yaakov' => 'nimiby@gmail.com' }
  s.source           = { git: "https://github.com/enbaya/WebyclipSDK.git", tag: s.version }

  s.ios.deployment_target = '9.0'

  s.source_files = 'WebyclipSDK/Classes/**/*'
  
  s.resources = 'WebyclipSDK/Assets/**/*.{xib,xcassets,bundle}'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'

   s.dependency "SwiftyJSON", "~> 3.1.1"
   s.dependency "Alamofire", "~> 4.0.1"
   s.dependency "CryptoSwift", "~> 0.6.6"
   s.dependency "youtube-ios-player-helper", "~> 0.1.6"
end
