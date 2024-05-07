#
# Be sure to run `pod lib lint XMKit_zhf.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'XMKit_zhf'
  s.version          = '1.0.0'
  s.summary          = 'XMKit_zhf. iLife 游戏 新马 韩国 繁体'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/MF-dosear/XMKit_zhf'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'dosear@qq.com' => 'dosear@qq.com' }
  s.source           = { :git => 'https://github.com/MF-dosear/XMKit_zhf.git', :tag => s.version.to_s }
  
  #sdk 支持最低版本
  s.ios.deployment_target = '13.0'
  
  #不支持模拟器
  s.pod_target_xcconfig = {
    'VALID_ARCHS[sdk=iphonesimulator*]' => ''
  }

  #是否支持ARC
  #s.requires_arc = true
  
  #swift版本
  s.swift_version = ['5']
  
  #模式arm64
  valid_archs = ['arm64','x86_64','armv7']
  
  #设置为静态库
#  s.static_framework = true

  #暴露的头文件
  s.public_header_files = [
    'XMKit_zhf/Classes/XMSDK.h',
    'XMKit_zhf/Classes/XMManager.h',
    'XMKit_zhf/Classes/Common/XMCommon.h',
    'XMKit_zhf/Classes/XMDelegate.h',
    'XMKit_zhf/Classes/M/XMInfos.h',
    'XMKit_zhf/Classes/Lib/Singleton.h',
  ]

  #系统资源
  s.source_files = [
    'XMKit_zhf/Classes/**/*',
  ]
  
  #系统库framework
  s.frameworks  = [
  'StoreKit',
  'WebKit',
  'WatchConnectivity',
  'Social',
  'EventKit',
  'SystemConfiguration',
  'MobileCoreServices',
  'MessageUI',
  'JavaScriptCore',
  'CoreTelephony',
  'CoreMedia',
  'AVFoundation',
  'AudioToolbox',
  'AdSupport',
  'UIKit'
  ]
  
  #系统库library
  s.libraries = [
  'z',
  'z.1.2.5',
  'bz2.1.0',
  'c++'
  ]

  #引用外部framework库
  s.vendored_frameworks = [
  'XMKit_zhf/Frameworks/**/*.xcframework'
  ]
  
  #引用外部library库
  #s.vendored_libraries = ['XMKit_zhf/Libraries/*']
  
  #bundles
  s.resource_bundles = {
      'XMKit_zhf' => ['XMKit_zhf/Assets/*']
  }
  
  #pch
  s.prefix_header_file = 'XMKit_zhf/Classes/Header/ZPHeader.pch'
  
  # 指定Info.plist文件
  s.info_plist = {
      
  }
  
  #引用git第三方库
  s.dependency 'AppLovinSDK'
  s.dependency 'AppLovinMediationFyberAdapter'
  s.dependency 'AppLovinMediationGoogleAdManagerAdapter'
  s.dependency 'AppLovinMediationGoogleAdapter'
  s.dependency 'AppLovinMediationInMobiAdapter'
  s.dependency 'AppLovinMediationIronSourceAdapter'
  s.dependency 'AppLovinMediationVungleAdapter'
  s.dependency 'AppLovinMediationFacebookAdapter'
  s.dependency 'AppLovinMediationMintegralAdapter'
  s.dependency 'AppLovinMediationUnityAdsAdapter'
  s.dependency 'AppLovinMediationVerveAdapter'
  
  s.dependency 'AppsFlyerFramework', '~> 6.14.0'
  s.dependency 'FirebaseAnalytics', '~> 10.24.0'
  s.dependency 'FirebaseMessaging', '~> 10.24.0'

  s.dependency 'Masonry', '~> 1.1.0'
  s.dependency 'SVProgressHUD', '~> 2.3.1'
  s.dependency 'YYText', '~> 1.0.7'
  s.dependency 'AvoidCrash', '~> 2.5.2'
  s.dependency 'IQKeyboardManager', '~> 6.5.18'
  s.dependency 'AFNetworking', '~> 4.0.1'
  s.dependency 'JKCategories', '~> 1.9.3'
  s.dependency 'FMDB', '~> 2.7.10'

end
