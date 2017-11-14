//
//  YuShouRuViewController.m
//  BBShopping
//
//  Created by 张亚峰 on 2017/3/4.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "YuShouRuViewController.h"
#import "yushouruCell.h"
@interface YuShouRuViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong)NSMutableArray *dataArray;
@end

@implementation YuShouRuViewController
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray new];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"预收入";
    [self.tableview registerNib:[UINib nibWithNibName:@"yushouruCell" bundle:nil] forCellReuseIdentifier:@"yushouru"];
    [self request];
}
- (void)request
{
    [PPNetworkHelper GET:[NSString stringWithFormat:@"%@?start=1&limit=10",circlebudgetURL] parameters:@{} success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            for (NSDictionary *dic in responseObject[@"map"][@"orderBudgetDTO"][@"list"]) {
                [self.dataArray addObject:dic];
            }
        }
        [self.tableview reloadData];
    } failure:^(NSError *error) {
        
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    yushouruCell *cell = [tableView dequeueReusableCellWithIdentifier:@"yushouru" forIndexPath:indexPath];
    cell.firstLab.text = self.dataArray[indexPath.row][@"create_time"];
    cell.secLab.text = self.dataArray[indexPath.row][@"orderno"];
    cell.threelab.text = [NSString stringWithFormat:@"%.2f",[self.dataArray[indexPath.row][@"user1commission"] floatValue]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}



@end
