Pod::Spec.new do |s|
    s.name = 'VFloatingButton'
    s.version = '1.0.0'
    s.license = { :type => "MIT", :file => "LICENSE" }
    s.summary = 'Yet anothere FAB written in Swift'
    s.homepage = 'https://github.com/velthune/VFloatingButton'
    s.authors = { 'Luca Davanzo' => 'davanzo.luca@gmail.com' }
    s.source = { :git => 'https://github.com/velthune/VFloatingButton.git', :tag => s.version.to_s }
    s.platform     = :ios, '8.0'
    s.source_files = 'VFloatingButton/source/*.swift'
    s.resources = 'images/VFloatingButton.gif'
end
