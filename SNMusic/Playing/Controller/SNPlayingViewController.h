//
//  SNPlayingViewController.h
//  SNMusic
//
//  Created by 肖恩伟 on 2018/11/23.
//  Copyright © 2018 肖恩伟. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SNSongInfo;

@interface SNPlayingViewController : UIViewController
- (instancetype)initWithSongInfo:(SNSongInfo *)songInfo;
@end