//
//  Track+Provider.m
//  SNMusic
//
//  Created by 肖恩伟 on 2018/11/23.
//  Copyright © 2018 肖恩伟. All rights reserved.
//

#import "Track+Provider.h"
#import <MediaPlayer/MediaPlayer.h>
#import "SNSongInfo.h"

@implementation Track (Provider)

//+ (void)load
//{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//        [self remoteTracks];
//    });
//
////    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//////        [self musicLibraryTracks];
////    });
//}

+ (NSArray *)remoteTracksWithSongInfoArr:(NSArray *)songInfoArr
{
    static NSArray *tracks = nil;
    
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
    
        NSMutableArray *allTracks = [NSMutableArray array];
        
        for (SNSongInfo *songInfo in songInfoArr) {
            Track *track = [[Track alloc] init];
            // 设置歌手名
            SNArtistInfo *artistInfo = [songInfo.artists firstObject];
            [track setArtist:artistInfo.artistName];
            // 设置歌名
            [track setSongName:songInfo.songName];
            // 设置歌曲 URL
            NSString *urlStr = [NSString stringWithFormat:@"https://music.163.com/song/media/outer/url?id=%@.mp3", songInfo.songID];
            [track setAudioFileURL:[NSURL URLWithString:urlStr]];
            // 将 track 添加到 tracks 数组中
            [allTracks addObject:track];
        }

        tracks = [allTracks copy];
//    });
    
    return tracks;
}

+ (NSArray *)musicLibraryTracks
{
    static NSArray *tracks = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableArray *allTracks = [NSMutableArray array];
        for (MPMediaItem *item in [[MPMediaQuery songsQuery] items]) {
            if ([[item valueForProperty:MPMediaItemPropertyIsCloudItem] boolValue]) {
                continue;
            }
            
            Track *track = [[Track alloc] init];
            [track setArtist:[item valueForProperty:MPMediaItemPropertyArtist]];
            [track setSongName:[item valueForProperty:MPMediaItemPropertyTitle]];
            [track setAudioFileURL:[item valueForProperty:MPMediaItemPropertyAssetURL]];
            [allTracks addObject:track];
        }
        
        for (NSUInteger i = 0; i < [allTracks count]; ++i) {
            NSUInteger j = arc4random_uniform((u_int32_t)[allTracks count]);
            [allTracks exchangeObjectAtIndex:i withObjectAtIndex:j];
        }
        
        tracks = [allTracks copy];
    });
    
    return tracks;
}

@end
