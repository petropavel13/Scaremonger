Pod::Spec.new do |s|
  s.name            = "Scaremonger"
  s.version         = "0.0.1"
  s.summary         = "Error handling framework for iOS & Swift"
  s.homepage        = "https://github.com/TouchInstinct/Scaremonger"
  s.license         = "Apache License, Version 2.0"
  s.author          = "Touch Instinct"
  s.source          = { :git => "https://github.com/petropavel13/Scaremonger.git", :tag => s.version }
  s.platform        = :ios, '9.0'
  s.swift_versions  = ["5.0"]

  s.subspec 'Core' do |ss|
    ss.ios.deployment_target = '9.0'
    ss.tvos.deployment_target = '9.0'
    ss.watchos.deployment_target = '3.0'

    ss.source_files = "Sources/**/*.swift"
    ss.exclude_files = [
      "Sources/Extensions/Rx/**/*.swift"
    ]
    ss.watchos.exclude_files = [
      "Sources/Classes/Dispatchers/AlertDispatcher.swift",
      "Sources/Classes/Subscribers/AlertSubscriber.swift"
    ]
  end

  s.subspec 'Rx' do |ss|
    ss.source_files = "Sources/**/*.swift"

    ss.dependency "Scaremonger/Core"
    ss.dependency "RxSwift", '~> 4'
  end

  s.default_subspec = 'Rx'

end
