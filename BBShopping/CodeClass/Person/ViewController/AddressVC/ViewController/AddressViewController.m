//
//  AddressViewController.m
//  BBShopping
//
//  Created by mibo02 on 17/2/18.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "AddressViewController.h"
#import "AddressCell.h"
#import "EditAddressViewController.h"
#import "AddressModel.h"

@interface AddressViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation AddressViewController
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray new];
    }
    return _dataArray;
}
- (IBAction)addButton:(UIButton *)sender {
    if ([UserInfoManager isLoading]) {
        EditAddressViewController *edit = [EditAddressViewController new];
        [self.navigationController pushViewController:edit animated:YES];
    } else {
        [MBProgressHUD showSuccess:@"请登录"];
    }
   
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//   
//}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //获取地址列表
    [AddressRequest requestList:self.tableview arr:self.dataArray];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"地址管理";
    [self.tableview registerNib:[UINib nibWithNibName:@"AddressCell" bundle:nil] forCellReuseIdentifier:@"AddressCell"];
    self.tableview.emptyDataSetSource = self;
    self.tableview.emptyDataSetDelegate = self;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataArray.count != 0) {
        return self.dataArray.count;
    } else {
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"AddressCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.normalBtn.tag = 100 + indexPath.row;
    cell.editBtn.tag = 200 + indexPath.row;
    cell.deleteBtn.tag = 300 + indexPath.row;
    
    if ([self.dataArray[indexPath.row] isReceiveDefault] == 1) {
        [cell.normalBtn setImage:[UIImage imageNamed:@"选中"] forState:(UIControlStateNormal)];
        [cell.normalBtn setTitleColor:[ColorString colorWithHexString:@"#f9cd02"] forState:(UIControlStateNormal)];
    } else {
        [cell.normalBtn setImage:[UIImage imageNamed:@"未选中"] forState:(UIControlStateNormal)];
        [cell.normalBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    }
    
    [cell.normalBtn addTarget:self action:@selector(normalBtnActon:) forControlEvents:(UIControlEventTouchUpInside)];
    [cell.editBtn addTarget:self action:@selector(editBtnActon:) forControlEvents:(UIControlEventTouchUpInside)];
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnActon:) forControlEvents:(UIControlEventTouchUpInside)];
    if (self.dataArray.count != 0) {
        cell.model  = self.dataArray[indexPath.row]; 
    }
   
    return cell;
}
- (void)normalBtnActon:(UIButton *)sender
{
    [PPNetworkHelper setValue:[UserInfoManager getUserInfo].token forHTTPHeaderField:@"token"];
    NSInteger i = [self.dataArray[sender.tag - 100] id];
    [PPNetworkHelper POST:setDefaultAddressURL parameters:@{@"id":@(i)} success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            [sender setImage:[UIImage imageNamed:@"选中"] forState:(UIControlStateNormal)];
            [sender setTitleColor:[ColorString colorWithHexString:@"#f9cd02"] forState:(UIControlStateNormal)];
           
        } else if ([responseObject[@"code"] integerValue] == 40000){
            [MBProgressHUD showError:responseObject[@"message"]];
        }
          [AddressRequest requestList:self.tableview arr:self.dataArray];
    } failure:^(NSError *error) {
        
    }];
}
- (void)editBtnActon:(UIButton *)sender
{
    //将相应的参数传递过去
    EditAddressViewController *edit = [EditAddressViewController new];
    edit.btnstr = @"编辑完成";
    AddressModel *model = self.dataArray[sender.tag - 200];
    edit.editid = model.id;

    [self.navigationController pushViewController:edit animated:YES];
}
- (void)deleteBtnActon:(UIButton *)sender
{
    [PPNetworkHelper setValue:[UserInfoManager getUserInfo].token forHTTPHeaderField:@"token"];
    AddressModel *model = self.dataArray[sender.tag - 300];
    NSInteger i = [self.dataArray[sender.tag - 300] id];
    
    [PPNetworkHelper POST:deleteAddressURL parameters:@{@"id":@(i)} success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 0) {
            [self.dataArray removeObject:model];
            
            [self.tableview deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:sender.tag - 300 inSection:0]] withRowAnimation:(UITableViewRowAnimationFade)];
            [self.tableview reloadData];
            [MBProgressHUD showError:@"删除成功"];
        } else if ([responseObject[@"code"] integerValue] == 40000){
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        [self.tableview reloadData];
    } failure:^(NSError *error) {
        
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return view;
}

//返回标题
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"收货地址在哪里";
    UIFont *font = [UIFont systemFontOfSize:15];
    UIColor *color = [UIColor blackColor];
    NSMutableDictionary *attribult = [NSMutableDictionary new];
    [attribult setObject:font forKey:NSFontAttributeName];
    [attribult setObject:color forKey:NSForegroundColorAttributeName];
    return [[NSAttributedString alloc] initWithString:text attributes:attribult];
}

//
//返回单张图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"无地址"];
}

@end
