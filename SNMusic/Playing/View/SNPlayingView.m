//
//  SNPlayingView.m
//  SNMusic
//
//  Created by 肖恩伟 on 2018/11/24.
//  Copyright © 2018 肖恩伟. All rights reserved.
//

#import "SNPlayingView.h"

@interface SNPlayingView ()

@end

@implementation SNPlayingView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    
    return self;
}

- (void)initView {
    // 歌名 歌手
    UILabel *titleLabel = [UILabel new];
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.mas_top).offset(90);
    }];
    self.titleLabel = titleLabel;
    
    // 封面
    UIImageView *coverImageView = [UIImageView new];
    coverImageView.backgroundColor = [UIColor redColor];
    [self addSubview:coverImageView];
    [coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@200);
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self).offset(120);
    }];
    self.coverImageView = coverImageView;
    

    // 底部播放控制栏
    UIView *controlView = [UIView new];
    controlView.backgroundColor = [UIColor greenColor];
    [self addSubview:controlView];
    [controlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.left.equalTo(self);
        make.width.equalTo(self);
        make.height.equalTo(@150);
    }];
    
    // 播放、暂停
    UIButton *playPauseBtn = [UIButton new];
    [playPauseBtn setTitle:@"播放" forState:UIControlStateNormal];
    [controlView addSubview:playPauseBtn];
    [playPauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(controlView);
        make.bottom.equalTo(controlView).offset(-20);
    }];
    self.playPauseBtn = playPauseBtn;
    
    // 上一首
    UIButton *previousBtn = [UIButton new];
    [previousBtn setTitle:@"上一首" forState:UIControlStateNormal];
    [controlView addSubview:previousBtn];
    [previousBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(playPauseBtn.mas_left).offset(-20);
        make.bottom.equalTo(playPauseBtn);
    }];
    self.previousBtn = previousBtn;
    
    // 下一首
    UIButton *nextBtn = [UIButton new];
    [nextBtn setTitle:@"下一首" forState:UIControlStateNormal];
    [controlView addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(playPauseBtn.mas_right).offset(20);
        make.bottom.equalTo(playPauseBtn);
    }];
    self.nextBtn = nextBtn;
    
    // 播放模式按钮
    UIButton *modeBtn = [UIButton new];
    [modeBtn setTitle:@"播放模式" forState:UIControlStateNormal];
    [controlView addSubview:modeBtn];
    [modeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(previousBtn.mas_left).offset(-20);
        make.bottom.equalTo(playPauseBtn);
    }];
    self.modeBtn = modeBtn;
    
    // 歌曲列表按钮
    UIButton *listBtn = [UIButton new];
    [listBtn setTitle:@"歌曲列表" forState:UIControlStateNormal];
    [controlView addSubview:listBtn];
    [listBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nextBtn.mas_right).offset(20);
        make.bottom.equalTo(playPauseBtn);
    }];
    self.listBtn = listBtn;
    
    // 当前播放时间进度标签
    UILabel *currentTimeLabel = [UILabel new];
    [currentTimeLabel setText:@"00:00"];
    [controlView addSubview:currentTimeLabel];
    [currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(controlView).offset(20);
        make.bottom.equalTo(playPauseBtn.mas_top).offset(-20);
    }];
    self.currentTimeLabel = currentTimeLabel;
    
    // 总时长标签
    UILabel *durationLabel = [UILabel new];
    [durationLabel setText:@"03:21"];
    [controlView addSubview:durationLabel];
    [durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(controlView).offset(-20);
        make.bottom.equalTo(playPauseBtn.mas_top).offset(-20);
    }];
    self.durationLabel = durationLabel;
    
    // 播放进度条
    UISlider *progressSlider = [UISlider new];
    [controlView addSubview:progressSlider];
    [progressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(currentTimeLabel.mas_right).offset(20);
        make.right.equalTo(durationLabel.mas_left).offset(-20);
        make.centerY.equalTo(currentTimeLabel);
    }];
    self.progressSlider = progressSlider;
}

@end
