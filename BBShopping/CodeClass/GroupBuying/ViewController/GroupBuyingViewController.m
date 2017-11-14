//
//  GroupBuyingViewController.m
//  BBShopping
//
//  Created by mibo02 on 17/1/16.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "GroupBuyingViewController.h"
#import "GroupCell.h"
#import "GroupModel.h"
#import "GroupDetailViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
// 弹出分享菜单需要导入的头文件
#import <ShareSDKUI/ShareSDK+SSUI.h>
// 自定义分享菜单栏需要导入的头文件
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>

#import <ShareSDKUI/SSUIEditorViewStyle.h>


@interface GroupBuyingViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource,SDCycleScrollViewDelegate,UIScrollViewDelegate>{
    UIButton *backTop;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong)SDCycleScrollView *sdc;
@property (nonatomic, strong)NSMutableArray *bannerArray;
@property (nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation GroupBuyingViewController
- (NSMutableArray *)bannerArray
{
    if (!_bannerArray) {
        self.bannerArray = [NSMutableArray new];
    }
    return _bannerArray;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray new];
    }
    return _dataArray;
}
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    
}
//滑动时判断
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y> SCREEN_HEIGHT) {
        backTop.alpha = 1.0;
    } else {
        backTop.alpha = 0.0;
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [backTop removeFromSuperview];
  
}
- (void)shareaction
{
    
    NSString *wechaturl = @"https://itunes.apple.com/cn/app/%E9%82%A6%E9%82%A6%E8%B4%AD/id1217331895?mt=8";
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray = @[self.bannerArray[0]];
    
    // （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    [shareParams SSDKSetupShareParamsByText:@"邦邦购，安心食品购买平台"
                                     images:imageArray
                                        url:[NSURL URLWithString:wechaturl]
                                      title:@"超值团购"
                                       type:SSDKContentTypeAuto];
    
    // 设置分享菜单栏样式（非必要）
    
    //设置分享编辑界面状态栏风格
    [SSUIEditorViewStyle setStatusBarStyle:UIStatusBarStyleLightContent];
    //设置简单分享菜单样式
    [SSUIShareActionSheetStyle setShareActionSheetStyle:ShareActionSheetStyleSimple];
    //2、弹出ShareSDK分享菜单
    
    
    //分享
    [ShareSDK showShareActionSheet:self.view
     //将要自定义顺序的平台传入items参数中
                             items:@[@(SSDKPlatformTypeWechat)]
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {}];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem CreateItemWithTarget:self ForAction:@selector(shareaction) WithImage:@"分享" WithHighlightImage:nil bageLab:@"" ishide:YES];
   
    [_collectionView registerNib:[UINib nibWithNibName:@"GroupCell" bundle:nil] forCellWithReuseIdentifier:@"GroupCell"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self request];
    [self RefreshiForHeader];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
     [self createbuttonforbacktopAndshopingchart];
}
- (void)createbuttonforbacktopAndshopingchart
{
    backTop = [SuspendHelper backToTopButtonCreate];
    backTop.alpha = 0.0;
    [backTop addTarget:self action:@selector(backToTopBtn) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)backToTopBtn
{
    [self.collectionView setContentOffset:CGPointMake(0, 0)];
}
- (void)RefreshiForHeader
{
    
    self.collectionView.mj_header  = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        [self.bannerArray removeAllObjects];
        [self.dataArray removeAllObjects];
        [self.collectionView.mj_header beginRefreshing];
        [self request];
        
        [self.collectionView.mj_header endRefreshing];
    }];
    
}
//请求
- (void)request {
    [self showProgressHUD];
    [PPNetworkHelper GET:groupRL parameters:@{} responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        
        if ([responseObject[@"success"] integerValue] == 1) {
            //banner
            for (NSDictionary *dic in responseObject[@"map"][@"bannerList"]) {
                GroupModel *groupmodel = [GroupModel new];
                [groupmodel setValuesForKeysWithDictionary:dic];
                [self.bannerArray addObject:groupmodel.url];
            }
            //
            for (NSDictionary *dic in responseObject[@"map"][@"goodsList"]) {
                GroupModel *model = [GroupModel new];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArray addObject:model];
            }
        }
        [self hideProgressHUD];
        [self.collectionView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GroupCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GroupCell" forIndexPath:indexPath];
    if (self.dataArray.count != 0) {
       cell.model = self.dataArray[indexPath.row];
    }
    cell.buyBtn.tag = indexPath.item + 100;
    [cell.buyBtn addTarget:self action:@selector(actionBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    return cell;
}
- (void)actionBtn:(UIButton *)sender
{
    GroupDetailViewController *group  = [GroupDetailViewController new];
    group.hidesBottomBarWhenPushed = YES;
    group.classid = [self.dataArray[sender.tag - 100] id];
    [self.navigationController pushViewController:group animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (isiPhone5or5sor5c) {
        return CGSizeMake(320, 300);
    } else {
        return CGSizeMake(SCREEN_WIDTH, 320);
    }
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 0, 10, 0);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionReusableView *reusView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    
    self.sdc = [SDCycleScrollView cycleScrollViewWithFrame:reusView.frame imageURLStringsGroup:_bannerArray];
    self.sdc.delegate = self;
    [reusView addSubview:_sdc];
    
    return reusView;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (isiPhone5or5sor5c) {
        return CGSizeMake(320, 150);
    } else {
        return CGSizeMake(SCREEN_WIDTH, 200);
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GroupDetailViewController *group  = [GroupDetailViewController new];
    group.hidesBottomBarWhenPushed = YES;
    group.classid = [self.dataArray[indexPath.item] id];
    [self.navigationController pushViewController:group animated:YES];
}




@end
