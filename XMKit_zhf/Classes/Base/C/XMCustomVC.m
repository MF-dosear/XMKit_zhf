//
//  XMCustomVC.m
//  XMSDK
//
//  Created by G.E.M on 2023/8/19.
//  Copyright © 2023 G.E.M. All rights reserved.
//

#import "XMCustomVC.h"

@interface XMCustomVC ()

@end

@implementation XMCustomVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)dealloc{
    
    YXLog(@"%@对象已经被销毁",NSStringFromClass([self class]));
}

@end
