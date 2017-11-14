//
//  SecondViewController.m
//  BBShopping
//
//  Created by mibo02 on 17/3/19.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "SecondViewController.h"
#import "MyGroupModel.h"
#import "OrderAllCell.h"
#import "waitheaderView.h"
#import "waitFooterView.h"
#import "wuliuViewController.h"
@interface SecondViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, assign)NSInteger StratPage;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)MJRefreshBackNormalFooter *mj;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation SecondViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.StratPage = 1;
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"OrderAllCell" bundle:nil] forCellWithReuseIdentifier:@"first"];
   
    [self request:1];
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
        
        [self RefreshForCollection:responseObject];
        [self.collectionView reloadData];
        [self hideProgressHUD];
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
            [self request:1];
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
   
        UICollectionReusableView *headV = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
        waitheaderView *view = [[waitheaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        view.backgroundColor = [UIColor whiteColor];
        
        MyGroupModel *model = self.dataArray[indexPath.section];
        view.storelab.text = model.salesOutlets;
        view.rightlab.hidden = YES;
    
        view.imageV.image = [UIImage imageNamed:@""];
    
        [headV addSubview:view];
        
        return headV;
    
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

@end
