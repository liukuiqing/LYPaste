Pod::Spec.new do |s|
  s.name         = "data"
  s.version      = "1.0"
  s.homepage     = "https://git.namibox.com/app/ios_workspace"
  s.author       = { "base" => "liukuiqing" }
  s.summary      = "悦读阅读器"
  s.platform     =  :macOS, "9.0"
  s.osx.deployment_target = "10.9"
  s.source       = { :path => './LocalPods/data' }
  s.source_files = "**/*.swift"
  #s.requires_arc = true
  s.dependency 'WCDB.swift'
  s.static_framework = true
end

