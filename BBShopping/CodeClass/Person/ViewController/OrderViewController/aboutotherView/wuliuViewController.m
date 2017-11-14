//
//  wuliuViewController.m
//  BBShopping
//
//  Created by 张亚峰 on 2017/2/24.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "wuliuViewController.h"
#import "wuliuModel.h"
#import "wuliuHead.h"
#import "wuliuCell.h"

#import "waitshouhuoCell.h"
@interface wuliuViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong)NSDictionary *wuliuDic;
@property (nonatomic, strong)wuliuHead *head;
@property (nonatomic, strong)NSMutableArray *modelArray;
@end

@implementation wuliuViewController
- (NSMutableArray *)modelArray
{
    if (!_modelArray) {
        self.modelArray = [NSMutableArray new];
    }
    return _modelArray;
}
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray new];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"物流详情";
    [self.tableview registerNib:[UINib nibWithNibName:@"wuliuCell" bundle:nil] forCellReuseIdentifier:@"wuliucell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"waitshouhuoCell" bundle:nil] forCellReuseIdentifier:@"waitcell"];
    [self request];
}
- (void)request
{
    [self showProgressHUD];
    [PPNetworkHelper GET:[NSString stringWithFormat:@"%@?orderId=%ld",getLogisticsURL,self.orderId] parameters:@{} success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            self.wuliuDic = responseObject[@"map"];
            for (NSDictionary *dic in responseObject[@"map"][@"logisticsViews"]) {
                wuliuModel *model = [wuliuModel new];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArray addObject:model];
            }
            for (NSDictionary *newdic in responseObject[@"map"][@"goodsList"]) {
                wuliuModel *model  = [wuliuModel new];
                [model setValuesForKeysWithDictionary:newdic];
                [self.modelArray addObject:model];
            }
            if (self.modelArray == 0) {
                [self.tableview reloadEmptyDataSet];
            }
            
        }
         [self createHead];
        [self.tableview reloadData];
        
        [self hideProgressHUD];
    } failure:^(NSError *error) {
        
    }];
}
- (void)createHead
{
    _head = [[[NSBundle mainBundle] loadNibNamed:@"wuliuHead" owner:nil options:nil] firstObject];
    _head.firstLab.text = [NSString stringWithFormat:@"物流状态:%@",self.wuliuDic[@"state"]];
    _head.seclab.text = [NSString stringWithFormat:@"物流公司:%@",self.wuliuDic[@"logisticsCompany"]];
    _head.threeLab.text = [NSString stringWithFormat:@"运单编号:%@",self.wuliuDic[@"orderno"]];
    _head.fourLab.text = [NSString stringWithFormat:@"下单时间:%@",self.wuliuDic[@"createTime"]];
    self.tableview.tableHeaderView = _head;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.modelArray.count;
    } else {
       return self.dataArray.count;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        waitshouhuoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"waitcell" forIndexPath:indexPath];
        cell.wuliuModel = self.modelArray[indexPath.row];
        return cell;
    } else {
        wuliuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"wuliucell" forIndexPath:indexPath];
        if (indexPath.row== 0) {
            cell.leftTopLab.hidden = YES;
            cell.leftLab.backgroundColor = [ColorString colorWithHexString:@"#f9cd02"];
            
        } else {
            cell.leftTopLab.hidden = NO;
            
            cell.leftLab.backgroundColor  = [UIColor lightGrayColor];
        }
        
        cell.model = self.dataArray[indexPath.row];
        return cell;
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 100;
    } else {
        return 90;
    }
   
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
         return @"商品信息";
    } else {
         return @"物流跟踪";
    }
   
}

//
//返回标题
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无物流信息";
    UIFont *font = [UIFont systemFontOfSize:15];
    UIColor *color = [UIColor blackColor];
    NSMutableDictionary *attribult = [NSMutableDictionary new];
    [attribult setObject:font forKey:NSFontAttributeName];
    [attribult setObject:color forKey:NSForegroundColorAttributeName];
    return [[NSAttributedString alloc] initWithString:text attributes:attribult];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat sectionHeaderHeight = 45;
    if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0)
    {
        scrollView.contentInset = UIEdgeInsetsMake(- scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y >= sectionHeaderHeight)
    {
        scrollView.contentInset = UIEdgeInsetsMake(- sectionHeaderHeight, 0, 0, 0);
    }  
}

@end
