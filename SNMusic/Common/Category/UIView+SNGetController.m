//
//  UIView+SNGetController.m
//  SNMusic
//
//  Created by 肖恩伟 on 2018/11/23.
//  Copyright © 2018 肖恩伟. All rights reserved.
//

#import "UIView+SNGetController.h"

@implementation UIView (SNGetController)

/**
 获取当前页面的UIViewController
 
 @return UIViewController
 */
- (UIViewController *)getCurrentViewController {
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    
    return nil;
}
@end
