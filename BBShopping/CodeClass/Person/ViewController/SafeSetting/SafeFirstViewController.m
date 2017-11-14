//
//  SafeFirstViewController.m
//  BBShopping
//
//  Created by mibo02 on 17/3/7.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "SafeFirstViewController.h"

@interface SafeFirstViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *panzhengM;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *verificationButton;
@property (weak, nonatomic) IBOutlet UILabel *verificationLabel;
@property (weak, nonatomic) IBOutlet UITextField *newpassword;
//定时器
@property (nonatomic, strong)NSTimer *timer;

@property (nonatomic, assign)NSInteger verificationTime;//重新获取验证码时间
@property (nonatomic, copy)NSString *verification;//手机验证码
@end

@implementation SafeFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.actionNumber == 0) {
       self.title = @"设置提现密码";
    } else {
        self.title = @"忘记提现密码";
    }
    
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
- (IBAction)okButtonAction:(UIButton *)sender
{
    
    if (self.phone.text.length == 0) {
        [MBProgressHUD showError:@"手机号不能为空"];
        return;
    }
    
    if (![self.phone.text isMobileNumber]) {
        [MBProgressHUD showError:@"请输入正确的手机号"];
        return;
    }
    if (self.password.text.length == 0) {
        [MBProgressHUD showError:@"密码不能为空"];
        return;
    } else if (self.password.text.length > 12){
        [MBProgressHUD showError:@"密码不能超过12位"];
        return;
    }
    if (_panzhengM.text.length == 0) {
        [MBProgressHUD showError:@"验证码不能为空"];
    }
    if ([self.password.text isEqualToString:self.newpassword.text]) {
         [PPNetworkHelper setValue:[UserInfoManager getUserInfo].token forHTTPHeaderField:@"token"];
        [PPNetworkHelper GET:[NSString stringWithFormat:@"%@?action=%ld&extractPassword=%@&mobile=%@&verifiCode=%@",safeSetURL,self.actionNumber,[Factory md5String:self.password.text],self.phone.text,self.panzhengM.text] parameters:@{} success:^(id responseObject) {
            
            if ([responseObject[@"code"] integerValue] == 0) {
                [MBProgressHUD showError:responseObject[@"message"]];
            }
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            
        }];
    } else {
        [MBProgressHUD showError:@"密码不一致"];
    }
    
    
}

- (IBAction)getyanzhengButtonAction:(UIButton *)sender {
    if (self.phone.text.length == 0) {
        [MBProgressHUD showError:@"手机号不能为空"];
        return;
    }
    
    if (![self.phone.text isMobileNumber]) {
        [MBProgressHUD showError:@"请输入正确的手机号"];
        return;
    }
    NSString *url;
    if (self.actionNumber == 0) {
        url = [NSString stringWithFormat:@"%@?action=safe_set&mobile=%@",sendMessage,_phone.text];
    } else {
        url = [NSString stringWithFormat:@"%@?action=safe_pwd_forget&mobile=%@",sendMessage,_phone.text];
    }
    
    //请求
    [PPNetworkHelper GET:url parameters:@{} success:^(id responseObject) {
        
        [MBProgressHUD showError:responseObject[@"message"]];
        sender.hidden = YES;
        self.verificationLabel.text = [NSString stringWithFormat:@"获取验证码(%lds)",self.verificationTime];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(tiemrAction:) userInfo:nil repeats:YES];
    } failure:^(NSError *error) {
        
    }];

}

//当视图将要消失的时候销毁定时器
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}



@end
