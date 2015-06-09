//
//  EveViewController.m
//  PhoneNumber
//
//  Created by Sun jishuai on 15/6/2.
//  Copyright (c) 2015年 SunJishuai. All rights reserved.
//

#import "EveViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
@interface EveViewController ()<AVAudioPlayerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    AVAudioPlayer *_ap;
    MPMoviePlayerController *_pvc;
    MPMoviePlayerViewController * _mpvc;
}
@end

@implementation EveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(changeColor) userInfo:nil repeats:YES];
    
    //真正内容的大小
    _photo.contentSize=CGSizeMake(_photo.frame.size.width*6,self.view.frame.size.height-64);
    //偏移量
  //  _photo.contentOffset=CGPointMake(0, 0);
    //分页属性
    _photo.pagingEnabled=YES;
    //方向锁定
    _photo.directionalLockEnabled=YES;
    //添加到选择框下面
    [self.view addSubview:_photo];
    for (int i = 0; i < 6; i++) {
        UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.JPG",i]];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGestures)];
        longPress.numberOfTouchesRequired = 2;
        longPress.allowableMovement = 100.0f;
        longPress.minimumPressDuration = 1;
   
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(_photo.frame.size.width*i,0,_photo.frame.size.width , _photo.frame.size.height)];
        [imageView  addGestureRecognizer:longPress];
        if (i == 1 || i == 5) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeInfoLight];
            btn.frame = CGRectMake(20, 20, 44, 44);
            [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = i;
            [imageView addSubview:btn];
        }
        
        imageView.userInteractionEnabled = YES;
        imageView.image = image;
        [_photo addSubview:imageView];
    }
   
    // 音频播放器只能播放本地音乐
    NSString *path = [NSString stringWithFormat:@"%@/1.mp3",[[NSBundle mainBundle] resourcePath]];
    // 本地路径转化URL
    NSURL *url = [NSURL fileURLWithPath:path];
    _ap =[[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    // 设置音量
    [_ap setVolume:0.5];
    _ap.delegate = self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [_ap play];
}
- (void)changeColor
{
    NSString *numberPlist = [[NSBundle mainBundle]pathForResource:@"headImageColor" ofType:@"plist"];
    NSArray *numberArray = [[NSArray alloc]initWithContentsOfFile:numberPlist];
    int colorNum = arc4random()%6;
    NSDictionary *dict = [numberArray objectAtIndex:colorNum];
    _happy.textColor =[UIColor colorWithRed:[[dict objectForKey:@"R"]intValue]/256.0 green:[[dict objectForKey:@"G"]intValue]/256.0 blue:[[dict objectForKey:@"B"]intValue]/256.0 alpha:1.0];
    ((UILabel *)[_photo viewWithTag:101]).textColor = _happy.textColor;
    ((UILabel *)[_photo viewWithTag:101]).font = [UIFont systemFontOfSize:17+colorNum/3];
}
- (void)handleLongPressGestures
{
    [_ap stop];
    //返回
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
- (void)click:(UIButton *)btn
{
    [_ap pause];
    if (btn.tag == 1) {
        NSURL *videoUrl=[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/myEve.MOV",[[NSBundle mainBundle]resourcePath]]];
        [self playVideo:videoUrl];
    }else if (btn.tag == 5)
    {
        //拍照
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *myImagePicker = [[UIImagePickerController alloc]init];
            myImagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            myImagePicker.delegate = self;
            myImagePicker.allowsEditing = NO;
            myImagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            [self presentViewController:myImagePicker animated:YES completion:^(){
            }];//show the camera
        }
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* image=[info objectForKey:UIImagePickerControllerOriginalImage];
    //真正内容的大小
    _photo.contentSize=CGSizeMake(_photo.frame.size.width*7,self.view.frame.size.height-64);
    //偏移量
    _photo.contentOffset=CGPointMake(_photo.frame.size.width*6, 0);
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGestures)];
    longPress.numberOfTouchesRequired = 2;
    longPress.allowableMovement = 100.0f;
    longPress.minimumPressDuration = 1;
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(_photo.frame.size.width*6,0,_photo.frame.size.width , _photo.frame.size.height)];
    [imageView  addGestureRecognizer:longPress];
    imageView.userInteractionEnabled = YES;
    imageView.image = image;
    //翻转
    imageView.transform = CGAffineTransformMakeScale(-1, 1);

    //在多次添加的时候，会有累积
    [[_photo viewWithTag:101]removeFromSuperview];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(_photo.frame.size.width*6+20, 10, self.view.frame.size.width-40, 120)];
    label.font = [UIFont systemFontOfSize:17];
    label.textColor = [UIColor redColor];
    label.text = @"最真的心,给最爱的你!不是言语的承诺,而是神对心灵的指引! I need you ,need your help——forgiveness and prayer!求神指引我们继续走下去的脚步!";
    label.numberOfLines = 7;
    label.tag = 101;
    [_photo addSubview:imageView];
    [_photo addSubview:label];
    [picker dismissViewControllerAnimated:YES completion:^{
        [_ap play];
    }];
}

#pragma mark 背景音乐循环播放
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag;
{
    [_ap play];
}
#pragma mark 根据视频URL播放视频
- (void)playVideo:(NSURL *) movieURL
{
    _mpvc=[[MPMoviePlayerViewController alloc]initWithContentURL:movieURL];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playVideoFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:[_mpvc moviePlayer]];
    [self presentViewController:_mpvc animated:YES completion:^{
    }];
    
    _pvc = [_mpvc moviePlayer];
    [_pvc play];
}
#pragma mark 视频播放，当点击Done按键或播放完成时调用此函数
- (void)playVideoFinished:(NSNotification *)note
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:_pvc];
    [_pvc stop];
    [_mpvc dismissViewControllerAnimated:YES completion:^{
    }];
    [_ap play];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
