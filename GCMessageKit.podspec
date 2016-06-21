Pod::Spec.new do |s|
  s.name         = 'GCMessageKit'
  s.version      = '0.0.1'
  s.license      = 'LICENSE'
  s.homepage     = 'https://github.com/BestKai/GCMessageKit'
  s.authors      = { 'BestKai' => 'bestkai9009@gmail.com' }
  s.summary      = 'A weixin chat messageKit || 微信聊天界面'

  s.platform     =  :ios, '7.0'
  s.source       =  { git: 'https://github.com/BestKai/GCMessageKit.git', :tag => s.version }


  s.subspec 'Category' do |ss|
  ss.source_files = 'GCMessageKit/Category/*.{h,m}'
  ss.frameworks = 'MapKit'
  end

    s.subspec 'CommonHelper' do |ss|
    ss.source_files = 'GCMessageKit/CommonHelper/*.{h,m}'
    ss.frameworks = 'AddressBook','AddressBookUI','Contacts','ContactsUI','AVFoundation'
    end


    s.subspec 'Controller' do |ss|
    ss.source_files = 'GCMessageKit/Controller/*.{h,m}'
    ss.frameworks = 'MediaPlayer'
    end

    s.subspec 'InputView' do |ss|
    ss.source_files = 'GCMessageKit/InputView/*.{h,m}'
    end

    s.subspec 'Macro' do |ss|
    ss.source_files = 'GCMessageKit/Macro/*.{h,m}'
    end

    s.subspec 'MessageCell' do |ss|
    ss.source_files = 'GCMessageKit/MessageCell/*.{h,m}'
    end

    s.subspec 'ModelView' do |ss|
    ss.source_files = 'GCMessageKit/ModelView/*.{h,m}'
    end

  s.resources = 'resource'
  s.frameworks   = 'UIKit','Foundation'
  s.requires_arc = true
  
  s.dependency 'YYWebImage'
  s.dependency 'YYText'
  s.dependency 'YAssetsPicker'
  s.dependency 'SVProgressHUD'


end
