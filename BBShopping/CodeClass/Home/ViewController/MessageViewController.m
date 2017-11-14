//
//  MessageViewController.m
//  BBShopping
//
//  Created by mibo02 on 17/2/14.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "MessageViewController.h"
#import "newothermessageCell.h"
@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)MJRefreshBackNormalFooter *mj;
@property (nonatomic, assign)NSInteger StratPage;
@end

@implementation MessageViewController
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通知中心";
    self.StratPage = 1;
    [self.tableView registerNib:[UINib nibWithNibName:@"newothermessageCell" bundle:nil] forCellReuseIdentifier:@"message"];
    
    [self request];
}
- (void)request
{
    [self showProgressHUD];
    [PPNetworkHelper setValue:[UserInfoManager getUserInfo].token forHTTPHeaderField:@"token"];
    [PPNetworkHelper GET:[NSString stringWithFormat:@"%@?pageNum=%ld&pageSize=10",getMsgListURL,self.StratPage] parameters:@{} success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            for (NSDictionary *dic in responseObject[@"map"][@"msgList"][@"list"]) {
                [self.dataArray addObject:dic];
            }
        }
        [self.tableView reloadData];
        //上拉刷新
        [self RefreshForCollection:responseObject];
        [self hideProgressHUD];
    } failure:^(NSError *error) {
        
    }];
}
- (void)RefreshForCollection:(id)responseObject
{
    //判断是否是最后一页
    if ([responseObject[@"map"][@"msgList"][@"pages"] integerValue] > self.StratPage) {
        
        self.StratPage += 1;
        //进入下拉加载
        _mj = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self.tableView.mj_footer beginRefreshing];
            
            [self request];
            [self.tableView.mj_footer endRefreshing];
        }];
        self.tableView.mj_footer = _mj;
        
    } else {
        
        [_mj endRefreshingWithNoMoreData];
    }
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
    newothermessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"message" forIndexPath:indexPath];
    cell.titleLab.text = self.dataArray[indexPath.row][@"title"];
    cell.contentLab.text = self.dataArray[indexPath.row][@"content"];
    cell.timelab.text = self.dataArray[indexPath.row][@"createTime"];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
//返回标题
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无消息";
    
    UIFont *font = [UIFont systemFontOfSize:15];
    UIColor *color = [UIColor blackColor];
    NSMutableDictionary *attribult = [NSMutableDictionary new];
    [attribult setObject:font forKey:NSFontAttributeName];
    [attribult setObject:color forKey:NSForegroundColorAttributeName];
    return [[NSAttributedString alloc] initWithString:text attributes:attribult];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
