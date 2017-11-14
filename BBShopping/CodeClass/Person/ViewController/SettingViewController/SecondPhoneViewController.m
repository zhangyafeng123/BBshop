//
//  SecondPhoneViewController.m
//  BBShopping
//
//  Created by mibo02 on 17/3/21.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "SecondPhoneViewController.h"

@interface SecondPhoneViewController ()
@property (weak, nonatomic) IBOutlet UIButton *verificationButton;
//定时器
@property (nonatomic, strong)NSTimer *timer;

@property (nonatomic, assign)NSInteger verificationTime;//重新获取验证码时间
@property (nonatomic, copy)NSString *verification;//手机验证码
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *panzhengM;
@property (weak, nonatomic) IBOutlet UILabel *verificationLabel;
@end

@implementation SecondPhoneViewController
- (IBAction)yanzhengAction:(UIButton *)sender {
    if (self.phone.text.length == 0) {
        [MBProgressHUD showError:@"手机号不能为空"];
        return;
    }
    
    if (![self.phone.text isMobileNumber]) {
        [MBProgressHUD showError:@"请输入正确的手机号"];
        return;
    }
    //请求
    [PPNetworkHelper GET:[NSString stringWithFormat:@"%@?action=new_phone_binding&mobile=%@",sendMessage,self.phone.text] parameters:@{} success:^(id responseObject) {
        
        //发送成功之后
        NSLog(@"%@",responseObject[@"message"]);
        [MBProgressHUD showError:responseObject[@"message"]];
        sender.hidden = YES;
        self.verificationLabel.text = [NSString stringWithFormat:@"获取验证码(%lds)",self.verificationTime];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(tiemrAction:) userInfo:nil repeats:YES];
    } failure:^(NSError *error) {
        
    }];
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
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"绑定新手机号";
 
    self.navigationController.navigationBar.translucent = NO;
    //刚开始30秒
    _verificationTime = 60;
}
- (IBAction)bangdingAction:(UIButton *)sender {
    if (self.phone.text.length == 0) {
        [MBProgressHUD showError:@"手机号不能为空"];
        return;
    }
    
    if (![self.phone.text isMobileNumber]) {
        [MBProgressHUD showError:@"请输入正确的手机号"];
        return;
    }
    if (self.panzhengM.text.length == 0) {
        [MBProgressHUD showError:@"验证码不能为空"];
        return;
    }
     [PPNetworkHelper setValue:[UserInfoManager getUserInfo].token forHTTPHeaderField:@"token"];
    [PPNetworkHelper POST:bindMobileURL parameters:@{@"mobile":self.phone.text,@"verifiCode":self.panzhengM.text} success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else if ([responseObject[@"code"] integerValue] == 20005){
            [MBProgressHUD showError:responseObject[@"message"]];
        }
    } failure:^(NSError *error) {
        
    }];
}



@end
