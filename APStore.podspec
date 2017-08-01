#
# Be sure to run `pod lib lint APStore.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'APStore'
  s.version          = '0.1.0'
  s.summary          = 'I am a store.'

  s.description      = <<-DESC
  APStore is a local store, include APKeyValueStore etc.
  APKeyValueStore is base on fmdb.
                       DESC

  s.homepage         = 'https://github.com/673697831/APStore'
  s.license          = "MIT"
  s.author           = { 'ozr' => '673697831@qq.com' }
  s.source           = { :git => 'https://github.com/673697831/APStore.git', :tag => s.version.to_s }

  s.ios.deployment_target = '7.0'

  s.public_header_files = 'Classes/APStore.h'
  s.source_files = 'Classes/APStore.h'
  s.requires_arc = true

  s.subspec 'APKeyValueStore' do |ss|
    ss.source_files = 'Classes/APKeyValueStore/*.{h,m}'
    ss.frameworks = 'Foundation'
    ss.libraries  = "sqlite3"
    ss.dependency 'FMDB/SQLCipher', '~> 2.6.2'
  end

end
