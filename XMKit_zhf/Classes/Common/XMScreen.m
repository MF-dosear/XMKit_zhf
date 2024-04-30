//
//  TKScreen.m
// Hello
//
//  Created by G.E.M on 2023/8/15.
//  Copyright © 2021 Hello. All rights reserved.
//

#import "XMScreen.h"

@implementation XMScreen

static XMScreen *instance;
+ (instancetype)shared{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        
        CGSize size = [UIScreen mainScreen].bounds.size;
        NSInteger height = size.height > size.width ? size.height : size.width;
        instance.mode = height;
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

- (id)copyWithZone:(NSZone *)zone {
    return instance;
}

- (CGFloat)width{
    switch (self.mode) {
        case iPhone_5S_SE:        return 320;
            break;
        case iPhone_12mini:       return 360;
            break;
        case iPhone_12__12Pro:    return 390;
            break;
        case iPhone_XR_XSMax_11_11ProMax:
        case iPhone_6P_6SP_7P_8P: return 414;
            break;
        case iPhone_12ProMax:     return 428;
            break;
        default:                  return 375;
            break;
    }
}

- (CGFloat)ratio{
    switch (self.mode) {
        case iPhone_5S_SE:        return 320.0 / 375.0;
            break;
        case iPhone_12mini:       return 360.0 / 375.0;
            break;
        case iPhone_12__12Pro:    return 390.0 / 375.0;
            break;
        case iPhone_XR_XSMax_11_11ProMax:
        case iPhone_6P_6SP_7P_8P: return 414.0 / 375.0;
            break;
        case iPhone_12ProMax:     return 428.0 / 375.0;
            break;
        default:                  return 1;
            break;
    }
}

- (CGFloat)navBarH{
    switch (self.mode) {
        case iPhone_12mini:
        case iPhone_X_XS_11Pro:
        case iPhone_12__12Pro:
        case iPhone_XR_XSMax_11_11ProMax:
        case iPhone_12ProMax:       return 88;
        default:                    return 64;
            break;
    }
}

- (CGFloat)navBarAddH{
    switch (self.mode) {
        case iPhone_12mini:
        case iPhone_X_XS_11Pro:
        case iPhone_12__12Pro:
        case iPhone_XR_XSMax_11_11ProMax:
        case iPhone_12ProMax:       return 24;
        default:                    return 0;
            break;
    }
}

- (CGFloat)mas_left{
    if (self.orientation == OVScreenOrientationHorizontal) {
        switch (self.mode) {
            case iPhone_12mini:
            case iPhone_X_XS_11Pro:
            case iPhone_12__12Pro:
            case iPhone_XR_XSMax_11_11ProMax:
            case iPhone_12ProMax:       return 40;
            default:                    return 0;
                break;
        }
    }else{
        return 0;
    }
}

- (CGFloat)landscapeRight_MasLeft{
    if (self.orientation == OVScreenOrientationHorizontal) {
        switch (self.mode) {
            case iPhone_12mini:
            case iPhone_X_XS_11Pro:
            case iPhone_12__12Pro:
            case iPhone_XR_XSMax_11_11ProMax:
            case iPhone_12ProMax:       return 44;
            default:                    return 0;
                break;
        }
    }else{
        return 0;
    }
}

- (CGFloat)navStatusH{
    switch (self.mode) {
        case iPhone_12mini:
        case iPhone_X_XS_11Pro:
        case iPhone_12__12Pro:
        case iPhone_XR_XSMax_11_11ProMax:
        case iPhone_12ProMax:       return 44;
        default:                    return 20;
            break;
    }
}

- (CGFloat)tabBarH{
    switch (self.mode) {
        case iPhone_12mini:
        case iPhone_X_XS_11Pro:
        case iPhone_12__12Pro:
        case iPhone_XR_XSMax_11_11ProMax:
        case iPhone_12ProMax:       return 83;
        default:                    return 49;
            break;
    }
}

- (CGFloat)tabBarAddH{
    switch (self.mode) {
        case iPhone_12mini:
        case iPhone_X_XS_11Pro:
        case iPhone_12__12Pro:
        case iPhone_XR_XSMax_11_11ProMax:
        case iPhone_12ProMax:       return 34;
        default:                    return 0;
            break;
    }
}

- (OVScreenOrientation)orientation{
    
    if (_orientation != OVScreenOrientationNone) {
        return _orientation;
    }
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        
        _orientation = OVScreenOrientationVertical;
    }else if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight){
        
        _orientation = OVScreenOrientationHorizontal;
    }else{
        _orientation = OVScreenOrientationNone;
    }
    
    return _orientation;
}

- (CGFloat)orientationRatio{
    switch (self.orientation) {
        case OVScreenOrientationVertical:    return  0.7;
            break;
        case OVScreenOrientationHorizontal:  return  0.6;
            break;
        default: return 1;
            break;
    }
}

@end
