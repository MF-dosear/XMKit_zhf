//
//  YXDebug.h
//  XMSDK
//
//  Created by G.E.M on 2023/8/6.
//  Copyright © 2023 G.E.M. All rights reserved.
//

#ifndef YXDebug_h
#define YXDebug_h

#if YXDebug 
// 处于开发阶段

#define YXLog(...)                NSLog(__VA_ARGS__)
#define YXLog_delloc(obj)         NSLog(@"%@对象被销毁",NSStringFromClass([obj class]))

#else
// 处于发布阶段

#define YXLog(...)
#define YXLog_delloc(...)

#endif

#endif /* YXDebug_h */
