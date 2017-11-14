//
//  RegistViewController.m
//  BBShopping
//
//  Created by mibo02 on 17/1/17.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "RegistViewController.h"

@interface RegistViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *yanzhengM;

@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *newpassword;
@property (weak, nonatomic) IBOutlet UILabel *verificationLabel;
@property (weak, nonatomic) IBOutlet UIButton *verificationButton;
@property (weak, nonatomic) IBOutlet UIButton *protolBtn;
@property (weak, nonatomic) IBOutlet UILabel *protolLab;

//定时器
@property (nonatomic, strong)NSTimer *timer;

@property (nonatomic, assign)NSInteger verificationTime;//重新获取验证码时间
@property (nonatomic, copy)NSString *verification;//手机验证码

@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"注册";
    self.protolBtn.hidden = YES;
    self.protolLab.hidden = YES;
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
        self.verificationLabel.text = [NSString stringWithFormat:@"获取验证码(%lds)",(long)self.verificationTime];
    }
}
//发送验证码
- (IBAction)sendMessageBtn:(UIButton *)sender
{
    if (self.phone.text.length == 0) {
        [MBProgressHUD showError:@"手机号不能为空"];
        return;
    }
   
    if (![self.phone.text isMobileNumber]) {
        [MBProgressHUD showError:@"请输入正确的手机号"];
        return;
    }
  //  if (_protolBtn.tag) {
        //请求
        [PPNetworkHelper GET:[NSString stringWithFormat:@"%@?action=signup&mobile=%@",sendMessage,_phone.text] parameters:@{} success:^(id responseObject) {
           
            [MBProgressHUD showError:responseObject[@"message"]];
            sender.hidden = YES;
            self.verificationLabel.text = [NSString stringWithFormat:@"获取验证码(%lds)",(long)self.verificationTime];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(tiemrAction:) userInfo:nil repeats:YES];
        } failure:^(NSError *error) {
            
        }];
  //  } else {
  //      [MBProgressHUD showError:@"是否同意协议"];
  //  }
}

//点击同意协议
- (IBAction)procolBtnAction:(UIButton *)sender
{
    sender.tag = !sender.tag;
    if (sender.tag) {
        [sender setImage:[UIImage imageNamed:@"对勾"] forState:(UIControlStateNormal)];
    } else {
        [sender setImage:[UIImage imageNamed:@"圆角矩形-2"] forState:(UIControlStateNormal)];
    }
}
//注册
- (IBAction)registBtnAction:(id)sender
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
    if (_yanzhengM.text.length == 0) {
        
        [MBProgressHUD showError:@"验证码不能为空"];
        
    }
    
    if ([self.password.text isEqualToString:self.newpassword.text]) {
        NSDictionary *dic = @{@"mobile":self.phone.text,@"password":[Factory md5String:self.password.text],@"smsCode":_yanzhengM.text,@"source":@3};
        [PPNetworkHelper POST:RegistURL parameters:dic success:^(id responseObject) {
            
            if ([responseObject[@"code"] integerValue] == 1002) {
                [MBProgressHUD showError:responseObject[@"message"]];
            } else if ([responseObject[@"code"] integerValue] == 0){
                [MBProgressHUD showError:@"注册成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        } failure:^(NSError *error) {
            
        }];
    } else {
        [MBProgressHUD showError:@"密码不一致"];
    }
    
}
//当视图将要消失的时候销毁定时器
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}

@end
