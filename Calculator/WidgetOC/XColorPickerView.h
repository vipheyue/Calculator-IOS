//
//  XColorPickerView.h
//  zyt-ios
//
//  Created by mic on 16-2-16.
//
//

#import <UIKit/UIKit.h>

@protocol ColorChanageDelegate;

@interface XColorPickerView : UIView
@property(nonatomic,strong) UIColor *currentColor;//当前选择颜色，中心颜色
#ifndef DOXYGEN_SHOULD_SKIP_THIS
- (id)init __attribute__((unavailable("init is not a supported initializer for this class.")));
#endif
@property (nonatomic, weak) id<ColorChanageDelegate> delegate;

@end

@protocol ColorChanageDelegate <NSObject>

-(void)onColorChanged;

@end
