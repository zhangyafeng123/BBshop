//
//  BangDingPhoneViewController.m
//  BBShopping
//
//  Created by mibo02 on 17/3/8.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "BangDingPhoneViewController.h"

@interface BangDingPhoneViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *yanzhengM;
@property (weak, nonatomic) IBOutlet UILabel *verificationLabel;
@property (weak, nonatomic) IBOutlet UIButton *verificationButton;
//定时器
@property (nonatomic, strong)NSTimer *timer;

@property (nonatomic, assign)NSInteger verificationTime;//重新获取验证码时间
@property (nonatomic, copy)NSString *verification;//手机验证码
@end

@implementation BangDingPhoneViewController


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
    if (self.yanzhengM.text.length == 0) {
        [MBProgressHUD showError:@"验证码不能为空"];
    }
    
    NSString *sex = [NSString stringWithFormat:@"%ld",[_bangdingDic[@"sex"] integerValue]];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"registerID"]) {
        //进入绑定手机号页面
        [PPNetworkHelper POST:webChatLoginFirstURL parameters:@{@"openid":_bangdingDic[@"openid"],@"nickname":_bangdingDic[@"nickname"],@"sex":sex,@"city":_bangdingDic[@"city"],@"province":_bangdingDic[@"province"],@"headimgurl":_bangdingDic[@"headimgurl"],@"registrationId":[[NSUserDefaults standardUserDefaults] objectForKey:@"registerID"],@"mobile":self.phone.text,@"verifiCode":self.yanzhengM.text,@"source":@3} success:^(id responseObject) {
            
            if ([responseObject[@"code"] integerValue] == 0) {
                
                [UserInfoManager cleanUserInfo];
                PersonModel *model = [PersonModel new];
                model.token = responseObject[@"map"][@"token"];
                [UserInfoManager saveUserInfoWithModel:model];
                [MBProgressHUD showError:@"微信登录成功"];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            
            
            
        } failure:^(NSError *error) {
            
        }];

    } else {
        //进入绑定手机号页面
        [PPNetworkHelper POST:webChatLoginFirstURL parameters:@{@"openid":_bangdingDic[@"openid"],@"nickname":_bangdingDic[@"nickname"],@"sex":sex,@"city":_bangdingDic[@"city"],@"province":_bangdingDic[@"province"],@"headimgurl":_bangdingDic[@"headimgurl"],@"mobile":self.phone.text,@"verifiCode":self.yanzhengM.text,@"source":@3} success:^(id responseObject) {
            
            if ([responseObject[@"code"] integerValue] == 0) {
                
                [UserInfoManager cleanUserInfo];
                PersonModel *model = [PersonModel new];
                model.token = responseObject[@"map"][@"token"];
                [UserInfoManager saveUserInfoWithModel:model];
                [MBProgressHUD showError:@"微信登录成功"];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            
            
            
        } failure:^(NSError *error) {
            
        }];
    }
    
}

- (IBAction)getyanzhengma:(UIButton *)sender {
    
    if (self.phone.text.length == 0) {
        [MBProgressHUD showError:@"手机号不能为空"];
        return;
    }
    
    if (![self.phone.text isMobileNumber]) {
        [MBProgressHUD showError:@"请输入正确的手机号"];
        return;
    }
   
    //请求
    [PPNetworkHelper GET:[NSString stringWithFormat:@"%@?action=new_phone_binding&mobile=%@",sendMessage,_phone.text] parameters:@{} success:^(id responseObject) {
        
        //发送成功之后
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


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"绑定手机号";
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



@end
