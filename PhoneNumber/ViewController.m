//
//  ViewController.m
//  PhoneNumber
//
//  Created by Sun jishuai on 15/6/1.
//  Copyright (c) 2015年 SunJishuai. All rights reserved.
//

#import "ViewController.h"
#import "EveViewController.h"
@interface ViewController ()
{
    UIWebView *_webView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    /*create the gesture recognizer*/
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGestures)];
    /*the number of fingers that must be present on the screen */
    longPress.numberOfTouchesRequired = 3;
    /*maximum 100 points of movement allowed before the gesture is recognized*/
    longPress.allowableMovement = 100.0f;
    /*the user must press two fingers(numberOfTouchesRequired)for at least one second for the gesture to be recognized*/
    longPress.minimumPressDuration = 1.0;
    /*add this gesture recognizer to the view*/
    [self.view  addGestureRecognizer:longPress];
}

- (IBAction)Verification:(id)sender {
    if ([self isBlankString: self.inputNumber.text]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"输入内容不可为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else{
        if ([self.inputNumber.text isEqualToString:@"18724759939"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"这是坏蛋的手机号码吗？" delegate:self cancelButtonTitle:@"不是" otherButtonTitles:@"是", nil];
            [alert show];
            alert.tag = 102;
            return;
        }
        if ([self.inputNumber.text isEqualToString:@"18354268178"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"这是小坏蛋的手机号码吗？" delegate:self cancelButtonTitle:@"不是" otherButtonTitles:@"是", nil];
            [alert show];
            alert.tag = 103;
            return;
        }
        
        
        if ([self isMobileNumber: self.inputNumber.text]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"号码正确,你要拨打吗？" delegate:self cancelButtonTitle:@"才不来,话费老贵啦！" otherButtonTitles:@"有钱人，任性，打打打……", nil];
            [alert show];
            alert.tag = 101;
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"你输得什么呀？我都测不出来" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
            
    }
}
#pragma mark 判断手机号、电话号、小号
- (BOOL)isMobileNumber:(NSString *)mobileNum
{
   NSString *allMore = @"(^1+\\d{10})|(^1+\\d{2}-(\\d{4})-(\\d{4}))|(^((86)|(\\+86))1+((\\d{10})|(\\d{2}-(\\d{4})-(\\d{4}))))|(^(\\d{3,4})-(\\d{7,8}))|(^(\\d{7,8}))$";
//    /**
//     * 手机号码
//     */
//    NSString * MOBILE = @"(^1+\\d{10})|(^1+\\d{2}-(\\d{4})-(\\d{4}))$";
//    //带86 或 +86
//    NSString *CHINA = @"^((86)|(\\+86))1+((\\d{10})|(\\d{2}-(\\d{4})-(\\d{4})))$";
//   //电话号码
//    NSString *TEL = @"((^(\\d{3,4})-(\\d{7,8}))|(^(\\d{7,8})))$";
    //其他号码
    NSString *numberPlist = [[NSBundle mainBundle]pathForResource:@"numberPlist" ofType:@"plist"];
    NSArray *numberArray = [[NSArray alloc]initWithContentsOfFile:numberPlist];
    for(NSString *num in numberArray)
    {
        if([mobileNum isEqualToString: num])
        {
            return YES;
        }
    }
   NSPredicate *regextALL= [NSPredicate predicateWithFormat:@"SELF MATCHES %@", allMore];
    
//    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//    NSPredicate *regextestchina = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CHINA];
//    NSPredicate *regextesttel = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", TEL];
 
    BOOL allBool = [regextALL evaluateWithObject:mobileNum];
//    BOOL mobileBool = [regextestmobile evaluateWithObject:mobileNum];
//    BOOL chinaBool = [regextestchina evaluateWithObject:mobileNum];
//    BOOL telBool = [regextesttel evaluateWithObject:mobileNum];
   
    
    
//    if (( mobileBool== YES)||
//        ( chinaBool== YES)||
//        ( telBool== YES))
    if (allBool)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
#pragma mark - 判断字符串是否为空
- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isEqualToString:@"(null)"]) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}
- (IBAction)findNumber:(id)sender {
    //用于加载网页
    _webView =[[UIWebView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width,  self.view.frame.size.height)];
    //网页适应大小
    _webView.scalesPageToFit=YES;
    //取消反弹效果
    _webView.scrollView.bounces=NO;
    //有前端的网页才可以加载
    NSURL *url=[NSURL URLWithString:@"http://www.ip138.com/tel.htm"];
    NSURLRequest *request=[[NSURLRequest alloc]initWithURL:url];
    //加载请求
    [_webView loadRequest:request];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"icon"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(20, 20, 44, 44);
    [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [_webView addSubview:btn];
    [self.view addSubview:_webView];
    [self.inputNumber resignFirstResponder];
}
- (void)click
{
    _webView.hidden = YES;
}
- (void)handleLongPressGestures
{
    EveViewController *ickImageViewController = [[EveViewController alloc] init];
    [self presentViewController:ickImageViewController animated:YES completion:^{
    }];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.inputNumber resignFirstResponder];
    if (alertView.tag == 101 &&  buttonIndex == 1) {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.inputNumber.text];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
    if (alertView.tag == 102 &&  buttonIndex == 0) {
        [self handleLongPressGestures];
    }else if(alertView.tag == 102 &&  buttonIndex == 1){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"检测证明，你是坏蛋的老婆!" delegate:self cancelButtonTitle:@"😄😄😄😄" otherButtonTitles:nil, nil];
        [alert show];
    }
    if (alertView.tag == 103 &&  buttonIndex == 1) {
        [self handleLongPressGestures];
    }else if(alertView.tag == 103 &&  buttonIndex == 0){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"检测证明，你就是小坏蛋!" delegate:self cancelButtonTitle:@"😄😄😄😄" otherButtonTitles:nil, nil];
        [alert show];
    }
  
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
