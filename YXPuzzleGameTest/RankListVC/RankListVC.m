//
//  RankListVC.m
//  YXPuzzleGameTest
//
//  Created by ios on 2020/6/1.
//  Copyright © 2020 August. All rights reserved.
//

#import "RankListVC.h"
#import "RankListCell.h"
#import <BmobSDK/Bmob.h>

@interface RankListVC ()

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableDictionary *dic;

@end

@implementation RankListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"游戏排行榜";
    self.view.backgroundColor = [UIColor colorWithRed:2.0/255 green:34.0/255 blue:70.0/255 alpha:1];
    _dataSource = [[NSMutableArray alloc] init];
    
    [self initData];
    [self initView];
}

- (void)initData {
    
    __weak typeof(self) weakSelf = self;
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"JigsawGame"];
    //由高到低排列
    [bquery orderByAscending:@"checkpoint"];
    //查找GameScore表所有数据
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobObject *obj in array) {
            if ([obj objectForKey:@"checkpoint"] != 0) {
                weakSelf.dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[obj objectForKey:@"userName"], @"userName", [obj objectForKey:@"checkpoint"], @"checkpoint", nil];
                [weakSelf.dataSource addObject:weakSelf.dic];
                [self.tableView reloadData];
            }
        }
    }];
}

- (void)initView {
    
    //改变单元格大小
    self.tableView.rowHeight = 90;
    //尾部视图
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellID = NSStringFromClass([RankListCell class]);
    RankListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[RankListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.userNameLab.text = [NSString stringWithFormat:@"姓名：%@", [_dataSource[indexPath.row] objectForKey:@"userName"]];
    cell.titleLab.text = [NSString stringWithFormat:@"%@关", [_dataSource[indexPath.row] objectForKey:@"checkpoint"]];
    
    return cell;
}

@end
