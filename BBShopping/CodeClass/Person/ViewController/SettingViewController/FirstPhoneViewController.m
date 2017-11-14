//
//  FirstPhoneViewController.m
//  BBShopping
//
//  Created by mibo02 on 17/3/21.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "FirstPhoneViewController.h"
#import "SecondPhoneViewController.h"
@interface FirstPhoneViewController ()
@property (weak, nonatomic) IBOutlet UIButton *verificationButton;
@property (weak, nonatomic) IBOutlet UILabel *verificationLabel;
//定时器
@property (nonatomic, strong)NSTimer *timer;

@property (nonatomic, assign)NSInteger verificationTime;//重新获取验证码时间
@property (nonatomic, copy)NSString *verification;//手机验证码
@property (weak, nonatomic) IBOutlet UITextField *panzhengM;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@end

@implementation FirstPhoneViewController

- (IBAction)yanzhengBtnAction:(UIButton *)sender {
    //请求
    [PPNetworkHelper GET:[NSString stringWithFormat:@"%@?action=old_phone_binding&mobile=%@",sendMessage,self.newstr] parameters:@{} success:^(id responseObject) {
        
        //发送成功之后
     //   NSLog(@"%@",responseObject[@"message"]);
        [MBProgressHUD showError:responseObject[@"message"]];
        sender.hidden = YES;
        self.verificationLabel.text = [NSString stringWithFormat:@"获取验证码(%lds)",self.verificationTime];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(tiemrAction:) userInfo:nil repeats:YES];
    } failure:^(NSError *error) {
        
    }];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"验证原手机号";
    self.phoneLab.text = [NSString stringWithFormat:@"手机号:%@",self.newstr];
    self.navigationController.navigationBar.translucent = NO;
    //刚开始30秒
    _verificationTime = 60;
}
- (void)tiemrAction:(NSTimer *)sender
{
    
    self.verificationTime -=1;
    if (self.verificationTime == 0) {
        [self.timer invalidate];
        self.timer = nil;
        self.verificationTime = 60;
        self.verificationButton.hidden = NO;
        self.verificationLabel.text = [NSString stringWithFormat:@"发送验证码"];
    } else {
        self.verificationLabel.text = [NSString stringWithFormat:@"获取验证码(%lds)",self.verificationTime];
    }
}
- (IBAction)NextBtnAction:(UIButton *)sender
{
    if (self.panzhengM.text.length == 0) {
        [MBProgressHUD showError:@"验证码不能为空"];
        
        return;
    }
    [PPNetworkHelper setValue:[UserInfoManager getUserInfo].token forHTTPHeaderField:@"token"];
    [PPNetworkHelper POST:reBindMobileURL parameters:@{@"verifiCode":self.panzhengM.text} success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            SecondPhoneViewController *second = [SecondPhoneViewController new];
            [self.navigationController pushViewController:second animated:YES];
        }
    } failure:^(NSError *error) {
        
    }];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
