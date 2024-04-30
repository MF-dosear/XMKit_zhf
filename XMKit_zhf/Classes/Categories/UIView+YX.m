//
//  UIView+YX.m
//  XMSDK
//
//  Created by G.E.M on 2023/8/15.
//  Copyright © 2023 G.E.M. All rights reserved.
//

#import "UIView+YX.h"

@implementation UIView (YX)

// 竖向
- (void)mj_gradualHorizontal:(UIColor *)startColor endColor:(UIColor *)endColor{
    [self gradual:CGPointMake(0.5,0.0) endPoint:CGPointMake(0.5,1.0) startColor:startColor endColor:endColor];
}


/**
 给UIView设置渐变色
 @param startPoint 开始渐变点（0，0）表示从左上角开始变化。(0.5,0.0)表示从x轴为中间，y为顶端的开始变化
 @param endPoint 结束渐变点 （1，1）表示到右下角变化结束。(0.5,1.0)  表示从x轴为中间，y为低端的结束变化
 @param startColor 开始颜色
 @param endColor 结束颜色
 */
- (void)gradual:(CGPoint)startPoint endPoint:(CGPoint)endPoint startColor:(UIColor *)startColor endColor:(UIColor *)endColor{
    
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.startPoint = startPoint;//（0，0）表示从左上角开始变化。默认值是(0.5,0.0)表示从x轴为中间，y为顶端的开始变化
    layer.endPoint = endPoint;//（1，1）表示到右下角变化结束。默认值是(0.5,1.0)  表示从x轴为中间，y为低端的结束变化
    layer.colors = [NSArray arrayWithObjects:(id)startColor.CGColor,(id)endColor.CGColor, nil];
    //    layer.locations = @[@0.5f,@1.0f];//渐变颜色的区间分布，locations的数组长度和color一致，这个值一般不用管它，默认是nil，会平均分布
    layer.frame = self.bounds;
    [self.layer insertSublayer:layer atIndex:0];
}

@end
