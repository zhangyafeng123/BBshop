//
//  PingLunViewController.m
//  BBShopping
//
//  Created by mibo02 on 17/2/18.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "PingLunViewController.h"
#import "PingLunCell.h"
#import "pinglunModel.h"
@interface PingLunViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation PingLunViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray new];
        
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的评论";
    [self.tableview registerNib:[UINib nibWithNibName:@"PingLunCell" bundle:nil] forCellReuseIdentifier:@"pinglunCell"];
    [self request];
}
- (void)request
{
    [self showProgressHUD];
    
    [PPNetworkHelper GET:commentURL parameters:@{} success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            for (NSDictionary *dic in responseObject[@"obj"][@"myrateList1"]) {
                pinglunModel *model = [pinglunModel new];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArray addObject:model];
            }
            for (NSDictionary *secdic in responseObject[@"obj"][@"myrateList2"]) {
                pinglunModel *model = [pinglunModel new];
                [model setValuesForKeysWithDictionary:secdic];
                [self.dataArray addObject:model];
            }
            for (NSDictionary *secdic in responseObject[@"obj"][@"myrateList3"]) {
                pinglunModel *model = [pinglunModel new];
                [model setValuesForKeysWithDictionary:secdic];
                [self.dataArray addObject:model];
            }
            
        }
        
        [self.tableview reloadData];
        [self hideProgressHUD];
    } failure:^(NSError *error) {
        
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PingLunCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pinglunCell" forIndexPath:indexPath];
    pinglunModel *model = self.dataArray[indexPath.row];
    cell.nicknameLab.text = model.userName;
    [cell.leftImg  sd_setImageWithURL:[NSURL URLWithString:model.goodsPicUrl]];
    cell.titleLab.text = model.goodsName;
    cell.dateLab.text = model.addTime;
    cell.contentlab.text = model.content;
    
    HCSStarRatingView *starRatingView = [[HCSStarRatingView alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
    starRatingView.allowsHalfStars = NO;
    starRatingView.value = [self.dataArray[indexPath.row] evaluation];
    starRatingView.tintColor = [ColorString colorWithHexString:@"#f9cd02"];
    [cell.starView addSubview:starRatingView];
    UIView *starV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    starV.backgroundColor = [UIColor clearColor];
    [starRatingView addSubview:starV];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 170;
}
//返回标题
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"很抱歉,暂无评论记录";
    UIFont *font = [UIFont systemFontOfSize:15];
    UIColor *color = [UIColor blackColor];
    NSMutableDictionary *attribult = [NSMutableDictionary new];
    [attribult setObject:font forKey:NSFontAttributeName];
    [attribult setObject:color forKey:NSForegroundColorAttributeName];
    return [[NSAttributedString alloc] initWithString:text attributes:attribult];
}


@end
