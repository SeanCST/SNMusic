//
//  SNSongInfo.h
//  SNMusic
//
//  Created by 肖恩伟 on 2018/11/17.
//  Copyright © 2018 肖恩伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>

/**
 歌手信息
 */
@interface SNArtistInfo : NSObject

@property (nonatomic, copy) NSString *artistID;
@property (nonatomic, copy) NSString *artistName;
@property (nonatomic, copy) NSString *picUrl;
@property (nonatomic, strong) NSArray *alias;
@property (nonatomic, assign) NSInteger albumSize;
@property (nonatomic, assign) NSInteger picId;
@property (nonatomic, copy) NSString *img1v1Url;
@property (nonatomic, assign) NSInteger img1v1;
@property (nonatomic, copy) NSString *trans;

@end



/**
 专辑信息
 */
@interface SNAlbumInfo : NSObject

@property (nonatomic, copy) NSString *albumID;
@property (nonatomic, copy) NSString *albumName;
@property (nonatomic, strong) SNArtistInfo *artist;
@property (nonatomic, copy) NSString *publishTime;
@property (nonatomic, assign) NSInteger size;
@property (nonatomic, assign) NSInteger copyrightId;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString *picId;
@property (nonatomic, strong) NSArray *alia;

@end



/**
 歌曲信息
 */
@interface SNSongInfo : NSObject

@property (nonatomic, copy) NSString *songID;
@property (nonatomic, copy) NSString *songName;
@property (nonatomic, strong) NSArray *artists;
@property (nonatomic, strong) SNAlbumInfo *album;
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, assign) NSInteger copyrightId;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSArray *alias;
@property (nonatomic, assign) NSInteger rtype;
@property (nonatomic, assign) NSInteger ftype;
@property (nonatomic, copy) NSString *mvid;
@property (nonatomic, assign) NSInteger fee;
@property (nonatomic, copy) NSString *rUrl;

@end
