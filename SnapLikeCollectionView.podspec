Pod::Spec.new do |s|
  s.name         = "SnapLikeCollectionView"
  s.version      = "1.0.0"
  s.summary      = "Scaling and Good Scrolling CollectionView like Snapchat's that."
  s.description  = <<-DESC
                     - Scaling and Good Scrolling CollectionView like Snapchat's that.
                   DESC

  s.homepage     = "https://github.com/kboy-silvergym/SnapLikeCollectionView"
  s.license      = "MIT"
  s.author             =   "Kei Fujikawa"
  s.social_media_url   = "http://twitter.com/kboy_silvergym"
  s.platform     = :ios, "11.0"
  s.source       = { :git => "https://github.com/kboy-silvergym/SnapLikeCollectionView.git", :commit => "8cf54f1c76345950014137ff0d071fd916a4adcf" }
  s.source_files  = "SnapLikeCollectionView/**/*.swift"
  s.swift_version = '4.2'
end