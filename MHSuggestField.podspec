#
# Be sure to run `pod lib lint MHSuggestField.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MHSuggestField'
  s.version          = '0.1.0'
  s.summary          = 'A textfield with an optional auto suggest view.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
A textfield with an optional list of suggested values that the user can pick from. You can restrict the user to pick a value from the list or leave it free.
                       DESC

  s.homepage         = 'https://github.com/mazenhalawi/MHSuggestField.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Mazen' => 'mazen.halawi79@hotmail.com' }
  s.source           = { :git => 'https://github.com/mazenhalawi/MHSuggestField.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '12.0'

  s.source_files = 'MHSuggestField/Classes/**/*'
  
  # s.resource_bundles = {
  #   'MHSuggestField' => ['MHSuggestField/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.swift_version = '4.0'
end
