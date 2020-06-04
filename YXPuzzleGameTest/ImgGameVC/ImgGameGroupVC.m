
//
//  ImgGameGroupVC.m
//  YXPuzzleGameTest
//
//  Created by ios on 2020/6/2.
//  Copyright © 2020 August. All rights reserved.
//

#import "ImgGameGroupVC.h"
#import <BmobSDK/Bmob.h>

#define kBorderWidth 2

@interface ImgGameGroupVC ()

@property (nonatomic, copy) NSString *currentImgUrl; //当前图片地址
@property (nonatomic, strong) UIImageView *currentImgV; //当前图片
@property (nonatomic, strong) UIView *showBgView; //显示背景视图
@property (nonatomic, strong) NSMutableArray *stepImgArr; //切割图片数组
@property (nonatomic, copy) NSString *userName; //用户名
@property (nonatomic, assign) NSInteger stepAmount; //步数统计
@property (nonatomic, assign) NSInteger placeHolderIndex; //占位下标
@property (nonatomic, assign) NSInteger checkpointAmount; //关卡统计
@property (nonatomic, assign) BOOL boolSettlement; //是否结算

@end

@implementation ImgGameGroupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    _checkpointAmount = 1;
    [self initView];
}

#pragma mark - method
#pragma mark - 图片随机排列
- (void)randomImgVArrangement {
    
    __weak typeof(self) weakSelf = self;
    for (NSInteger i = 0; i < 100; i ++) {
        NSInteger value = arc4random() %(_stepImgArr.count - 1);
        UIImageView *imgV = _stepImgArr[value];
        [imgV.gestureRecognizers enumerateObjectsUsingBlock:^(__kindof UIGestureRecognizer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           
            if ([obj isKindOfClass:[UITapGestureRecognizer class]]) {
                weakSelf.boolSettlement = NO;
                [weakSelf imgChange:obj.view.tag];
            }
        }];
    }
}

#pragma mark - 更新显示数据
- (void)uploadValue {
    
    __weak typeof(self) weakSelf = self;
    [self initDataSource];
    [self loadImgVByUrl:_currentImgUrl showImgV:_currentImgV finished:^(UIImage *img) {
      
        [weakSelf.currentImgV setImage:img];
        [weakSelf cuttingImg];
        [weakSelf randomImgVArrangement];
    }];
}

#pragma mark - 修改数据库数据
- (void)changeBmobValue {
    
    __weak typeof(self) weakSelf = self;
    self.showBgView.userInteractionEnabled = NO;
    
    //获取服务器里的用户信息
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"JigsawGame"];
    //查询JigsawGame表里多条数据
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        for (BmobObject *obj in array) {
            //修改Bmob数据信息
            [bquery getObjectInBackgroundWithId:obj.objectId block:^(BmobObject *object, NSError *error) {
                
                if (!error) {
                    //对象存在
                    if (object) {
                        BmobObject *obj = [BmobObject objectWithoutDatatWithClassName:object.className objectId:object.objectId];
                        [obj setObject:[NSString stringWithFormat:@"%@", @(weakSelf.checkpointAmount)] forKey:@"checkpoint"];
                        //异步更新数据
                        [obj updateInBackground];
                        
                        [weakSelf.exChangeImgArr removeObjectAtIndex:0];
                        if (weakSelf.exChangeImgArr.count != 0) {
                            [weakSelf uploadValue];
                        }
                        else {
                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"恭喜您" message:@"您已经通关了！快去欣赏自己的排名吧" preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *sure = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%@", @"确定"] style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                                
                                [weakSelf processBackHomeBtn];
                            }];
                            
                            [alert addAction:sure];
                            [weakSelf presentViewController:alert animated:YES completion:nil];
                        }
                    }
                }
                else {
                    //进行错误处理
                    NSLog(@"error == %@", error.localizedDescription);
                }
                weakSelf.showBgView.userInteractionEnabled = YES;
            }];
        }
    }];
}

#pragma mark - 加载图片
- (void)loadImgVByUrl:(NSString *)url showImgV:(UIImageView *)showImgV finished:(void(^)(UIImage *img))finished {
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        UIImage *img = [url containsString:@"http"] ? [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]] : [UIImage imageNamed:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIImage *endImg = [weakSelf imgCompressForSizeImg:img targetSize:showImgV.bounds.size];
            if (finished) {
                finished(endImg);
            }
        });
    });
}

#pragma mark - 按比例缩放图片
- (UIImage *)imgCompressForSizeImg:(id)imgValue targetSize:(CGSize)targetSize {
    
    UIImage *img = [[UIImage alloc] init];
    img = [imgValue isKindOfClass:[UIImage class]] ? imgValue: [UIImage imageNamed:imgValue];
    
    UIImage *newImg = nil;
    CGSize imgSize = img.size;
    CGFloat width = imgSize.width;
    CGFloat height = imgSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if (CGSizeEqualToSize(imgSize, targetSize) == NO) {
        CGFloat widthFactor = targetWidth /width;
        CGFloat heightFactor = targetHeight /height;

        scaleFactor = widthFactor > heightFactor ? widthFactor : heightFactor;
        scaledWidth = width *scaleFactor;
        scaledHeight = height *scaleFactor;

        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) *0.5;
        }
        else if (widthFactor < heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) *0.5;
        }
    }
    
    UIGraphicsBeginImageContextWithOptions(targetSize, YES, 0);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [img drawInRect:thumbnailRect];
    newImg = UIGraphicsGetImageFromCurrentImageContext();

    if (newImg == nil) NSLog(@"scale image fail");
    UIGraphicsEndImageContext();
    
    return newImg;
}

#pragma mark - 切割图片
- (void)cuttingImg {
    
    _stepImgArr = [[NSMutableArray alloc] init];
    
    NSInteger xCount = self.baseNum;
    NSInteger yCount = self.baseNum;
    NSInteger imgAmount = self.baseNum *self.baseNum;
    NSInteger size = (NSInteger)(_showBgView.bounds.size.width /self.baseNum);
    
    NSInteger amount = 0;
    for (NSInteger i = 0; i < xCount; i ++) {
        for (NSInteger j = 0; j < yCount; j ++) {
            //显示的切割图片
            CGImageRef imgRef = CGImageCreateWithImageInRect(_currentImgV.image.CGImage, CGRectMake(size *i, size *j, size, size));
            CIImage *newImg = [[CIImage alloc] initWithCGImage:imgRef];
            
            //显示的图片空间
            UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(size *i, size *j, size, size)];
            imgV.layer.borderWidth = kBorderWidth;
            imgV.layer.borderColor = [UIColor blackColor].CGColor;
            imgV.backgroundColor = [UIColor blackColor];
            imgV.tag = amount;
            imgV.userInteractionEnabled = YES;
            [_showBgView addSubview:imgV];
            
            if (amount != (imgAmount - 1)) { //不是最后一张，正常显示
                imgV.image = [UIImage imageWithCIImage:newImg];
                
                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(processGestureRecognizer:)];
                tapGesture.numberOfTapsRequired = 1;
                tapGesture.numberOfTouchesRequired = 1;
                [imgV addGestureRecognizer:tapGesture];
            }
            [_stepImgArr addObject:imgV];
            amount ++;
        }
    }
}

#pragma mark - 图片移动
- (void)stepImgVMoveByImgV:(UIImageView *)imgV placeHolderImgV:(UIImageView *)placeHolderImgV {
    
    NSInteger size = (NSInteger)(_showBgView.bounds.size.width /self.baseNum);
    
    if (imgV.frame.origin.x - size == placeHolderImgV.frame.origin.x && imgV.frame.origin.y == placeHolderImgV.frame.origin.y) { //left
        [self exChangeImgVAndArrByImgV:imgV placeHolderImgV:placeHolderImgV];
        [UIView animateWithDuration:0.5 animations:^{
            
            imgV.frame = CGRectMake(placeHolderImgV.frame.origin.x, placeHolderImgV.frame.origin.y, size, size);
            placeHolderImgV.frame = CGRectMake(imgV.frame.origin.x + size, imgV.frame.origin.y, size, size);
        }];
    }
    else if (imgV.frame.origin.x + size == placeHolderImgV.frame.origin.x && imgV.frame.origin.y == placeHolderImgV.frame.origin.y) { //right
        [self exChangeImgVAndArrByImgV:imgV placeHolderImgV:placeHolderImgV];
        [UIView animateWithDuration:0.5 animations:^{
            
            imgV.frame = CGRectMake(placeHolderImgV.frame.origin.x, placeHolderImgV.frame.origin.y, size, size);
            placeHolderImgV.frame = CGRectMake(imgV.frame.origin.x - size, imgV.frame.origin.y, size, size);
        }];
    }
    else if (imgV.frame.origin.x == placeHolderImgV.frame.origin.x && imgV.frame.origin.y - size == placeHolderImgV.frame.origin.y) { //up
        [self exChangeImgVAndArrByImgV:imgV placeHolderImgV:placeHolderImgV];
        [UIView animateWithDuration:0.5 animations:^{
            
            imgV.frame = CGRectMake(placeHolderImgV.frame.origin.x, placeHolderImgV.frame.origin.y, size, size);
            placeHolderImgV.frame = CGRectMake(imgV.frame.origin.x, imgV.frame.origin.y + size, size, size);
        }];
    }
    else if (imgV.frame.origin.x == placeHolderImgV.frame.origin.x && imgV.frame.origin.y + size == placeHolderImgV.frame.origin.y) { //down
        [self exChangeImgVAndArrByImgV:imgV placeHolderImgV:placeHolderImgV];
        [UIView animateWithDuration:0.5 animations:^{
            
            imgV.frame = CGRectMake(placeHolderImgV.frame.origin.x, placeHolderImgV.frame.origin.y, size, size);
            placeHolderImgV.frame = CGRectMake(imgV.frame.origin.x, imgV.frame.origin.y - size, size, size);
        }];
    }
}
- (void)exChangeImgVAndArrByImgV:(UIImageView *)imgV placeHolderImgV:(UIImageView *)placeHolderImgV {
    
    __weak typeof(self) weakSelf = self;
    __block NSInteger placeHodleIndex = placeHolderImgV.tag;
    __block NSInteger exChangeIndex = 0;
    [_stepImgArr enumerateObjectsUsingBlock:^(UIImageView *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        if (obj.tag == placeHolderImgV.tag) {
            placeHodleIndex = idx;
        }
        if (obj.tag == imgV.tag) {
            exChangeIndex = idx;
            weakSelf.placeHolderIndex = exChangeIndex;
        }
    }];
    
    [_stepImgArr exchangeObjectAtIndex:exChangeIndex withObjectAtIndex:placeHodleIndex];
}

#pragma mark - 判断是否拼接完成
- (void)judgeImgVSame {
    
    NSMutableArray *tagArr = [[NSMutableArray alloc] init];
    NSMutableArray *norTagArr = [[NSMutableArray alloc] init];
    [_stepImgArr enumerateObjectsUsingBlock:^(UIImageView *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        [norTagArr addObject:@(obj.tag)];
        if (obj.tag == idx) {
            [tagArr addObject:@(obj.tag)];
        }
    }];
    
    if (tagArr.count == (self.baseNum *self.baseNum)) {
        [self showAlertView];
    }
}

#pragma mark - 确认弹窗
- (void)showAlertView {
    
    __weak typeof(self) weakSelf = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"恭喜您" message:@"拼图成功，是否进入下一关" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%@", @"确定"] style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        weakSelf.checkpointAmount++;
        [weakSelf changeBmobValue];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%@", @"返回，并上传本关成绩"] style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
    
        [weakSelf changeBmobValue];
        [weakSelf processBackHomeBtn];
    }];
    
    [alert addAction:sure];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - progress
#pragma mark - 返回首页
- (void)processBackHomeBtn {
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 换一关
- (void)processChangeCheckpointBtn {
    
    __weak typeof(self) weakSelf = self;
    NSInteger index = arc4random() %self.exChangeImgArr.count;
    _currentImgUrl = self.exChangeImgArr[index];
    NSInteger imgAmount = self.baseNum *self.baseNum;
    _placeHolderIndex = (imgAmount - 1) < 0 ? 0 : (imgAmount - 1);
    [_showBgView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        [obj removeFromSuperview];
    }];
    [self loadImgVByUrl:_currentImgUrl showImgV:_currentImgV finished:^(UIImage *img) {
      
        [weakSelf.currentImgV setImage:img];
        [weakSelf cuttingImg];
        [weakSelf randomImgVArrangement];
    }];
}

#pragma mark - 图片变换
- (void)imgChange:(NSInteger)tag {
    
    __block NSInteger moveImgIndex = tag;
    [_stepImgArr enumerateObjectsUsingBlock:^(UIImageView *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj.tag == tag) {
            moveImgIndex = idx;
        }
    }];
    UIImageView *moveImgV = _stepImgArr[moveImgIndex];
    UIImageView *placeHolderImgV = _stepImgArr[_placeHolderIndex];
    
    [self stepImgVMoveByImgV:moveImgV placeHolderImgV:placeHolderImgV];
    if (_boolSettlement) [self judgeImgVSame];
}

#pragma mark - 点击图片
- (void)processGestureRecognizer:(UIGestureRecognizer *)gesture {
    
    _boolSettlement = YES;
    [self imgChange:gesture.view.tag];
    _stepAmount++;
}

#pragma mark - 初始化数据
- (void)initDataSource {
    
    _currentImgUrl = [self.exChangeImgArr firstObject];
    NSInteger imgAmount = self.baseNum *self.baseNum;
    _placeHolderIndex = (imgAmount - 1) < 0 ? 0 : (imgAmount - 1);
    [_showBgView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        [obj removeFromSuperview];
    }];
}

#pragma mark - 初始化视图
- (void)initView {
 
    UIImageView *bgImgV = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [bgImgV setImage:[UIImage imageNamed:@"星空2.jpeg"]];
    bgImgV.contentMode = UIViewContentModeScaleAspectFill;
    bgImgV.userInteractionEnabled = YES;
    [self.view addSubview:bgImgV];
    
    CGFloat showBgViewWidth = bgImgV.bounds.size.width - 40;
    _showBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, showBgViewWidth, showBgViewWidth)];
    _showBgView.center = self.view.center;
    _showBgView.backgroundColor = [UIColor blackColor];
    [bgImgV addSubview:_showBgView];
    
    _currentImgV = [[UIImageView alloc] initWithFrame:CGRectMake(bgImgV.bounds.size.width - 120, _showBgView.frame.origin.y - 120, 100, 100)];
    [bgImgV addSubview:_currentImgV];
    
    UIButton *backHomeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    backHomeBtn.frame = CGRectMake(30, CGRectGetMaxY(_showBgView.frame) + 20, 140, 30);
    [backHomeBtn setTitle:@"返回首页" forState:UIControlStateNormal];
    backHomeBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [backHomeBtn addTarget:self action:@selector(processBackHomeBtn) forControlEvents:UIControlEventTouchUpInside];
    [bgImgV addSubview:backHomeBtn];
    
    UIButton *changeCheckpointBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    changeCheckpointBtn.frame = CGRectMake(CGRectGetMaxX(backHomeBtn.frame) + 20, CGRectGetMinY(backHomeBtn.frame), 140, 30);
    [changeCheckpointBtn setTitle:@"换一关" forState:UIControlStateNormal];
    changeCheckpointBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [changeCheckpointBtn addTarget:self action:@selector(processChangeCheckpointBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeCheckpointBtn];
    
    [self uploadValue];
}

@end
