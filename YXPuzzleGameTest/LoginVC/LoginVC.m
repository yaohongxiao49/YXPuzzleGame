//
//  LoginVC.m
//  YXPuzzleGameTest
//
//  Created by ios on 2020/6/1.
//  Copyright © 2020 August. All rights reserved.
//

#import "LoginVC.h"
#import <AVFoundation/AVFoundation.h>

#import "BaseTabBarVC.h"
#import "RegistVC.h"
#import "ViewController.h"

@interface LoginVC () <UITextFieldDelegate, CAAnimationDelegate>

@property (nonatomic, assign) BOOL isLog;
    
@property (nonatomic, strong) UITextField *userNameTextFiled;
@property (nonatomic, strong) UITextField *userPasswordTextFiled;
@property (nonatomic, strong) UIActivityIndicatorView *indecatorView;
@property (nonatomic, retain) AVAudioPlayer *audioPlayer;
@property (nonatomic, copy) NSArray *musicNames;
@property (nonatomic, assign) NSInteger currentMusicIndex;

@end

@implementation LoginVC

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self initView];
}

#pragma mark - 初始化视图
- (void)initView {
    
    UIImageView *bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    [bgImage setImage:[UIImage imageNamed:@"星空1.jpeg"]];
    [self.view addSubview:bgImage];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    titleLabel.center = CGPointMake(self.view.center.x, self.view.center.y - 200);
    titleLabel.text = @"拼图游戏";
    titleLabel.font = [UIFont systemFontOfSize:30];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    UILabel *userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width /2 - 140, self.view.frame.size.height /2 - 150, 80, 40)];
    userNameLabel.text = @"账号：";
    userNameLabel.font = [UIFont systemFontOfSize:20];
    userNameLabel.textColor = [UIColor whiteColor];
    [self.view addSubview: userNameLabel];
    
    _userNameTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(userNameLabel.frame.origin.x + 70, userNameLabel.frame.origin.y, 200, 40)];
    _userNameTextFiled.backgroundColor = [UIColor lightTextColor];
    _userNameTextFiled.placeholder = @"请输入您的账号";
    _userNameTextFiled.textAlignment = NSTextAlignmentCenter;
    _userNameTextFiled.layer.cornerRadius = 5;
    _userNameTextFiled.textColor = [UIColor blackColor];
    _userNameTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_userNameTextFiled becomeFirstResponder];
    _userNameTextFiled.tintColor = [UIColor grayColor];
    _userNameTextFiled.tag = 10;
    _userNameTextFiled.delegate = self;
    [self.view addSubview:_userNameTextFiled];
    
    UILabel * userPasswordLabel = [[UILabel alloc] initWithFrame:CGRectMake(userNameLabel.frame.origin.x, userNameLabel.frame.origin.y + 60, 80, 40)];
    userPasswordLabel.text = @"密码:";
    userPasswordLabel.font = [UIFont systemFontOfSize:20];
    userPasswordLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:userPasswordLabel];
    
    _userPasswordTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(userPasswordLabel.frame.origin.x + 70, userPasswordLabel.frame.origin.y, 200, 40)];
    _userPasswordTextFiled.backgroundColor = [UIColor lightTextColor];
    _userPasswordTextFiled.placeholder = @"请输入您的密码";
    _userPasswordTextFiled.textAlignment = NSTextAlignmentCenter;
    _userPasswordTextFiled.layer.cornerRadius = 5;
    _userPasswordTextFiled.secureTextEntry = YES;
    _userPasswordTextFiled.textColor = [UIColor blackColor];
    _userPasswordTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    _userPasswordTextFiled.tag = 18;
    _userPasswordTextFiled.delegate = self;
    [self.view addSubview: _userPasswordTextFiled];
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    loginButton.frame = CGRectMake(self.view.frame.size.width /2 - 80, self.view.frame.size.height /2 - 20, 80, 35);
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginButton.layer.cornerRadius = 10;
    [loginButton addTarget:self action:@selector(processLoginButton) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:loginButton];
    
    UIButton *registrationButton = [UIButton buttonWithType:UIButtonTypeSystem];
    registrationButton.frame = CGRectMake(self.view.frame.size.width /2, self.view.frame.size.height /2 - 20, 80, 35);
    [registrationButton setTitle:@"注册" forState:UIControlStateNormal];
    registrationButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [registrationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    registrationButton.layer.cornerRadius = 10;
    [registrationButton addTarget:self action:@selector(processRegistrationButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registrationButton];
    
    UISwitch *passwordSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 + 30, self.view.frame.size.height /2 + 20, 80, 35)];
    [passwordSwitch addTarget:self action:@selector(processPasswordSwitch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:passwordSwitch];
    self.view.backgroundColor = [UIColor blackColor];
    
    NSString *desText = @"是否显示密码？";
    UILabel * showLable = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width /2 + 90, self.view.frame.size.height /2 + 10, 120, 25)];
    showLable.text = desText;
    showLable.textColor = [UIColor whiteColor];
    showLable.font = [UIFont systemFontOfSize:12];
    CGSize contantSize = CGSizeMake(120, 100);
    CGRect autoRect = [desText boundingRectWithSize:contantSize options:
                       NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                         attributes:@{NSFontAttributeName:showLable.font} context:nil];
    showLable.frame = CGRectMake(self.view.frame.size.width /2 + 90, self.view.frame.size.height /2 + 30, 120, autoRect.size.height);
    [self.view addSubview:showLable];
    
    _musicNames = [[NSArray alloc] initWithObjects:@"music_fail.MP3", @"music_success.caf", nil];
    _currentMusicIndex = 0;
}

#pragma mark - 密码开关
- (void)processPasswordSwitch: (UISwitch *)sender {
    
    _userPasswordTextFiled.secureTextEntry = sender.isOn == YES ? NO : YES;
}

#pragma mark - <UITextFieldDelegate>
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField endEditing:YES];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField.tag == 10) {
        if (range.location >= 10) {
            return NO;
        }
    }
    else if (textField.tag == 18) {
        if (range.location >= 18) {
            return NO;
        }
    }
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

#pragma mark - process
#pragma mark - 添加登陆按钮事件
- (void)processLoginButton {
    
    __weak typeof(self) weakSelf = self;
    if (_userNameTextFiled.text.length == 0 || _userPasswordTextFiled.text.length == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"账号和密码不能为空" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%@", @"确定"] style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {}];
        [alert addAction:sure];
        [self presentViewController:alert animated:YES completion:nil];
        
        //结束动画
        [_indecatorView stopAnimating];
        //添加音乐
        [self initAudioPlayerWithMusicName:_musicNames[_currentMusicIndex] autoPlay:YES];
    }
    else {
        //获取服务器里的用户信息
        BmobQuery *bquery = [BmobQuery queryWithClassName:@"JigsawGame"];
        //查询JigsawGame表里多条数据
        [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            
            for (BmobObject *obj in array) {
                if ([weakSelf.userNameTextFiled.text isEqual:[obj objectForKey:@"userName"]] && [weakSelf.userPasswordTextFiled.text isEqual:[obj objectForKey:@"passWord"]]) {
                    [UserMessageManager sharedManager].userName = [obj objectForKey:@"userName"];
                    [UserMessageManager sharedManager].userId = obj.objectId;
                    
                    weakSelf.isLog = YES;
                    //活动指示器
                    weakSelf.indecatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
                    weakSelf.indecatorView.center = CGPointMake(200, 450);
                    weakSelf.indecatorView.color = [UIColor redColor];
                    //开始动画
                    [weakSelf.indecatorView startAnimating];
                    [weakSelf.view addSubview:weakSelf.indecatorView];
                    //活动指示器的监听
                    [weakSelf performSelector:@selector(processLoginActivity) withObject:nil afterDelay:3];
                    
                    //转场动画
                    CATransition *transition = [[CATransition alloc] init];
                    //动画时长
                    transition.duration = 3;
                    //动画效果
                    transition.type = @"rippleEffect"; //水波纹效果
                    transition.delegate = weakSelf;
                    [weakSelf.view.layer addAnimation:transition forKey:@"transition"];
                    weakSelf.currentMusicIndex = 1;
                    //添加音乐
                    [weakSelf initAudioPlayerWithMusicName:weakSelf.musicNames[weakSelf.currentMusicIndex] autoPlay:YES];
                }
            }
            if (!weakSelf.isLog) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"账号和密码不能错误" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *sure = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%@", @"确定"] style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {}];
                [alert addAction:sure];
                [self presentViewController:alert animated:YES completion:nil];
                
                //结束动画
                [weakSelf.indecatorView stopAnimating];
                //添加音乐
                [weakSelf initAudioPlayerWithMusicName:weakSelf.musicNames[weakSelf.currentMusicIndex] autoPlay:YES];
            }
        }];
        
        //通知
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:_userNameTextFiled.text, @"text", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"success" object:nil userInfo:dic];
    }
}
- (void)initAudioPlayerWithMusicName:(NSString *)musicName autoPlay:(BOOL)autoPlay {
    
    //销毁上一次的
    NSError *error = nil;
    //重新初始化，开辟一个内存空间
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForAuxiliaryExecutable:musicName] error:&error];
    if (error) {
        NSLog(@"音乐播放器初始化失败：%@", error.localizedDescription);
    }
    else {
        if (autoPlay) {
            //准备播放
            [_audioPlayer prepareToPlay];
            //开始播放
            [_audioPlayer play];
        }
        else {}
    }
}

#pragma mark - 添加登录活动控制器监听
- (void)processLoginActivity {

    [UserMessageManager sharedManager].boolLogin = YES;
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 添加注册按钮事件监听
- (void)processRegistrationButton {
    
    __weak typeof(self) weakSelf = self;
    RegistVC *vc = [[RegistVC alloc] init];
    [UIView transitionWithView:self.view duration:1 options:UIViewAnimationOptionTransitionCurlUp animations:nil completion:^(BOOL finished) {
        
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [weakSelf presentViewController:vc animated:NO completion:nil];
    }];
}

#pragma mark - 动画效果的消失
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    UIView *view = [self.view viewWithTag:10];
    [UIView animateWithDuration:1 animations:^{
      
        view.alpha = 0;
    } completion:^(BOOL finished) {
        
        [view removeFromSuperview];
    }];
}

@end
