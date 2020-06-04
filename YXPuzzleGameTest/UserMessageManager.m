//
//  UserMessageManager.m
//  YXPuzzleGameTest
//
//  Created by ios on 2020/6/2.
//  Copyright © 2020 August. All rights reserved.
//

#import "UserMessageManager.h"

@implementation UserMessageManager

+ (instancetype)sharedManager {
    
    static dispatch_once_t onceToken;
    static UserMessageManager *instance;
    dispatch_once(&onceToken, ^{
        
        instance = [[UserMessageManager alloc] init];
    });
    return instance;
}

- (void)loginOut {
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"login"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userId"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userName"];
}

#pragma mark - 是否登录
- (void)setBoolLogin:(BOOL)boolLogin {
    
    [[NSUserDefaults standardUserDefaults] setObject:@(boolLogin) forKey:@"login"];
}
- (BOOL)boolLogin {
    
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"login"] boolValue];
}

#pragma mark - 用户Id
- (void)setUserId:(NSString *)userId {
    
    [[NSUserDefaults standardUserDefaults] setObject:userId forKey:@"userId"];
}
- (NSString *)userId {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
}

#pragma mark - 用户名
- (void)setUserName:(NSString *)userName {
    
    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:@"userName"];
}
- (NSString *)userName {
 
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
}

@end
