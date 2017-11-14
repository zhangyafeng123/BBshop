//
//  ThreeViewController.m
//  BBShopping
//
//  Created by mibo02 on 17/3/19.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "ThreeViewController.h"
#import "MyGroupModel.h"
#import "OrderAllCell.h"
#import "waitheaderView.h"
#import "waitFooterView.h"
#import "wuliuViewController.h"
@interface ThreeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, assign)NSInteger StratPage;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)MJRefreshBackNormalFooter *mj;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ThreeViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray new];
    }
    return _dataArray;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.dataArray removeAllObjects];
    [self request:2];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.StratPage = 1;
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"OrderAllCell" bundle:nil] forCellWithReuseIdentifier:@"first"];
    
}
- (void)request:(NSInteger)number
{
    [self showProgressHUD];
    [PPNetworkHelper setValue:[UserInfoManager getUserInfo].token forHTTPHeaderField:@"token"];
    
    [PPNetworkHelper GET:[NSString stringWithFormat:@"%@?status=%ld&pageNum=%ld",myGrouponListURl,number,self.StratPage] parameters:@{} success:^(id responseObject) {
        for (NSDictionary *dic in responseObject[@"map"][@"grouponList"][@"list"]) {
            MyGroupModel *model = [MyGroupModel new];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataArray addObject:model];
        }
        
        [self hideProgressHUD];
        [self.collectionView reloadData];
        [self RefreshForCollection:responseObject];
    } failure:^(NSError *error) {
        
    }];
}
- (void)RefreshForCollection:(id)responseObject
{
    //判断是否是最后一页
    if ([responseObject[@"map"][@"grouponList"][@"lastPage"] integerValue] > self.StratPage) {
        
        self.StratPage += 1;
        //进入下拉加载
        _mj = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self.collectionView.mj_footer beginRefreshing];
            [self request:2];
            [self.collectionView.mj_footer endRefreshing];
        }];
        self.collectionView.mj_footer = _mj;
        
    } else {
        
        [_mj endRefreshingWithNoMoreData];
    }
}





- (NSInteger )numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataArray.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSMutableArray *arr = [self.dataArray[section] groupArray];
    return arr.count;
    
}

- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    OrderAllCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"first" forIndexPath:indexPath];
    NSMutableArray *arr = [self.dataArray[indexPath.section] groupArray];
    
    cell.groupmodel = arr[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (isiPhone5or5sor5c) {
        return CGSizeMake(320, 100);
    } else {
        return CGSizeMake(SCREEN_WIDTH, 100);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (isiPhone5or5sor5c) {
        return CGSizeMake(320, 100);
    } else {
        return CGSizeMake(SCREEN_WIDTH, 100);
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (isiPhone5or5sor5c) {
        return CGSizeMake(320, 50);
    } else {
        return CGSizeMake(SCREEN_WIDTH, 50);
    }
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *headV = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
        waitheaderView *view = [[waitheaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        view.backgroundColor = [UIColor whiteColor];
        
        MyGroupModel *model = self.dataArray[indexPath.section];
        view.storelab.text = model.salesOutlets;
        view.rightlab.hidden = YES;
        //拼团成功
        if (model.grouponStatus == 2) {
            view.imageV.image = [UIImage imageNamed:@"groupsuccess"];
        } else {
            //拼团失败或者进行中的。
            view.imageV.image = [UIImage imageNamed:@"groupfile"];
        }
        [headV addSubview:view];
        
        return headV;
    } else {
        UICollectionReusableView *footV = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"footer" forIndexPath:indexPath];
        waitFooterView *view = [[[NSBundle mainBundle] loadNibNamed:@"waitFooterView" owner:nil options:nil] firstObject];
        if (isiPhone5or5sor5c) {
            view.frame = CGRectMake(0, 0, 320, 100);
        } else {
            view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 100);
        }
        MyGroupModel *model = self.dataArray[indexPath.section];
        view.lab.text = [NSString stringWithFormat:@"共1件商品 合计:¥%.2f(含运费¥%.2f)",model.totalPrice,model.postage];
        if (model.orderStatus == 1) {
            view.firstbutton.hidden = YES;
            view.secondbutton.hidden = NO;
            view.thridbutton.hidden = NO;
            
            [ButtonBorderColorManager setbuttonNormalbordercolor:view.secondbutton buttontitle:@"查看物流"];
            [ButtonBorderColorManager setbuttonbordercolor:view.thridbutton btntitle:@"确认收货"];
        } else if (model.orderStatus == 2){
            
            view.firstbutton.hidden = YES;
            view.secondbutton.hidden = NO;
            view.thridbutton.hidden = NO;
            
            [ButtonBorderColorManager setbuttonNormalbordercolor:view.secondbutton buttontitle:@"查看物流"];
            if (model.israte) {
                [view.thridbutton setTitle:@"已评价" forState:(UIControlStateNormal)];
            } else {
                [ButtonBorderColorManager setbuttonbordercolor:view.thridbutton btntitle:@"去评价"];
            }
            
        } else if (model.orderStatus == 3){
            view.firstbutton.hidden = YES;
            view.secondbutton.hidden = YES;
            view.thridbutton.hidden = YES;
        }
        
        view.secondbutton.tag  = 500 + indexPath.section;
        view.thridbutton.tag = 1000 +indexPath.section;
        
        [view.secondbutton addTarget:self action:@selector(secondbuttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [view.thridbutton addTarget:self action:@selector(thridbuttonaction:) forControlEvents:(UIControlEventTouchUpInside)];
        [footV addSubview:view];
        return footV;
    }
}

- (void)secondbuttonAction:(UIButton *)sender
{
    MyGroupModel *model = self.dataArray[sender.tag - 500];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"wuliu" object:nil userInfo:@{@"wuliu":model}];
}
- (void)thridbuttonaction:(UIButton *)sender
{
    MyGroupModel *model = self.dataArray[sender.tag - 1000];
    
    if ([sender.titleLabel.text isEqualToString:@"确认收货"]) {
      
        [PPNetworkHelper GET:[NSString stringWithFormat:@"%@?orderId=%ld&status=4",setOrderInfoOrderStatusURl,model.id] parameters:@{} success:^(id responseObject) {
            
            if ([responseObject[@"code"] integerValue] == 0) {
                [MBProgressHUD showError:@"已确认收货"];
                [sender setTitle:@"去评价" forState:(UIControlStateNormal)];
                
            }
            
        } failure:^(NSError *error) {
            
        }];
    } else if ([sender.titleLabel.text isEqualToString:@"去评价"]){
        //进入评价页面
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pingjia" object:nil userInfo:@{@"pingjia":model}];
        
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyGroupModel *model = self.dataArray[indexPath.section];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"grouporder" object:nil userInfo:@{@"model":model}];
}
//返回标题
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text;
    if ([UserInfoManager isLoading]) {
        
        text = @"无订单";
        
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
        
        return [UIImage imageNamed:@"无订单"];
        
    } else {
        return nil;
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
