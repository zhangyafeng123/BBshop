//
//  OrderDetailViewController.m
//  BBShopping
//
//  Created by mibo02 on 17/3/8.
//  Copyright © 2017年 mibo02. All rights reserved.
//
#import "orderDetailHead.h"
#import "OrderDetailViewController.h"
#import "orderDetailModel.h"
#import "waitshouhuoCell.h"
#import "orderDetailFoot.h"
#import "ShouHouViewController.h"
#import "DetailViewController.h"
#import "PresentQueRenZhiFuViewController.h"
#import "ZhifuFangShiViewController.h"
#import "PingjiaViewController.h"
#import "orderAllModel.h"
@interface OrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)NSDictionary *orderDic;
@end

@implementation OrderDetailViewController
-  (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray new];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    [self.tableView registerNib:[UINib nibWithNibName:@"waitshouhuoCell" bundle:nil] forCellReuseIdentifier:@"waitcell"];
    
   
   
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self request];
}
- (void)request
{
    [self showProgressHUD];
    [self.dataArray removeAllObjects];
    [PPNetworkHelper GET:[NSString stringWithFormat:@"%@?orderId=%ld",findFrontOrderInfoURL,self.orderId] parameters:@{} success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 0) {
            self.orderDic = responseObject[@"obj"];
            
            for (NSDictionary *dic in responseObject[@"obj"][@"goodsDetails"]) {
                orderDetailModel *model = [orderDetailModel new];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArray addObject:model];
            }
        }
        [self.tableView reloadData];
        [self hideProgressHUD];
        [self createheadAndFoot];
        
        
    } failure:^(NSError *error) {
        
    }];
}
//取消订单
- (void)leftButtonAction:(UIButton *)sender
{
  
        [self showProgressHUD];
        [PPNetworkHelper GET:[NSString stringWithFormat:@"%@?orderId=%ld&status=5",setOrderInfoOrderStatusURl,[self.orderDic[@"id"] integerValue]] parameters:@{} success:^(id responseObject) {
            
            if ([responseObject[@"code"] integerValue] == 0) {
                
                [self.navigationController popViewControllerAnimated:YES];
            }
            [self hideProgressHUD];
        } failure:^(NSError *error) {
            
        }];
   
    
}
//去付款
- (void)rightButtonAction:(UIButton *)sender
{
   
    //判断进入金钱支付界面还是礼品卡支付界面
    if ([self.orderDic[@"realPayment"] floatValue]  * 100 == 0) {
        PresentQueRenZhiFuViewController *present = [PresentQueRenZhiFuViewController new];
        present.presentDic = @{@"serialNumber":self.orderDic[@"orderno"],@"giftCardPrice":@([self.orderDic[@"totalPrice"] floatValue])};
        [self.navigationController pushViewController:present animated:YES];
    } else {
        ZhifuFangShiViewController *zhifu  = [ZhifuFangShiViewController new];
        
        NSDictionary *orderdic = @{@"serialNumber":self.orderDic[@"orderno"],@"totalFee":@([self.orderDic[@"realPayment"] floatValue])};
        zhifu.weixinDic = orderdic;
        [self.navigationController pushViewController:zhifu animated:YES];
    }
    
}

- (void)pingjiaButtonAction:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"去评价"]) {
        //去评价
        PingjiaViewController *pingjia = [PingjiaViewController new];
        pingjia.dataArray = self.dataArray;
        [self.navigationController pushViewController:pingjia animated:YES];
    } else {
        //确认收货
        [PPNetworkHelper GET:[NSString stringWithFormat:@"%@?orderId=%ld&status=4",setOrderInfoOrderStatusURl,[self.orderDic[@"id"] integerValue]] parameters:@{} success:^(id responseObject) {
            
            if ([responseObject[@"code"] integerValue] == 0) {
                [MBProgressHUD showError:@"已确认收货"];
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        } failure:^(NSError *error) {
            
        }];
    }
    
}
- (void)createheadAndFoot
{
    //创建footer
    orderDetailFoot *foot = [[[NSBundle mainBundle] loadNibNamed:@"orderDetailFoot" owner:nil options:nil] firstObject];
    
    //取消订单点击事件
    [foot.leftButton addTarget:self action:@selector(leftButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [foot.rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [foot.pingjiaButton addTarget:self action:@selector(pingjiaButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    foot.topfirstLab.text = [NSString stringWithFormat:@"¥%.2f",[self.orderDic[@"postage"] floatValue]];
    foot.topsecondLab.text = [NSString stringWithFormat:@"¥%.2f",[self.orderDic[@"totalPrice"] floatValue]];
    foot.topsecondLab.attributedText = [PriceLine priceLineMethod:foot.topsecondLab.text];
    foot.topthreeLab.text = [NSString stringWithFormat:@"¥%.2f",[self.orderDic[@"realPayment"] floatValue]];
    foot.firstLab.text = [NSString stringWithFormat:@"订单编号  %@",self.orderDic[@"orderno"]];
    foot.secondLab.text = [NSString stringWithFormat:@"下单时间  %@",self.orderDic[@"createTime"]];
    if (self.orderDic[@"payTime"]) {
        foot.threeLab.text = [NSString stringWithFormat:@"付款时间 %@",self.orderDic[@"payTime"]];
    } else {
        foot.threeLab.hidden = YES;
    }
    
    if (self.orderDic[@"consignTime"]) {
        foot.fourLab.text = [NSString stringWithFormat:@"发货时间 %@",self.orderDic[@"consignTime"]];
    } else {
        foot.fourLab.hidden = YES;
    }
    
    if ([self.orderDic[@"orderStatus"] integerValue] == 4) {
        foot.fiveLab.text = [NSString stringWithFormat:@"签收时间 %@",self.orderDic[@"signTime"]];
    } else {
        foot.fiveLab.hidden = YES;
        
    }
    self.tableView.tableFooterView = foot;
    
    //创建header
    orderDetailHead *head = [[[NSBundle mainBundle] loadNibNamed:@"orderDetailHead" owner:nil options:nil] firstObject];
    head.firstLab.text = [NSString stringWithFormat:@"物流公司  %@",self.orderDic[@"logisticsCompany"]];
    head.threelab.text = [NSString stringWithFormat:@"%@   %@",_orderDic[@"receiveName"],_orderDic[@"receiveMobile"]];
    head.fourLab.text = [NSString stringWithFormat:@"%@%@%@%@",_orderDic[@"receiveProvince"],_orderDic[@"receiveCity"],_orderDic[@"receiveArea"],_orderDic[@"receiveAddress"]];
    
    head.fiveLab.text = _orderDic[@"salesOutlets"];
    
    if ([self.orderDic[@"orderStatus"] integerValue] == 1) {
        head.constraintInset.constant = 10;
        head.secLab.hidden = YES;
        head.sixLab.text = @"待付款";
        foot.leftBtninset.constant = 10;
        foot.rightinset.constant = 10;
        foot.pingjiaButton.hidden = YES;
    } else if ([self.orderDic[@"orderStatus"] integerValue] == 2){
        head.constraintInset.constant = 10;
        head.secLab.hidden = YES;
        head.sixLab.text = @"待发货";
        foot.pingjiaButton.hidden = YES;
        foot.leftButton.hidden = YES;
        foot.rightButton.hidden = YES;
        
    } else if ([self.orderDic[@"orderStatus"] integerValue] == 3){
         head.secLab.hidden = NO;
        head.secLab.text = [NSString stringWithFormat:@"运单编号  %@",self.orderDic[@"serialNumber"]];
        head.sixLab.text = @"待签收";
        [foot.pingjiaButton setTitle:@"确认收货" forState:(UIControlStateNormal)];
        foot.pingjiaButton.hidden = NO;
        foot.leftButton.hidden = YES;
        foot.rightButton.hidden = YES;
    } else if([self.orderDic[@"orderStatus"] integerValue] == 4){
         head.secLab.hidden = NO;
        head.secLab.text = [NSString stringWithFormat:@"运单编号  %@",self.orderDic[@"serialNumber"]];
        head.sixLab.text = @"交易完成";
        //判断是否已经评价
        if ([self.orderDic[@"israte"] integerValue] == 0) {
            //进行评价
            foot.leftButton.hidden = YES;
            foot.rightButton.hidden = YES;
            
        } else {
            foot.leftButton.hidden = YES;
            foot.rightButton.hidden = YES;
            foot.pingjiaButton.hidden = NO;
            [foot.pingjiaButton setTitle:@"已评价" forState:(UIControlStateNormal)];
            foot.pingjiaButton.enabled = NO;
        }
        
    } else if([self.orderDic[@"orderStatus"] integerValue] == 5){
        head.firstLab.text = @"物流公司 无";
        head.sixLab.text = @"已取消";
        head.constraintInset.constant = 10;
        head.secLab.hidden = YES;
        foot.leftButton.hidden = YES;
        foot.rightButton.hidden = YES;
        foot.pingjiaButton.hidden = YES;
    } else {
        head.secLab.hidden = NO;
        head.secLab.text = [NSString stringWithFormat:@"运单编号  %@",self.orderDic[@"serialNumber"]];
        head.sixLab.text = @"退款完成";
        foot.leftButton.hidden = YES;
        foot.rightButton.hidden = YES;
        foot.pingjiaButton.hidden = NO;
        [foot.pingjiaButton setTitle:@"已退款" forState:(UIControlStateNormal)];
        foot.pingjiaButton.enabled = NO;
    }
    self.tableView.tableHeaderView = head;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    waitshouhuoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"waitcell" forIndexPath:indexPath];
    [ButtonBorderColorManager setbuttonbordercolor:cell.shouhouButton btntitle:@"申请售后"];
    //交易完成之后
    if (self.orderStatusNew == 4 || self.orderStatusNew == 3) {
        for (orderSubModel *submodel in self.canshenqingArr) {
            
            if (submodel.isApplyAfterSale == 0) {
               
               cell.shouhouButton.hidden = NO;
            } else {
                cell.shouhouButton.hidden = YES;
            }
             NSLog(@"%d售后参数--------",submodel.isApplyAfterSale);
        }
       
    } else {
        cell.shouhouButton.hidden = YES;
    }
   
    cell.shouhouButton.tag = 100 + indexPath.row;
    [cell.shouhouButton addTarget:self action:@selector(shouhouButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    cell.detailModel = self.dataArray[indexPath.row];
    
    return cell;
}
- (void)shouhouButtonAction:(UIButton *)sender
{
    orderDetailModel *model = self.dataArray[sender.tag - 100];
    
    NSDictionary *dic =@{@"goodsName":model.goodsName,
                         @"goodsPrice":[NSString stringWithFormat:@"%.2f",model.goodsPrice],
                         @"quantity":[NSString stringWithFormat:@"%ld",model.quantity],
                         @"goodsPicurl":model.goodsPicurl,
                         @"orderId":[NSString stringWithFormat:@"%ld",[_orderDic[@"id"] integerValue]],
                         @"orderNo":_orderDic[@"orderno"],
                         @"goodsId":[NSString stringWithFormat:@"%ld",model.id],
                         @"skuId":[NSString stringWithFormat:@"%ld",model.skuId],
                         @"appId":[NSString stringWithFormat:@"%ld",[self.orderDic[@"appId"] integerValue]]};
    
    
    
    //进入售后申请
    [PPNetworkHelper POST:customerapplyIdexURL parameters:dic success:^(id responseObject) {
        
        
        if ([responseObject[@"code"] integerValue] == 0) {
            
            ShouHouViewController *shouhou = [ShouHouViewController new];
            shouhou.shouhouDic = responseObject[@"map"][@"customerApplyView"];
            [self.navigationController pushViewController:shouhou animated:YES];
            
        }
       
    } failure:^(NSError *error) {
        
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detail = [DetailViewController new];
    
    detail.detailID = [self.dataArray[indexPath.row] goodsId];
    
    [self.navigationController pushViewController:detail animated:YES];
}



@end
