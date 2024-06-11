# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'EasyEF' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for EasyEF

pod 'Alamofire', '~> 5.4'
pod 'SwiftyJSON', '~> 4.0'
pod 'SDWebImage', '~> 5.0'
pod 'ProgressHUD'
pod 'IQKeyboardManagerSwift'
pod 'SideMenuSwift'
pod 'SwiftAlertView', '~> 2.2.1'
pod 'CameraKit-iOS'
pod 'SwiftEntryKit', '2.0.0'
pod "SearchTextField"
pod 'SwiftGifOrigin', '~> 1.7.0'

post_install do |installer|
    installer.generated_projects.each do |project|
        project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
            end
        end
    end
end

  target 'EasyEFTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'EasyEFUITests' do
    # Pods for testing
  end
  
end
