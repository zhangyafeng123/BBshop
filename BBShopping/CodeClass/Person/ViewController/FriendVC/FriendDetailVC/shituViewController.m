//
//  shituViewController.m
//  BBShopping
//
//  Created by 张亚峰 on 2017/3/4.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "shituViewController.h"
#import "ShiTuModel.h"
#import "ShiTuCell.h"
@interface shituViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *leftbtn;
@property (weak, nonatomic) IBOutlet UIButton *rightbtn;


@end

@implementation shituViewController
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  = @"师徒";
     self.navigationController.navigationBar.translucent = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"ShiTuCell" bundle:nil]
         forCellReuseIdentifier:@"shitu"];

    _leftbtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.leftbtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.leftbtn.titleLabel.numberOfLines = 2;
    self.rightbtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.rightbtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.rightbtn.titleLabel.numberOfLines = 2;
    
    [self request:1];
     [self.rightbtn setTitle:@"徒孙\n0" forState:(UIControlStateNormal)];
}

- (IBAction)leftbtnAction:(UIButton *)sender {
    
    [self request:1];
    
    
}
- (IBAction)rightBtnAction:(UIButton *)sender {
    
    [self request:2];
   
}

- (void)request:(NSInteger)number
{
    [PPNetworkHelper setValue:[UserInfoManager getUserInfo].token forHTTPHeaderField:@"token"];
    [self.dataArray removeAllObjects];
    [PPNetworkHelper GET:[NSString stringWithFormat:@"%@?queryType=%ld",disciplesAndFollowersURL,number] parameters:@{} success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 9999) {
            [MBProgressHUD showError:responseObject[@"message"]];
        } else if ([responseObject[@"code"] integerValue] == 0){
            for (NSDictionary *dic in responseObject[@"map"][@"disciples"][@"distributeRelacount"]) {
                ShiTuModel *model = [ShiTuModel new];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArray addObject:model];
            }
        }
        if (number == 1) {
            [self.leftbtn setTitle:[NSString stringWithFormat:@"徒弟\n%ld",self.dataArray.count] forState:(UIControlStateNormal)];
        } else if(number == 2){
            [self.rightbtn setTitle:[NSString stringWithFormat:@"徒孙\n%ld",self.dataArray.count] forState:(UIControlStateNormal)];
        }
        
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShiTuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shitu" forIndexPath:indexPath];
    ShiTuModel *model = self.dataArray[indexPath.row];
    cell.namelab.text = model.user_name;
    cell.firstLab.text = [NSString stringWithFormat:@"%.2f",model.pro_totalPrice];
    cell.secondLab.text = [NSString stringWithFormat:@"%.2f",model.pro_devotePrice];
    cell.threeLab.text = model.last_time;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}



@end
