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
    
    self.userNameLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, (self.contentView.bounds.size.width - 40) /2, 30)];
    self.userNameLab.font = [UIFont boldSystemFontOfSize:20];
    self.userNameLab.textColor = [UIColor whiteColor];
    [self.contentView addSubview:self.userNameLab];
    
    self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.userNameLab.frame), 30, self.userNameLab.bounds.size.width, 30)];
    self.titleLab.font = [UIFont boldSystemFontOfSize:20];
    self.titleLab.textColor = [UIColor whiteColor];
    [self.contentView addSubview:self.titleLab];
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
