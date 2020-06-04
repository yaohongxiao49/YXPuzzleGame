//
//  UserMessageManager.h
//  YXPuzzleGameTest
//
//  Created by ios on 2020/6/2.
//  Copyright © 2020 August. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserMessageManager : NSObject

+ (instancetype)sharedManager;

/** 是否登录 */
@property (nonatomic, assign) BOOL boolLogin;
/** 用户Id */
@property (nonatomic, copy) NSString *userId;
/** 用户名 */
@property (nonatomic, copy) NSString *userName;

/** 退出登录 */
- (void)loginOut;

@end

NS_ASSUME_NONNULL_END
