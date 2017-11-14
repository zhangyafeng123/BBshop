//
//  NewForgetViewController.m
//  BBShopping
//
//  Created by mibo02 on 17/3/2.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "NewForgetViewController.h"

@interface NewForgetViewController ()
@property (weak, nonatomic) IBOutlet UITextField *onetext;
@property (weak, nonatomic) IBOutlet UITextField *twotext;

@end

@implementation NewForgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"忘记密码";
    
}
- (IBAction)okbutton:(id)sender {
    
    if (self.onetext.text.length == 0 || self.twotext.text.length == 0) {
        [MBProgressHUD showError:@"密码不能为空"];
        return;
    } else if (self.onetext.text.length > 12 || self.twotext.text.length > 12){
        [MBProgressHUD showError:@"密码不能超过12位"];
        return;
    }
    if (self.onetext.text.length == 0 && self.twotext.text.length == 0) {
        [MBProgressHUD showError:@"密码不能为空"];
        return;
    } else if (self.onetext.text.length > 12 && self.twotext.text.length > 12){
        [MBProgressHUD showError:@"密码不能超过12位"];
        return;
    }
   
    
    if ([self.onetext.text isEqualToString:self.twotext.text]) {
        
        [PPNetworkHelper POST:newfindPassURL parameters:@{@"password":[Factory md5String:self.twotext.text],@"verifiCode":self.sendStr,@"mobile":self.phoneStr} success:^(id responseObject) {
            if ([responseObject[@"code"] integerValue] == 0) {
                [MBProgressHUD showSuccess:@"设置密码成功"];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        } failure:^(NSError *error) {
            
        }];
    } else {
        [MBProgressHUD showError:@"密码不一致"];
    }
    
}



@end
