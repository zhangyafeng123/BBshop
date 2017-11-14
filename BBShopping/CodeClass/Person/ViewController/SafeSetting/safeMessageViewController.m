//
//  safeMessageViewController.m
//  BBShopping
//
//  Created by mibo02 on 17/3/15.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "safeMessageViewController.h"
#import "safeMessageCell.h"
@interface safeMessageViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic, strong)NSArray *oneArr;
@property (nonatomic, strong)NSArray *twoArr;

@end

@implementation safeMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"消息提醒设置";
    self.oneArr = @[@"订单提交成功通知",@"订单取消通知",@"订单支付成功通知",@"订单发货通知",@"订单确认收货通知",@"提现提交通知",@"提现失败通知",@"提现成功通知"];
    self.twoArr = @[@"成为分销商通知",@"新增徒弟通知",@"徒弟付款通知",@"徒弟确认收货通知",@"新增徒孙通知",@"徒孙付款通知",@"徒孙确认收货通知"];
    [self.tableview registerNib:[UINib nibWithNibName:@"safeMessageCell" bundle:nil] forCellReuseIdentifier:@"message"];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.oneArr.count;
    } else {
        return self.twoArr.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    safeMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"message" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        cell.leftLab.text = self.oneArr[indexPath.row];
    } else {
        cell.leftLab.text = self.twoArr[indexPath.row];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UILabel *leftlab  = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH - 20, 40)];
    leftlab.backgroundColor = [UIColor clearColor];
    if (section == 0) {
        leftlab.text = @"商城信息提醒";
    } else {
        leftlab.text = @"分销信息提醒";
    }
    [view addSubview:leftlab];
    return view;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _tableview) {
        //去掉UItableview的section的headerview黏性
        CGFloat sectionHeaderHeight = 40;
        if (scrollView.contentOffset.y<=sectionHeaderHeight && scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}


@end
