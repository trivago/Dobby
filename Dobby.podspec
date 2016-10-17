Pod::Spec.new do |spec|
  spec.name = 'Dobby'
  spec.version = '0.6.0'
  spec.authors = {
    'trivago' => 'opensource@trivago.com'
  }
  spec.social_media_url = 'https://twitter.com/trivago_tech'
  spec.license = {
    :type => 'Apache License, Version 2.0',
    :file => 'LICENSE'
  }
  spec.homepage = 'https://github.com/trivago/Dobby'
  spec.source = {
    :git => 'https://github.com/trivago/Dobby.git',
    :tag => spec.version.to_s
  }
  spec.summary = 'Swift helpers for mocking and stubbing'
  spec.description = 'Dobby provides a few helpers for mocking and stubbing.'

  spec.ios.deployment_target = '8.0'
  spec.osx.deployment_target = '10.9'

  spec.frameworks = 'Foundation', 'XCTest'

  spec.source_files = 'Dobby/**/*.swift'
end
