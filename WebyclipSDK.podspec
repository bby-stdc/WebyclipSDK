Pod::Spec.new do |spec|
  spec.name = "WebyclipSDK"
  spec.version = "1.0.0"
  spec.summary = "Webyclip SDK"
  spec.homepage = "https://www.webyclip.com"
  spec.license = { type: 'MIT', file: 'LICENSE' }
  spec.authors = { "Webyclip" => 'info@webyclip.com' }

  spec.platform = :ios, "8.0"
  spec.requires_arc = true
  spec.source = { git: "https://github.com/enbaya/WebyclipSDK.git", tag: "v#{spec.version}", submodules: true }
  spec.source_files = "WebyclipSDK/**/*.{h,swift}"

  spec.dependency "SwiftyJSON", "~> 2.4.0"
  spec.dependency "Alamofire", "~> 3.0"
  spec.dependency "CryptoSwift", "~> 0.2.3"
end
