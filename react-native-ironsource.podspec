require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "react-native-ironsource"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.description  = <<-DESC
                  react-native-ironsource
                   DESC
  s.homepage     = "https://github.com/github_account/react-native-ironsource"
  # brief license entry:
  s.license      = "MIT"
  # optional - use expanded license entry instead:
  # s.license    = { :type => "MIT", :file => "LICENSE" }
  s.authors      = { "Itagiba ALIX" => "itagiba@redpill.paris" }
  s.platforms    = { :ios => "10.0" }
  s.source       = { :git => "https://github.com/github_account/react-native-ironsource.git", :tag => "#{s.version}" }

  s.source_files = "ios/**/*.{h,c,m,swift}"
  s.requires_arc = true

  s.dependency "React"
  s.dependency "IronSourceSDK","6.16.2.0"


  # ...
  # s.dependency "..."
end

