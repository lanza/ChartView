Pod::Spec.new do |s|
  s.name             = 'ChartView'
  s.version          = '0.0.1'
  s.summary          = 'A simpler and easier to use version of UITableView designed to resemble a table.'



  s.homepage         = 'https://github.com/nathanlanza/ChartView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Nathan Lanza' => 'nathan@lanza.io' }
  s.source           = { :git => 'https://github.com/nathanlanza/ChartView.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/lanzaio'

  s.ios.deployment_target = '10.0'

  s.source_files = '*'
  
  s.frameworks = 'UIKit'
end
