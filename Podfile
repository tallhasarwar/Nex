platform :ios, '9.0'

# ignore all warnings from all pods
inhibit_all_warnings!

target 'Connectivity' do

pod 'AFNetworking', '~> 3.0'
pod 'TPKeyboardAvoiding'
pod 'SVProgressHUD'
pod 'FBSDKCoreKit'
pod 'FBSDKLoginKit'
pod 'Google/SignIn'
pod 'GoogleMaps'
pod 'GooglePlaces'
pod 'CWStatusBarNotification', '~> 2.3.5'
pod 'Firebase/Core'
pod 'Firebase/Messaging'
pod 'Firebase/Database'
pod 'Firebase/Storage'
pod 'SDWebImage', '~> 4.0'
pod 'Google/Analytics'
pod 'DZNEmptyDataSet'

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '10.0'
        end
    end
end
