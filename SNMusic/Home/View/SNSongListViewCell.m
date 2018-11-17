//
//  SNSongListViewCell.m
//  SNMusic
//
//  Created by 肖恩伟 on 2018/11/17.
//  Copyright © 2018 肖恩伟. All rights reserved.
//

#import "SNSongListViewCell.h"
#include "SNSongInfo.h"

@interface SNSongListViewCell ()
@property (nonatomic, strong) UILabel *songNameLabel;
@property (nonatomic, strong) UILabel *artistNameLabel;
@property (nonatomic, strong) UILabel *albumNameLabel;

@end

@implementation SNSongListViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    // 歌名
    _songNameLabel = [[UILabel alloc] init];
    [_songNameLabel setTextColor:SNBackgroundColor];
    [_songNameLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [self addSubview:_songNameLabel];
    [_songNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self).offset(10);
        make.height.equalTo(@16);
    }];
    
    // 歌手名
    _artistNameLabel = [[UILabel alloc] init];
    [_artistNameLabel setTextColor:[UIColor lightGrayColor]];
    [_artistNameLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [self addSubview:_artistNameLabel];
    [_artistNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.songNameLabel.mas_bottom).offset(5);
        make.left.equalTo(self.songNameLabel);
        make.height.equalTo(@13);
    }];
    
    // 专辑名
    _albumNameLabel = [[UILabel alloc] init];
    [_albumNameLabel setTextColor:[UIColor lightGrayColor]];
    [_albumNameLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [self addSubview:_albumNameLabel];
    [_albumNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.songNameLabel.mas_bottom).offset(5);
        make.left.equalTo(self.artistNameLabel.mas_right).offset(5);
        make.height.equalTo(@13);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
    }];
}

- (void)setData:(SNSongInfo *)songInfo {
    _songNameLabel.text = songInfo.songName;
    
    NSMutableString *artistStr = [NSMutableString string];
    for (SNArtistInfo *artistInfo in songInfo.artists) {
        if (artistStr.length > 0) { // 不是第一个名字在前面加斜杠
            [artistStr appendString:@"/"];
        }
        [artistStr appendString:artistInfo.artistName];
    }
    _artistNameLabel.text = artistStr;
    
    
    _albumNameLabel.text = songInfo.album.albumName.length > 0 ? [NSString stringWithFormat:@"- %@", songInfo.album.albumName] : @" "; // 确保专辑名不为空，因为将专辑 Label 与 cell 底部绑定在一起了
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
