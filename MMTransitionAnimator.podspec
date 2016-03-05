#
#  Be sure to run `pod spec lint MMTransitionAnimator.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = 'MMTransitionAnimator'
  s.version      = '0.0.1'
  s.license      = { :type => 'MIT',
                      :text => 'copyright' }
  s.homepage	   = 'https://github.com/mojun/MMTransitionAnimator'
  s.authors      = { 'mojun' => 'immojun@gmail.com' }
  s.summary      = 'Custom transition & interactive transition animator for iOS. written in Objective-C.'
  s.source       = { :git => 'https://github.com/mojun/MMTransitionAnimator.git', 
                     :tag => '0.0.1' }
  s.source_files = 'Classes','Classes/MMTransitionAnimator/*.{h,m}'
  s.requires_arc = true
  s.platform     = :ios, '8.0'
  
end
