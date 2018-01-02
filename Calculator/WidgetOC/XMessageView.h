//
//  messageView.h
//  zyt-ios
//
//  Created by xinyu_mac on 16/4/19.
//  Copyright © 2016年 tcxy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMessageView : UIWindow

- (void) messageView:(UIViewController *) viewController;

- (void) messageFrameView;

- (instancetype)initWithMessage:(NSString *)message;
- (instancetype)initWithMessage:(NSString *)message withType:(BOOL) type;
- (void)show;

+ (void) messageShow:(NSString *) message;
+ (void) cameraMessageShow:(NSString *)message;

@end
