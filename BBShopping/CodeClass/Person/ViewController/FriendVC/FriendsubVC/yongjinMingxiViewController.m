//
//  yongjinMingxiViewController.m
//  BBShopping
//
//  Created by 张亚峰 on 2017/3/11.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "yongjinMingxiViewController.h"
#import "mingxidetailCell.h"
@interface yongjinMingxiViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)NSDictionary *newdic;
@end

@implementation yongjinMingxiViewController
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray new];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"佣金明细";
    [self.tableview registerNib:[UINib nibWithNibName:@"mingxidetailCell" bundle:nil] forCellReuseIdentifier:@"detailcell"];
    [self request];
}

- (void)request
{
    [self showProgressHUD];
    [PPNetworkHelper GET:[NSString stringWithFormat:@"%@?userId=%ld",commission_detailURL,self.userid] parameters:@{} success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 0) {
            self.newdic = responseObject[@"map"];
            for (NSDictionary *dic in responseObject[@"map"][@"budgetList"][@"list"]) {
                [self.dataArray addObject:dic];
            }
        }
        //
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
    leftLab.text = @"累计佣金(元)";
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
    mingxidetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailcell" forIndexPath:indexPath];
    
    cell.firstLab.text = self.dataArray[indexPath.row][@"create_time"];
    cell.secLab.text = [NSString stringWithFormat:@"订单编号:%@",self.dataArray[indexPath.row][@"orderno"]];
    cell.threeLab.text = [NSString stringWithFormat:@"%.2f",[self.dataArray[indexPath.row][@"commission"] floatValue]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}


@end
