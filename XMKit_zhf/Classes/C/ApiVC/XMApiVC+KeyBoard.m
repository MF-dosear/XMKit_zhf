//
//  XMApiVC+KeyBoard.m
//  XMSDK
//
//  Created by G.E.M on 2023/8/17.
//  Copyright © 2023 G.E.M. All rights reserved.
//

#import "XMApiVC+KeyBoard.h"

@implementation XMApiVC (KeyBoard)

- (void)addKeyBoardNoti{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidHide) name:UIKeyboardDidHideNotification object:nil];
}

- (void)keyBoardDidHide{
    self.webView.scrollView.contentOffset = CGPointMake(0, 0);
}

- (void)removeKeyBoardNoti{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

@end
