//
//  ViewController.m
//  FreeOTPDemo
//
//  Created by Mac on 14-8-6.
//  Copyright (c) 2014年 zhcpeng. All rights reserved.
//

#import "ViewController.h"
#import "TokenStore.h"

@interface ViewController (){
    TokenStore *store;
    NSURLComponents *urlc;
    TokenCode *tc;
    NSTimer *timer;
}
@end

@implementation ViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    // Do any additional setup after loading the view from its nib.
    
    store = [[TokenStore alloc]init];
    
    urlc = [[NSURLComponents alloc] init];
    urlc.scheme = @"otpauth";
    urlc.host = 0 ? @"totp" : @"hotp";
    urlc.path = [NSString stringWithFormat:@"/%@:%@", ISSuer, ID];
    urlc.query = [NSString stringWithFormat:@"algorithm=%s&digits=%lu&secret=%@&%s=%lu",
                  "md5", (unsigned long)8, Secret,  0 ? "period" : "counter",(unsigned long)30];
    
    // Make token
    Token* tokenAlloc = [[Token alloc] initWithURL:[urlc URL]];
    if (tokenAlloc != nil)
        [[[TokenStore alloc] init] add:tokenAlloc];
    
    [self setCodeAndTime];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnStart:(UIButton *)sender {
    return;
    
    if (!urlc) {
        // Built URI
        urlc = [[NSURLComponents alloc] init];
        urlc.scheme = @"otpauth";
        urlc.host = 0 ? @"totp" : @"hotp";
        urlc.path = [NSString stringWithFormat:@"/%@:%@", ISSuer, ID];
        urlc.query = [NSString stringWithFormat:@"algorithm=%s&digits=%lu&secret=%@&%s=%lu",
                      "md5", (unsigned long)8, Secret,  0 ? "period" : "counter",(unsigned long)30];
        
        // Make token
        Token* tokenAlloc = [[Token alloc] initWithURL:[urlc URL]];
        if (tokenAlloc != nil)
            [[[TokenStore alloc] init] add:tokenAlloc];
    }

    Token *token = [store get:0];
    
    /*TokenCode **/tc = token.code;
    [store save:token];
    
    NSString *code = [tc currentCode];
    
//    NSLog(@"%@",code);
    self.labCode.text = code;
    self.labTime.text = @"30";
//    NSLog(@"%f",tc.currentProgress);

    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(outputCurrentTime) userInfo:nil repeats:YES];
 
}

-(void)outputCurrentTime{
    int x = ceilf(tc.currentProgress * 30);
    self.labTime.text = [NSString stringWithFormat:@"%d",x];
    
    if (x == 0 ) {
        [timer invalidate];
        timer = nil;
        [self setCodeAndTime];
    }
}


-(void)setCodeAndTime{
    Token *token = [store get:0];
    tc = token.code;
    [store save:token];
    
    NSString *code = [tc currentCode];
    self.labCode.text = code;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(outputCurrentTime) userInfo:nil repeats:YES];
}

@end
