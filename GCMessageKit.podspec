Pod::Spec.new do |s|
  s.name         = 'GCMessageKit'
  s.version      = '0.0.1'
  s.license      = 'LICENSE'
  s.homepage     = 'https://github.com/BestKai/GCMessageKit'
  s.authors      = { 'BestKai' => 'bestkai9009@gmail.com' }
  s.summary      = 'A weixin chat messageKit || 微信聊天界面'

  s.platform     =  :ios, '7.0'
  s.source       =  { git: 'https://github.com/BestKai/GCMessageKit.git', :tag => s.version }
  s.source_files = 'GCMessageKit/**/*.{h,m}'
  s.frameworks   =  'UIKit','Foundation'
  s.requires_arc = true
  
  s.dependencies =  "YYWebImage","YYText","AMap2DMap","AMapSearch","YAssetsPicker","SVProgressHUD"

end