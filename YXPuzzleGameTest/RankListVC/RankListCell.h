//
//  RankListCell.h
//  YXPuzzleGameTest
//
//  Created by ios on 2020/6/1.
//  Copyright © 2020 August. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RankListCell : UITableViewCell

@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) UILabel *firstPassLabel;
@property (nonatomic, strong) UILabel *firstPass;
@property (nonatomic, strong) UILabel *firstPassRight;
@property (nonatomic, strong) UILabel *secondPassLabel;
@property (nonatomic, strong) UILabel *secondPass;
@property (nonatomic, strong) UILabel *secondPassRight;

@end

NS_ASSUME_NONNULL_END
