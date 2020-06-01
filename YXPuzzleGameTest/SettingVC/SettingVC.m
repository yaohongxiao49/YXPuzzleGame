//
//  SettingVC.m
//  YXPuzzleGameTest
//
//  Created by ios on 2020/6/1.
//  Copyright © 2020 August. All rights reserved.
//

#import "SettingVC.h"
#import <AVFoundation/AVFoundation.h>

@interface SettingVC ()

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) NSString *musicName;
@property (nonatomic, strong) UISlider *soundSlider;

@end

@implementation SettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [imageView setImage:[UIImage imageNamed:@"星空.jpeg"]];
    [self.view addSubview:imageView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"Set";
    [self initView];
}

- (void)initView {
    
    //获取音乐文件专辑图片
    _musicName = @"background.mp3";
    NSURL *musicUrl = [[NSBundle mainBundle] URLForAuxiliaryExecutable:_musicName];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:musicUrl options:nil];
    for (NSString *format in [urlAsset availableMetadataFormats]) {
        for (AVMetadataItem *metadataItem in [urlAsset metadataForFormat:format]) {
            if ([metadataItem.commonKey isEqualToString:@"artwork"]) {
//                NSLog(@"%@",metadataItem.value);
                NSData *data = [metadataItem.value copyWithZone:nil];
                //得到图片数据
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 250, 250)];
                imageView.center = CGPointMake(self.view.center.x, self.view.center.y - 80);
                //通过图片数据设置图片视图
                [imageView setImage:[UIImage imageWithData:data]];
                [self.view addSubview:imageView];
            }
        }
    }
    
    //音乐开关
    UILabel *musicSwitchLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) /2 - 120, CGRectGetHeight(self.view.frame) - 185, 200, 20)];
    musicSwitchLabel.text = @"是否播放音乐:";
    musicSwitchLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:musicSwitchLabel];
    UISwitch *musicSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)/ 2 + 20, CGRectGetHeight(self.view.frame) - 190, 150, 10)];
    
    [musicSwitch addTarget:self action:@selector(processSwitch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:musicSwitch];
    
    //音量滑动条
    UILabel *soundLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) /2 - 120, CGRectGetHeight(self.view.frame) - 145, 100, 20)];
    soundLabel.text = @"音量调节：";
    soundLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:soundLabel];
    _soundSlider = [[UISlider alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) /2 - 10, CGRectGetHeight(self.view.frame) - 140, 150, 10)];
    [_soundSlider setThumbImage:[UIImage imageNamed:@"圆点.png"] forState:UIControlStateNormal];
    [_soundSlider addTarget:self action:@selector(processSoundSlider:) forControlEvents:UIControlEventValueChanged];
    _soundSlider.value = 0.5;
    _audioPlayer.volume = _soundSlider.value;
    [self.view addSubview:_soundSlider];
}

#pragma mark - 初始化音乐播放器
- (void)initAudioPlayer:(NSString *)musicName autoPlay:(BOOL)autoPlay {
    
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
    }
}

#pragma mark - process
#pragma mark - 音乐开关
- (void)processSwitch:(UISwitch *)sender {
    
    _musicName = @"background.mp3";
    [self initAudioPlayer:_musicName autoPlay:YES];
    sender.isOn == NO ? [_audioPlayer stop] : [_audioPlayer play];
}

#pragma mark - 音量调节
- (void)processSoundSlider:(UISlider *)sender {
    
    //音量
    _audioPlayer.volume = sender.value;
}

@end
