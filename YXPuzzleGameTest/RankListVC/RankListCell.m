//
//  RankListCell.m
//  YXPuzzleGameTest
//
//  Created by ios on 2020/6/1.
//  Copyright © 2020 August. All rights reserved.
//

#import "RankListCell.h"

@implementation RankListCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithRed:2.0/255 green:34.0/255 blue:70.0/255 alpha:1];
        
        [self initView];
    }
    return self;
}

- (void)initView {
    
    //姓名
    _userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 80, 30)];
    _userNameLabel.font = [UIFont boldSystemFontOfSize:20];
    _userNameLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:_userNameLabel];
    _userName = [[UILabel alloc] initWithFrame:CGRectMake(75, 0, 80, 30)];
    _userName.font = [UIFont boldSystemFontOfSize:20];
    _userName.textColor = [UIColor whiteColor];
    [self.contentView addSubview:_userName];
    
    //第一关成绩
    _firstPassLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 30, 120, 30)];
    _firstPassLabel.font = [UIFont boldSystemFontOfSize:20];
    _firstPassLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:_firstPassLabel];
    _firstPass = [[UILabel alloc] initWithFrame:CGRectMake(320, 30, 30, 30)];
    _firstPass.font = [UIFont boldSystemFontOfSize:20];
    _firstPass.textColor = [UIColor whiteColor];
    [self.contentView addSubview:_firstPass];
    _firstPassRight = [[UILabel alloc] initWithFrame:CGRectMake(340, 30, 30, 30)];
    _firstPassRight.font = [UIFont boldSystemFontOfSize:20];
    _firstPassRight.textColor = [UIColor whiteColor];
    [self.contentView addSubview:_firstPassRight];
    
    //第二关成绩
    _secondPassLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 60, 120, 30)];
    _secondPassLabel.font = [UIFont boldSystemFontOfSize:20];
    _secondPassLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:_secondPassLabel];
    _secondPass = [[UILabel alloc] initWithFrame:CGRectMake(320, 60, 30, 30)];
    _secondPass.font = [UIFont boldSystemFontOfSize:20];
    _secondPass.textColor = [UIColor whiteColor];
    [self.contentView addSubview:_secondPass];
    _secondPassRight = [[UILabel alloc] initWithFrame:CGRectMake(340, 60, 30, 30)];
    _secondPassRight.font = [UIFont boldSystemFontOfSize:20];
    _secondPassRight.textColor = [UIColor whiteColor];
    [self.contentView addSubview:_secondPassRight];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
