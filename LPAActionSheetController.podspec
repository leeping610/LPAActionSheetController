#
# Be sure to run `pod lib lint LPAActionSheetController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LPAActionSheetController'
  s.version          = '0.1.1'
  s.summary          = '一个类似actionSheet的菜单.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = '一个类似actionSheet的底部弹出菜单'

  s.homepage         = 'https://github.com/leeping610/LPAActionSheetController'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'leeping' => 'liping_000@126.com' }
  s.source           = { :git => 'https://github.com/leeping610/LPAActionSheetController.git', :tag => '0.1.1' }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'LPAActionSheetController/Classes/**/*'
  
  s.resource_bundles = {
    'LPAActionSheetController' => ['LPAActionSheetController/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
