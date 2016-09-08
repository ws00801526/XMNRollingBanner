Pod::Spec.new do |s|
  s.name         = "XMNRollingBanner"
  s.version      = "1.0.0"
  s.summary      = "无限循环滚动banner"
  s.description  = "基于UICollectionView封装的banner,如果您发现什么bug或者有什么问题,可以联系我"
  s.homepage     = "https://github.com/ws00801526/XMNRollingBanner"
  s.license      = "MIT"
  s.author       = { "XMFraker" => "3057600441@qq.com" }  
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/ws00801526/XMNRollingBanner.git", :tag => s.version }
  s.source_files = "./XMNRollingBannerExample/XMNBanner/**/*.{h,m}"
  s.ios.frameworks   = "UIKit", "Foundation"
  s.requires_arc = true
end
