//
//  NewLoginViewController.m
//  BBShopping
//
//  Created by mibo02 on 17/3/13.
//  Copyright © 2017年 mibo02. All rights reserved.
//
#import <ShareSDK/ShareSDK.h>
#import "BangDingPhoneViewController.h"
#import "NewLoginViewController.h"
#import "LoginViewController.h"
@interface NewLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phone;

@property (weak, nonatomic) IBOutlet UITextField *yanzhengM;
@property (weak, nonatomic) IBOutlet UIButton *verificationButton;
@property (weak, nonatomic) IBOutlet UILabel *verificationLabel;
//定时器
@property (nonatomic, strong)NSTimer *timer;

@property (nonatomic, assign)NSInteger verificationTime;//重新获取验证码时间
@property (nonatomic, copy)NSString *verification;//手机验证码
@end

@implementation NewLoginViewController

//登录
- (IBAction)loginBtnAction:(UIButton *)sender
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
        return;
    }
    NSString *regId = [[NSUserDefaults standardUserDefaults] objectForKey:@"registerID"];
    
    if (regId) {
    
    [PPNetworkHelper POST:smsLoginURL parameters:@{@"mobile":self.phone.text,@"verifiCode":self.yanzhengM.text,@"registrationId":regId,@"source":@3} success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 0) {
            [UserInfoManager cleanUserInfo];
            PersonModel *model = [PersonModel new];
            [model setValuesForKeysWithDictionary:responseObject[@"map"]];
            [UserInfoManager saveUserInfoWithModel:model];
            [MBProgressHUD showError:@"登录成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(NSError *error) {
        
    }];
    } else {
        [PPNetworkHelper POST:smsLoginURL parameters:@{@"mobile":self.phone.text,@"verifiCode":self.yanzhengM.text,@"source":@3} success:^(id responseObject) {
            
            if ([responseObject[@"code"] integerValue] == 0) {
                
                [UserInfoManager cleanUserInfo];
                PersonModel *model = [PersonModel new];
                [model setValuesForKeysWithDictionary:responseObject[@"map"]];
                [UserInfoManager saveUserInfoWithModel:model];
                [MBProgressHUD showError:@"登录成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        } failure:^(NSError *error) {
            
        }];
    }
}
//账号密码登录
- (IBAction)zhanghaomimaAction:(UIButton *)sender
{
    LoginViewController *login = [LoginViewController new];
    [self.navigationController pushViewController:login animated:YES];
}
//微信登录
- (IBAction)wechatAction:(UIButton *)sender
{
   
    
    [ShareSDK getUserInfo:SSDKPlatformTypeWechat
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             
             NSDictionary *dic = user.rawData;
             user.credential.expired = [NSDate dateWithTimeIntervalSinceNow:1];
             //判断是否是第一次登陆
             [self requestForFirstLogin:dic];
             
         }else{
             NSLog(@"%@",error);
         }
         
     }];

}
- (void)requestForFirstLogin:(NSDictionary *)dic
{
        //判断是否第一次登陆
        [PPNetworkHelper GET:[NSString stringWithFormat:@"%@?openid=%@",isFirstLoginURL,dic[@"openid"]] parameters:@{} success:^(id responseObject) {
            
            if ([responseObject[@"code"] integerValue] == 0) {
                //不是第一次登陆
                if ([responseObject[@"obj"][@"flag"] isEqualToString:@"0"]) {
                    NSString *sex = [NSString stringWithFormat:@"%ld",[dic[@"sex"] integerValue]];
                    //不是第一次登陆但是没有绑定手机号
                    if ([responseObject[@"obj"][@"hasMobile"] isEqualToString:@"0"]) {
                        //
                        [self bangdingshoujihao:dic];
                    } else {
                        
                    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"registerID"]) {
                        [PPNetworkHelper POST:webChatLogin parameters:@{@"openid":dic[@"openid"],@"nickname":dic[@"nickname"],@"sex":sex,@"city":dic[@"city"],@"province":dic[@"province"],@"headimgurl":dic[@"headimgurl"],@"registrationId":[[NSUserDefaults standardUserDefaults] objectForKey:@"registerID"],@"source":@3} success:^(id responseObject) {
                            
                            if ([responseObject[@"code"] integerValue] == 0) {
                                [UserInfoManager cleanUserInfo];
                                PersonModel *model = [PersonModel new];
                                model.token = responseObject[@"map"][@"token"];
                                [UserInfoManager saveUserInfoWithModel:model];
                                [MBProgressHUD showError:@"微信登录成功"];
                                [self.navigationController popViewControllerAnimated:YES];
                            }
                            
                        } failure:^(NSError *error) {
                            
                        }];

                    } else {
                        [PPNetworkHelper POST:webChatLogin parameters:@{@"openid":dic[@"openid"],@"nickname":dic[@"nickname"],@"sex":sex,@"city":dic[@"city"],@"province":dic[@"province"],@"headimgurl":dic[@"headimgurl"],@"source":@3} success:^(id responseObject) {
                            
                            if ([responseObject[@"code"] integerValue] == 0) {
                                [UserInfoManager cleanUserInfo];
                                PersonModel *model = [PersonModel new];
                                model.token = responseObject[@"map"][@"token"];
                                [UserInfoManager saveUserInfoWithModel:model];
                                [MBProgressHUD showError:@"微信登录成功"];
                                [self.navigationController popViewControllerAnimated:YES];
                            }
                            
                        } failure:^(NSError *error) {
                            
                        }];
                    }
                    
                    
                    }
                    
                } else {
                    //第一次登陆
                    [self bangdingshoujihao:dic];
                }
            }
            
        } failure:^(NSError *error) {
            
        }];

}
//微信登录是第一次登陆
- (void)bangdingshoujihao:(NSDictionary *)dic
{
    
    //到绑定手机号界面
    BangDingPhoneViewController *bangding = [BangDingPhoneViewController new];
    
    bangding.bangdingDic = dic;
    
    [self.navigationController pushViewController:bangding animated:YES];
    
}

//发送验证码
- (IBAction)getyanzhengMAction:(UIButton *)sender {
    if (self.phone.text.length == 0) {
        [MBProgressHUD showError:@"手机号不能为空"];
        return;
    }
    
    if (![self.phone.text isMobileNumber]) {
        [MBProgressHUD showError:@"请输入正确的手机号"];
        return;
    }
   
    //请求
    [PPNetworkHelper GET:[NSString stringWithFormat:@"%@?action=login&mobile=%@",sendMessage,_phone.text] parameters:@{} success:^(id responseObject) {
        
        [MBProgressHUD showError:responseObject[@"message"]];
        sender.hidden = YES;
        self.verificationLabel.text = [NSString stringWithFormat:@"获取验证码(%lds)",self.verificationTime];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(tiemrAction:) userInfo:nil repeats:YES];
    } failure:^(NSError *error) {
        
    }];

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"登录";
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
//当视图将要消失的时候销毁定时器
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}




@end
