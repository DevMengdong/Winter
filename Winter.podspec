Pod::Spec.new do |s|

  s.name         = "Winter"
  s.version      = "1.0.5"
  s.description  = "some method ObjectC"
  s.author       = { "limengdong" => "1903345463@qq.com" }
  s.homepage     = "https://github.com/DevMengdong/Winter"
  s.summary      = "A short description of Winter."
  s.source       = { :git => "https://github.com/DevMengdong/Winter", :tag => "#{s.version}" }
  s.license      = { :type => "MIT", :file => "LICENSE"}
  s.platform 	 = :ios, '7.0'
  s.source_files = "MDMethod"
  s.exclude_files = "Classes/Exclude"
  
end
