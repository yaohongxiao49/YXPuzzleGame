//
//  ImgGameGroupVC.h
//  YXPuzzleGameTest
//
//  Created by ios on 2020/6/2.
//  Copyright © 2020 August. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImgGameGroupVC : UIViewController

@property (nonatomic, strong) NSMutableArray *exChangeImgArr;
@property (nonatomic, assign) NSInteger baseNum; //切个基数，2x2 = 4；3x3 = 9; 4x4 = 16; 5x5 = 25;

@end

NS_ASSUME_NONNULL_END
