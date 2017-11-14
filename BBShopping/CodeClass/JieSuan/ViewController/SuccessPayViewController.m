//
//  SuccessPayViewController.m
//  BBShopping
//
//  Created by mibo02 on 17/3/7.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "SuccessPayViewController.h"

@interface SuccessPayViewController ()
@property (weak, nonatomic) IBOutlet UIButton *homebtn;
@property (weak, nonatomic) IBOutlet UIButton *dingdanbtn;

@end

@implementation SuccessPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"下单成功";
    //设置不允许侧滑
    self.backPanEnabled = NO;
    
    self.homebtn.layer.cornerRadius  = 5;
    self.homebtn.layer.masksToBounds = YES;
    self.homebtn.layer.borderColor = [UIColor blackColor].CGColor;
    self.homebtn.layer.borderWidth = 1;
    self.dingdanbtn.layer.cornerRadius  = 5;
    self.dingdanbtn.layer.masksToBounds  = YES;
    self.dingdanbtn.layer.borderColor = [UIColor blackColor].CGColor;
    self.dingdanbtn.layer.borderWidth = 1;
}
- (IBAction)backhome:(UIButton *)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    [self performSelector:@selector(notificationActions) withObject:nil afterDelay:0.5];
    
}
//一秒之后执行返回主界面
- (void)notificationActions
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"homeVC" object:nil];
}
- (IBAction)backdingdan:(UIButton *)sender {

     [self.navigationController popToRootViewControllerAnimated:YES];
    [self performSelector:@selector(notificationActionsforperson) withObject:nil afterDelay:1];
    
}
- (void)notificationActionsforperson
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ordernewenterorder" object:nil];
}


@end
