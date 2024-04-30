//
//  UIViewController+YX.m
//  XMSDK
//
//  Created by G.E.M on 2023/8/14.
//  Copyright © 2023 G.E.M. All rights reserved.
//

#import "UIViewController+YX.h"
#import "XMNavVC.h"

@implementation UIViewController (YX)

- (void)present{

    XMNavVC *nvc = [[XMNavVC alloc] initWithRootViewController:self];
    nvc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    nvc.modalPresentationStyle = UIModalPresentationOverFullScreen;

    [SELFVC presentViewController:nvc animated:true completion:nil];
}

- (void)push:(UIViewController *)vc{
    [self.navigationController pushViewController:vc animated:false];
}

- (void)pop{
    [self.navigationController popViewControllerAnimated:false];
}

- (void)dismiss{
    [self dismissViewControllerAnimated:true completion:nil];
}


@end
