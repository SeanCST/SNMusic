//
//  SNHomeView.m
//  SNMusic
//
//  Created by 肖恩伟 on 2018/11/17.
//  Copyright © 2018 肖恩伟. All rights reserved.
//

#import "SNHomeView.h"
#import "SNSongListView.h"
#import "SNSearchSongVM.h"

@interface SNHomeView () <UISearchBarDelegate>
@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) SNSongListView *listView;
@end

@implementation SNHomeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    
    // 搜索框
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    self.searchBar = searchBar;
    searchBar.delegate = self;
    [self addSubview:searchBar];
    [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.height.equalTo(@40);
    }];
    
    CGFloat listViewTop = 10 + 40 + 10;
    // 歌曲列表 View
    SNSongListView *listView = [[SNSongListView alloc] initWithFrame:CGRectMake(0, listViewTop, kScreenWidth, self.h - listViewTop)];
    self.listView = listView;
    [self addSubview:listView];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *searchText = searchBar.text;
    NSLog(@"%@", searchText);
    SNWeakSelf;
    [[SNSearchSongVM shareClient] searchWithKeywords:searchText Completion:^(BOOL isSuccess) {
        weakSelf.listView.data = [SNSearchSongVM shareClient].searchedSongs;
        weakSelf.listView.keywords = weakSelf.searchBar.text;
    }];
    
    // 每一次点击搜索，tableView 滚动到顶端
    [self.listView.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
}

@end
