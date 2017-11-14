//
//  GuanLiViewController.m
//  BBShopping
//
//  Created by 张亚峰 on 2017/3/4.
//  Copyright © 2017年 mibo02. All rights reserved.
//
#import "yongjinMainViewController.h"
#import "GuanLiViewController.h"
#import "guanlihead.h"
#import "TQXJViewController.h"
@interface GuanLiViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSDictionary *dic;
@end

@implementation GuanLiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"资金管理";
    [self request];
}
- (void)request
{
     [PPNetworkHelper setValue:[UserInfoManager getUserInfo].token forHTTPHeaderField:@"token"];
    [PPNetworkHelper GET:myFundsURL parameters:@{} success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 0) {
            self.dic = responseObject[@"map"];
        }
        [self.tableView reloadData];
        
        guanlihead *head = [[[NSBundle mainBundle] loadNibNamed:@"guanlihead" owner:nil options:nil] firstObject];
        head.firstLab.text = [NSString stringWithFormat:@"累计金额(元):%.2f",[self.dic[@"financeFundCashAccount"][@"accountBalance"] floatValue]];
        head.seclab.text = [NSString stringWithFormat:@"冻结金额(元):%.2f",[self.dic[@"financeFundCashAccount"][@"freezeBalance"] floatValue]];
        head.threeLab.text = [NSString stringWithFormat:@"可用金额(元):%.2f",[self.dic[@"financeFundCashAccount"][@"canBalance"] floatValue]];
        head.fourLab.text = [NSString stringWithFormat:@"申请金额(元):%.2f",[self.dic[@"financeFundCashAccount"][@"currentMoney"] floatValue]];
        [head.tixianBtn addTarget:self action:@selector(actionBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        self.tableView.tableHeaderView = head;
    } failure:^(NSError *error) {
        
    }];
}
- (void)actionBtn:(UIButton *)sender
{
  
    if ([UserInfoManager isLoading]) {
        TQXJViewController *tq = [TQXJViewController new];
        [self.navigationController pushViewController:tq animated:YES];
      
    } else {
        [MBProgressHUD showError:@"请登录"];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:str];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row == 0) {
        cell.textLabel.text = @"累计佣金";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f",[self.dic[@"totalCommission"] floatValue]];
    } else {
        cell.textLabel.text = @"已提现金额";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f",[self.dic[@"financeFundCashAccount"][@"extractedMoney"] floatValue]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        yongjinMainViewController *yongjin = [yongjinMainViewController new];
        [self.navigationController pushViewController:yongjin animated:YES];
    }
}




@end
