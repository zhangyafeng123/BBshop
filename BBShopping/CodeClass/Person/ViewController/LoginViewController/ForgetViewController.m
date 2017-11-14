//
//  ForgetViewController.m
//  BBShopping
//
//  Created by mibo02 on 17/1/17.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "ForgetViewController.h"
#import "NewForgetViewController.h"
@interface ForgetViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *yanzhengM;
@property (weak, nonatomic) IBOutlet UIButton *verificationButton;
@property (weak, nonatomic) IBOutlet UILabel *verificationLabel;
//定时器
@property (nonatomic, strong)NSTimer *timer;

@property (nonatomic, assign)NSInteger verificationTime;//重新获取验证码时间
@property (nonatomic, copy)NSString *verification;//手机验证码
@end

@implementation ForgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"忘记密码";
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
//发送验证码
- (IBAction)sendmess:(UIButton *)sender {
    
    
    if (self.phone.text.length == 0) {
        [MBProgressHUD showError:@"手机号不能为空"];
        return;
    }
    
    if (![self.phone.text isMobileNumber]) {
        [MBProgressHUD showError:@"请输入正确的手机号"];
        return;
    }
    
    //请求
    [PPNetworkHelper GET:[NSString stringWithFormat:@"%@?action=find_pwd&mobile=%@",sendMessage,_phone.text] parameters:@{} success:^(id responseObject) {
        if ([responseObject[@"success"] integerValue] == 0) {
            [MBProgressHUD showError:responseObject[@"message"]];
            return;
        }
        //发送成功之后
        [MBProgressHUD showError:responseObject[@"message"]];
        sender.hidden = YES;
        self.verificationLabel.text = [NSString stringWithFormat:@"获取验证码(%lds)",self.verificationTime];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(tiemrAction:) userInfo:nil repeats:YES];
    } failure:^(NSError *error) {
        
    }];
    
}


- (IBAction)okbuttonAction:(UIButton *)sender {
    
    if (self.phone.text.length == 0) {
        [MBProgressHUD showError:@"手机号不能为空"];
        return;
    }
    
    if (![self.phone.text isMobileNumber]) {
        [MBProgressHUD showError:@"请输入正确的手机号"];
        return;
    }
    if (self.yanzhengM.text.length == 0) {
        [MBProgressHUD showError:@"验证码不能为空"];
        return;
    }
    
    [PPNetworkHelper POST:findPassURL parameters:@{@"mobile":self.phone.text,@"verifiCode":self.yanzhengM.text} success:^(id responseObject) {
        
        
        if ([responseObject[@"code"] integerValue] == 0) {
            NewForgetViewController *new = [NewForgetViewController new];
            
            new.sendStr = self.yanzhengM.text;
            new.phoneStr = self.phone.text;
            [self.navigationController pushViewController:new animated:YES];
        } else if ([responseObject[@"code"] integerValue] == 40000){
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
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
