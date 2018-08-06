# Uncomment this line to define a global platform for your project
platform :ios, '10.0'

source 'https://github.com/ResearchSuite/Specs.git'
source 'https://github.com/CuriosityHealth/Specs.git'
source 'https://github.com/CocoaPods/Specs.git'

target 'YADL Reference App' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for YADL Reference App
  # pod 'OMHClient', :git => 'https://github.com/ResearchSuite/OMHClient-ios'
  pod 'ResearchSuiteExtensions'
  pod 'ResearchSuiteResultsProcessor'
  pod 'LS2SDK', '~> 0.9'
  pod "sdlrkx"
  # pod "sdlrkx", :path => '~/Developer/ResearchSuite/iOS/sdl-rkx'
  pod "ResearchKit", '~> 1.5'
  pod "ResearchSuiteTaskBuilder", '~> 0.11'
  # pod "ResearchSuiteAppFramework", :path => '~/Developer/ResearchSuite/iOS/ResearchSuiteAppFramework-iOS'
  pod "ResearchSuiteAppFramework", :git => 'https://github.com/ResearchSuite/ResearchSuiteAppFramework-iOS', :branch => 'reduction'

  target 'YADL Reference AppTests' do
    inherit! :search_paths
    # Pods for testing
  end

end
