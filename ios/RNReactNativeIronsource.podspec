
Pod::Spec.new do |s|
  s.name         = "RNReactNativeIronsource"
  s.version      = "1.0.0"
  s.summary      = "RNReactNativeIronsource"
  s.description  = <<-DESC
                  RNReactNativeIronsource
                   DESC
  s.homepage     = "https://github.com/RedPillGroup/react-native-ironsource"
  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = { "author" => "itagiba@redpill.paris" }
  s.platform     = :ios, "13.0"
  s.source       = { :git => "https://github.com/RedPillGroup/react-native-ironsource", :tag => "master" }
  s.source_files  = "RNReactNativeIronsource/**/*.{h,m}"
  s.requires_arc = true

  s.dependency "React"
  s.dependency "IronSourceSDK","6.16.1.0"

end

  