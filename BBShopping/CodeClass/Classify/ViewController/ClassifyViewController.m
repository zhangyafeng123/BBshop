//
//  ClassifyViewController.m
//  BBShopping
//
//  Created by mibo02 on 17/1/16.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "ClassifyViewController.h"
#import "ClassifyCell.h"
#import "SearchViewController.h"
#import "ClassSortModel.h"
#import "ClassifyDetailViewController.h"
@interface ClassifyViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>{
    UIButton *backTop;
    
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong)NSMutableArray *dataArray;
@end

@implementation ClassifyViewController

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [[SDImageCache sharedImageCache]clearMemory];
    
    if (scrollView.contentOffset.y> SCREEN_HEIGHT) {
        backTop.alpha = 1.0;
    } else {
        backTop.alpha = 0.0;
    }
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray new];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    [_collectionView registerNib:[UINib nibWithNibName:@"ClassifyCell" bundle:nil] forCellWithReuseIdentifier:@"classCell"];
     [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self request];
    [self RefreshiForHeader];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //当页面将要出现的时候创建
    [self createBackTopBtnAndShopBtn];
}
- (void)createBackTopBtnAndShopBtn
{
    backTop = [SuspendHelper backToTopButtonCreate];
    backTop.alpha = 0.0;
    [backTop addTarget:self action:@selector(backToTopBtn) forControlEvents:(UIControlEventTouchUpInside)];
    
}
- (void)backToTopBtn
{
    [_collectionView setContentOffset:CGPointMake(0, 0)];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [backTop removeFromSuperview];
}
- (void)RefreshiForHeader
{
    
    self.collectionView.mj_header  = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        [self.dataArray removeAllObjects];
        [self.collectionView.mj_header beginRefreshing];
        [self request];
        
        [self.collectionView.mj_header endRefreshing];
    }];
    
}
- (void)request
{
    [self showProgressHUD];
    [PPNetworkHelper GET:SortURL parameters:@{} responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            for (NSDictionary *dic in responseObject[@"map"][@"categoryViews"]) {
                ClassSortModel *model = [ClassSortModel new];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArray addObject:model];
            }
        }
        [self.collectionView reloadData];
        [self hideProgressHUD];
    } failure:^(NSError *error) {
        
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ClassifyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"classCell" forIndexPath:indexPath];
    if (self.dataArray.count != 0) {
         cell.model = self.dataArray[indexPath.row];
    }
   
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
     UICollectionReusableView *reusView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    
    //将搜索按钮添加到sdc上
    UIButton *searchBtn = [SuspendHelper searchButtonCreate:[ColorString colorWithHexString:@"#eeeeee"]];
   
    [searchBtn addTarget:self action:@selector(searchBtnAction) forControlEvents:(UIControlEventTouchUpInside)];
    [reusView addSubview:searchBtn];

    return reusView;
}

- (void)searchBtnAction
{
    //进入搜索界面
    SearchViewController *search = [SearchViewController new];
    search.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:search animated:YES];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(SCREEN_WIDTH, 60);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(3, 3, 3, 3);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (isiPhone5or5sor5c) {
        return CGSizeMake(311 / 2, 100);
    } else {
        return CGSizeMake((SCREEN_WIDTH - 9) / 2, 124);
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ClassifyDetailViewController *detail = [ClassifyDetailViewController new];
    detail.hidesBottomBarWhenPushed = YES;
    
    detail.newtypeid = 3;
    detail.sortModel = self.dataArray[indexPath.item];
    
    
    [self.navigationController pushViewController:detail animated:YES];
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
