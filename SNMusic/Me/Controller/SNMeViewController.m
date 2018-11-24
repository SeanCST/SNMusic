//
//  SNMeViewController.m
//  SNMusic
//
//  Created by 肖恩伟 on 2018/11/24.
//  Copyright © 2018 肖恩伟. All rights reserved.
//

#import "SNMeViewController.h"
#import "SNPlayingView.h"

@interface SNMeViewController ()

@end

@implementation SNMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    SNPlayingView *playingView = [[SNPlayingView alloc] initWithFrame:CGRectMake(0, GetRectNavAndStatusHight, kScreenWidth, kScreenHeight - GetRectNavAndStatusHight - TAB_BAR_HEIGHT)];
    [self.view addSubview:playingView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end