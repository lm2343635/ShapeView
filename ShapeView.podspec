# Be sure to run `pod lib lint RxOrientation.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ShapeView'
  s.version          = '0.2.2'
  s.summary          = 'A customized shape view with shadow and transparent background supported.'

  s.description      = <<-DESC
ShapeView support to create a view with the customized shape, shadow and transparent background at the same time.
                       DESC

  s.homepage         = 'https://github.com/lm2343635/ShapeView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'lm2343635' => 'lm2343635@126.com' }
  s.source           = { :git => 'https://github.com/lm2343635/ShapeView.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '9.0'
  s.source_files = 'ShapeView/Classes/**/*'
  
end
