//
//  WMDragView.m
//  DragButtonDemo
//
//  Created by zhengwenming on 2016/12/16.
//
//

#import "YXAuxView.h"
#import "YXAuxInfoView.h"

#import "XMApiVC.h"
#import "XMInfos.h"
#import "XMManager.h"

// 摇一摇
#import <CoreMotion/CoreMotion.h>

@interface YXAuxView ()<UIGestureRecognizerDelegate>

@property (nonatomic,assign) CGPoint startPoint;
@property (nonatomic,strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic,assign) CGFloat previousScale;

@property (strong,nonatomic) CMMotionManager *motionManager;// 摇一摇
@property (nonatomic, assign) float aZ;
@property (nonatomic, assign) float rX;
@property (nonatomic, assign) float rY;

@property (nonatomic,strong) UIView *redLayer;

@property (nonatomic, strong)UIView *lineView;

@property (nonatomic,strong) UIImageView *imgView;

@property (nonatomic,strong) UILabel *label;

@end

static const double GRATIVY = 0.7;//翻转角度
static const double HSYMaxRotationRate = 2;//加速度，翻转速度控制
static const CGFloat left = 3.8;

@implementation YXAuxView

- (UIView *)lineView{
    if (_lineView == nil) {
        UIWindow *keyWindow = [UIApplication sharedApplication].delegate.window;
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, keyWindow.jk_height - 160, keyWindow.jk_width, 160)];
        _lineView.hidden = true;
        [_lineView mj_gradualHorizontal:[UIColor colorWithWhite:0 alpha:0.05] endColor:[UIColor colorWithWhite:0 alpha:0.8]];
        [keyWindow insertSubview:_lineView belowSubview:self];
    }
    return _lineView;
}

- (UIImageView *)imgView{
    if (_imgView == nil) {
        // 图片
        _imgView = [[UIImageView alloc] initWithImage:IMAGE(@"icon_close")];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.backgroundColor = [UIColor whiteColor];
        _imgView.alpha = 0.8;
        [self.lineView addSubview:_imgView];
        
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(30);
            make.centerX.mas_equalTo(self.lineView.mas_centerX);
            make.height.width.mas_equalTo(54);
        }];
        
        self.label = [[UILabel alloc] init];
        self.label.font = FONTNAME(18);
        self.label.textColor = [UIColor whiteColor];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.text = LocalizedString(@"Drop to Hide");
        [self.lineView addSubview:self.label];
        
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(100);
            make.centerX.mas_equalTo(self.lineView.mas_centerX);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(self.lineView.mas_width);
        }];
    }
    return _imgView;
}

- (UIView *)redLayer{
    if (_redLayer == nil) {
        _redLayer = [[UIView alloc] init];
        _redLayer.backgroundColor = [UIColor redColor];
        _redLayer.layer.cornerRadius = RedRadius / 2;
        _redLayer.hidden = true;
        
        _redLayer.frame = CGRectMake(left, left, RedRadius, RedRadius);
        [self addSubview:_redLayer];
    }
    return _redLayer;
}

- (void)setIsHiddenRedLayer:(BOOL)isHiddenRedLayer{
    self.redLayer.hidden = isHiddenRedLayer;
}

-(UIImageView *)imageView{
    if (_imageView==nil) {
        _imageView = [[UIImageView alloc]init];
        _imageView.userInteractionEnabled = YES;
        [self addSubview:_imageView];
    }
    return _imageView;
}

-(UIButton *)button{
    if (_button==nil) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.userInteractionEnabled = NO;
        [self addSubview:_button];
    }
    return _button;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
        
        self.motionManager = [[CMMotionManager alloc] init];//一般在viewDidLoad中进行
        self.motionManager.deviceMotionUpdateInterval = 0.15;//加速仪更新频率，以秒为单位
        [self startDeviceMotionUpdates];
        
        // 监听
        //viewDidAppear中加入
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:UIApplicationWillEnterForegroundNotification object:nil];

//        // 红色提示
//        [self layoutRedLayer:1];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    //中间镂空的矩形框
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //背景色
    //[[UIColor colorWithPatternImage:[UIImage imageNamed:@"1.jpg"]] set];
    [[UIColor colorWithWhite:0.8 alpha:0.7] set];
    CGContextAddRect(ctx, rect);
    CGContextFillPath(ctx);
    
    //设置清空模式
    /**
     kCGBlendModeClear,
     kCGBlendModeCopy,
     kCGBlendModeSourceIn,
     kCGBlendModeSourceOut,
     kCGBlendModeSourceAtop,
     kCGBlendModeDestinationOver,
     kCGBlendModeDestinationIn,
     kCGBlendModeDestinationOut,
     kCGBlendModeDestinationAtop,
     kCGBlendModeXOR,
     kCGBlendModePlusDarker,
     kCGBlendModePlusLighter
     */
    CGContextSetBlendMode(ctx, kCGBlendModeClear);
    
    //画圆
    //    CGContextAddEllipseInRect(ctx, myRect);
    CGFloat w = rect.size.width / 2;
    CGContextAddArc(ctx, w, w, w - 2, 0, 2 * M_PI, 0);
    CGContextSetLineWidth(ctx, 1);
    CGContextDrawPath(ctx, kCGPathStroke);
    
    //画圆
    CGContextAddArc(ctx, w, w, w * 1.5, 0, 2 * M_PI, 0);
    CGContextSetLineWidth(ctx, w);
    CGContextDrawPath(ctx, kCGPathStroke);
}

- (void)layoutRedLayer{
    
    CGFloat centerX = [UIScreen mainScreen].bounds.size.width / 2;
    
    CGFloat A = 0;
    if (self.center.x > centerX) {
        A = 45.0;
    }else{
        A = 135.0;
    }
    
    CGFloat T2 = 1.4142135623731;
    CGFloat dragW = self.frame.size.width;
    CGFloat R = A / 45 * M_PI_4;
    CGFloat radius = (dragW / 2 - left - RedRadius / 2) * T2;
    CGFloat X = radius * cos(R);
    CGFloat Y = radius * sin(R);
    CGPoint redPoint = CGPointMake(dragW / 2.0 - X, dragW / 2.0 - Y);
    
    [UIView animateWithDuration:0.5 animations:^{
        self.redLayer.center = redPoint;
    }];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setUp];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    if (self.freeRect.origin.x!=0||self.freeRect.origin.y!=0||self.freeRect.size.height!=0||self.freeRect.size.width!=0) {
        //设置了freeRect--活动范围
    }else{
        //没有设置freeRect--活动范围，则设置默认的活动范围为父视图的frame
        self.freeRect = (CGRect){CGPointZero,self.superview.bounds.size};
    }
//    self.contentViewForDrag.frame = self.button.frame = (CGRect){CGPointZero,self.bounds.size};
    self.imageView.frame = CGRectMake(5, 5, self.bounds.size.width - 10, self.bounds.size.height - 10);

    [self layoutRedLayer];
    
//    CGSize size = [UIScreen mainScreen].bounds.size;
//    CGFloat w = 60;
    self.imgView.layer.cornerRadius = 27;
}

-(void)setUp{
    self.dragEnable = YES;//默认可以拖曳
//    self.clipsToBounds = YES;
    self.isKeepBounds = NO;
    self.backgroundColor = [UIColor lightGrayColor];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickDragView)];
    [self addGestureRecognizer:singleTap];
    
    //添加移动手势可以拖动
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragAction:)];
    self.panGestureRecognizer.minimumNumberOfTouches = 1;
    self.panGestureRecognizer.maximumNumberOfTouches = 1;
    self.panGestureRecognizer.delegate = self;
    [self addGestureRecognizer:self.panGestureRecognizer];
}

/**
 拖动事件
 @param pan 拖动手势
 */
-(void)dragAction:(UIPanGestureRecognizer *)pan{
    if(self.dragEnable==NO)return;
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:{//开始拖动
            
            self.lineView.hidden = false;
            
            if (self.beginDragBlock) {
                self.beginDragBlock(self);
            }
            //注意完成移动后，将translation重置为0十分重要。否则translation每次都会叠加
            [pan setTranslation:CGPointZero inView:self];
            //保存触摸起始点位置
            self.startPoint = [pan translationInView:self];
            break;
        }
        case UIGestureRecognizerStateChanged:{//拖动中
            
            UIWindow *keyWindow = [UIApplication sharedApplication].delegate.window;
            CGPoint origin = [self.imgView convertRect:self.imgView.bounds toView:keyWindow].origin;
            CGSize size = self.imgView.frame.size;
            if (self.center.x > origin.x && self.center.x < (origin.x + size.width) && self.center.y > origin.y && self.center.y < (origin.y + size.height)) {
                
                self.imgView.image = IMAGE(@"icon_close_sel");
            }else{
                self.imgView.image = IMAGE(@"icon_close_nor");
            }
            
            //计算位移 = 当前位置 - 起始位置
            if (self.duringDragBlock) {
                self.duringDragBlock(self);
            }
            CGPoint point = [pan translationInView:self];
            float dx;
            float dy;
            switch (self.dragDirection) {
                case WMDragDirectionAny:
                    dx = point.x - self.startPoint.x;
                    dy = point.y - self.startPoint.y;
                    break;
                case WMDragDirectionHorizontal:
                    dx = point.x - self.startPoint.x;
                    dy = 0;
                    break;
                case WMDragDirectionVertical:
                    dx = 0;
                    dy = point.y - self.startPoint.y;
                    break;
                default:
                    dx = point.x - self.startPoint.x;
                    dy = point.y - self.startPoint.y;
                    break;
            }
            
            //计算移动后的view中心点
            CGPoint newCenter = CGPointMake(self.center.x + dx, self.center.y + dy);
            //移动view
            self.center = newCenter;
            //  注意完成上述移动后，将translation重置为0十分重要。否则translation每次都会叠加
            [pan setTranslation:CGPointZero inView:self];
            
            CGFloat T2 = 1.4142135623731;
            CGFloat dragW = self.frame.size.width;
            CGFloat SCRRENW = [UIScreen mainScreen].bounds.size.width - dragW;
            CGFloat space = (self.center.x - dragW / 2) / SCRRENW;
            CGFloat A = 135 - space * 90;
            CGFloat R = A / 45 * M_PI_4;
//            YXLog(@"space = %.2lf",A);
            CGFloat radius = (dragW / 2 - left - RedRadius / 2) * T2;
            CGFloat X = radius * cos(R);
            CGFloat Y = radius * sin(R);
//            YXLog(@"x = %.2lf ,y = %.2lf",X,Y);
//            self.tranView.transform = CGAffineTransformMakeRotation(M_PI_2);
            CGPoint redPoint = CGPointMake(dragW / 2.0 - X, dragW / 2.0 - Y);
            self.redLayer.center = redPoint;
            
            break;
        }
        case UIGestureRecognizerStateEnded:{//拖动结束
            
            self.lineView.hidden = true;
            
            UIWindow *keyWindow = [UIApplication sharedApplication].delegate.window;
            CGPoint origin = [self.imgView convertRect:self.imgView.bounds toView:keyWindow].origin;
            CGSize size = self.imgView.frame.size;
            if (self.center.x > origin.x && self.center.x < (origin.x + size.width) && self.center.y > origin.y && self.center.y < (origin.y + size.height) && self.block) {
                
                self.block();
            }
            
            [self keepBounds];
            if (self.endDragBlock) {
                self.endDragBlock(self);
            }
            break;
        }
        default:
            break;
    }
}

//点击事件
-(void)clickDragView{
    if (self.clickDragViewBlock) {
        self.clickDragViewBlock(self);
    }
}

//黏贴边界效果
- (void)keepBounds{
    //中心点判断
    float centerX = self.freeRect.origin.x+(self.freeRect.size.width - self.frame.size.width)/2;
    CGRect rect = self.frame;
    if (self.isKeepBounds==NO) {//没有黏贴边界的效果
        if (self.frame.origin.x < self.freeRect.origin.x) {
            CGContextRef context = UIGraphicsGetCurrentContext();
            [UIView beginAnimations:@"leftMove" context:context];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:0.5];
            rect.origin.x = self.freeRect.origin.x;
            self.frame = rect;
            [UIView commitAnimations];
        } else if(self.freeRect.origin.x+self.freeRect.size.width < self.frame.origin.x+self.frame.size.width){
            CGContextRef context = UIGraphicsGetCurrentContext();
            [UIView beginAnimations:@"rightMove" context:context];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:0.5];
            rect.origin.x = self.freeRect.origin.x+self.freeRect.size.width-self.frame.size.width;
            self.frame = rect;
            [UIView commitAnimations];
        }
    }else if(self.isKeepBounds==YES){//自动粘边
        if (self.frame.origin.x< centerX) {
            CGContextRef context = UIGraphicsGetCurrentContext();
            [UIView beginAnimations:@"leftMove" context:context];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:0.5];
            rect.origin.x = self.freeRect.origin.x;
            self.frame = rect;
            [UIView commitAnimations];
            
            CGFloat space = -20;
            OVScreenMode mode = [XMScreen shared].mode;
            if (mode == iPhone_12mini ||
                mode == iPhone_X_XS_11Pro ||
                mode == iPhone_12__12Pro ||
                mode == iPhone_XR_XSMax_11_11ProMax ||
                mode == iPhone_12ProMax) {
                UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
                if (orientation == UIInterfaceOrientationLandscapeRight) {
                    space = 10;
                }
            }
            [self hiddenAfter:space];
        } else {
            CGContextRef context = UIGraphicsGetCurrentContext();
            [UIView beginAnimations:@"rightMove" context:context];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:0.5];
            rect.origin.x = self.freeRect.origin.x + self.freeRect.size.width - self.frame.size.width;
            self.frame = rect;
            [UIView commitAnimations];
            
            CGFloat space = 20;
            OVScreenMode mode = [XMScreen shared].mode;
            if (mode == iPhone_12mini ||
                mode == iPhone_X_XS_11Pro ||
                mode == iPhone_12__12Pro ||
                mode == iPhone_XR_XSMax_11_11ProMax ||
                mode == iPhone_12ProMax) {
                UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
                if (orientation == UIInterfaceOrientationLandscapeLeft) {
                    space = -10;
                }
            }
            [self hiddenAfter:space];
        }
    }
    
    if (self.frame.origin.y < self.freeRect.origin.y) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:@"topMove" context:context];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.5];
        rect.origin.y = self.freeRect.origin.y;
        self.frame = rect;
        [UIView commitAnimations];
    } else if(self.freeRect.origin.y+self.freeRect.size.height< self.frame.origin.y+self.frame.size.height){
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:@"bottomMove" context:context];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.5];
        rect.origin.y = self.freeRect.origin.y+self.freeRect.size.height-self.frame.size.height;
        self.frame = rect;
        [UIView commitAnimations];
    }
    
    [self layoutRedLayer];
}

// 3秒后修整位置
- (void)hiddenAfter:(CGFloat)space{
    
    if (space == 0) {
        return;
    }
    
    // 先取消
    if (self.bfSpace != 0) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(resetFrame:) object:@(self.bfSpace)];
    }
    
    // 再开始
    [self performSelector:@selector(resetFrame:) withObject:@(space) afterDelay:6];
    self.bfSpace = space;
}


//[NSNotificationCenter defaultCenter]
- (void)resetFrame:(NSNumber *)space{
    
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = self.frame;
        frame.origin.x = frame.origin.x + [space floatValue];
        self.frame = frame;
    }];
}

-(void)startDeviceMotionUpdates{

    WEAKSELF;
    [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
        
        CMAcceleration accrleration = motion.gravity;
        weakSelf.aZ = accrleration.z;
        CMRotationRate rotationRate = motion.rotationRate;
        weakSelf.rX = rotationRate.x;
        weakSelf.rY = rotationRate.y;
        if ([weakSelf isAchieveRotationRate] && [weakSelf isFaceDown]) {
            
//            YXLog(@"屏幕朝下~");n
            [weakSelf.motionManager stopDeviceMotionUpdates];
            if (auxView.isHidden == true) {
                [YXAuxView showAux];
            }
            
//            if (self.superview != nil) {
//                // 震动
//                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
//            }
        }
    }];
}

- (BOOL)isFaceDown {
    if (self.aZ >= GRATIVY) {
        return YES;
    }
    return NO;
}

- (BOOL)isAchieveRotationRate {
    if (self.rX <= - HSYMaxRotationRate) {
        return YES;
    }
    if (self.rY <= - HSYMaxRotationRate) {
        return YES;
    }
    return NO;
}

//对应上面的通知中心回调的消息接收
-(void)receiveNotification:(NSNotification *)notification{

    if ([notification.name
         isEqualToString:UIApplicationDidEnterBackgroundNotification]){

        [self.motionManager stopDeviceMotionUpdates];
    }else{

        [self startDeviceMotionUpdates];
    }
}

- (void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}

#pragma mark -- 我添加的方法
static YXAuxView *auxView;
static YXAuxInfoView *auxInfoView;
+ (instancetype)sharedAux{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        auxView = [[YXAuxView alloc] initWithFrame:CGRectMake(0, 150, YXAuxH, YXAuxH)];
        auxView.imageView.image = IMAGE(@"icon_logo");
        auxView.isKeepBounds = true;
        auxView.layer.cornerRadius = YXAuxH / 2;
        auxView.alpha = 0;
        auxView.isHidden = true;
        
        // 显示隐藏
        auxInfoView = [[YXAuxInfoView alloc] init];
        
        // 点击回调
        auxView.clickDragViewBlock = ^(YXAuxView *dragView) {
            
            [YXAuxView showRowsVC];
        };
        
        auxView.block = ^{
            [auxInfoView show];
        };
        
    });
    return auxView;
}

// 显示更多选择
+ (void)showRowsVC{
    [auxView cancelPrevious];
    
    XMConfig *config = [XMConfig sharedXMConfig];
    XMInfos *infos = [XMInfos sharedXMInfos];
    
    NSString *language = [NSBundle h5Language];
    
    XMApiVC *vc = [[XMApiVC alloc] init];
    vc.isNavBarHidden = true;
    vc.isClear = true;
    vc.api = [NSString stringWithFormat:@"http://d22vt38om5l4ym.cloudfront.net/center.html?account=%@&language=%@&appid=%@&udid=%@&channel=%@&platform=ios",config.user_name,language,infos.AppID,DEV_IDFA,GMChannel];
    
    // 交互禁用
    auxView.userInteractionEnabled = false;
    
    // 界面跳转
    [vc present];
}

/// 显示悬浮框
+ (void)showAux{
    
    // 红点刷新
    [auxView updateRedMark];
    
    auxView.isHidden = true;
    [auxView resetFrame];
}

/// 隐藏悬浮框
+ (void)hiddenAux{
    
    auxView.isHidden = false;
    [auxView resetFrame];
}

- (void)resetFrame{
    
    auxView.isHidden = !auxView.isHidden;
    CGFloat alpha = auxView.isHidden ? 0 : 0.8;
    
    XMConfig *config = [XMConfig sharedXMConfig];
    if ([config.buoyState isEqualToString:@"open"] == false && auxView.isHidden == false) {
        return;
    }

    if (alpha > 0) {
        // 先取消
        if (self.bfSpace != 0) {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(resetFrame:) object:@(self.bfSpace)];
        }
        
        CGRect frame = self.frame;
        CGFloat x = self.frame.origin.x;
        CGFloat w = [UIScreen mainScreen].bounds.size.width;
        CGFloat rightX = w - self.frame.size.width;
        if (x < 0) {
            x = 0;
        }else if (x > rightX){
            x = rightX;
        }
        frame.origin.x = x;
        self.frame = frame;
        
        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        [window addSubview:auxView];
    }
    
    [UIView animateWithDuration:0.8 animations:^{

        self.alpha = alpha;
    } completion:^(BOOL finished) {

        [self startDeviceMotionUpdates];
        if (alpha == 0) {
            [auxView removeFromSuperview];
        }
    }];
}

/// 取消贴边
- (void)cancelPrevious{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(resetFrame:) object:@(self.bfSpace)];
}

- (void)updateRedMark{
    
    XMConfig *config = [XMConfig sharedXMConfig];
    NSString *shareRed = [NSString stringWithFormat:@"ShareRed%@",config.user_name];
    BOOL isShareRed = [[NSUserDefaults objectForKey:shareRed] boolValue];
    
//    if (isShareRed == false && config.isShare == true) {
//        auxView.isHiddenRedLayer = false;
//    } else{
//        NSString *saveRedKey = [NSString stringWithFormat:@"saveRedDotDic%@",config.user_name];
//        NSDictionary *RedDotDic = [NSUserDefaults objectForKey:saveRedKey];
//
//        XMConfig *config = [XMConfig sharedXMConfig];
//        if (RedDotDic.allKeys.count < config.RedDotDic.allKeys.count) {
//            auxView.isHiddenRedLayer = false;
//        } else {
//            BOOL isHave = false;
//            for (id keyID in config.RedDotDic.allValues) {
//                NSString *key = [NSString stringWithFormat:@"%@",keyID];
//                BOOL flag = [RedDotDic[key] boolValue];
//                if (flag == false) {
//                    isHave = true;
//                    break;
//                }
//            }
//            
//            auxView.isHiddenRedLayer = !isHave;
//        }
//    }
}

@end
