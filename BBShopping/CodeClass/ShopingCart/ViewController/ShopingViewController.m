//
//  ShopingViewController.m
//  BBShopping
//
//  Created by mibo02 on 17/3/14.
//  Copyright © 2017年 mibo02. All rights reserved.
//
#import "JieSuanViewController.h"
#import "ShopingViewController.h"
#import "ShoppingCell.h"
#import "ShoppingCarHeadView.h"
#import "ShoppingModel.h"
#import "ShoppingHeaderModel.h"
#import "ShoppingCarBottomView.h"
#import "ShoppingCarBottomModel.h"
#import <MJExtension.h>
@interface ShopingViewController ()<UITableViewDelegate,UITableViewDataSource,ShoppingCellDelegate,ShoppingCarHeaderViewDelegate,ShoppingCarBottomViewDelegate,UIScrollViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *carLists;
@property (nonatomic, strong)ShoppingCarBottomView *bottomView;
/**
 *  数据模型数组
 */
@property(nonatomic,strong) NSMutableArray * modelArrs;
/**
 *  组数据模型
 */
@property(nonatomic,strong) NSMutableArray * groupArrs;


/**
 *  全选所有商品按钮
 */
@property(nonatomic,weak)UIButton * allselectBt;

@property(nonatomic,strong) ShoppingCarBottomModel * bottomModel;
@property(nonatomic,strong) ShoppingModel *cartModel;
/**
 *  全选按钮
 */
@property(nonatomic,assign)BOOL isallSel;
/**
 *  是否结算
 */
@property(nonatomic,assign)BOOL isSettle;

@property(nonatomic,assign) CGFloat allPrice;

@property (nonatomic, strong)NSMutableArray *selecedArray;
@end

@implementation ShopingViewController
- (NSMutableArray *)selecedArray
{
    if (!_selecedArray) {
        self.selecedArray = [NSMutableArray new];
    }
    return _selecedArray;
}

- (NSMutableArray *)modelArrs
{
    if (!_modelArrs) {
        self.modelArrs = [NSMutableArray new];
    }
    return _modelArrs;
}
- (NSMutableArray *)groupArrs
{
    if (!_groupArrs) {
        self.groupArrs = [NSMutableArray new];
    }
    return _groupArrs;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
     self.bottomModel = [[ShoppingCarBottomModel alloc]init];
     self.bottomModel.isSelect = YES;
    [self requestForShop];
    
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"购物车";
   
}
//获取用户购物车列表
- (void)requestForShop
{
    [self.groupArrs removeAllObjects];
    [self.modelArrs removeAllObjects];
    [self showProgressHUD];
    [PPNetworkHelper setValue:[UserInfoManager getUserInfo].token forHTTPHeaderField:@"token"];
   
    [PPNetworkHelper GET:getShoppingCartUrl parameters:@{} success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            
            
            
            _carLists = responseObject[@"obj"];
           
            
            for (NSDictionary *dict in _carLists) {
                NSMutableArray *modelArr = [ShoppingModel mj_objectArrayWithKeyValuesArray:dict[@"goodsCarts"]];
                
                for (ShoppingModel *model in modelArr) {
                    model.isSelect = YES;
                }
                
                [self.modelArrs addObject:modelArr];
            }
            
            self.groupArrs = [ShoppingHeaderModel mj_objectArrayWithKeyValuesArray:_carLists];
            for (ShoppingHeaderModel *model in self.groupArrs) {
                model.isSelect = YES;
            }
            
            //计算总价格
            [self imputedAllPrice];
            
        }
        
        [self.tableView reloadData];
        [self hideProgressHUD];
    } failure:^(NSError *error) {
        
    }];
    
    
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return self.modelArrs.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_modelArrs[section] count];
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ShoppingCell *cell = [ShoppingCell cellWithTableView:tableView];
    if (self.modelArrs.count != 0) {
       cell.model = self.modelArrs[indexPath.section][indexPath.row];
    }
    
    cell.delegate = self;
    
    return cell;
    
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 120;
}
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    [self imputedAllPrice];
    
    CGRect frame = CGRectMake(0, 0,self.view.frame.size.width, 40);
    ShoppingHeaderModel * headModel;
    if (self.groupArrs.count != 0) {
        headModel =  self.groupArrs[section];
    }
    
    ShoppingCarHeadView * headView = [[ShoppingCarHeadView alloc]initWithFrame:frame WithSection:section HeadModel:headModel];
    
    if ([_modelArrs[section] count] == 0) {
        //删除
        [self.modelArrs removeObject:self.modelArrs[section]];
        [headView removeFromSuperview];
       
        return nil;
    } else {
        headView.delegate = self;
        
        return headView;
    }
    
}
- (void) setupBottomView{
    
    UIButton * bt = [[UIButton alloc]init];
    self.allselectBt = bt;
    _bottomView = [[ShoppingCarBottomView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height- 99, self.view.frame.size.width, 50) With:self.bottomModel];
    _bottomView.delegate = self;
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomView];
   // [self imputedAllPrice];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
   
    if ([_modelArrs[section] count] == 0) {
        return 0;
    } else {
        return 30;
    }
}

/**
 *  cell的代理方法
 *
 *  @param cell     cell可以拿到indexpath
 *  @param selectBt 选中按钮
 */
- (void)shoppingCellDelegate:(ShoppingCell *)cell WithSelectButton:(UIButton *)selectBt
{
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    ShoppingModel * model = self.modelArrs[indexPath.section][indexPath.row];
    NSArray * arr = self.modelArrs[indexPath.section];
    model.isSelect = !selectBt.selected;
    int counts = 0;
    for (ShoppingModel * modelArr in arr)
    {
        if(modelArr.isSelect)
        {
            counts ++ ;
        }
    }
    ShoppingHeaderModel * headerModel = self.groupArrs[indexPath.section];
    if(counts == arr.count)
    {
        headerModel.isSelect = YES;
    }else
    {
        headerModel.isSelect = NO;
        self.allselectBt.selected = NO;
    }
    [self isallSelectAllPrice];
   
    [self.tableView reloadData];
}
//删除代理方法
- (void)shoppingCellDelegate:(ShoppingCell *)cell WithDeleteButton:(UIButton *)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ShoppingModel *model = self.modelArrs[indexPath.section][indexPath.row];

    //请求
    [PPNetworkHelper GET:[NSString stringWithFormat:@"%@?store_user_id=%ld&store_id=%ld&goods_id=%ld&sku_id=%ld",DelegatecartShop,[model storeUserId],[model storeId],[model goodsId],[model skuId]] parameters:@{} success:^(id responseObject) {
        
        [self.modelArrs[indexPath.section] removeObject:model];
        
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationFade)];
        
        //便利得到是否全选
        [self isallSelectAllPrice];
        
        if (model.isSelect) {
            [self.selecedArray removeObject:model];
            model.isSelect = NO;
        }
        
        //这时候选中的为0
        [self imputedAllPrice];
       
        [self.tableView reloadData];
        
       
    } failure:^(NSError *error) {
        
    }];

}
/**
 *  cell的代理方法
 *
 *  @param cell    cell可以拿到indexpath
 *  @param countBt 加减按钮
 */
- (void)shoppingCellDelegateForGoodsCount:(ShoppingCell *)cell WithCountButton:(UIButton *)countBt
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ShoppingModel *model = self.modelArrs[indexPath.section][indexPath.row];
    //判断是加号还是减号按钮   addbt的tag值是1
    if(countBt.tag == 101)
    {
        
        model.buycount = model.buycount + 1;
        
    }else
    {
        if (model.buycount == 1) {
            return;
        } else {
            model.buycount = model.buycount - 1;
        }
        
    }
    
    [self.tableView reloadData];
}

- (void)shoppingCarHeaderViewDelegat:(UIButton *)bt WithHeadView:(ShoppingCarHeadView *)view
{
    
    bt.selected = !bt.selected;
    NSInteger indexpath = bt.tag - 1000;
    ShoppingHeaderModel *headModel = self.groupArrs[indexpath];
    NSArray *allSelectArr = self.modelArrs[indexpath];
    if(bt.selected)
    {
        for (ShoppingModel * model in allSelectArr)
        {
            model.isSelect = YES;
            headModel.isSelect = YES;
        }
    }else
    {
        for (ShoppingModel * model in allSelectArr)
        {
            model.isSelect = NO;
            headModel.isSelect = NO;
        }
    }
    [self isallSelectAllPrice];
    [self.tableView reloadData];
}
/**
 *  footer 全选和取消
 */
- (void)shoppingcarBottomViewDelegate:(UIButton *)allselBt
{
    if (allselBt.tag == 650) {

    allselBt.selected = ! allselBt.selected;
    self.bottomModel.isSelect = allselBt.selected;
    if(allselBt.selected)
    {
        self.isallSel = YES;
    }else
    {
        self.isallSel = NO;
    }
    //逻辑
    if (self.isallSel)
    {
        for (NSArray * arr in self.modelArrs)
        {
            for (ShoppingModel * model in arr)
            {
                model.isSelect = YES;
            }
        }
        for (ShoppingHeaderModel *headModel in self.groupArrs)
        {
            headModel.isSelect = YES;
        }
    }else
    {
        for (NSArray * arr in self.modelArrs)
        {
            for (ShoppingModel * model in arr)
            {
                model.isSelect = NO;
            }
        }
        for (ShoppingHeaderModel *headModel in self.groupArrs)
        {
            headModel.isSelect = NO;
        }
    }
    
    [self.tableView reloadData];
    } else {
        
        if (self.selecedArray.count == 0) {
            [MBProgressHUD showError:@"未选中"];
        } else {
            //进入结算
            JieSuanViewController *jiesuan = [JieSuanViewController new];
            jiesuan.hidesBottomBarWhenPushed = YES;
            jiesuan.shopingNumbersign = 1;
            jiesuan.orderShopArray = self.selecedArray;
            
            
            [self.navigationController pushViewController:jiesuan animated:YES];
            
        }
        
       
    }
}

/**
 *  遍历所有是否全选
 */
- (void)isallSelectAllPrice
{
    for (NSArray * arr in self.modelArrs)
    {
        for (ShoppingModel * model in arr)
        {
            if (!model.isSelect)
            {
                self.bottomModel.isSelect = NO;
                return;
            }else
            {
                self.bottomModel.isSelect = YES;
            }
        }
    }
}

/**
 *  计算总价
 */
- (void)imputedAllPrice
{
    [self.selecedArray removeAllObjects];
    
    NSLog(@"开始计算总价");
    CGFloat allprice = 0;
    NSInteger allCount = 0;
   
    for (NSArray * goodsArr in self.modelArrs)
    {
        for (ShoppingModel * goodsModel in goodsArr)
        {
            
            if(goodsModel.isSelect == YES)
            {
                CGFloat price = goodsModel.buycount * goodsModel.groupBuyPrice;
                NSInteger count = goodsModel.buycount;
                allCount = count + allCount;
                allprice = price + allprice;
                [self.selecedArray addObject:goodsModel];
            }
        }
    }
    
    NSString * priceText = [NSString stringWithFormat:@"合计:¥%.2f",allprice];
    self.bottomModel.priceText = priceText;
    self.bottomModel.counts = allCount;
   
    //计算完成总价格之后在进行创建
    [self setupBottomView];
   
}

//去掉UItableview headerview黏性(sticky)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
   
    [[SDImageCache sharedImageCache]clearMemory];

    CGFloat sectionHeaderHeight = 40;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
    
}

//返回单张图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"购物车-空"];
}
- (nullable NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
    [dic setValue:[UIFont systemFontOfSize:15] forKey:NSFontAttributeName];
    return [[NSAttributedString alloc] initWithString:@"购物车空空如也，快去挑选商品吧~" attributes:dic];
}
//按钮
- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:[ColorString colorWithHexString:@"#f9cd02"] forKey:NSForegroundColorAttributeName];
    [dic setValue:[UIFont systemFontOfSize:20] forKey:NSFontAttributeName];
    return [[NSAttributedString alloc] initWithString:@"去逛逛" attributes:dic];
}
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"homeVC" object:nil];
}




@end
