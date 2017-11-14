//
//  ChangePhoneViewController.m
//  BBShopping
//
//  Created by mibo02 on 17/3/21.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "ChangePhoneViewController.h"
#import "FirstPhoneViewController.h"
@interface ChangePhoneViewController ()
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;

@end

@implementation ChangePhoneViewController
- (IBAction)changeButtonAction:(UIButton *)sender {
    FirstPhoneViewController *first = [FirstPhoneViewController new];
    first.newstr = self.str;
    [self.navigationController pushViewController:first animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"更换绑定手机号";
    self.navigationController.navigationBar.translucent = NO;
    self.phoneLab.text  = [NSString stringWithFormat:@"手机号:%@",self.str];
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
