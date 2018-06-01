Pod::Spec.new do |s|
  s.name             = 'UpdateCenter'
  s.module_name      = 'UpdateCenter'
  s.version          = '0.1.4'
  s.summary          = 'Manage your application updates from remote source (API / Firebase). UpdateCenter library notifies you when there are new updates for your app.'

  s.description      = <<-DESC
    Library to manage application updates in app
                       DESC

  s.homepage         = 'https://github.com/unitedclassifiedsapps/updatecenter.ios'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'United Classifieds s.r.o.' => 'unitedclassifiedsapps@gmail.com' }
  s.source           = { :git => 'https://github.com/unitedclassifiedsapps/updatecenter.ios.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'UpdateCenter/Classes/**/*'

   s.resource_bundles = {
     'UpdateCenter' => ['UpdateCenter/Assets/*.plist']
   }

  s.dependency 'Firebase/RemoteConfig', '4.13.0'
  s.framework      = ['FirebaseABTesting', 'FirebaseCore', 'FirebaseCoreDiagnostics', 'FirebaseInstanceID', 'FirebaseNanoPB', 'FirebaseRemoteConfig']

  #s.static_framework = true
end
