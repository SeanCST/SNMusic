//
//  SNSongInfo.m
//  SNMusic
//
//  Created by 肖恩伟 on 2018/11/17.
//  Copyright © 2018 肖恩伟. All rights reserved.
//

#import "SNSongInfo.h"

@implementation SNSongInfo

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"songID" : @"id",
             @"songName" : @"name",
             };
}

// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"artists" : [SNArtistInfo class],
             };
}
@end


@implementation SNArtistInfo

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"artistID" : @"id",
             @"artistName" : @"name",
             };
}

@end


@implementation SNAlbumInfo : NSObject

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"albumID" : @"id",
             @"albumName" : @"name",
             };
}
@end

