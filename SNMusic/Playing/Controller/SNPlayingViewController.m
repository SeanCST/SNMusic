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

#import <UIImageView+WebCache.h>

static void *kStatusKVOKey = &kStatusKVOKey;
static void *kDurationKVOKey = &kDurationKVOKey;
static void *kBufferingRatioKVOKey = &kBufferingRatioKVOKey;

@interface SNPlayingViewController ()
//{
//@private
//    UILabel *_titleLabel;
//    UILabel *_statusLabel;
//    UILabel *_miscLabel;
//
//    UIButton *_buttonPlayPause;
//    UIButton *_buttonNext;
//    UIButton *_buttonStop;
//
//    UISlider *_progressSlider;
//
//    UILabel *_volumeLabel;
//    UISlider *_volumeSlider;
//
//    NSUInteger _currentTrackIndex;
//    NSTimer *_timer;
//
//    DOUAudioStreamer *_streamer;
//    DOUAudioVisualizer *_audioVisualizer;
//}
//@property (nonatomic, strong) SNSongInfo *songInfo;

@property (nonatomic, strong) SNPlayingView *playingView;


@property (nonatomic, copy) NSArray *tracks;
@property (nonatomic, strong) NSArray *songInfoArr;
@property (nonatomic, assign) NSInteger currentTrackIndex;

@property (nonatomic, strong) NSTimer *timer;



@property (nonatomic, strong) DOUAudioStreamer *streamer;
//@property (nonatomic, strong) DOUAudioVisualizer *visualizer;

@end

@implementation SNPlayingViewController

- (instancetype)initWithSongInfoArr:(NSArray *)songInfoArr CurrentIndex:(NSUInteger)currentIndex {
    self = [super init];
    if (self) {
//        self.songInfo = songInfo;
        self.songInfoArr = songInfoArr;
        self.currentTrackIndex = currentIndex;
        [self setTracks:[Track remoteTracksWithSongInfoArr:self.songInfoArr]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"播放";

    SNPlayingView *playingView = [[SNPlayingView alloc] initWithFrame:CGRectMake(0, GetRectNavAndStatusHight, kScreenWidth, kScreenHeight - GetRectNavAndStatusHight - TAB_BAR_HEIGHT)];
    [self.view addSubview:playingView];
    self.playingView = playingView;
    
    [self.playingView.progressSlider addTarget:self action:@selector(_actionSliderProgress:) forControlEvents:UIControlEventValueChanged];
    [self.playingView.playPauseBtn addTarget:self action:@selector(_actionPlayPause:) forControlEvents:UIControlEventTouchUpInside];
    [self.playingView.nextBtn addTarget:self action:@selector(_actionNext:) forControlEvents:UIControlEventTouchUpInside];
    [self.playingView.previousBtn addTarget:self action:@selector(_actionPrevious:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//- (void)loadView
//{
//    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    [view setBackgroundColor:[UIColor whiteColor]];
//
//    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 64.0, CGRectGetWidth([view bounds]), 30.0)];
//    [_titleLabel setFont:[UIFont systemFontOfSize:20.0]];
//    [_titleLabel setTextColor:[UIColor blackColor]];
//    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
//    [_titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
//    [view addSubview:_titleLabel];
//
//    _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY([_titleLabel frame]) + 10.0, CGRectGetWidth([view bounds]), 30.0)];
//    [_statusLabel setFont:[UIFont systemFontOfSize:16.0]];
//    [_statusLabel setTextColor:[UIColor colorWithWhite:0.4 alpha:1.0]];
//    [_statusLabel setTextAlignment:NSTextAlignmentCenter];
//    [_statusLabel setLineBreakMode:NSLineBreakByTruncatingTail];
//    [view addSubview:_statusLabel];
//
//    _miscLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY([_statusLabel frame]) + 10.0, CGRectGetWidth([view bounds]), 20.0)];
//    [_miscLabel setFont:[UIFont systemFontOfSize:10.0]];
//    [_miscLabel setTextColor:[UIColor colorWithWhite:0.5 alpha:1.0]];
//    [_miscLabel setTextAlignment:NSTextAlignmentCenter];
//    [_miscLabel setLineBreakMode:NSLineBreakByTruncatingTail];
//    [view addSubview:_miscLabel];
//
//    _buttonPlayPause = [UIButton buttonWithType:UIButtonTypeSystem];
//    [_buttonPlayPause setFrame:CGRectMake(80.0, CGRectGetMaxY([_miscLabel frame]) + 20.0, 60.0, 20.0)];
//    [_buttonPlayPause setTitle:@"Play" forState:UIControlStateNormal];
//    [_buttonPlayPause addTarget:self action:@selector(_actionPlayPause:) forControlEvents:UIControlEventTouchDown];
//    [view addSubview:_buttonPlayPause];
//
//    _buttonNext = [UIButton buttonWithType:UIButtonTypeSystem];
//    [_buttonNext setFrame:CGRectMake(CGRectGetWidth([view bounds]) - 80.0 - 60.0, CGRectGetMinY([_buttonPlayPause frame]), 60.0, 20.0)];
//    [_buttonNext setTitle:@"Next" forState:UIControlStateNormal];
//    [_buttonNext addTarget:self action:@selector(_actionNext:) forControlEvents:UIControlEventTouchDown];
//    [view addSubview:_buttonNext];
//
//    _buttonStop = [UIButton buttonWithType:UIButtonTypeSystem];
//    [_buttonStop setFrame:CGRectMake(round((CGRectGetWidth([view bounds]) - 60.0) / 2.0), CGRectGetMaxY([_buttonNext frame]) + 20.0, 60.0, 20.0)];
//    [_buttonStop setTitle:@"Stop" forState:UIControlStateNormal];
//    [_buttonStop addTarget:self action:@selector(_actionStop:) forControlEvents:UIControlEventTouchDown];
//    [view addSubview:_buttonStop];
//
//    _progressSlider = [[UISlider alloc] initWithFrame:CGRectMake(20.0, CGRectGetMaxY([_buttonStop frame]) + 20.0, CGRectGetWidth([view bounds]) - 20.0 * 2.0, 40.0)];
//    [_progressSlider addTarget:self action:@selector(_actionSliderProgress:) forControlEvents:UIControlEventValueChanged];
//    [view addSubview:_progressSlider];
//
//    _volumeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, CGRectGetMaxY([_progressSlider frame]) + 20.0, 80.0, 40.0)];
//    [_volumeLabel setText:@"Volume:"];
//    [view addSubview:_volumeLabel];
//
//    _volumeSlider = [[UISlider alloc] initWithFrame:CGRectMake(CGRectGetMaxX([_volumeLabel frame]) + 10.0, CGRectGetMinY([_volumeLabel frame]), CGRectGetWidth([view bounds]) - CGRectGetMaxX([_volumeLabel frame]) - 10.0 - 20.0, 40.0)];
//    [_volumeSlider addTarget:self action:@selector(_actionSliderVolume:) forControlEvents:UIControlEventValueChanged];
//    [view addSubview:_volumeSlider];
//
//    _audioVisualizer = [[DOUAudioVisualizer alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY([_volumeSlider frame]), CGRectGetWidth([view bounds]), CGRectGetHeight([view bounds]) - CGRectGetMaxY([_volumeSlider frame]))];
//    [_audioVisualizer setBackgroundColor:[UIColor colorWithRed:239.0 / 255.0 green:244.0 / 255.0 blue:240.0 / 255.0 alpha:1.0]];
//    [view addSubview:_audioVisualizer];
//
//    [self setView:view];
//}

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
            [self _actionNext:nil];
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
- (void)_actionPlayPause:(id)sender
{
    if ([_streamer status] == DOUAudioStreamerPaused ||
        [_streamer status] == DOUAudioStreamerIdle) {
        [_streamer play];
    }
    else {
        [_streamer pause];
    }
}

- (void)_actionNext:(id)sender
{
    if (++_currentTrackIndex >= [_tracks count]) {
        _currentTrackIndex = 0;
    }
    
    [self _resetStreamer];
}

- (void)_actionPrevious:(id)sender
{
    if (--_currentTrackIndex < 0) {
        _currentTrackIndex = [_tracks count] - 1;
    }
    
    [self _resetStreamer];
}

- (void)_actionStop:(id)sender
{
    [_streamer stop];
}

- (void)_actionSliderProgress:(id)sender
{
    [_streamer setCurrentTime:[_streamer duration] * [self.playingView.progressSlider value]];
}

# pragma mark - Show Cover
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
