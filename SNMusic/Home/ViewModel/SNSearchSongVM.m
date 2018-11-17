//
//  SNSearchSongVM.m
//  SNMusic
//
//  Created by 肖恩伟 on 2018/11/17.
//  Copyright © 2018 肖恩伟. All rights reserved.
//

#import "SNSearchSongVM.h"
#import "SNSongInfo.h"

@implementation SNSearchSongVM

+ (SNSearchSongVM *)shareClient {
    static SNSearchSongVM *_shareClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareClient = [[SNSearchSongVM alloc] init];
    });
    return _shareClient;
}

/**
 使用关键字搜索请求 - 首次 - 第1页
 */
- (void)searchWithKeywords:(NSString *)keywords Completion:(void(^)(BOOL isSuccess))completion {
    SNWeakSelf;
    NSString *urlStr = [NSString stringWithFormat:@"%@/search", BaseUrl];
    NSDictionary *params = @{
                             @"keywords" : keywords
                             };
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDict = (NSDictionary *)responseObject;
        if ([responseObject[@"code"] isEqualToNumber:@(200)]) { // 搜索成功
            NSDictionary *result = responseDict[@"result"];
            NSArray *arr = result[@"songs"];
            [weakSelf.searchedSongs removeAllObjects]; // 填入前要清空所有歌曲
            for (int i = 0; i < arr.count; i++) {
                SNSongInfo *songInfo = [SNSongInfo yy_modelWithJSON:arr[i]];
                [weakSelf.searchedSongs addObject:songInfo];
            }
            
            if (completion) {
                completion(YES);
            }
            
        } else { // 搜索失败
            NSLog(@"搜索失败");
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"搜索失败");
    }];
};

/**
 使用关键字搜索请求 - 后面 - 加载更多
 */
- (void)searchMoreWithKeywords:(NSString *)keywords Offset:(NSUInteger)offset Completion:(void(^)(BOOL isSuccess))completion {
    __weak typeof(self) weakSelf = self;
    NSString *urlStr = [NSString stringWithFormat:@"%@/search", BaseUrl];
    NSDictionary *params = @{
                             @"keywords" : keywords,
                             @"offset" : @(offset * 30)
                             };
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDict = (NSDictionary *)responseObject;
        if ([responseObject[@"code"] isEqualToNumber:@(200)]) { // 搜索成功
            NSDictionary *result = responseDict[@"result"];
            NSArray *arr = result[@"songs"];
            // 把搜索到的歌曲添加到数组中 - 接在之前数据的后面
            for (int i = 0; i < arr.count; i++) {
                SNSongInfo *songInfo = [SNSongInfo yy_modelWithJSON:arr[i]];
                [weakSelf.searchedSongs addObject:songInfo];
            }
            
            if (completion) {
                completion(YES);
            }
            
        } else { // 搜索失败
            NSLog(@"搜索失败");
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"搜索失败");
    }];
};


- (NSMutableArray *)searchedSongs {
    if (!_searchedSongs) {
        _searchedSongs = [NSMutableArray array];
    }
    return _searchedSongs;
}

@end
