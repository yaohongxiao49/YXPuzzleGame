//
//  ViewController.m
//  YXPuzzleGameTest
//
//  Created by ios on 2020/6/1.
//  Copyright © 2020 August. All rights reserved.
//

#import "ViewController.h"
#import "LoginVC.h"
#import "ImgGameGroupVC.h"
#import "RankListVC.h"

@interface ViewController ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *userName;

@end

@implementation ViewController

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notification
- (void)processSuccess:(NSNotification *)notification {
    
    NSDictionary *dic = [notification userInfo];
    _userName.text = [dic objectForKey:@"text"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"Home";

    _imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    [_imageView setImage:[UIImage imageNamed:@"星空.jpeg"]];
    _imageView.userInteractionEnabled = YES;
    [self.view addSubview:_imageView];
    
    [self initView];
    [self judgeShowLogin];
}

#pragma mark - 判断是否弹出登录
- (void)judgeShowLogin {
    
    BOOL boolLogin = [UserMessageManager sharedManager].boolLogin;
    if (!boolLogin) [self login];
}

#pragma mark - 弹出登录
- (void)login {
    
    LoginVC *loginVC = [[LoginVC alloc] init];
    loginVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:loginVC animated:YES completion:nil];
}

#pragma mark - Process
#pragma mark - 游戏开始按钮事件监听
- (void)processStartGameButton {
    
    __weak typeof(self) weakSelf = self;
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"JigsawGameRankList"];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        for (BmobObject *obj in array) {
            NSMutableArray *bannerArr = [[NSMutableArray alloc] initWithArray:[obj objectForKey:@"imgs"]];
            ImgGameGroupVC *vc = [[ImgGameGroupVC alloc] init];
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            vc.exChangeImgArr = bannerArr;
            vc.baseNum = 3;
            [weakSelf presentViewController:vc animated:YES completion:nil];
        }
    }];
}

#pragma mark - 排行榜按钮事件监听
- (void)processSelectGameButton {
    
    RankListVC *vc = [[RankListVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 退出登录
- (void)processLoginOutButton {
    
    [[UserMessageManager sharedManager] loginOut];
    [self judgeShowLogin];
}

#pragma mark - 初始化视图
- (void)initView {
    
    UILabel *welComeText = [[UILabel alloc] initWithFrame:CGRectMake(15, 120, 100, 30)];
    welComeText.text = @"欢迎你：";
    welComeText.textColor = [UIColor whiteColor];
    welComeText.font = [UIFont fontWithName:@"DIN Alternate" size:20];
    [self.view addSubview:welComeText];
    
    _userName = [[UILabel alloc] initWithFrame:CGRectMake(100, 120, 100, 30)];
    _userName.textColor = [UIColor whiteColor];
    _userName.font = [UIFont fontWithName:@"DIN Alternate" size:20];
    _userName.text = [UserMessageManager sharedManager].userName;
    [self.view addSubview:_userName];
    
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
    
    UIButton *loginOutButton = [UIButton buttonWithType:UIButtonTypeSystem];
    loginOutButton.frame = CGRectMake(0, 0, 300, 50);
    loginOutButton.center = CGPointMake(self.view.center.x, self.view.center.y + 100);
    loginOutButton.layer.cornerRadius = 5;
    [loginOutButton setTitle:@"退出登录" forState:UIControlStateNormal];
    loginOutButton.titleLabel.font = [UIFont systemFontOfSize:30];
    [loginOutButton addTarget:self action:@selector(processLoginOutButton) forControlEvents:UIControlEventTouchUpInside];
    [_imageView addSubview:loginOutButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processSuccess:) name:@"success" object:nil];
}

@end
