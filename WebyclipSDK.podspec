Pod::Spec.new do |spec|
  spec.name = "WebyclipSDK"
  spec.version = "1.0.0"
  spec.summary = "Webyclip SDK"
  spec.homepage = "https://www.webyclip.com"
  spec.license = { type: 'MIT', file: 'LICENSE' }
  spec.authors = { "Webyclip" => 'info@webyclip.com' }

  spec.platform = :ios, "9.0"
  spec.requires_arc = true
  spec.source = { git: "https://github.com/enbaya/WebyclipSDK.git", tag: "v#{spec.version}", submodules: true }
  spec.source_files = "WebyclipSDK/**/*.{h,swift,m}"
  spec.resources = "WebyclipSDK/**/*.{xib,xcassets,bundle}"

  spec.dependency "SwiftyJSON"
  spec.dependency "Alamofire"
  spec.dependency "CryptoSwift"
end
