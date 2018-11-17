//
//  SNSongListView.h
//  SNMusic
//
//  Created by 肖恩伟 on 2018/11/17.
//  Copyright © 2018 肖恩伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SNSongListView : UIView
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, copy) NSString *keywords;

@property (nonatomic, strong) UITableView *tableView;

@end
