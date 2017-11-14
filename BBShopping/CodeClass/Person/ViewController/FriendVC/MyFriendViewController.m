//
//  MyFriendViewController.m
//  BBShopping
//
//  Created by mibo02 on 17/1/17.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "MyFriendViewController.h"
#import "shituViewController.h"
#import "OrderViewController.h"
#import "YuShouRuViewController.h"
#import "GuanLiViewController.h"
@interface MyFriendViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSArray *arr;
@end

@implementation MyFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的圈子";
    self.arr = @[@"师徒",@"分销订单",@"预收入",@"资金管理"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"fengfeng";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:str];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.arr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            shituViewController *shitu = [shituViewController new];
            [self.navigationController pushViewController:shitu animated:YES];
        }
            break;
        case 1:
        {
            OrderViewController *fenxiao = [OrderViewController new];
            fenxiao.begTypes = 4;
            [self.navigationController pushViewController:fenxiao animated:YES];
        }
            break;
        case 2:
        {
            YuShouRuViewController *shouru = [YuShouRuViewController new];
            [self.navigationController pushViewController:shouru animated:YES];
        }
            break;
        case 3:
        {
            GuanLiViewController *guanli = [GuanLiViewController new];
            [self.navigationController pushViewController:guanli animated:YES];
        }
            break;
            
        default:
            break;
    }
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
