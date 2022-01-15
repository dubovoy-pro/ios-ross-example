platform :ios, '12.0'

def shared_pods
  pod 'Alamofire', '5.5.0'
  pod 'CocoaLumberjack/Swift', '3.7.4'
  pod 'SnapKit', '5.0.1'
  pod 'SwiftGen', '6.5.1'
end

target 'bcoin' do
  use_frameworks!

  # Pods for bcoin
  shared_pods

  target 'bcoinTests' do
    inherit! :search_paths
  end

  target 'bcoinUITests' do
  end

end

target 'UIDevStand' do
  use_frameworks!
  shared_pods
end
