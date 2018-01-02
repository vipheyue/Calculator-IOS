//
//  messageView.m
//  zyt-ios
//
//  Created by xinyu_mac on 16/4/19.
//  Copyright © 2016年 tcxy. All rights reserved.
//

#import "XMessageView.h"


@implementation XMessageView

- (void)messageView:(UIViewController *)viewController
{
    
}

- (void)messageFrameView
{
    
}

+ (void)cameraMessageShow:(NSString *)message
{
    [[[XMessageView alloc] initWithMessage:message withType:YES] show];
}

+ (void)messageShow:(NSString *)message
{
    [[[XMessageView alloc] initWithMessage:message] show];
}

- (instancetype)initWithMessage:(NSString *)message {
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor clearColor];
        self.windowLevel = UIWindowLevelAlert;
        UIViewController *vc = [[UIViewController alloc] init];
        self.rootViewController = vc;
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = [UIScreen mainScreen].bounds.size.height;
        CGSize messageSize = [message sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(width - 100, 100)];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, messageSize.width + 20, messageSize.height + 20)];
        view.center = CGPointMake(width / 2, height - 100);
        view.backgroundColor = [UIColor lightGrayColor];
        view.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        view.layer.cornerRadius = 2;
        [vc.view addSubview:view];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, messageSize.width, messageSize.height)];
        label.numberOfLines = 0;
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:15];
        label.text = message;
        [view addSubview:label];
    }
    return self;
}


- (instancetype)initWithMessage:(NSString *)message withType:(BOOL) type {
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor clearColor];
        self.windowLevel = UIWindowLevelAlert;
        UIViewController *vc = [[UIViewController alloc] init];
        self.rootViewController = vc;
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = [UIScreen mainScreen].bounds.size.height;
        CGSize messageSize = [message sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(width - 100, 100)];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, messageSize.width + 20, messageSize.height + 20)];
        view.center = CGPointMake(width / 2, height - 100);
        view.backgroundColor = [UIColor colorWithRed:139.0/255 green:214.0/255 blue:233.0/255 alpha:1];
        view.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        view.layer.cornerRadius = 2;
        [vc.view addSubview:view];
        if (type) {
            view.transform = CGAffineTransformMakeRotation(90.0f * M_PI / 180.0f);
            view.center = CGPointMake(width/2, height/2);
            view.backgroundColor = [UIColor grayColor];
            view.alpha = 0.7;
        }
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, messageSize.width, messageSize.height)];
        label.numberOfLines = 0;
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:15];
        label.text = message;
        [view addSubview:label];
    }
    return self;
}

- (void)show
{
    self.hidden = NO;
    self.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.2 animations:^{
                self.alpha = 0;
            } completion:^(BOOL finished) {
                self.hidden = YES;
            }];
        });
    }];
}


@end
