//
//  SNPlayingViewController.m
//  SNMusic
//
//  Created by 肖恩伟 on 2018/11/23.
//  Copyright © 2018 肖恩伟. All rights reserved.
//

#import "SNPlayingViewController.h"
#import "SNSongInfo.h"

#import "Track+Provider.h"
#import "DOUAudioStreamer.h"
#import "DOUAudioVisualizer.h"

#import "SNPlayingView.h"
#import "SNDownloader.h"
#import <UIImageView+WebCache.h>

static void *kStatusKVOKey = &kStatusKVOKey;
static void *kDurationKVOKey = &kDurationKVOKey;
static void *kBufferingRatioKVOKey = &kBufferingRatioKVOKey;

// 播放模式 枚举
typedef enum : NSUInteger {
    SNPlayingModeOrder, // 顺序播放
    SNPlayingModeSingle, // 单曲循环
    SNPlayingModeRandom, // 随机播放
} SNPlayingMode;

@interface SNPlayingViewController ()

@property (nonatomic, strong) SNPlayingView *playingView;

@property (nonatomic, copy) NSArray *tracks;
@property (nonatomic, strong) NSArray *songInfoArr;
@property (nonatomic, assign) NSInteger currentTrackIndex;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) DOUAudioStreamer *streamer;
//@property (nonatomic, strong) DOUAudioVisualizer *visualizer;

@property (nonatomic, assign) SNPlayingMode playingMode;

@end

@implementation SNPlayingViewController

- (instancetype)initWithSongInfoArr:(NSArray *)songInfoArr CurrentIndex:(NSUInteger)currentIndex {
    self = [super init];
    if (self) {
        self.songInfoArr = songInfoArr;
        self.currentTrackIndex = currentIndex;
        [self setTracks:[Track remoteTracksWithSongInfoArr:self.songInfoArr]];
        
        self.playingMode = SNPlayingModeOrder; // 默认顺序播放
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"播放";

    SNPlayingView *playingView = [[SNPlayingView alloc] initWithFrame:CGRectMake(0, GetRectNavAndStatusHight, kScreenWidth, kScreenHeight - GetRectNavAndStatusHight)];
    [self.view addSubview:playingView];
    self.playingView = playingView;
    
    [self.playingView.progressSlider addTarget:self action:@selector(actionSliderProgress:) forControlEvents:UIControlEventValueChanged];
    [self.playingView.playPauseBtn addTarget:self action:@selector(actionPlayPause:) forControlEvents:UIControlEventTouchUpInside];
    [self.playingView.nextBtn addTarget:self action:@selector(actionNext:) forControlEvents:UIControlEventTouchUpInside];
    [self.playingView.previousBtn addTarget:self action:@selector(actionPrevious:) forControlEvents:UIControlEventTouchUpInside];
    
//    [self.playingView.downloadBtn addTarget:self action:@selector(actionDownload:) forControlEvents:UIControlEventTouchUpInside];
    [self.playingView.modeBtn addTarget:self action:@selector(changePlayingMode) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Playing Handler
- (void)_cancelStreamer
{
    if (_streamer != nil) {
        [_streamer pause];
        [_streamer removeObserver:self forKeyPath:@"status"];
        [_streamer removeObserver:self forKeyPath:@"duration"];
        [_streamer removeObserver:self forKeyPath:@"bufferingRatio"];
        _streamer = nil;
    }
}

- (void)_resetStreamer
{
    [self _cancelStreamer];
    
    if (0 == [_tracks count])
    {
        NSLog(@"(No tracks available)");
    }
    else
    {
        Track *track = [_tracks objectAtIndex:_currentTrackIndex];
        NSString *title = [NSString stringWithFormat:@"%@ - %@", track.artist, track.songName];
        [self.playingView.titleLabel setText:title];
        
        _streamer = [DOUAudioStreamer streamerWithAudioFile:track];
        [_streamer addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:kStatusKVOKey];
        [_streamer addObserver:self forKeyPath:@"duration" options:NSKeyValueObservingOptionNew context:kDurationKVOKey];
        [_streamer addObserver:self forKeyPath:@"bufferingRatio" options:NSKeyValueObservingOptionNew context:kBufferingRatioKVOKey];
        
        [_streamer play];
        
        [self _updateBufferingStatus];
        [self _setupHintForStreamer];
    }
    
    // 设置封面图片
    [self setCoverWithIndex:self.currentTrackIndex];
}

- (void)_setupHintForStreamer
{
    NSUInteger nextIndex = _currentTrackIndex + 1;
    if (nextIndex >= [_tracks count]) {
        nextIndex = 0;
    }
    
    [DOUAudioStreamer setHintWithAudioFile:[_tracks objectAtIndex:nextIndex]];
}

- (void)_timerAction:(id)timer
{
    if ([_streamer duration] == 0.0) {
        [self.playingView.progressSlider setValue:0.0f animated:NO];
    }
    else {
        NSTimeInterval currentTime = [_streamer currentTime];
        NSTimeInterval duration = [_streamer duration];
        
        [self.playingView.progressSlider setValue:(currentTime / duration) animated:YES];
//        NSLog(@"currentTime = %f", [_streamer currentTime]);
        [self.playingView.currentTimeLabel setText:[self minSecStrWithSeconds:(NSUInteger)currentTime]];
        [self.playingView.durationLabel setText:[self minSecStrWithSeconds:(NSUInteger)duration]];
    }
}

- (NSString *)minSecStrWithSeconds:(NSUInteger)second {
    return [NSString stringWithFormat:@"%02lu:%02lu", second / 60, second % 60];
}

- (void)_updateStatus
{
    switch ([_streamer status]) {
        case DOUAudioStreamerPlaying:
//            [_statusLabel setText:@"playing"];
            [self.playingView.playPauseBtn setTitle:@"暂停" forState:UIControlStateNormal];
            break;
            
        case DOUAudioStreamerPaused:
//            [_statusLabel setText:@"paused"];
            [self.playingView.playPauseBtn setTitle:@"播放" forState:UIControlStateNormal];
            break;
            
        case DOUAudioStreamerIdle:
//            [_statusLabel setText:@"idle"];
            [self.playingView.playPauseBtn setTitle:@"播放" forState:UIControlStateNormal];
            break;
            
        case DOUAudioStreamerFinished:
//            [_statusLabel setText:@"finished"];
            [self actionNext:nil];
            break;
            
        case DOUAudioStreamerBuffering:
//            [_statusLabel setText:@"buffering"];
            NSLog(@"buffering");
            break;
            
        case DOUAudioStreamerError:
//            [_statusLabel setText:@"error"];
            NSLog(@"error");
            break;
    }
}

- (void)_updateBufferingStatus
{
//    [_miscLabel setText:[NSString stringWithFormat:@"Received %.2f/%.2f MB (%.2f %%), Speed %.2f MB/s", (double)[_streamer receivedLength] / 1024 / 1024, (double)[_streamer expectedLength] / 1024 / 1024, [_streamer bufferingRatio] * 100.0, (double)[_streamer downloadSpeed] / 1024 / 1024]];

    NSLog(@"%@", [NSString stringWithFormat:@"Received %.2f/%.2f MB (%.2f %%), Speed %.2f MB/s", (double)[_streamer receivedLength] / 1024 / 1024, (double)[_streamer expectedLength] / 1024 / 1024, [_streamer bufferingRatio] * 100.0, (double)[_streamer downloadSpeed] / 1024 / 1024]);

    if ([_streamer bufferingRatio] >= 1.0) {
        NSLog(@"sha256: %@", [_streamer sha256]);
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == kStatusKVOKey) {
        [self performSelector:@selector(_updateStatus)
                     onThread:[NSThread mainThread]
                   withObject:nil
                waitUntilDone:NO];
    }
    else if (context == kDurationKVOKey) {
        [self performSelector:@selector(_timerAction:)
                     onThread:[NSThread mainThread]
                   withObject:nil
                waitUntilDone:NO];
    }
    else if (context == kBufferingRatioKVOKey) {
        [self performSelector:@selector(_updateBufferingStatus)
                     onThread:[NSThread mainThread]
                   withObject:nil
                waitUntilDone:NO];
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - View Appear or Disappear
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self _resetStreamer];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(_timerAction:) userInfo:nil repeats:YES];
//    [_volumeSlider setValue:[DOUAudioStreamer volume]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_timer invalidate];
    [_streamer stop];
    [self _cancelStreamer];
    
    [super viewWillDisappear:animated];
}

#pragma mark - Button Clicked
- (void)actionPlayPause:(id)sender
{
    if ([_streamer status] == DOUAudioStreamerPaused ||
        [_streamer status] == DOUAudioStreamerIdle) {
        [_streamer play];
    }
    else {
        [_streamer pause];
    }
    // 更改选中状态
    self.playingView.playPauseBtn.selected = !self.playingView.playPauseBtn.selected;
}

- (void)actionNext:(id)sender
{
    if (self.playingMode == SNPlayingModeOrder) { // 顺序
        if (++_currentTrackIndex >= [_tracks count]) {
            _currentTrackIndex = 0;
        }
    } else if (self.playingMode == SNPlayingModeSingle) { // 单曲循环，不需要作调整
        
    } else { // 随机播放
        NSUInteger count = [_tracks count];
        _currentTrackIndex += arc4random_uniform((uint32_t)count);
        if (_currentTrackIndex >= count) {
            _currentTrackIndex -= count;
        }
    }
    
    [self _resetStreamer];
}

- (void)actionPrevious:(id)sender
{
    if (self.playingMode == SNPlayingModeOrder) { // 顺序
        if (--_currentTrackIndex < 0) {
            _currentTrackIndex = [_tracks count] - 1;
        }
    } else if (self.playingMode == SNPlayingModeSingle) { // 单曲循环，不需要作调整
        
    } else { // 随机播放
        NSUInteger count = [_tracks count];
        _currentTrackIndex += arc4random_uniform((uint32_t)count);
        if (_currentTrackIndex >= count) {
            _currentTrackIndex -= count;
        }
    }
    
    [self _resetStreamer];
}

- (void)actionStop:(id)sender
{
    [_streamer stop];
}

- (void)actionSliderProgress:(id)sender
{
    [_streamer setCurrentTime:[_streamer duration] * [self.playingView.progressSlider value]];
}

//#pragma mark - 下载
//- (void)actionDownload:(id)sender {
//    SNSongInfo *info = self.songInfoArr[self.currentTrackIndex];
//
//    [[SNDownloader shareClient] downloadWithSongInfo:info];
//}


/**
 改变播放模式
 */
- (void)changePlayingMode {
    if (self.playingMode == SNPlayingModeOrder) {
        [self.playingView.modeBtn setImage:[UIImage imageNamed:@"cm2_play_btn_one"] forState:UIControlStateNormal];
        self.playingMode = SNPlayingModeSingle;
    } else if (self.playingMode == SNPlayingModeSingle) {
        [self.playingView.modeBtn setImage:[UIImage imageNamed:@"cm2_play_btn_shuffle"] forState:UIControlStateNormal];
        self.playingMode = SNPlayingModeRandom;
    } else {
        [self.playingView.modeBtn setImage:[UIImage imageNamed:@"cm2_play_btn_loop"] forState:UIControlStateNormal];
        self.playingMode = SNPlayingModeOrder;
    }
}

#pragma mark - Show Cover
- (void)setCoverWithIndex:(NSInteger)index {
    SNSongInfo *songInfo = self.songInfoArr[index];
    
    SNWeakSelf;
    NSString *urlStr = [NSString stringWithFormat:@"%@/song/detail", BaseUrl];
    NSDictionary *params = @{
                             @"ids" : songInfo.songID
                             };
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDict = (NSDictionary *)responseObject;
        if ([responseObject[@"code"] isEqualToNumber:@(200)]) { // 成功
            NSArray *songs = responseDict[@"songs"];
            NSDictionary *song = [songs firstObject];
            NSDictionary *album = song[@"al"];
            NSString *picUrlStr = album[@"picUrl"];

            [weakSelf.playingView.coverImageView sd_setImageWithURL:[NSURL URLWithString:picUrlStr] placeholderImage:nil];
            
        } else { // 失败
            NSLog(@"加载封面失败");
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"加载封面失败");
    }];
}

//- (void)_actionSliderVolume:(id)sender
//{
//    [DOUAudioStreamer setVolume:[_volumeSlider value]];
//}

@end
