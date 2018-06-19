
Pod::Spec.new do |s|
  s.name         = "RNNowPlaying"
  s.version      = "1.0.0"
  s.summary      = "RNNowPlaying"
  s.description  = <<-DESC
                  RNNowPlaying
                   DESC
  s.homepage     = "https://github.com/author/RNNowPlaying.git"
  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = { "author" => "author@domain.cn" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/weswes/react-native-now-playing.git", :tag => "master" }
  s.source_files  = "**/*.{h,m}"
  s.public_header_files = "**/*.{h}"
  s.requires_arc = true

  s.dependency "React"
  s.dependency "SpotifyAppRemoteSDK"

end
