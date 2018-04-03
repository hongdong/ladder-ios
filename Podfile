source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '9.0'
use_frameworks!
inhibit_all_warnings!

target 'Ladder' do
  pod 'KeychainAccess', '~> 3.1.0'
  pod 'SnapKit', '~> 4.0.0'

  target 'PacketTunnel' do
    inherit! :search_paths

    pod 'CocoaAsyncSocket', '~> 7.6.3'
    pod 'CryptoSwift', '~> 0.9.0'
  end
end
