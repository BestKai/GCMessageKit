Pod::Spec.new do |s|
  s.name         = 'GCMessageKit'
  s.version      = '0.0.2'
  s.license      = 'LICENSE'
  s.homepage     = 'https://github.com/BestKai/GCMessageKit'
  s.authors      = { 'BestKai' => 'bestkai9009@gmail.com' }
  s.summary      = 'A weixin chat messageKit || 微信聊天界面'

  s.platform     =  :ios, '7.0'
  s.source       =  { git: 'https://github.com/BestKai/GCMessageKit.git', :tag => s.version }


    s.subspec 'Category' do |ss|
    ss.source_files = 'GCMessageKit/Category/*'
    ss.frameworks = 'MapKit'
    end

    s.subspec 'CommonHelper' do |ss|
    ss.source_files = 'GCMessageKit/CommonHelper/*'
    ss.dependency 'GCMessageKit/Macro'
    ss.dependency 'GCMessageKit/Category'
    ss.frameworks = 'AddressBook','AddressBookUI','Contacts','ContactsUI','AVFoundation'
    end

    s.subspec 'Controller' do |ss|
    ss.source_files = 'GCMessageKit/Controller/*'
    ss.dependency 'GCMessageKit/ModelView'
    ss.dependency 'GCMessageKit/MessageModel'
    ss.frameworks = 'MediaPlayer'
    end

    s.subspec 'InputView' do |ss|
    ss.source_files = 'GCMessageKit/InputView/*'

       ss.subspec 'ShareMenuView' do |sss|
       sss.source_files = 'GCMessageKit/InputView/ShareMenuView/*'
       sss.dependency 'GCMessageKit/Macro'
       end

       ss.subspec 'VoiceRecord' do |sss|
       sss.source_files = 'GCMessageKit/InputView/VoiceRecord/*'
       end

    end

    s.subspec 'Macro' do |ss|
    ss.source_files = 'GCMessageKit/Macro/*'
    end

    s.subspec 'MessageCell' do |ss|
    ss.source_files = 'GCMessageKit/MessageCell/*'
    ss.dependency 'GCMessageKit/ModelView'
    ss.dependency 'GCMessageKit/MessageModel'
    end

    s.subspec 'MessageModel' do |ss|
    ss.source_files = 'GCMessageKit/MessageModel/*'
    ss.dependency 'GCMessageKit/InputView/ShareMenuView'
    ss.dependency 'GCMessageKit/Macro'
    end


    s.subspec 'ModelView' do |ss|
    ss.source_files = 'GCMessageKit/ModelView/*'
    ss.dependency 'GCMessageKit/Macro'
    ss.dependency 'GCMessageKit/CommonHelper'

    end
  s.frameworks   = 'UIKit','Foundation'
  s.requires_arc = true
  
  s.dependency 'YYWebImage'
  s.dependency 'YYText'
  s.dependency 'SVProgressHUD'


end
