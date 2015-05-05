Pod::Spec.new do |s|
  s.name     = 'MCTimeSeriesView'
  s.version  = '0.1'
  s.ios.deployment_target   = '7.0'
  s.license  = { :type => 'MIT', :file => 'LICENSE' }
  s.summary  = 'A light-weight solution for displaying time series charts.'
  s.homepage = 'https://github.com/matthewcheok/MCTimeSeriesView'
  s.author   = { 'Matthew Cheok' => 'cheok.jz@gmail.com' }
  s.requires_arc = true
  s.source   = {
    :git => 'https://github.com/matthewcheok/MCTimeSeriesView.git',
    :branch => 'master',
    :tag => s.version.to_s
  }
  s.source_files = 'MCTimeSeriesView/*.{h,m}'
  s.public_header_files = 'MCTimeSeriesView/*.h'
end
