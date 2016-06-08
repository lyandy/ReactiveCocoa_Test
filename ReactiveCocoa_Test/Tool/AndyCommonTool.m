//
//  AndyCommonTool.m
//  ReactiveCocoa_Test
//
//  Created by 李扬 on 16/3/10.
//  Copyright © 2016年 andyli. All rights reserved.
//

#import "AndyCommonTool.h"

@implementation AndyCommonTool


+ (UIViewController *)getCurrentPerformanceUIViewContorller
{
//    UIViewController *rootVc=(UIViewController *)[UIApplication sharedApplication].windows.firstObject.rootViewController;
    
    UIViewController *rootVc = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIViewController *vc = rootVc.childViewControllers.lastObject;
    
    return vc;
}

@end
