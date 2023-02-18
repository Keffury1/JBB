
# Uncomment the next line to define a global platform for your project
platform :ios, '14.0'

target 'The JBB' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for The JBB
  pod 'UIImageColors'
  pod 'Firebase'
  pod 'Firebase/AdMob'
  pod 'Kingfisher'
  pod 'IQKeyboardManagerSwift'
  pod 'ProgressHUD'
  pod 'KeychainSwift'
  pod 'Google-Mobile-Ads-SDK'

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
    end
  end
end
end
