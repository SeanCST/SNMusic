//
//  SNSongListView.m
//  SNMusic
//
//  Created by 肖恩伟 on 2018/11/17.
//  Copyright © 2018 肖恩伟. All rights reserved.
//

#import "SNSongListView.h"
#import "SNSongListViewCell.h"
#import "MJRefresh.h"
#import "SNSearchSongVM.h"

#define ReuseIdentifier @"SNSongListViewCell"

@interface SNSongListView () <UITableViewDelegate, UITableViewDataSource>
// 页面偏移量，分页请求歌曲列表
@property (nonatomic, assign) NSInteger offset;

@end

@implementation SNSongListView
// 添加此句，否则同时重写了 setter 和 getter 会报错
@synthesize data = _data;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
        self.offset = 0;
    }
    return self;
}

- (void)initView {
//    self.tableView.backgroundColor = [UIColor redColor];
    [self addSubview:self.tableView];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView.hidden = YES; // 默认不显示，搜索完才显示
        CGFloat tabbarHeight = TAB_BAR_HEIGHT;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.h - tabbarHeight)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 50.0f;
        _tableView.rowHeight = UITableViewAutomaticDimension; // 新特性，自动计算行高
        [_tableView registerClass:[SNSongListViewCell class] forCellReuseIdentifier:ReuseIdentifier];
        _tableView.showsVerticalScrollIndicator = YES;
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        _tableView.mj_footer.hidden = YES;
    }
    
    return _tableView;
}

- (void)loadMoreData {
    SNWeakSelf;
    [[SNSearchSongVM shareClient] searchMoreWithKeywords:self.keywords Offset:(self.offset + 1) Completion:^(BOOL isSuccess) {
        weakSelf.offset += 1;
        weakSelf.data = [SNSearchSongVM shareClient].searchedSongs;
        [weakSelf.tableView.mj_footer endRefreshing];
//        [weakSelf.tableView reloadData];
    }];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SNSongListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier forIndexPath:indexPath];
    [cell setData:self.data[indexPath.row]];
    
    return cell;
}

- (NSArray *)data {
    if (!_data) {
        _data = [NSArray array];
    }
    return _data;
}

- (void)setData:(NSArray *)data {
    _data = data;
    [self.tableView reloadData];
    _tableView.mj_footer.hidden = NO;
}

@end
