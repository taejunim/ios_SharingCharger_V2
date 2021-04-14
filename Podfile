# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'SharingCharger_V2' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  use_modular_headers!

  pod 'Alamofire', '~> 5.2.2'
  pod 'MaterialComponents/BottomSheet'
  pod 'SideMenu'
  pod 'GoneVisible'
  pod 'Toast-Swift'
  pod 'RealmSwift'

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '10.0'
      end
    end
  end

  # Pods for SharingCharger_V2

end
