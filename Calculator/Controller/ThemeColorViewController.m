//
//  ThemeColorViewController.m
//  Calculator
//
//  Created by YC X on 2018/1/29.
//  Copyright © 2018年 YC X. All rights reserved.
//

#import "ThemeColorViewController.h"
#import "XColorPickerView.h"
#import "XMessageView.h"

@interface ThemeColorViewController ()

@property (weak, nonatomic) IBOutlet UIView *colorPickerView;
@property (nonatomic, strong) XColorPickerView *colorPicker;


@end

@implementation ThemeColorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.colorPicker =[[XColorPickerView alloc] initWithFrame:CGRectMake(0, 0, self.colorPickerView.frame.size.width, self.colorPickerView.frame.size.width)];
//    self.colorPicker.delegate = self;
    [self.colorPickerView addSubview:self.colorPicker];
    [self.colorPickerView bringSubviewToFront:self.colorPicker];
    
    
    NSNumber *num = [NSNumber numberWithBool:NO];
    
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:num,@"sdfdfs",@"23",@"dsaf",nil];
    NSLog(@"dddd = %@", dic);
}

- (IBAction)touchUpInsideEvent:(UIButton *)sender {
    if (sender.tag == 1) {
        CGFloat red = 0;
        CGFloat green = 0;
        CGFloat blue = 0;
        CGFloat alpha = 1;
        [self.colorPicker.currentColor getRed:&red green:&green blue:&blue alpha:&alpha];
//        UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
//        NSDictionary *dict = @{@"red":[NSString stringWithFormat:@"%f",red],@"green":[NSString stringWithFormat:@"%f",green],@"blue":[NSString stringWithFormat:@"%f",blue],@"alpha":[NSString stringWithFormat:@"%f",alpha]};
        [[NSUserDefaults standardUserDefaults] setFloat:red forKey:@"RED"];
        [[NSUserDefaults standardUserDefaults] setFloat:green forKey:@"GREEN"];
        [[NSUserDefaults standardUserDefaults] setFloat:blue forKey:@"BLUE"];
        [XMessageView messageShow:@"设置成功"];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
