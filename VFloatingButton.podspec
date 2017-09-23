Pod::Spec.new do |s|
    s.name = 'VFloatingButton'
    s.version = '1.0.0'
    s.license = 'MIT'
    s.summary = 'Yet anothere FAB written in Swift'
    s.homepage = 'https://github.com/velthune/VFloatingButton'
    s.authors = { 'Luca Davanzo' => 'davanzo.luca@gmail.com' }
    s.source = { :git => 'https://github.com/velthune/VFloatingButton.git', :tag => s.version.to_s }

    s.ios.deployment_target = '8.0'

    s.pod_target_xcconfig = {
        'SWIFT_VERSION' => '3.0',
    }

    s.source_files = 'VFloatingButton/source/*.swift'
end
