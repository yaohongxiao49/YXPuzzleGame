//
//  BaseTabBarVC.m
//  YXPuzzleGameTest
//
//  Created by ios on 2020/6/1.
//  Copyright © 2020 August. All rights reserved.
//

#import "BaseTabBarVC.h"
#import "ViewController.h"
#import "SettingVC.h"

@interface BaseTabBarVC ()

@end

@implementation BaseTabBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self initView];
}

- (void)initView {
    
    ViewController *homeVC = [[ViewController alloc] init];
    SettingVC *setVC = [[SettingVC alloc] init];
    
    UINavigationController *homeNavc = [[UINavigationController alloc] initWithRootViewController:homeVC];
    UINavigationController *setNavc = [[UINavigationController alloc] initWithRootViewController:setVC];
    
    self.viewControllers = @[homeNavc, setNavc];
    
    UITabBarItem *homeItem = [[UITabBarItem alloc] initWithTitle:@"主页" image:[UIImage imageNamed:@"home.png"] tag:1];
    UITabBarItem *setItem = [[UITabBarItem alloc] initWithTitle:@"设置" image:[UIImage imageNamed:@"set.png"] tag:2];
    
    homeNavc.tabBarItem = homeItem;
    setNavc.tabBarItem = setItem;
    
    self.tabBar.tintColor = [UIColor whiteColor];
    self.tabBar.barTintColor = [UIColor colorWithRed:2.0/255 green:34.0/255 blue:70.0/255 alpha:1];
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont fontWithName:@"Zapfino" size:20]};
    [UINavigationBar appearance].barTintColor = [UIColor colorWithRed:2.0/255 green:34.0/255 blue:70.0/255 alpha:1];
}

@end
