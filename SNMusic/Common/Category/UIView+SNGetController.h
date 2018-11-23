//
//  UIView+SNGetController.h
//  SNMusic
//
//  Created by 肖恩伟 on 2018/11/23.
//  Copyright © 2018 肖恩伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SNGetController)
/**
 获取当前页面的UIViewController
 
 @return UIViewController
 */
- (UIViewController *)getCurrentViewController;
@end
