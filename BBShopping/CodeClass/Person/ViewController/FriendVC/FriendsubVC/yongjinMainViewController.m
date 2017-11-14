//
//  yongjinMainViewController.m
//  BBShopping
//
//  Created by 张亚峰 on 2017/3/11.
//  Copyright © 2017年 mibo02. All rights reserved.
//
#import "yongjinMingxiViewController.h"
#import "yongjinMainViewController.h"

@interface yongjinMainViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)NSDictionary *newdic;
@end


@implementation yongjinMainViewController
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray new];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  = @"佣金主页";
    [self request];
}
- (void)request
{
    [self showProgressHUD];
    [PPNetworkHelper GET:[NSString stringWithFormat:@"%@?start=%d&limit=%d",detail_allURL,1,10] parameters:@{} success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            self.newdic = responseObject[@"map"];
            for (NSDictionary *dic in responseObject[@"map"][@"fundsBudgetList"][@"list"]) {
                [self.dataArray addObject:dic];
            }
        }
        [self createhead];
        
        [self.tableview reloadData];
        [self hideProgressHUD];
    } failure:^(NSError *error) {
        
    }];
}
- (void)createhead
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    view.backgroundColor  = [UIColor groupTableViewBackgroundColor];
    UILabel *leftLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH/2-20, 44)];
    leftLab.backgroundColor = [UIColor clearColor];
    leftLab.textAlignment = NSTextAlignmentLeft;
    leftLab.text = @"应收佣金(元)";
    [view addSubview:leftLab];
    UILabel *rightlab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2, 0, SCREEN_WIDTH/2-20, 44)];
    rightlab.backgroundColor = [UIColor clearColor];
    rightlab.textAlignment = NSTextAlignmentRight;
    rightlab.text = [NSString stringWithFormat:@"%.2f",[self.newdic[@"totalCommission"] floatValue]];
    [view addSubview:rightlab];
    self.tableview.tableHeaderView = view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"yongjin";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:str];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = self.dataArray[indexPath.row][@"nickname"];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"累计佣金(元)%.2f",[self.dataArray[indexPath.row][@"totalCommission"] floatValue]];
    
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    yongjinMingxiViewController *mingxi = [yongjinMingxiViewController new];
    mingxi.userid = [self.dataArray[indexPath.row][@"user1Id"] integerValue];
    [self.navigationController pushViewController:mingxi animated:YES];
}

@end
