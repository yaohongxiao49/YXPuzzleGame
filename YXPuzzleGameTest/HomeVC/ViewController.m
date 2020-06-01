//
//  ViewController.m
//  YXPuzzleGameTest
//
//  Created by ios on 2020/6/1.
//  Copyright © 2020 August. All rights reserved.
//

#import "ViewController.h"
#import "LoginVC.h"
#import "ImgGameVC.h"
#import "RankListVC.h"

@interface ViewController ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) ImgGameVC *imgGameVC;
@property (nonatomic, assign) BOOL isLog;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _imgGameVC = [[ImgGameVC alloc] init];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"Home";

    _imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [_imageView setImage:[UIImage imageNamed:@"星空.jpeg"]];
    [self.view addSubview:_imageView];
    
    [self initView];
    
    BOOL boolLogin = [[NSUserDefaults standardUserDefaults] objectForKey:@"login"];
    if (boolLogin) [self login];
}

- (void)login {
    
    _isLog =! _isLog;
    if (_isLog) {
        LoginVC *loginVC = [[LoginVC alloc] init];
        loginVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:loginVC animated:YES completion:nil];
    }
}

- (void)initView {
    
    UILabel *welComeText = [[UILabel alloc] initWithFrame:CGRectMake(15, 120, 100, 30)];
    welComeText.text = @"欢迎你：";
    welComeText.textColor = [UIColor whiteColor];
    welComeText.font = [UIFont fontWithName:@"DIN Alternate" size:20];
    [self.view addSubview:welComeText];
    
    _imageView.userInteractionEnabled = YES;
    
    UIButton *startGameButton = [UIButton buttonWithType:UIButtonTypeSystem];
    startGameButton.frame = CGRectMake(0, 0, 300, 50);
    startGameButton.center = CGPointMake(self.view.center.x, self.view.center.y - 100);
    startGameButton.layer.cornerRadius = 5;
    [startGameButton setTitle:@"开始游戏" forState:UIControlStateNormal];
    startGameButton.titleLabel.font = [UIFont systemFontOfSize:30];
    [startGameButton addTarget:self action:@selector(processStartGameButton) forControlEvents:UIControlEventTouchUpInside];
    [_imageView addSubview:startGameButton];
    
    UIButton *selectGameButton = [UIButton buttonWithType:UIButtonTypeSystem];
    selectGameButton.frame = CGRectMake(0, 0, 300, 50);
    selectGameButton.center = CGPointMake(self.view.center.x, self.view.center.y);
    selectGameButton.layer.cornerRadius = 5;
    [selectGameButton setTitle:@"游戏排行" forState:UIControlStateNormal];
    selectGameButton.titleLabel.font = [UIFont systemFontOfSize:30];
    [selectGameButton addTarget:self action:@selector(processSelectGameButton) forControlEvents:UIControlEventTouchUpInside];
    [_imageView addSubview:selectGameButton];
    
    
#pragma mark - 通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processSuccess:) name:@"success" object:nil];
}

#pragma mark - Process
/** 游戏开始按钮事件监听 */
- (void)processStartGameButton {
    
    _imgGameVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:_imgGameVC animated:YES completion:nil];
}
/** 排行榜按钮事件监听 */
- (void)processSelectGameButton {
    
    RankListVC *vc = [[RankListVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Notification
- (void)processSuccess:(NSNotification *)notification {
    
    NSDictionary *dic = [notification userInfo];
    UILabel *userName = [[UILabel alloc] initWithFrame:CGRectMake(100, 120, 100, 30)];
    userName.textColor = [UIColor whiteColor];
    userName.font = [UIFont fontWithName:@"DIN Alternate" size:20];
    userName.text = [dic objectForKey:@"text"];
    [self.view addSubview:userName];
}

@end
