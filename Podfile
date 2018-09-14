# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Calculator' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  # use_frameworks!

pod 'mob_sharesdk'
 
# UI模块(非必须，需要用到ShareSDK提供的分享菜单栏和分享编辑页面需要以下1行)
pod 'mob_sharesdk/ShareSDKUI'
 
# 平台SDK模块(对照一下平台，需要的加上。如果只需要QQ、微信、新浪微博，只需要以下3行)
pod 'mob_sharesdk/ShareSDKPlatforms/QQ'
pod 'mob_sharesdk/ShareSDKPlatforms/SinaWeibo'
pod 'mob_sharesdk/ShareSDKPlatforms/WeChatFull'
#（微信sdk带支付的命令，和上面不带支付的不能共存，只能选择一个）

  # Pods for Calculator

  target 'CalculatorTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'CalculatorUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
