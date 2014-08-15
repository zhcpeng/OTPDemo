//
//  ViewController.h
//  FreeOTPDemo
//
//  Created by Mac on 14-8-6.
//  Copyright (c) 2014年 zhcpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *labCode;
@property (weak, nonatomic) IBOutlet UILabel *labTime;


- (IBAction)btnStart:(UIButton *)sender;
@end
