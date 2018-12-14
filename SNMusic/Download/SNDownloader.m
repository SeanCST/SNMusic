//
//  SNDownloader.m
//  SNMusic
//
//  Created by SeanCST on 2018/11/29.
//  Copyright © 2018 肖恩伟. All rights reserved.
//

#import "SNDownloader.h"
#import "SNSongInfo.h"

@implementation SNDownloader

+ (instancetype)shareClient {
    static SNDownloader *_downloader = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       _downloader = [[SNDownloader alloc] init];
    });
    return _downloader;
}

- (void)downloadWithSongInfo:(SNSongInfo *)songInfo {
    
    NSLog(@"下载暂未处理");
    return;
    
    // 设置歌手名
    SNArtistInfo *artistInfo = [songInfo.artists firstObject];
    NSString *artistName = artistInfo.artistName;
    // 设置歌名
    NSString *songName = songInfo.songName;
    // 设置歌曲 URL
    NSString *urlStr = [NSString stringWithFormat:@"https://music.163.com/song/media/outer/url?id=%@.mp3", songInfo.songID];
    
    // 设置下载链接
    NSURL *songURL = [NSURL URLWithString:urlStr];
    // 根据链接获取数据
//    NSData *audioData = [NSData dataWithContentsOfURL:songURL];

    
    NSDate *date = [NSDate date];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:songURL];
    NSURLResponse *response;
    NSError *error;
    NSData* result = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
    NSLog(@"Response expects %lld bytes", [response expectedContentLength]);
    NSLog(@"Response suggested file name: %@", [response suggestedFilename]);
    if ([response suggestedFilename]){
//        if (!result)
//            NSLog(@"Error downloading data: %@.", [error localizedDescription]);
//        else if (response.expectedContentLength < 0)
//            NSLog(@"Error with download. Carrier redirect?");
    }
    else
    {
//            NSLog(@"Download succeeded.");
//            NSLog(@"Read %d bytes", result.length);
//            NSLog(@"Elapsed time: %0.2f seconds.", -1*[date timeIntervalSinceNow]);
        
        //设置保存文件夹
        NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        //设置保存路径和生成文件名
        NSString *songFileName = [NSString stringWithFormat:@"%@_%@", songInfo.songID, songName];
        NSString *filePath = [NSString stringWithFormat:@"%@/SongFiles/%@.mp3",docDirPath, songFileName];
        
        if ([result writeToFile:filePath atomically:YES]) {
            NSLog(@"%@", filePath);
            NSLog(@"下载成功");
        }else{
            NSLog(@"下载失败");
        }
    }
}

@end
