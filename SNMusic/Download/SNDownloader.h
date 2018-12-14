//
//  SNDownloader.h
//  SNMusic
//
//  Created by SeanCST on 2018/11/29.
//  Copyright © 2018 肖恩伟. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SNSongInfo;
@interface SNDownloader : NSObject

+ (instancetype)shareClient;
- (void)downloadWithSongInfo:(SNSongInfo *)songInfo;

@end
