//
//  ViewController.h
//  PhoneNumber
//
//  Created by Sun jishuai on 15/6/1.
//  Copyright (c) 2015年 SunJishuai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *inputNumber;
@property (weak, nonatomic) IBOutlet UIButton *verificationBtn;
@property (weak, nonatomic) IBOutlet UIButton *usedNumber;
@end

