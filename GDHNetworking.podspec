Pod::Spec.new do |s|

  s.name         = "GDHNetworking"
  s.version      = "3.0.0"
  s.summary      = "GDHNetworking is a high level request util based on AFNetworking."
  s.homepage     = "https://github.com/gdhGaoFei/GDHNetworking"
  s.license      = "MIT"
  s.author       = { "高得华" => "gdhgaofei@163.com" }
  s.source        = { :git => "https://github.com/gdhGaoFei/GDHNetworking.git", :tag => s.version.to_s }
  s.source_files  = "GDHNetworking", "*.{h,m}"
  s.requires_arc  = true

  s.resources = 'GDHNetworking/images/*.png'

  s.ios.deployment_target = "7.0"
  s.framework = "CFNetwork"

  s.dependency "AFNetworking", "~> 3.1.0"
  s.dependency "MBProgressHUD", "~> 0.9.2"
  s.dependency "XMLDictionary", "~> 1.4.1"
end
