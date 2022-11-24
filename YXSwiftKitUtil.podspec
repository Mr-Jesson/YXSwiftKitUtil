#
# Be sure to run `pod lib lint YXSwiftKitUtil.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.pod_target_xcconfig = { 'VALID_ARCHS' => 'x86_64 armv7 arm64' }
  s.name             = 'YXSwiftKitUtil'
  s.version          = '1.0.0'
  s.summary          = 'Swift常用Kit工具类'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/Mr-Jesson/YXSwiftKitUtil'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Mr-Jesson' => 'zjsaufe@qq.com' }
  s.source           = { :git => 'https://github.com/Mr-Jesson/YXSwiftKitUtil.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'YXSwiftKitUtil/Classes/**/*.swift'
  
   s.resource_bundles = {
     'YXSwiftKitUtil' => ['YXSwiftKitUtil/Classes/src/*.png']
   }

#   s.public_header_files = 'Pod/Classes/**/*'
  # s.frameworks = 'UIKit', 'MapKit'
   s.dependency 'SnapKit'
   s.dependency 'TangramKit'
   s.dependency 'Moya'
   s.dependency 'RxSwift'
   s.dependency 'RxCocoa'
   s.dependency 'RxDataSources'
   s.dependency 'dsBridge'
   s.dependency 'SwiftyJSON'
   s.dependency 'ObjectMapper'
end
