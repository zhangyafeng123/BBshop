//
//  PersonViewController.m
//  BBShopping
//
//  Created by mibo02 on 17/1/16.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "PersonViewController.h"
#import "HeadView.h"
#import "PersonCell.h"
#import "LoginViewController.h"
#import "NewLoginViewController.h"
#import "SafeSetViewController.h"
#import "SetViewController.h"
#import "MyFriendViewController.h"
#import "TotalGroupViewController.h"
#import "SafeSetViewController.h"
#import "OrderViewController.h"
#import "PresentViewController.h"
#import "AddressViewController.h"
#import "PingLunViewController.h"

@interface PersonViewController ()<UITableViewDelegate,UITableViewDataSource,HeadViewDelegate>
@property (nonatomic, strong)HeadView *headView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSArray *arr1;
@property (nonatomic, strong)NSArray *arr2;
@property (nonatomic, strong)NSArray *imageArr1;
@property (nonatomic, strong)NSArray *imageArr2;
@property (nonatomic, strong)NSDictionary *personDic;
@property (nonatomic, strong)NSDictionary *countsDic;

@property (nonatomic, assign)NSInteger numcount;
@end

@implementation PersonViewController
//删除通知
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"PersonCell" bundle:nil] forCellReuseIdentifier:@"personCell"];
    self.arr1 = @[@"我的圈子",@"礼品卡"];
    self.arr2 = @[@"地址管理",@"系统设置",@"我的评论"];
    self.imageArr1 = @[@"我的圈子",@"礼品卡"];
    self.imageArr2 = @[@"地址管理",@"设置",@"评论"];
    //判断登陆没有
    [self erterLoginForOne];
   //进入登陆界面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterLogin) name:@"enterLogin" object:nil];
    //进入全部订单界面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionfororderNew) name:@"othernewertersuccessorderVC" object:nil];
    //进入未支付订单界面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unpayaction) name:@"newentersecondpay" object:nil];
   
}
- (void)unpayaction
{
    OrderViewController *order = [OrderViewController new];
    order.hidesBottomBarWhenPushed = YES;
    order.title = @"待付款";
    order.indexStats = 1;
    order.begTypes = 1;
    [self.navigationController pushViewController:order animated:YES];
}
- (void)actionfororderNew
{
    OrderViewController *order = [OrderViewController new];
    order.hidesBottomBarWhenPushed = YES;
    order.title = @"全部订单";
    [self.navigationController pushViewController:order animated:YES];
}
- (void)erterLoginForOne
{
    if (![UserInfoManager isLoading] || self.numcount == 9999) {
        NewLoginViewController *login = [[NewLoginViewController alloc] init];
        login.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:login animated:YES];
    }
}

/*
 通知进入登录界面
 */
- (void)enterLogin
{
    
    NewLoginViewController *login = [[NewLoginViewController alloc] init];
    login.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:login animated:YES];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self request];
    [self requestCounts];
}

#pragma marks------请求订单显示角标数量-------

- (void)requestCounts
{
 
        [PPNetworkHelper GET:countsURL parameters:@{} success:^(id responseObject) {
            
            self.numcount = [responseObject[@"code"] integerValue];
            
            if ([responseObject[@"code"] integerValue] == 0) {
                self.countsDic = responseObject[@"obj"];
               
            }
            [self.tableView reloadData];
            
        } failure:^(NSError *error) {
            
        }];
    
    
}
- (void)request
{
    
    if ([UserInfoManager isLoading]) {
        [PPNetworkHelper setValue:[UserInfoManager getUserInfo].token forHTTPHeaderField:@"token"];
        [PPNetworkHelper GET:GetInfoMationURL parameters:@{} responseCache:^(id responseCache) {
            
        } success:^(id responseObject) {
            
            if ([responseObject[@"code"] integerValue] == 0) {
                
                self.personDic = responseObject[@"map"];
                if ([responseObject[@"map"][@"nickname"] isEqualToString:@""] && [responseObject[@"map"][@"headimgurl"] isEqualToString:@""]) {
                    _headView = [[HeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150) imageStr:@"" nickName:@"未设置"];
                    _headView.delegate = self;
                    
                    self.tableView.tableHeaderView = _headView;
                } else {
                    _headView = [[HeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150) imageStr:responseObject[@"map"][@"headimgurl"] nickName:responseObject[@"map"][@"nickname"]];
                    _headView.delegate = self;
                    
                    self.tableView.tableHeaderView = _headView;
                }
                
            } else if ([responseObject[@"code"] integerValue] == 9999){
                [UserInfoManager cleanUserInfo];
                
                _headView = [[HeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150) imageStr:@"" nickName:@"登录/注册"];
                _headView.delegate = self;
                
                self.tableView.tableHeaderView = _headView;
            }
           
            
        } failure:^(NSError *error) {
            
        }];
        
        
    } else {
        
        _headView = [[HeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150) imageStr:@"未登录" nickName:@"登录/注册"];
        _headView.delegate = self;
        
        self.tableView.tableHeaderView = _headView;
    }
    
}


#pragma mark -----------HeadViewDelegate-----------
- (void)selectBtnAction:(UIButton *)sender
{
    
    if ([UserInfoManager isLoading]) {
        SetViewController *set = [[SetViewController alloc] init];
        set.setDic = self.personDic;
        set.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:set animated:YES];
    } else {
        NewLoginViewController *login = [[NewLoginViewController alloc] init];
        login.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:login animated:YES];
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    } else if (section == 1){
        return 1;
    } else if (section == 2){
        return 2;
    } else {
        return 3;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            UITableViewCell *cell = [PriceLine tableViewcellFortable:tableView textLab:@"我的订单" imageStr:@""];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
           
        } else {
            PersonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"personCell" forIndexPath:indexPath];
            if (self.numcount == 0) {
                
                if ([self.countsDic[@"p_nopayorder_nums"] integerValue] != 0) {
                    cell.bageone.hidden = NO;
                    cell.bageone.text = [NSString stringWithFormat:@"%ld",[self.countsDic[@"p_nopayorder_nums"] integerValue]];
                } else {
                    cell.bageone.hidden = YES;
                }
                
                
                if ([self.countsDic[@"p_paidorder_nums"] integerValue] != 0) {
                    cell.bagetwo.hidden = NO;
                    cell.bagetwo.text = [NSString stringWithFormat:@"%ld",[self.countsDic[@"p_paidorder_nums"] integerValue]];
                } else {
                    cell.bagetwo.hidden = YES;
                }
                
                
                if ([self.countsDic[@"p_inboundorder_nums"] integerValue] != 0) {
                    cell.bagethree.hidden = NO;
                    cell.bagethree.text = [NSString stringWithFormat:@"%ld",[self.countsDic[@"p_inboundorder_nums"] integerValue]];
                } else {
                    cell.bagethree.hidden = YES;
                }
                
                
                if ([self.countsDic[@"p_evaluateorder_nums"] integerValue] != 0) {
                    cell.bageLabel.hidden = NO;
                    cell.bageLabel.text = [NSString stringWithFormat:@"%ld",[self.countsDic[@"p_evaluateorder_nums"] integerValue]];
                    
                } else {
                    cell.bageLabel.hidden = YES;
                }

            } else if(self.numcount == 9999){
                cell.bageone.hidden = YES;
                cell.bagetwo.hidden = YES;
                cell.bagethree.hidden = YES;
                cell.bageLabel.hidden = YES;
            }
            
            
            
            cell.buttonBlock =^(NSInteger index){
                  OrderViewController *order = [OrderViewController new];
                    order.begTypes = 1;
                
                switch (index) {
                    case 100:
                    {
                  
                        order.indexStats = 1;
                        
                    }
                        break;
                    case 101:
                    {
                        order.indexStats = 2;
                    }
                        break;
                    case 102:
                    {
                        order.indexStats = 3;
                    }
                        break;
                    case 103:
                    {
                        order.indexStats = 4;
                    }
                        break;
                        
                    default:
                        break;
                }
                order.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:order animated:YES];
                
            };
            return cell;
        }

    } else if (indexPath.section == 1){
       
        UITableViewCell *cell = [PriceLine tableViewcellFortable:tableView textLab:@"我的拼团" imageStr:@"我的拼团"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    } else if (indexPath.section == 2){
        UITableViewCell *cell = [PriceLine tableViewcellFortable:tableView textLab:self.arr1 imageArr:self.imageArr1 indexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    
    } else {
        UITableViewCell *cell = [PriceLine tableViewcellFortable:tableView textLab:self.arr2 imageArr:self.imageArr2 indexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 10);
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            return 60;
        } else {
            return 44;
        }
    } else {
        return 44;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            OrderViewController *order = [[OrderViewController alloc] init];
            order.indexStats = 0;
            order.begTypes = 1;
            order.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:order animated:YES];
        }
    } else if(indexPath.section == 1){
        TotalGroupViewController *group = [TotalGroupViewController new];
        group.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:group animated:YES];
    } else if (indexPath.section == 2){
        
        if (indexPath.row == 0) {
            //我的圈子
            MyFriendViewController *friend = [MyFriendViewController new];
            friend.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:friend animated:YES];
        } else {
            //礼品卡
            PresentViewController *present = [PresentViewController new];
            present.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:present animated:YES];
        }
        
    } else {
        if (indexPath.row == 0) {
            //地址
            AddressViewController *add = [AddressViewController new];
            add.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:add animated:YES];
        } else if (indexPath.row == 1){
            //安全设置
            SafeSetViewController *safe = [[SafeSetViewController alloc] init];
            safe.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:safe animated:YES];
        } else if(indexPath.row == 2){
            //我的评论
            PingLunViewController *ping = [PingLunViewController new];
            ping.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:ping animated:YES];
        }
    }
}



@end
