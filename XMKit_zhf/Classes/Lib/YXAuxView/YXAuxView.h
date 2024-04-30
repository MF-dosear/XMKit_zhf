//
//  WMDragView.h
//  DragButtonDemo
//
//  Created by zhengwenming on 2016/12/16.
//
//

#import <UIKit/UIKit.h>


// 拖曳view的方向
typedef NS_ENUM(NSInteger, WMDragDirection) {
    WMDragDirectionAny,          /**< 任意方向 */
    WMDragDirectionHorizontal,   /**< 水平方向 */
    WMDragDirectionVertical,     /**< 垂直方向 */
};

static CGFloat const YXAuxH = 45;

@interface YXAuxView : UIView
/**
 是不是能拖曳，默认为YES
 YES，能拖曳
 NO，不能拖曳
 */
@property (nonatomic,assign) BOOL dragEnable;

/**
 活动范围，默认为父视图的frame范围内（因为拖出父视图后无法点击，也没意义）
 如果设置了，则会在给定的范围内活动
 如果没设置，则会在父视图范围内活动
 注意：设置的frame不要大于父视图范围
 注意：设置的frame为0，0，0，0表示活动的范围为默认的父视图frame，如果想要不能活动，请设置dragEnable这个属性为NO
 */
@property (nonatomic,assign) CGRect freeRect;

/**
 拖曳的方向，默认为any，任意方向
 */
@property (nonatomic,assign) WMDragDirection dragDirection;

/**
 contentView内部懒加载的一个UIImageView
 开发者也可以自定义控件添加到本view中
 注意：最好不要同时使用内部的imageView和button
 */
@property (nonatomic,strong) UIImageView *imageView;
/**
 contentView内部懒加载的一个UIButton
 开发者也可以自定义控件添加到本view中
 注意：最好不要同时使用内部的imageView和button
 */
@property (nonatomic,strong) UIButton *button;
/**
 是不是总保持在父视图边界，默认为NO,没有黏贴边界效果
 isKeepBounds = YES，它将自动黏贴边界，而且是最近的边界
 isKeepBounds = NO， 它将不会黏贴在边界，它是free(自由)状态，跟随手指到任意位置，但是也不可以拖出给定的范围frame
 */
@property (nonatomic,assign) BOOL isKeepBounds;
/**
 点击的回调block
 */
@property (nonatomic,copy) void(^clickDragViewBlock)(YXAuxView *dragView);
/**
 开始拖动的回调block
 */
@property (nonatomic,copy) void(^beginDragBlock)(YXAuxView *dragView);
/**
 拖动中的回调block
 */
@property (nonatomic,copy) void(^duringDragBlock)(YXAuxView *dragView);
/**
 结束拖动的回调block
 */
@property (nonatomic,copy) void(^endDragBlock)(YXAuxView *dragView);

/**
 是否隐藏小红点
 */
@property (nonatomic,assign) BOOL isHiddenRedLayer;


/**
 拖拽到指定位置
 */
@property (nonatomic,copy) void(^block)(void);

#pragma mark -- 我添加的方法

/**
 是否隐藏
 */
@property (nonatomic,assign) BOOL isHidden;

@property (nonatomic,assign) CGFloat bfSpace;


+ (instancetype)sharedAux;

/// 贴边
- (void)hiddenAfter:(CGFloat)space;

/// 显示更多选择
+ (void)showRowsVC;

/// 显示悬浮框
+ (void)showAux;

/// 隐藏悬浮框
+ (void)hiddenAux;

/// 刷新红点
- (void)updateRedMark;

@end


