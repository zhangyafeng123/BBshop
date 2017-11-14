//
//  OrderViewController.m
//  BBShopping
//
//  Created by mibo02 on 17/1/17.
//  Copyright © 2017年 mibo02. All rights reserved.
//
#import "waitshouhuoCell.h"
#import "waitheaderView.h"
#import "waitFooterView.h"
#import "OrderViewController.h"
#import "orderAllModel.h"
#import "ZhifuFangShiViewController.h"
#import "OrderDetailViewController.h"
#import "wuliuViewController.h"
#import "ShouHouViewController.h"
#import "PingjiaViewController.h"
#import "fenxiaoView.h"
#import "PresentQueRenZhiFuViewController.h"
@interface OrderViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,UITextFieldDelegate>
@property (nonatomic, assign)NSInteger StratPage;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)MJRefreshBackStateFooter *mj;
@property (nonatomic, strong)waitFooterView *footV;
//是否禁用键盘弹起
@property (nonatomic, assign)BOOL wasKeyboardManagerEnabled;
//输入的内容
@property (nonatomic, copy)NSString *contentStr;

@end

@implementation OrderViewController
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

//禁用键盘弹起
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _wasKeyboardManagerEnabled = [[IQKeyboardManager sharedManager] isEnabled];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    
    [self.dataArray removeAllObjects];
    
    self.StratPage = 1;
    if (self.begTypes == 1) {
        if (self.indexStats == 0) {
            self.title = @"我的订单";
        } else if (self.indexStats == 1){
            self.title = @"待付款";
        } else if (self.indexStats == 2){
            self.title = @"待发货";
        } else if (self.indexStats == 3){
            self.title = @"待收货";
        } else {
            self.title = @"待评价";
        }
    } else if(self.begTypes == 4){
        self.title = @"分销订单";
    }
    
    //刚开始不进入搜索状态
    [self request:@""];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:_wasKeyboardManagerEnabled];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    
    self.StratPage = 1;
    if (self.begTypes == 1) {
        if (self.indexStats == 0) {
            self.title = @"我的订单";
        } else if (self.indexStats == 1){
            self.title = @"待付款";
        } else if (self.indexStats == 2){
            self.title = @"待发货";
        } else if (self.indexStats == 3){
            self.title = @"待收货";
        } else {
            self.title = @"待评价";
        }
    } else if(self.begTypes == 4){
        self.title = @"分销订单";
    }
  
    [self.tableView registerNib:[UINib nibWithNibName:@"waitshouhuoCell" bundle:nil] forCellReuseIdentifier:@"waitcell"];
    
   
}

- (void)createHead
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 60)];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake(40, 10, SCREEN_WIDTH - 80, 40)];
    textfield.backgroundColor = [UIColor whiteColor];
    textfield.borderStyle = UITextBorderStyleRoundedRect;
    textfield.delegate = self;
    textfield.placeholder = @"搜索订单";
    textfield.clearButtonMode = UITextFieldViewModeAlways;
    textfield.returnKeyType = UIReturnKeySearch;
    textfield.clearsOnBeginEditing = YES;
    
    [view addSubview:textfield];
    self.tableView.tableHeaderView = view;
}

- (void)RefreshForCollection:(id)responseObject
{
    //判断是否是最后一页
    if ([responseObject[@"map"][@"page"][@"pages"] integerValue] > self.StratPage) {
        
        self.StratPage += 1;
       
        //进入下拉加载
        _mj = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
            [self.tableView.mj_footer beginRefreshing];
           
            if (self.contentStr.length > 0) {
                [self request:self.contentStr];
            } else {
                [self request:@""];
            }
            
            [self.tableView.mj_footer endRefreshing];
        }];
        self.tableView.mj_footer = _mj;
        
    } else {
        self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
     
    }
}
- (void)request:(NSString *)textStr
{

    [self showProgressHUD];
    NSString *url;
    if (textStr.length > 0) {
       
       url = [[NSString stringWithFormat:@"%@?begType=%ld&orderStatus=%ld&conditions=%@&start=%ld",orderListURL,self.begTypes,(long)self.indexStats,textStr,self.StratPage]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
   
    } else {
        
        url = [NSString stringWithFormat:@"%@?begType=%ld&orderStatus=%ld&start=%ld",orderListURL,self.begTypes,(long)self.indexStats,self.StratPage];
    }
    
    [PPNetworkHelper GET:url parameters:@{} success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            for (NSDictionary *dic in responseObject[@"map"][@"page"][@"list"]) {
                orderAllModel *model = [orderAllModel new];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArray addObject:model];
            }
            if (self.dataArray == 0) {
                [self.tableView reloadEmptyDataSet];
            }
        }
       
        [self hideProgressHUD];
        [self.tableView reloadData];
        [self createHead];
        
        //上拉刷新
        [self RefreshForCollection:responseObject];
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if (textField.text.length == 0) {
        [MBProgressHUD showError:@"内容不能为空"];
    } else {
        
        [self.dataArray removeAllObjects];
        NSLog(@"我是输入内容：%@",textField.text);
        self.contentStr = textField.text;
        [self request:textField.text];
    }
    return YES;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *arr = [self.dataArray[section] listArray];
    
    return arr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    waitshouhuoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"waitcell" forIndexPath:indexPath];
  
    NSMutableArray *arr = [self.dataArray[indexPath.section] listArray];
        
    cell.model = arr[indexPath.row];
   
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.begTypes == 4) {
        return 50;
    } else {
        return 90;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
        waitheaderView *view = [[waitheaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        view.backgroundColor = [UIColor whiteColor];
        view.imageV.hidden = YES;
        orderAllModel *model = self.dataArray[section];
        view.storelab.text = model.salesOutlets;
        if (model.orderStatus == 1) {
            view.rightlab.text = @"待付款";
        } else if (model.orderStatus == 2){
            view.rightlab.text = @"待发货";
        } else if (model.orderStatus == 3){
            view.rightlab.text = @"待签收";
        } else if(model.orderStatus == 4){
            view.rightlab.text = @"交易完成";
        } else if(model.orderStatus == 5){
            view.rightlab.text = @"已取消";
        } else {
            view.rightlab.text = @"已退款";
        }
        
        return view;
   
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    orderAllModel *model = self.dataArray[section];
    
    if (self.begTypes == 4) {
        fenxiaoView *view = [[[NSBundle mainBundle] loadNibNamed:@"fenxiaoView" owner:nil options:nil] firstObject];
        view.fenxiaoLab.text =  [NSString stringWithFormat:@"共%ld件商品 合计:¥%.2f(含运费¥%.2f)",(long)model.logisticsType,model.totalPrice,model.postage];
        return view;
    } else {
    self.footV = [[[NSBundle mainBundle] loadNibNamed:@"waitFooterView" owner:nil options:nil] firstObject];
    
    self.footV.lab.text = [NSString stringWithFormat:@"共%ld件商品 合计:¥%.2f(含运费¥%.2f)",(long)model.logisticsType,model.totalPrice,model.postage];
    if (model.orderStatus == 1) {
        self.footV.firstbutton.hidden = YES;
        self.footV.secondbutton.hidden = NO;
        self.footV.thridbutton.hidden = NO;
        [ButtonBorderColorManager setbuttonNormalbordercolor:self.footV.secondbutton buttontitle:@"取消订单"];
        [ButtonBorderColorManager setbuttonbordercolor:self.footV.thridbutton btntitle:@"去支付"];
    } else if (model.orderStatus == 2){
      
        self.footV.firstbutton.hidden = YES;
        self.footV.secondbutton.hidden = YES;
        self.footV.thridbutton.hidden = YES;
        
    } else if (model.orderStatus == 3){
        
        //判断是否可以申请售后
        for (orderSubModel *submodel in model.listArray) {
            NSInteger i = submodel.isApplyAfterSale;
            //未申请
            if (i == 0) {
               self.footV.firstbutton.hidden = NO;
            } else {
                self.footV.firstbutton.hidden = YES;
            }
        }
        
        
        self.footV.secondbutton.hidden = NO;
        self.footV.thridbutton.hidden = NO;
        [ButtonBorderColorManager setbuttonNormalbordercolor:self.footV.firstbutton buttontitle:@"申请售后"];
        [ButtonBorderColorManager setbuttonNormalbordercolor:self.footV.secondbutton buttontitle:@"查看物流"];
        [ButtonBorderColorManager setbuttonbordercolor:self.footV.thridbutton btntitle:@"确认收货"];
    } else if(model.orderStatus == 4){
        //判断是否可以申请售后
        for (orderSubModel *submodel in model.listArray) {
            NSInteger i = submodel.isApplyAfterSale;
            //未申请
            if (i == 0) {
                self.footV.firstbutton.hidden = NO;
            } else {
                self.footV.firstbutton.hidden = YES;
            }
        }
        self.footV.secondbutton.hidden = NO;
        self.footV.thridbutton.hidden = NO;
        [ButtonBorderColorManager setbuttonNormalbordercolor:self.footV.firstbutton buttontitle:@"申请售后"];
        [ButtonBorderColorManager setbuttonNormalbordercolor:self.footV.secondbutton buttontitle:@"查看物流"];
        if (model.israte) {
            [self.footV.thridbutton setTitle:@"已评价" forState:(UIControlStateNormal)];
        } else {
            [ButtonBorderColorManager setbuttonbordercolor:self.footV.thridbutton btntitle:@"去评价"];
        }
    } else if(model.orderStatus == 5){
        self.footV.firstbutton.hidden = YES;
        self.footV.secondbutton.hidden = NO;
        self.footV.thridbutton.hidden = NO;
         [ButtonBorderColorManager setbuttonNormalbordercolor:self.footV.secondbutton buttontitle:@"删除订单"];
        [self.footV.thridbutton setTitle:@"已取消" forState:(UIControlStateNormal)];
    } else {
        self.footV.firstbutton.hidden = YES;
        self.footV.secondbutton.hidden = YES;
        self.footV.thridbutton.hidden = NO;
        [self.footV.thridbutton setTitle:@"已退款" forState:(UIControlStateNormal)];
    }
    self.footV.firstbutton.tag = 100 + section;
    self.footV.secondbutton.tag  = 500 + section;
    self.footV.thridbutton.tag = 1000 +section;
    [self.footV.firstbutton addTarget:self action:@selector(firstbuttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.footV.secondbutton addTarget:self action:@selector(secondbuttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.footV.thridbutton addTarget:self action:@selector(thridbuttonaction:) forControlEvents:(UIControlEventTouchUpInside)];
    return self.footV;
    }
    
}
//申请售后按钮
- (void)firstbuttonAction:(UIButton *)sender
{
    orderAllModel *model = self.dataArray[sender.tag - 100];
    
    OrderDetailViewController *detail  = [OrderDetailViewController new];
    
    detail.orderStatusNew =  model.orderStatus;
    
    detail.orderId = model.id;
    
    detail.canshenqingArr = model.listArray;
    
    [self.navigationController pushViewController:detail animated:YES];
}
- (void)secondbuttonAction:(UIButton *)sender
{
     orderAllModel *model = self.dataArray[sender.tag - 500];
    
    if ([sender.titleLabel.text isEqualToString:@"取消订单"]) {
        [self showProgressHUD];
        [PPNetworkHelper GET:[NSString stringWithFormat:@"%@?orderId=%ld&status=5",setOrderInfoOrderStatusURl,model.id] parameters:@{} success:^(id responseObject) {
            
            if ([responseObject[@"code"] integerValue] == 0) {
                [MBProgressHUD showError:@"取消订单成功"];
                [self.dataArray removeObject:model];
                [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sender.tag - 500] withRowAnimation:(UITableViewRowAnimationFade)];
                [self.tableView reloadData];
            }
            [self hideProgressHUD];
        } failure:^(NSError *error) {
            
        }];
        
    } else if([sender.titleLabel.text isEqualToString:@"查看物流"]){
    //查看物流
    wuliuViewController *wuliu  = [wuliuViewController new];
    wuliu.orderId = model.id;
    [self.navigationController pushViewController:wuliu animated:YES];
    } else {
        //删除订单
        [PPNetworkHelper GET:[NSString stringWithFormat:@"%@?orderId=%ld&isRemove=1",setOrderInfoOrderStatusURl,model.id] parameters:@{} success:^(id responseObject) {
            
            if ([responseObject[@"code"] integerValue] == 0) {
                [MBProgressHUD showError:@"删除订单成功"];
                [self.dataArray removeObject:model];
                [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sender.tag - 500] withRowAnimation:(UITableViewRowAnimationFade)];
                [self.tableView reloadData];
            }
            [self hideProgressHUD];
        } failure:^(NSError *error) {
            
        }];
    }
}
- (void)thridbuttonaction:(UIButton *)sender
{
    orderAllModel *model = self.dataArray[sender.tag - 1000];
    
    if ([sender.titleLabel.text isEqualToString:@"去支付"]) {
       
        if (model.realPayment *100 == 0) {
            PresentQueRenZhiFuViewController *present = [PresentQueRenZhiFuViewController new];
            present.presentDic = @{@"serialNumber":model.orderno,@"giftCardPrice":@(model.totalPrice)};
            [self.navigationController pushViewController:present animated:YES];
            
        } else {
            ZhifuFangShiViewController *zhifu  = [ZhifuFangShiViewController new];
            
            NSDictionary *orderdic = @{@"serialNumber":model.orderno,@"totalFee":@(model.realPayment)};
            zhifu.weixinDic = orderdic;
            [self.navigationController pushViewController:zhifu animated:YES];
        }
        
        
    }  else if ([sender.titleLabel.text isEqualToString:@"去评价"]){
        PingjiaViewController *pingjia = [PingjiaViewController new];
        pingjia.dataArray = model.listArray;
        [self.navigationController pushViewController:pingjia animated:YES];
    } else if ([sender.titleLabel.text isEqualToString:@"确认收货"]){
         orderAllModel *model = self.dataArray[sender.tag - 1000];
        [PPNetworkHelper GET:[NSString stringWithFormat:@"%@?orderId=%ld&status=4",setOrderInfoOrderStatusURl,model.id] parameters:@{} success:^(id responseObject) {
            
            if ([responseObject[@"code"] integerValue] == 0) {
                 [MBProgressHUD showError:@"已确认收货"];
                [sender setTitle:@"去评价" forState:(UIControlStateNormal)];
            }
            
        } failure:^(NSError *error) {
            
        }];
    }
}

//返回标题
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text;
    if ([UserInfoManager isLoading]) {
        
        if (self.indexStats == 0) {
            text = @"无订单";
        } else if (self.indexStats == 1){
            text = @"无待付款订单";
        } else if (self.indexStats == 2){
            text = @"无待发货订单";
        } else if (self.indexStats == 3){
            text = @"无待收货订单";
        } else {
            text = @"无待评价订单";
        }
    } else {
        text = @"未登录";
    }
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
    if ([UserInfoManager isLoading]) {
        
        if (self.indexStats == 0) {
            return [UIImage imageNamed:@"无订单"];
        } else if (self.indexStats == 1){
            return [UIImage imageNamed:@"无待付款"];
        } else if (self.indexStats == 2){
            return [UIImage imageNamed:@"无待发货"];
        } else if (self.indexStats == 3){
            return [UIImage imageNamed:@"无待收货"];
        } else {
           return [UIImage imageNamed:@"无待评价"];
        }
    } else {
        return nil;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    orderAllModel *model = self.dataArray[indexPath.section];
    OrderDetailViewController *detail  = [OrderDetailViewController new];
    detail.orderStatusNew =  model.orderStatus;
    detail.orderId = model.id;
    [self.navigationController pushViewController:detail animated:YES];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView)
    {
        
        UITableView *tableview = (UITableView *)scrollView;
        CGFloat sectionHeaderHeight = 50;
        CGFloat sectionFooterHeight;
        if (self.begTypes == 4) {
           sectionFooterHeight = 50;
        } else {
            sectionFooterHeight = 100;
        }
        
        CGFloat offsetY = tableview.contentOffset.y;
      
        if (offsetY >= 0 && offsetY <= sectionHeaderHeight)
        {
            tableview.contentInset = UIEdgeInsetsMake(-offsetY, 0, -sectionFooterHeight, 0);
        }else if (offsetY >= sectionHeaderHeight && offsetY <= tableview.contentSize.height - tableview.frame.size.height - sectionFooterHeight)
        {
            tableview.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, -sectionFooterHeight, 0);
        }else if (offsetY >= tableview.contentSize.height - tableview.frame.size.height - sectionFooterHeight && offsetY <= tableview.contentSize.height - tableview.frame.size.height)
        {
            tableview.contentInset = UIEdgeInsetsMake(-offsetY, 0, -(tableview.contentSize.height - tableview.frame.size.height - sectionFooterHeight), 0);
        }
        
    }
}


@end
