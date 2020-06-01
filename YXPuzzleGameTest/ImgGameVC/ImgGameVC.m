//
//  ImgGameVC.m
//  YXPuzzleGameTest
//
//  Created by ios on 2020/6/1.
//  Copyright © 2020 August. All rights reserved.
//

#define kNumber 100
#define kBorderWidth 2

#import "ImgGameVC.h"
#import <BmobSDK/Bmob.h>

@interface ImgGameVC () <UIAlertViewDelegate>

@property (nonatomic, strong) UIImage *img;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, assign) CGImageRef imgRef;
@property (nonatomic, copy) NSArray *array;
@property (nonatomic, assign) NSInteger arrayCount;
    
@property (nonatomic, strong) UIImageView *firstImgV;
@property (nonatomic, strong) UIImageView *secondImgV;
@property (nonatomic, strong) UIImageView *thirdImgV;
@property (nonatomic, strong) UIImageView *fourImgV;
@property (nonatomic, strong) UIImageView *fiveImgV;
@property (nonatomic, strong) UIImageView *sixImgV;
@property (nonatomic, strong) UIImageView *sevenImgV;
@property (nonatomic, strong) UIImageView *eightImgV;
@property (nonatomic, strong) UIImageView *blackImgV;
    
@property (nonatomic, strong) UIButton *backHomeBtn;
@property (nonatomic, strong) UIButton *changeImageBtn;
@property (nonatomic, strong) UILabel *imgName;
@property (nonatomic, strong) UIImageView *imgAllView;
    
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) UIView *bgView;

@end

@implementation ImgGameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processSuccess:) name:@"success" object:nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _array = [[NSArray alloc] initWithObjects:@"Pom1.png", @"Pom2.png", @"Pom3.png", nil];
    
    _imgName = [[UILabel alloc] init];
    _imgName.text = _array[1];
    _img = [UIImage imageNamed:_imgName.text];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"星空2.jpeg"]];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self tapGestureRecognize];
    [self showHistory];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_firstImgV removeFromSuperview];
    [_secondImgV removeFromSuperview];
    [_thirdImgV removeFromSuperview];
    [_fourImgV removeFromSuperview];
    [_fiveImgV removeFromSuperview];
    [_sixImgV removeFromSuperview];
    [_sevenImgV removeFromSuperview];
    [_eightImgV removeFromSuperview];
    [_blackImgV removeFromSuperview];
    [_bgView removeFromSuperview];
}

#pragma mark - 显示历史记录
- (void)showHistory {
    
    __weak typeof(self) weakSelf = self;
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(20, 100, 210, 30)];
    UILabel *labelLeft = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 190, 30)];
    labelLeft.font = [UIFont fontWithName:@"DIN Alternate" size:14];
    labelLeft.textColor = [UIColor whiteColor];
    labelLeft.text = @"您上次完成本关用的步数为：";
    [_bgView addSubview:labelLeft];
    
    UILabel *historyLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 0, 20, 30)];
    historyLabel.textColor = [UIColor whiteColor];
    historyLabel.font = [UIFont fontWithName:@"DIN Alternate" size:20];
    // 获取服务器里的用户信息
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"JigsawGame"];
    // 查询JigsawGame表里多条数据
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        for (BmobObject * obj in array) {
            if ([weakSelf.userName.text isEqual:[obj objectForKey:@"userName"]]) {
                historyLabel.text = [obj objectForKey:@"stepsFirstCount"];
            }
        }
    }];
    [_bgView addSubview:historyLabel];
    [self.view addSubview:_bgView];
}

- (void)initView {
    
    _imgAllView = [[UIImageView alloc] initWithFrame:CGRectMake(235, 44, 100, 100)];
    [_imgAllView setImage:[UIImage imageNamed:_imgName.text]];
    [self.view addSubview:_imgAllView];
    
    self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    _imgView.center = self.view.center;
    _imgView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_imgView];
    
    _imgRef = _img.CGImage;
    _imgView.userInteractionEnabled = YES;
    
    _backHomeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _backHomeBtn.frame = CGRectMake(0, 0, 140, 30);
    _backHomeBtn.center = CGPointMake(self.view.center.x - 80, self.view.center.y + 220);
    [_backHomeBtn setTitle:@"返回首页" forState:UIControlStateNormal];
    _backHomeBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [_backHomeBtn addTarget:self action:@selector(processBackHomeButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backHomeBtn];
    
    _changeImageBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _changeImageBtn.frame = CGRectMake(0, 0, 140, 30);
    _changeImageBtn.center = CGPointMake(self.view.center.x + 80, self.view.center.y + 220);
    [_changeImageBtn setTitle:@"更换图片" forState:UIControlStateNormal];
    _changeImageBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [_changeImageBtn addTarget:self action:@selector(processChangImageButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_changeImageBtn];
    
}

#pragma mark - 判断
- (void)judge {
    
    //First
    int xFirst = (int)(_firstImgV.center.x);
    int yFirst = (int)(_firstImgV.center.y);
    //Second
    int xSecond = (int)(_secondImgV.center.x);
    int ySecond= (int)(_secondImgV.center.y);
    //Third
    int xThird = (int)(_thirdImgV.center.x);
    int yThird = (int)(_thirdImgV.center.y);
    //Four
    int xFour = (int)(_fourImgV.center.x);
    int yFour = (int)(_fourImgV.center.y);
    //Five
    int xFive = (int)(_fiveImgV.center.x);
    int yFive = (int)(_fiveImgV.center.y);
    //Six
    int xSix = (int)(_sixImgV.center.x);
    int ySix = (int)(_sixImgV.center.y);
    //Seven
    int xSeven = (int)(_sevenImgV.center.x);
    int ySeven = (int)(_sevenImgV.center.y);
    //Eight
    int xEight = (int)(_eightImgV.center.x);
    int yEight = (int)(_eightImgV.center.y);
    if (((xFirst == xFour)&& (xFirst == xSeven) && (xFour == xSeven)) && ((xSecond == xFive) && (xSecond == xEight) && (xFive == xEight)) && (xThird == xSix)) {
        if (((yFirst == ySecond) && (yFirst == yThird) && (ySecond == yThird)) && ((yFour == yFive) && (yFour == ySix) && (yFive == ySix)) && (ySeven == yEight)) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"恭喜你" message:@"拼图成功，智商超过160" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"下一关", @"上传本关成绩", @"上传本关成绩并开始下一关", nil];
            [alert show];
        }
    }
}

#pragma mark - 图片显示和点击动作
- (void)tapGestureRecognize {
    
    //----------------------------------上部-----------------------------
    //部分一（左上角）
    //切割图片的大小
    CGImageRef imgFirst = CGImageCreateWithImageInRect(_imgRef, CGRectMake(0, 0, kNumber, kNumber));
    CIImage *newFirstImg = [[CIImage alloc] initWithCGImage:imgFirst];
    //切割后的图片在视图上的位置
    _firstImgV = [[UIImageView alloc] initWithFrame:CGRectMake(kNumber, 0, kNumber, kNumber)];
    _firstImgV.image = [UIImage imageWithCIImage:newFirstImg];
    _firstImgV.layer.borderWidth = kBorderWidth;
    _firstImgV.layer.borderColor = [UIColor blackColor].CGColor;
    
    UITapGestureRecognizer *gestureRecognizerFirst = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(processGestureRecognizer:)];
    gestureRecognizerFirst.numberOfTapsRequired = 1;
    gestureRecognizerFirst.numberOfTouchesRequired = 1;
    _firstImgV.userInteractionEnabled = YES;
    _firstImgV.tag = 1;
    [_firstImgV addGestureRecognizer:gestureRecognizerFirst];
    [_imgView addSubview:_firstImgV];
    
    //部分二（最上面中部）
    CGImageRef imgSecond = CGImageCreateWithImageInRect(_imgRef, CGRectMake(kNumber, 0, kNumber, kNumber));
    CIImage *newSecondImg = [[CIImage alloc] initWithCGImage:imgSecond];
    _secondImgV = [[UIImageView alloc] initWithFrame:CGRectMake(kNumber, kNumber, kNumber, kNumber)];
    _secondImgV.image = [UIImage imageWithCIImage:newSecondImg];
    _secondImgV.layer.borderWidth = kBorderWidth;
    _secondImgV.layer.borderColor = [UIColor blackColor].CGColor;
    
    UITapGestureRecognizer *gestureRecognizerSecond = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(processGestureRecognizer:)];
    gestureRecognizerSecond.numberOfTapsRequired = 1;
    gestureRecognizerSecond.numberOfTouchesRequired = 1;
    _secondImgV.userInteractionEnabled = YES;
    _secondImgV.tag = 2;
    [_secondImgV addGestureRecognizer:gestureRecognizerSecond];
    [_imgView addSubview:_secondImgV];
    
    //部分三（右上角）
    CGImageRef imgThird = CGImageCreateWithImageInRect(_imgRef, CGRectMake(2 *kNumber, 0, kNumber, kNumber));
    CIImage *newThirdImg = [[CIImage alloc] initWithCGImage:imgThird];
    _thirdImgV = [[UIImageView alloc] initWithFrame:CGRectMake(2 *kNumber, 0, kNumber, kNumber)];
    _thirdImgV.image = [UIImage imageWithCIImage:newThirdImg];
    _thirdImgV.layer.borderWidth = kBorderWidth;
    _thirdImgV.layer.borderColor = [UIColor blackColor].CGColor;
  
    UITapGestureRecognizer *gestureRecognizerThird = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(processGestureRecognizer:)];
    gestureRecognizerThird.numberOfTapsRequired = 1;
    gestureRecognizerThird.numberOfTouchesRequired = 1;
    _thirdImgV.userInteractionEnabled = YES;
    _thirdImgV.tag = 3;
    [_thirdImgV addGestureRecognizer:gestureRecognizerThird];
    [_imgView addSubview:_thirdImgV];
    
    //--------------------------------中部------------------------------------------
    //部分四（中部左边）
    CGImageRef imgFour = CGImageCreateWithImageInRect(_imgRef, CGRectMake(0, kNumber, kNumber, kNumber));
    CIImage *newFourImg = [[CIImage alloc] initWithCGImage:imgFour];
    _fourImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kNumber, kNumber)];
    _fourImgV.image = [UIImage imageWithCIImage:newFourImg];
    _fourImgV.layer.borderWidth = kBorderWidth;
    _fourImgV.layer.borderColor = [UIColor blackColor].CGColor;
  
    UITapGestureRecognizer *gestureRecognizerFour = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(processGestureRecognizer:)];
    gestureRecognizerFour.numberOfTapsRequired = 1;
    gestureRecognizerFour.numberOfTouchesRequired = 1;
    _fourImgV.userInteractionEnabled = YES;
    _fourImgV.tag = 4;
    [_fourImgV addGestureRecognizer:gestureRecognizerFour];
    [_imgView addSubview:_fourImgV];
    
    //部分五（中部中间）
    CGImageRef imgFive = CGImageCreateWithImageInRect(_imgRef, CGRectMake(kNumber, kNumber, kNumber, kNumber));
    CIImage *newFiveImg = [[CIImage alloc] initWithCGImage:imgFive];
    _fiveImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2 *kNumber, kNumber, kNumber)];
    _fiveImgV.image = [UIImage imageWithCIImage:newFiveImg];
    _fiveImgV.layer.borderWidth = kBorderWidth;
    _fiveImgV.layer.borderColor = [UIColor blackColor].CGColor;
    
    UITapGestureRecognizer *gestureRecognizerFive = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(processGestureRecognizer:)];
    gestureRecognizerFive.numberOfTapsRequired = 1;
    gestureRecognizerFive.numberOfTouchesRequired = 1;
    _fiveImgV.userInteractionEnabled = YES;
    _fiveImgV.tag = 5;
    [_fiveImgV addGestureRecognizer:gestureRecognizerFive];
    [_imgView addSubview:_fiveImgV];
    
    //部分六（中部右边）
    CGImageRef imgSix = CGImageCreateWithImageInRect(_imgRef, CGRectMake(2 *kNumber, kNumber, kNumber, kNumber));
    CIImage *newSixImg = [[CIImage alloc] initWithCGImage:imgSix];
    _sixImgV = [[UIImageView alloc] initWithFrame:CGRectMake(2 *kNumber, kNumber, kNumber, kNumber)];
    _sixImgV.image = [UIImage imageWithCIImage:newSixImg];
    _sixImgV.layer.borderWidth = kBorderWidth;
    _sixImgV.layer.borderColor = [UIColor blackColor].CGColor;
    
    UITapGestureRecognizer *gestureRecognizerSix = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(processGestureRecognizer:)];
    gestureRecognizerSix.numberOfTapsRequired = 1;
    gestureRecognizerSix.numberOfTouchesRequired = 1;
    _sixImgV.userInteractionEnabled = YES;
    _sixImgV.tag = 6;
    [_sixImgV addGestureRecognizer:gestureRecognizerSix];
    [_imgView addSubview:_sixImgV];
    
    //-----------------------------------下部-----------------------------------
    //部分七（左下角）
    CGImageRef imgSeven = CGImageCreateWithImageInRect(_imgRef, CGRectMake(0, 2 *kNumber, kNumber, kNumber));
    CIImage *newSevenImg = [[CIImage alloc] initWithCGImage:imgSeven];
    _sevenImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, kNumber, kNumber, kNumber)];
    _sevenImgV.image = [UIImage imageWithCIImage:newSevenImg];
    _sevenImgV.layer.borderWidth = kBorderWidth;
    _sevenImgV.layer.borderColor = [UIColor blackColor].CGColor;
    
    UITapGestureRecognizer *gestureRecognizerSeven = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(processGestureRecognizer:)];
    gestureRecognizerSeven.numberOfTapsRequired = 1;
    gestureRecognizerSeven.numberOfTouchesRequired = 1;
    _sevenImgV.userInteractionEnabled = YES;
    _sevenImgV.tag = 7;
    [_sevenImgV addGestureRecognizer:gestureRecognizerSeven];
    [_imgView addSubview:_sevenImgV];
    
    //部分八（下部中间）
    CGImageRef imgEight = CGImageCreateWithImageInRect(_imgRef, CGRectMake(kNumber, 2 *kNumber, kNumber, kNumber));
    CIImage *newEightImg = [[CIImage alloc] initWithCGImage:imgEight];
    _eightImgV = [[UIImageView alloc] initWithFrame:CGRectMake(kNumber, 2 *kNumber, kNumber, kNumber)];
    _eightImgV.image = [UIImage imageWithCIImage:newEightImg];
    _eightImgV.layer.borderWidth = kBorderWidth;
    _eightImgV.layer.borderColor = [UIColor blackColor].CGColor;
    
    UITapGestureRecognizer *gestureRecognizerEight = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(processGestureRecognizer:)];
    gestureRecognizerEight.numberOfTapsRequired = 1;
    gestureRecognizerEight.numberOfTouchesRequired = 1;
    _eightImgV.userInteractionEnabled = YES;
    _eightImgV.tag = 8;
    [_eightImgV addGestureRecognizer:gestureRecognizerEight];
    [_imgView addSubview:_eightImgV];
    
    //部分九（右下角）
    _blackImgV = [[UIImageView alloc] initWithFrame:CGRectMake(2 *kNumber, 2 *kNumber, kNumber, kNumber)];
    _blackImgV.layer.borderWidth = kBorderWidth;
    [_imgView addSubview:_blackImgV];
}

#pragma mark - <UIAlertViewDelegate>
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    __weak typeof(self) weakSelf = self;
    _firstImgV.userInteractionEnabled = NO;
    _secondImgV.userInteractionEnabled = NO;
    _thirdImgV.userInteractionEnabled = NO;
    _fourImgV.userInteractionEnabled = NO;
    _fiveImgV.userInteractionEnabled = NO;
    _sixImgV.userInteractionEnabled = NO;
    _sevenImgV.userInteractionEnabled = NO;
    _eightImgV.userInteractionEnabled = NO;
    if (buttonIndex == 1) {
//        vc.modalPresentationStyle = UIModalPresentationFullScreen;
//        [self presentViewController:_imageSecond animated:YES completion:nil];
    }
    if (buttonIndex == 2) {
        if (_count > 0) {
#pragma mark - 修改Bmob数据
            //获取服务器里的用户信息
            BmobQuery *bquery = [BmobQuery queryWithClassName:@"JigsawGame"];
            //查询JigsawGame表里多条数据
            [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                
                for (BmobObject *obj in array) {
                    if ([weakSelf.userName.text isEqual:[obj objectForKey:@"userName"]]) {
                        //修改Bmob数据信息
                        [bquery getObjectInBackgroundWithId:obj.objectId block:^(BmobObject *object, NSError *error) {
                            
                            if (!error) {
                                //对象存在
                                if (object) {
                                    BmobObject *obj1 = [BmobObject objectWithoutDatatWithClassName:object.className objectId:object.objectId];
                                    [obj1 setObject:[NSString stringWithFormat:@"%ld", weakSelf.count] forKey:@"stepsFirstCount"];
                                    //异步更新数据
                                    [obj1 updateInBackground];
                                }
                            }
                            else {
                                //进行错误处理
                                NSLog(@"%@", error.localizedDescription);
                            }
                        }];
                    }
                }
            }];
        }
    }
    if (buttonIndex == 3) {
//        ImageViewControllerSecond *imageSecond = [[ImageViewControllerSecond alloc] init];
//        vc.modalPresentationStyle = UIModalPresentationFullScreen;
//        [self presentViewController:imageSecond animated:YES completion:nil];
//        if (count > 0) {
//#pragma mark - 修改Bmob数据
//            // 获取服务器里的用户信息
//            BmobQuery * bquery = [BmobQuery queryWithClassName:@"JigsawGame"];
//            // 查询JigsawGame表里多条数据
//            [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
//
//                for (BmobObject * obj in array) {
//                    if ([_userName.text isEqual:[obj objectForKey:@"userName"]]) {
//                        // 修改Bmob数据信息
//                        [bquery getObjectInBackgroundWithId:obj.objectId block:^(BmobObject *object, NSError *error) {
//                            if (!error) {
//                                // 对象存在
//                                if (object) {
//                                    BmobObject *obj1 = [BmobObject objectWithoutDatatWithClassName:object.className objectId:object.objectId];
//                                    [obj1 setObject:[NSString stringWithFormat:@"%ld", count] forKey:@"stepsFirstCount"];
//                                    // 异步更新数据
//                                    [obj1 updateInBackground];
//                                }
//                            } else {
//                                // 进行错误处理
//                                NSLog(@"%@", error.localizedDescription);
//                            }
//                        }];
//                    }
//                }
//            }];
//        }
    }
}

#pragma mark - ImageViewProcess
- (void)processGestureRecognizer:(UIGestureRecognizer *)gesture {
    
    if (gesture.view.tag == 1) {
        [self move:_firstImgV];
        [self judge];
    }
    if (gesture.view.tag == 2) {
        [self move:_secondImgV];
        [self judge];
    }
    if (gesture.view.tag == 3) {
        [self move:_thirdImgV];
        [self judge];
    }
    if (gesture.view.tag == 4) {
        [self move:_fourImgV];
        [self judge];
    }
    if (gesture.view.tag == 5) {
        [self move:_fiveImgV];
        [self judge];
    }
    if (gesture.view.tag == 6) {
        [self move:_sixImgV];
        [self judge];
    }
    if (gesture.view.tag == 7) {
        [self move:_sevenImgV];
        [self judge];
    }
    if (gesture.view.tag == 8) {
        [self move:_eightImgV];
        [self judge];
    }
    _count++;
}

#pragma mark - Notification
- (void)processSuccess:(NSNotification *)notification {
    
    NSDictionary * dic = [notification userInfo];
    _userName = [[UILabel alloc] initWithFrame:CGRectMake(115, 80, 100, 30)];
    _userName.textColor = [UIColor whiteColor];
    _userName.font = [UIFont fontWithName:@"DIN Alternate" size:20];
    _userName.text = [dic objectForKey:@"text"];
}

#pragma mark - buttonProcess
#pragma mark - 更换图片按钮
- (void)processChangImageButton {
    
    _arrayCount ++;
    if (_arrayCount == 1) {
        _imgName.text = _array[0];
        _img = [UIImage imageNamed:_imgName.text];
        [_imgView removeFromSuperview];
        [_backHomeBtn removeFromSuperview];
        [_changeImageBtn removeFromSuperview];
        [_imgAllView removeFromSuperview];
        [_bgView removeFromSuperview];
        [self initView];
        [self tapGestureRecognize];
        [self showHistory];
    }
    if (_arrayCount == 2) {
        _imgName.text = _array[2];
        _img = [UIImage imageNamed:_imgName.text];
        [_imgView removeFromSuperview];
        [_backHomeBtn removeFromSuperview];
        [_changeImageBtn removeFromSuperview];
        [_imgAllView removeFromSuperview];
        [_bgView removeFromSuperview];
        [self initView];
        [self tapGestureRecognize];
        [self showHistory];
    }
    if (_arrayCount == 3) {
        _arrayCount = 0;
    }
    if (_arrayCount == 0) {
        _imgName.text = _array[1];
        _img = [UIImage imageNamed:_imgName.text];
        [_imgView removeFromSuperview];
        [_backHomeBtn removeFromSuperview];
        [_changeImageBtn removeFromSuperview];
        [_imgAllView removeFromSuperview];
        [_bgView removeFromSuperview];
        [self initView];
        [self tapGestureRecognize];
        [self showHistory];
    }
}

#pragma mark - 返回首页按钮
- (void)processBackHomeButton{
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - move
- (void)move:(UIImageView *)send {
    
    __weak typeof(self) weakSelf = self;
    //left
    if (send.frame.origin.x - kNumber == _blackImgV.frame.origin.x && send.frame.origin.y  == _blackImgV.frame.origin.y) {
        [UIView animateWithDuration:0.5 animations:^{
            
            send.frame = CGRectMake(weakSelf.blackImgV.frame.origin.x, weakSelf.blackImgV.frame.origin.y, kNumber, kNumber);
            weakSelf.blackImgV.frame = CGRectMake(send.frame.origin.x + kNumber, send.frame.origin.y, kNumber, kNumber);
        }];
    }
    //right
    else if (send.frame.origin.x + kNumber == _blackImgV.frame.origin.x && send.frame.origin.y == _blackImgV.frame.origin.y) {
        [UIView animateWithDuration:0.5 animations:^{
            
            send.frame = CGRectMake(weakSelf.blackImgV.frame.origin.x, weakSelf.blackImgV.frame.origin.y, kNumber, kNumber);
            weakSelf.blackImgV.frame = CGRectMake(send.frame.origin.x - kNumber, send.frame.origin.y, kNumber, kNumber);
        }];
    }
    //up
    else if (send.frame.origin.x == _blackImgV.frame.origin.x && send.frame.origin.y - kNumber == _blackImgV.frame.origin.y) {
        [UIView animateWithDuration:0.5 animations:^{
            
            send.frame = CGRectMake(weakSelf.blackImgV.frame.origin.x, weakSelf.blackImgV.frame.origin.y, kNumber, kNumber);
            weakSelf.blackImgV.frame = CGRectMake(send.frame.origin.x, send.frame.origin.y + kNumber, kNumber, kNumber);
        }];
    }
    //down
    else if (send.frame.origin.x == _blackImgV.frame.origin.x && send.frame.origin.y + kNumber == _blackImgV.frame.origin.y) {
        [UIView animateWithDuration:0.5 animations:^{
            
            send.frame = CGRectMake(weakSelf.blackImgV.frame.origin.x, weakSelf.blackImgV.frame.origin.y, kNumber, kNumber);
            weakSelf.blackImgV.frame = CGRectMake(send.frame.origin.x, send.frame.origin.y - kNumber, kNumber, kNumber);
        }];
    }
}

@end
