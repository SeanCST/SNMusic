//
//  SNHomeViewController.m
//  SNMusic
//
//  Created by 肖恩伟 on 2018/11/17.
//  Copyright © 2018 肖恩伟. All rights reserved.
//

#import "SNHomeViewController.h"
#import "SNSongInfo.h"
//#import "SNSearchSongVM.h"
#import "SNHomeView.h"

@interface SNHomeViewController ()
/**搜索到的歌曲数组*/
//@property (nonatomic, strong) NSMutableArray *searchedSongs;


@end

@implementation SNHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self initView];
}

- (void)initView {
    SNHomeView *homeView = [[SNHomeView alloc] initWithFrame:CGRectMake(0, GetRectNavAndStatusHight, kScreenWidth, kScreenHeight - GetRectNavAndStatusHight)];
    [self.view addSubview:homeView];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//- (NSMutableArray *)searchedSongs {
//    if (!_searchedSongs) {
//        _searchedSongs = [NSMutableArray array];
//    }
//    return _searchedSongs;
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
