//
//  ColorPickerView.m
//  zyt-ios
//
//  Created by zhoubo on 14-2-16.
//
//

#import "XColorPickerView.h"

#define PARAM_VIEW_PADDING           3.0f    // 控件最外边留白宽度系数
#define PARAM_INNER_PADDING          2.0f    // 当前颜色圆、色相环之间的留白系数
#define PARAM_OUTER_PADDING          3.0f    // 色相环、饱和度环之间的留白系数
#define PARAM_HUE_WIDTH              25.0f   // 色相环宽度系数
#define PARAM_SATURATION_WIDTH       3.0f    // 饱和度环宽度系数
#define PARAM_ARROW_SIZE             6.0f    // 箭头大小系数

@interface XColorPickerView()

@property(nonatomic,assign) BOOL isSelectCenter;
@property(nonatomic,assign) float curColorRadius;

@property(nonatomic,assign) float offX;//控件中心x偏移量
@property(nonatomic,assign) float offY;//控件中心y偏移量
@property(nonatomic,assign) float subdiv;//组成色相环的梯形个数,这个值改小梯形就可以看得很清楚
@property(nonatomic,assign) float hueInR;//色相环内环半径
@property(nonatomic,assign) float hueOutR;//色相环外环半径
@property(nonatomic,assign) float saturationInR;//饱和度环内环半径
@property(nonatomic,assign) float saturationOutR;//饱和度环外环半径
@property(nonatomic,assign) float curHueR;//当前选中色相圆的半径
@property(nonatomic,assign) float cursaturationR;//当前选中饱和度三角形边长

@end

@implementation XColorPickerView

@synthesize delegate=_delegate,currentColor=_currentColor;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _currentColor = [UIColor colorWithHue:0.3 saturation:0.1 brightness:1 alpha:1];
        self.isSelectCenter=NO;
        self.userInteractionEnabled=YES;

        self.offX = 150;
        self.offY = 150;
        //绘制色相环，实际上是由subdiv个梯形组合而成
        self.subdiv=512;
        self.hueInR=50;
        self.hueOutR=100;
        self.saturationInR = 110;
        self.saturationOutR = 125;
        self.curHueR = 12;
        self.cursaturationR = 25;
    }
    return self;
}

//绘制色相环
- (void)drawHue:(float)hueInR hueOutR:(float)hueOutR subdiv:(int)subdiv context:(CGContextRef)context {
    float halfinteriorPerim = M_PI*hueInR *2;//色相环内环的总长度(现在为1个圆弧长)
    float halfexteriorPerim = M_PI*hueOutR *2;//色相环外环的总长度(现在为1个圆弧长)
    float smallBase= halfinteriorPerim/subdiv;//梯形短边长
    float largeBase= halfexteriorPerim/subdiv;//梯形长边长
    
    //绘制梯形路径
    UIBezierPath * cell = [UIBezierPath bezierPath];
    
    [cell moveToPoint:CGPointMake(- smallBase/2, hueInR)];
    [cell addLineToPoint:CGPointMake(+ smallBase/2, hueInR)];
    
    [cell addLineToPoint:CGPointMake( largeBase /2 , hueOutR)];
    [cell addLineToPoint:CGPointMake(-largeBase /2,  hueOutR)];
    
    
    [cell closePath];
    
    float incr = M_PI *2/ subdiv;//每一个梯形旋转的弧度（现在总弧度为2PI,即360度）
    //CGContextRef ctx = [[NSGraphicsContext currentContext] graphicsPort];
    
    //通过平移、旋转，调整位置
    CGContextRotateCTM(context, M_PI/2);
    CGContextRotateCTM(context,incr/2);
    
    //循环绘制所有梯形，每绘制一个旋转一下
    for (int i=0;i<subdiv;i++) {
        // replace this color with a color extracted from your gradient object
        [[UIColor colorWithHue:(float)i/subdiv saturation:1 brightness:1 alpha:1] set];
        [cell fill];
        [cell stroke];
        CGContextRotateCTM(context, incr);
    }
}

//绘制饱和度环
- (void)drawSaturation:(float)saturationInR saturationOutR:(float)saturationOutR subdiv:(int)subdiv context:(CGContextRef)context curColor:(UIColor *)curColor {
    CGFloat hue;
    CGFloat saturation;
    CGFloat brightness;
    CGFloat alpha;
    [curColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    
    float halfinteriorPerim = M_PI*saturationInR *3/2;//色相环内环的总长度(现在为3/4个圆弧长)
    float halfexteriorPerim = M_PI*saturationOutR *3/2;//色相环外环的总长度(现在为3/4个圆弧长)
    float smallBase= halfinteriorPerim/subdiv;//梯形短边长
    float largeBase= halfexteriorPerim/subdiv;//梯形长边长
    
    //绘制梯形路径
    UIBezierPath * cell = [UIBezierPath bezierPath];
    
    [cell moveToPoint:CGPointMake(- smallBase/2, saturationInR)];
    [cell addLineToPoint:CGPointMake(+ smallBase/2, saturationInR)];
    
    [cell addLineToPoint:CGPointMake( largeBase /2 , saturationOutR)];
    [cell addLineToPoint:CGPointMake(-largeBase /2,  saturationOutR)];
    
    
    [cell closePath];
    
    float incr = M_PI *3/2/ subdiv;//每一个梯形旋转的弧度（现在总弧度为1.5PI,即270度）
    //CGContextRef ctx = [[NSGraphicsContext currentContext] graphicsPort];
    
    //通过旋转，调整位置
    CGContextRotateCTM(context, -M_PI/4);
    CGContextRotateCTM(context,incr/2);
    
    //循环绘制所有梯形，每绘制一个旋转一下
    for (int i=0;i<subdiv;i++) {
        [[UIColor colorWithHue:hue saturation:(float)i/subdiv brightness:1 alpha:1] set];
        [cell fill];
        [cell stroke];
        CGContextRotateCTM(context, incr);
    }
}

//画中心圆
- (void)drawCenter:(float)hueInR context:(CGContextRef)context curColor:(UIColor *)curColor {
    self.curColorRadius = hueInR-10;
    CGRect rectangle = CGRectMake(-self.curColorRadius,-self.curColorRadius,2*self.curColorRadius,2*self.curColorRadius);
    CGContextStrokePath(context);
    CGContextAddEllipseInRect(context,rectangle);
    CGContextSetFillColorWithColor(context, curColor.CGColor);
    CGContextFillEllipseInRect(context, rectangle);
}

//绘制当前选中色相
- (void)drawCurHue:(float)hueInR hueOutR:(float)hueOutR context:(CGContextRef)context curColor:(UIColor *)curColor curHueR:(float)curHueR{
    CGFloat hue;
    CGFloat saturation;
    CGFloat brightness;
    CGFloat alpha;
    [curColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    
    float angle = -M_PI * 3/4 + hue * 2 * M_PI;
    float curHueCen = hueInR + (hueOutR - hueInR)/2;
    int x = curHueCen * cosf(angle);
    int y = curHueCen * sinf(angle);
    CGRect rectangle = CGRectMake(x-curHueR,y-curHueR,2*curHueR,2*curHueR);
    CGContextStrokePath(context);
    CGContextAddEllipseInRect(context,rectangle);
    CGContextSetFillColorWithColor(context,[UIColor whiteColor].CGColor);
    CGContextFillEllipseInRect(context, rectangle);
}

//绘制当前选中饱和度三角形
- (void)drawTriangle:(float)cursaturationR saturationOutR:(float)saturationOutR context:(CGContextRef)context curColor:(UIColor *)curColor{
    CGFloat hue;
    CGFloat saturation;
    CGFloat brightness;
    CGFloat alpha;
    [curColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    
    CGContextSetStrokeColorWithColor(context, [UIColor brownColor].CGColor);
    CGContextSetFillColorWithColor(context,curColor.CGColor);
    float angle = -M_PI + M_PI *3/2 *saturation ;
    float off_angle = M_PI/55;
    int x = saturationOutR * cosf(angle);
    int y = saturationOutR * sinf(angle);
    int x1 =(saturationOutR+cursaturationR) * cosf(angle + off_angle);
    int y1 =(saturationOutR+cursaturationR) * sinf(angle + off_angle);
    int x2 =(saturationOutR+cursaturationR) * cosf(angle - off_angle);
    int y2 =(saturationOutR+cursaturationR) * sinf(angle - off_angle);
    CGContextMoveToPoint(context, x, y);
    CGContextAddLineToPoint(context, x1, y1);
    CGContextAddLineToPoint(context, x2, y2);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
    CGContextStrokePath(context);
}

- (void)drawRect:(CGRect)rect{
    //根据整个控件大小调整绘图大小。
    CGFloat iSize = MIN(self.frame.size.width, self.frame.size.height);
    self.offX = self.frame.size.width/2;
    self.offY = self.frame.size.height/2+(self.cursaturationR-5);
    self.hueInR=iSize / 8+5;
    self.hueOutR=self.hueInR + 55;
    self.saturationInR = self.hueOutR + 8;
    self.saturationOutR = self.saturationInR + 15;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    //平移坐标系
    CGContextTranslateCTM(context, self.offX, self.offY);
    
    //绘制色相环
    [self drawHue:self.hueInR hueOutR:self.hueOutR subdiv:self.subdiv context:context];

    //画中心圆
    [self drawCenter:self.hueInR context:context curColor:self.currentColor];
    
    //绘制饱和度环
    [self drawSaturation:self.saturationInR saturationOutR:self.saturationOutR subdiv:self.subdiv context:context curColor:self.currentColor];
    
    //绘制当前选中色相
    [self drawCurHue:self.hueInR hueOutR:self.hueOutR context:context curColor:self.currentColor curHueR:self.curHueR];
    
    //绘制当前选中饱和度三角形
    [self drawTriangle:self.cursaturationR saturationOutR:self.saturationOutR context:context curColor:self.currentColor];
    
     CGContextRestoreGState(context);
    
}

-(void)downMoveEvent:(CGPoint)point{
    int x = point.x;
    int y = point.y;
    CGFloat hue = 0;
    CGFloat saturation = 0;
    CGFloat brightness = 0;
    CGFloat alpha = 0;
    int cx = x - self.offX;
    int cy = y - self.offY;
    double d = sqrt(cx * cx + cy * cy);
    if (d <= self.hueOutR && d >= self.hueInR) {
        //点击在色相环范围内
        hue = (atan2(cy, cx))/2/M_PI + 0.5;
        self.currentColor = [UIColor colorWithHue:hue saturation:1 brightness:1 alpha:1];
    }else if (d >= self.saturationInR) {
        double a = atan2(cy, cx) / (2 * M_PI) + 0.625f;
        if (a > 1) {
            a = a - 1;
        }
        if (a > 0.875) {
            a = 0;
        }
        a = a * 4 / 3.0;
        [self.currentColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
        saturation = (float) MAX(0, MIN(1, a));
        
        self.currentColor = [UIColor colorWithHue:hue saturation:saturation brightness:1 alpha:1];
        
    }else if (d <= self.curColorRadius){
        self.isSelectCenter=YES;
    }
    
}

-(UIColor*) currentColor{
    return _currentColor;
}

-(void)setCurrentColor:(UIColor*) currentColor{
    if(currentColor){
        _currentColor=currentColor;
        [self setNeedsDisplay];
    }
}

- (void)touchesBegan:( NSSet *)touches withEvent:( UIEvent *)event{
    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
    CGPoint point = [touch locationInView:[touch view]]; //返回触摸点在视图中的当前坐标
    [self downMoveEvent:point];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:[touch view]]; //返回触摸点在视图中的当前坐标
    [self downMoveEvent:point];
}

-(void)touchesEnded:( NSSet *)touches withEvent:( UIEvent *)event{
    if (self.isSelectCenter) {
        CGFloat hue = 0;
        CGFloat saturation = 0;
        CGFloat brightness = 0;
        CGFloat alpha = 0;
        [self.currentColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
        self.currentColor = [UIColor colorWithHue:hue saturation:0 brightness:brightness alpha:1];
    }
    self.isSelectCenter = NO;
    
    if(self.delegate){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW,0), ^(void){
            [self.delegate onColorChanged];
        });
    }
    
}

-(void)dealloc{
    self.isSelectCenter = NO;
    self.currentColor=nil;
}
@end
