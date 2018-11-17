//
//  SNSearchSongVM.h
//  SNMusic
//
//  Created by 肖恩伟 on 2018/11/17.
//  Copyright © 2018 肖恩伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SNSearchSongVM : NSObject

// 网络搜索到的音乐
@property (nonatomic, strong) NSMutableArray *searchedSongs;


+ (SNSearchSongVM *)shareClient;
/**
 使用关键字搜索请求
 */
- (void)searchWithKeywords:(NSString *)keywords Completion:(void(^)(BOOL isSuccess))completion;
/**
 使用关键字搜索请求 - 后面 - 加载更多
 */
- (void)searchMoreWithKeywords:(NSString *)keywords Offset:(NSUInteger)offset Completion:(void(^)(BOOL isSuccess))completion;

@end
