//
//  SNPlayingView.h
//  SNMusic
//
//  Created by 肖恩伟 on 2018/11/24.
//  Copyright © 2018 肖恩伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SNPlayingView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UIButton *playPauseBtn;
@property (nonatomic, strong) UIButton *previousBtn;
@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, strong) UIButton *modeBtn;
@property (nonatomic, strong) UIButton *listBtn;
@property (nonatomic, strong) UILabel *currentTimeLabel;
@property (nonatomic, strong) UILabel *durationLabel;
@property (nonatomic, strong) UISlider *progressSlider;

@property (nonatomic, strong) UIButton *downloadBtn;


@end
