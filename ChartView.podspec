Pod::Spec.new do |s|
  s.name = 'ChartView'
  s.version = '0.2.0'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.summary = 'A short description of ChartView.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  Something amazing
                       DESC

  s.homepage = 'https://github.com/lanza/ChartView'
  s.authors = { 'Nathan Lanza' => 'nathan@lanza.io' }
  s.source = { :git => 'https://github.com/lanza/ChartView.git', :tag => s.version }
  s.ios.deployment_target = '13.0'
  s.source_files = 'Source/*.swift'
end
