#
# Be sure to run `pod lib lint YHNetWork.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YHNetWork'
  s.version          = '0.1.0'
  s.summary          = 'YHNetWork.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'A short description of YHNetWork.'

  s.homepage         = 'https://github.com/cloverapp1/YHNetWork'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'cloverapp' => '2510479687@qq.com' }
  s.source           = { :git => 'https://github.com/cloverapp1/YHNetWork.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'YHNetWork/Classes/**/*'
  
  # s.resource_bundles = {
  #   'YHNetWork' => ['YHNetWork/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'AFNetworking', '~> 3.2.0'
  s.dependency 'MJExtension','~>3.0.13'
  s.dependency 'MBProgressHUD','~>1.1.0'
  s.dependency 'YLJsonLib','~>0.1.7'
end
