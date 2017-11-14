//
//  LoginViewController.m
//  BBShopping
//
//  Created by mibo02 on 17/1/17.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "LoginViewController.h"
#import "RegistViewController.h"
#import "ForgetViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end

@implementation LoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"登录";
}
//登陆按钮
- (IBAction)LoginBtnAction:(UIButton *)sender {
    
    
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
    
     NSString *str = [Factory md5String:self.password.text];
     NSString *regId = [[NSUserDefaults standardUserDefaults] valueForKey:@"registerID"];
    if (![[NSUserDefaults standardUserDefaults] valueForKey:@"registerID"]) {
        [PPNetworkHelper POST:LoginURL parameters:@{@"mobile":self.phone.text,@"password":str} success:^(id responseObject) {
            
            if ([responseObject[@"code"] integerValue] == 0) {
                [UserInfoManager cleanUserInfo];
                PersonModel *model = [PersonModel new];
                [model setValuesForKeysWithDictionary:responseObject[@"map"]];
                [UserInfoManager saveUserInfoWithModel:model];
                [self.navigationController popToRootViewControllerAnimated:YES];
            } else if ([responseObject[@"code"] integerValue] == 10003){
                [MBProgressHUD showError:responseObject[@"message"]];
            } else if ([responseObject[@"code"] integerValue] == 1002){
                [MBProgressHUD showError:responseObject[@"message"]];
            } else if ([responseObject[@"code"] integerValue] == 1001){
                [MBProgressHUD showError:responseObject[@"message"]];
            }
            
        } failure:^(NSError *error) {
            
        }];
    } else {
   
    [PPNetworkHelper POST:LoginURL parameters:@{@"mobile":self.phone.text,@"password":str,@"registrationId":regId} success:^(id responseObject) {
       
            if ([responseObject[@"code"] integerValue] == 0) {
                [UserInfoManager cleanUserInfo];
                PersonModel *model = [PersonModel new];
                [model setValuesForKeysWithDictionary:responseObject[@"map"]];
                [UserInfoManager saveUserInfoWithModel:model];
                [self.navigationController popToRootViewControllerAnimated:YES];
            } else if ([responseObject[@"code"] integerValue] == 10003){
                [MBProgressHUD showError:responseObject[@"message"]];
            } else if ([responseObject[@"code"] integerValue] == 1002){
                [MBProgressHUD showError:responseObject[@"message"]];
            } else if ([responseObject[@"code"] integerValue] == 1001){
                [MBProgressHUD showError:responseObject[@"message"]];
            }
     
    } failure:^(NSError *error) {
        
    }];
    }
}

//新用户注册
- (IBAction)NewUserBtnAction:(id)sender
{
    RegistViewController *regist = [[RegistViewController alloc] init];
    [self.navigationController pushViewController:regist animated:YES];
}
- (IBAction)ForgetPassword:(UIButton *)sender
{
    ForgetViewController *forget = [[ForgetViewController alloc] init];
    [self.navigationController pushViewController:forget animated:YES];
}


@end
