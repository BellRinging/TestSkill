platform :ios, '14.0'
use_frameworks! 


target 'TestSkill' do
	pod 'GoogleSignIn'
	pod 'Firebase'
	pod 'Firebase/Auth'
	pod 'Firebase/Core'
	pod 'Firebase/Storage'
	pod 'Firebase/Database'
	pod 'Firebase/Messaging'
	pod 'Firebase/Firestore'
	pod 'SwiftEntryKit', '1.2.3'
	pod 'FBSDKCoreKit'
	pod 'FBSDKLoginKit'
	pod 'PromisesSwift'
	pod 'Introspect'
	pod 'SwiftUIRefresh'
	pod 'ALCameraViewController'
end




post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
  end
  
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end

end
