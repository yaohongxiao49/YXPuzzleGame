//
//  RegistVC.m
//  YXPuzzleGameTest
//
//  Created by ios on 2020/6/1.
//  Copyright © 2020 August. All rights reserved.
//

#import "RegistVC.h"
#import <BmobSDK/Bmob.h>

@interface RegistVC () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *userNameTextFiled;
@property (nonatomic, strong) UITextField *userPasswordTextFiled;

@end

@implementation RegistVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self initView];
}

- (void)initView {
    
    UIImageView *bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    [bgImage setImage:[UIImage imageNamed:@"星空1.jpeg"]];
    [self.view addSubview:bgImage];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    titleLabel.center = CGPointMake(self.view.center.x, self.view.center.y - 200);
    titleLabel.text = @"注册界面";
    titleLabel.font = [UIFont systemFontOfSize:30];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
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
    
    UILabel *userPasswordLabel = [[UILabel alloc] initWithFrame:CGRectMake(userNameLabel.frame.origin.x, userNameLabel.frame.origin.y + 60, 80, 40)];
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
    [loginButton setTitle:@"确认" forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginButton.layer.cornerRadius = 10;
    [loginButton addTarget:self action:@selector(processLoginButton) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:loginButton];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    backButton.frame = CGRectMake(self.view.frame.size.width /2, self.view.frame.size.height /2 - 20, 80, 35);
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backButton.layer.cornerRadius = 10;
    [backButton addTarget:self action:@selector(processBackButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    UISwitch * passwordSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 + 30, self.view.frame.size.height /2 + 20, 80, 35)];
    [passwordSwitch addTarget:self action:@selector(processPasswordSwitch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:passwordSwitch];
    self.view.backgroundColor = [UIColor blackColor];
    
    NSString * desText = @"是否显示密码？";
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
#pragma mark - 添加注册按钮事件
- (void)processLoginButton {
    
    __weak typeof(self) weakSelf = self;
    if (_userNameTextFiled.text.length == 0 || _userPasswordTextFiled.text.length == 0) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"账号和密码不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else {
        //添加数据
        BmobObject *JigsawGame = [BmobObject objectWithClassName:@"JigsawGame"];
        [JigsawGame setObject:_userNameTextFiled.text forKey:@"userName"];
        [JigsawGame setObject:_userPasswordTextFiled.text forKey:@"passWord"];
        [JigsawGame setObject:@"0" forKey:@"stepsFirstCount"];
        [JigsawGame setObject:@"0" forKey:@"stepsSecondCount"];
        [JigsawGame saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            //进行操作
        }];
        [UIView transitionWithView:self.view duration:1 options:UIViewAnimationOptionTransitionCurlDown animations:nil completion:^(BOOL finished) {
            
            [weakSelf.presentingViewController dismissViewControllerAnimated:NO completion:nil];
        }];
    }
}
#pragma mark - 返回按钮监听
- (void)processBackButton {
    
    __weak typeof(self) weakSelf = self;
    [UIView transitionWithView:self.view duration:1 options:UIViewAnimationOptionTransitionCurlDown animations:nil completion:^(BOOL finished) {
        
        [weakSelf.presentingViewController dismissViewControllerAnimated:NO completion:nil];
    }];
}

@end
