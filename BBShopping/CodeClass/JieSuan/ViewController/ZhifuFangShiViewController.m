//
//  ZhifuFangShiViewController.m
//  BBShopping
//
//  Created by mibo02 on 17/2/20.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "ZhifuFangShiViewController.h"
#import "ZhifuFangshiCell.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "Order.h"
#import "RSADataSigner.h"
#import "SuccessPayViewController.h"
#import <WebKit/WebKit.h>
@interface ZhifuFangShiViewController ()
@property (nonatomic, strong)NSDictionary *newdic;

@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn;



@end

@implementation ZhifuFangShiViewController

- (IBAction)firstAction:(UIButton *)sender {
    
    sender.selected = YES;
    
    _secondBtn.selected = NO;
    
}
- (IBAction)secondAction:(UIButton *)sender {
    
    sender.selected = YES;
    
    _firstBtn.selected = NO;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"支付方式";
    
    self.navigationController.navigationBar.translucent = NO;
    
    //微信跳转到成功的界面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backtoMe) name:@"WX_PaySuccess" object:nil];
    
    //支付宝跳转到成功界面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backzhifubao) name:@"safePayback" object:nil];
    
    //取消支付(进入待支付订单界面)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelPayAction) name:@"cancelPay" object:nil];
    
}
//返回到root
- (void)cancelPayAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    [self performSelector:@selector(notificationActions) withObject:nil afterDelay:1];
}
- (void)notificationActions
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ertersecondpay" object:nil];
}
- (void)backzhifubao
{
    //进入到支付成功界面
    SuccessPayViewController *success = [SuccessPayViewController new];
    [self.navigationController pushViewController:success animated:YES];
}
- (void)backtoMe
{
    //进入到支付成功界面
    SuccessPayViewController *success = [SuccessPayViewController new];
    [self.navigationController pushViewController:success animated:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (IBAction)buttonaction:(UIButton *)sender
{
    if (self.firstBtn.selected== NO && self.secondBtn.selected == NO) {
        [MBProgressHUD showError:@"请选择支付方式"];
    } else if (self.firstBtn.selected == YES && self.secondBtn.selected == NO) {
        
        [self WXPay];
    } else if (self.firstBtn.selected == NO && self.secondBtn.selected == YES){
        [self zhifubao];
    }
}
- (void)zhifubao
{
    Order *order = [Order new];
    order.app_id = @"2017021005610785";
    order.method = @"alipay.trade.app.pay";
    order.charset = @"utf-8";
    NSDateFormatter *fornatter = [NSDateFormatter new];
    [fornatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    order.timestamp = [fornatter stringFromDate:[NSDate date]];
    order.version = @"1.0";
    order.sign_type = @"RSA";
    order.notify_url = zhifubaonewURl;
    //
    order.biz_content = [BizContent new];
    order.biz_content.body = self.weixinDic[@"body"];
    order.biz_content.subject = self.weixinDic[@"serialNumber"];
    order.biz_content.out_trade_no = self.weixinDic[@"serialNumber"];
    order.biz_content.timeout_express = @"30m";
    order.biz_content.total_amount = [NSString stringWithFormat:@"%.2f",[self.weixinDic[@"totalFee"] floatValue]];
    NSString *orderInfo = [order orderInfoEncoded:NO];
    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
    NSLog(@"%@",orderInfoEncoded);

    [PPNetworkHelper POST:signaturesURL parameters:@{@"data":orderInfo} success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            NSString *appScheme = @"zhifubao";
            
        NSString *signedString  = responseObject[@"map"][@"sign"];
         
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",responseObject[@"map"][@"data"],signedString];
            
            //  NOTE: 调用支付结果开始支付
            [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                NSLog(@"reslut = %@",resultDic);
                
                //支付宝跳转到成功界面
                SuccessPayViewController *success = [SuccessPayViewController new];
                [self.navigationController pushViewController:success animated:YES];
            }];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}
#pragma mark 微信支付方法
- (void)WXPay{
    
    
    NSInteger i = [self.weixinDic[@"totalFee"] floatValue] * 100;
   
    NSDictionary *dic1 =  @{@"orderNo":self.weixinDic[@"serialNumber"],@"totalFee":@(i)};
    
    [PPNetworkHelper POST:wxpaywxprepayURL parameters:dic1 success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            NSDictionary *dic = responseObject[@"map"][@"prepayResult"];
            //需要创建这个支付对象
            PayReq *req   = [[PayReq alloc] init];
            //由用户微信号和AppID组成的唯一标识，用于校验微信用户
            req.openID = dic[@"appid"];
            // 商家id，在注册的时候给的
            req.partnerId = dic[@"partnerid"];
            // 预支付订单这个是后台跟微信服务器交互后，微信服务器传给你们服务器的，你们服务器再传给你
            req.prepayId  = dic[@"prepayid"];
            // 根据财付通文档填写的数据和签名
            //这个比较特殊，是固定的，只能是即req.package = Sign=WXPay
            req.package = dic[@"package"];
            // 随机编码，为了防止重复的，在后台生成
            req.nonceStr = dic[@"noncestr"];
            // 这个是时间戳，也是在后台生成的，为了验证支付的
            req.timeStamp = [dic[@"timestamp"] intValue];
            // 这个签名也是后台做的
            req.sign = dic[@"sign"];
           
            //发送请求到微信，等待微信返回onResp
            [WXApi sendReq:req];
           
        } else if ([responseObject[@"code"] integerValue] == -1){
            [MBProgressHUD showError:responseObject[@"message"]];
        }
    } failure:^(NSError *error) {
        
    }];
}



@end
