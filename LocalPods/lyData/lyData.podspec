Pod::Spec.new do |s|
  s.name         = "lyData"
  s.version      = "1.0"
  s.homepage     = "https://git.namibox.com/app/ios_workspace"
  s.author       = { "base" => "liukuiqing" }
  s.summary      = "悦读阅读器"
#  s.platform     =  :macOS, "11"
  s.osx.deployment_target = "11"
  s.source       = { :path => './LocalPods/lyData' }
  s.source_files = "**/*.swift"
  s.module_name = "lyData"
  s.requires_arc = true
#  s.static_framework = true
  s.pod_target_xcconfig = {
        "GCC_PREPROCESSOR_DEFINITIONS" => "SQLITE_HAS_CODEC WCDB_BUILTIN_SQLCIPHER",
        'SWIFT_WHOLE_MODULE_OPTIMIZATION' => 'YES',
        'APPLICATION_EXTENSION_API_ONLY' => 'YES',
        "HEADER_SEARCH_PATHS" => "${PODS_ROOT}/lyData",
        "LIBRARY_SEARCH_PATHS[sdk=macosx*]" => "$(SDKROOT)/usr/lib/system",
        "OTHER_SWIFT_FLAGS[config=Release][sdk=iphonesimulator*]" => "-D WCDB_IOS",
        "OTHER_SWIFT_FLAGS[config=Release][sdk=iphoneos*]" => "-D lyData_IOS",
        "OTHER_SWIFT_FLAGS[config=Debug]" => "-D DEBUG",
        "OTHER_SWIFT_FLAGS[config=Debug][sdk=iphonesimulator*]" => "-D lyData_IOS -D DEBUG",
        "OTHER_SWIFT_FLAGS[config=Debug][sdk=iphoneos*]" => "-D lyData_IOS -D DEBUG",
  }
  s.dependency 'WCDB.swift'
end

