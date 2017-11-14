//
//  NewShopViewController.m
//  BBShopping
//
//  Created by mibo02 on 17/1/21.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "NewShopViewController.h"
#import "NewShopModel.h"
#import "NewShopCell.h"
#import "DetailViewController.h"
#import "WebViewViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
// 弹出分享菜单需要导入的头文件
#import <ShareSDKUI/ShareSDK+SSUI.h>
// 自定义分享菜单栏需要导入的头文件
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import "NewLoginViewController.h"
#import <ShareSDKUI/SSUIEditorViewStyle.h>
@interface NewShopViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SDCycleScrollViewDelegate,UIScrollViewDelegate>{
    UIButton *backTop;
    UIButton *shopButton;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong)SDCycleScrollView *sdc;
//轮播图
@property (nonatomic, strong)NSMutableArray *bannerArr;
@property (nonatomic, strong)NSMutableArray *hotListArr;

@property (nonatomic, strong)NSMutableArray *urlArr;

@end

@implementation NewShopViewController
- (NSMutableArray *)urlArr
{
    if (!_urlArr) {
        self.urlArr = [NSMutableArray new];
    }
    return _urlArr;
}
- (NSMutableArray *)bannerArr
{
    if (!_bannerArr) {
        self.bannerArr = [NSMutableArray new];
    }
    return _bannerArr;
}
- (NSMutableArray *)hotListArr
{
    if (!_hotListArr) {
        self.hotListArr = [NSMutableArray new];
    }
    return _hotListArr;
}
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if (![[self.urlArr[index] reqUrl] isEqualToString:@""]){
        WebViewViewController *web = [[WebViewViewController alloc] init];
        web.url = [self.urlArr[index] reqUrl];
        [self.navigationController pushViewController:web animated:YES];
    }
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
    [shopButton removeFromSuperview];
}
- (void)shareaction
{
    
    NSString *wechaturl = @"https://itunes.apple.com/cn/app/%E9%82%A6%E9%82%A6%E8%B4%AD/id1217331895?mt=8";
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray *imageArray;
    if (self.bannerArr.count != 0) {
        imageArray = @[self.bannerArr[0]];
    } else {
        imageArray = @[@"AppIcon"];
    }
    
    // （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    [shareParams SSDKSetupShareParamsByText:@"邦邦购，安心食品购买平台"
                                     images:imageArray
                                        url:[NSURL URLWithString:wechaturl]
                                      title:self.title
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
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem CreateItemWithTarget:self ForAction:@selector(shareaction) WithImage:@"分享" WithHighlightImage:nil bageLab:@"" ishide:YES];
    [self createbuttonforbacktopAndshopingchart];
    [self.collectionView registerNib:[UINib nibWithNibName:@"NewShopCell" bundle:nil] forCellWithReuseIdentifier:@"newCell"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self request];
}

- (void)createbuttonforbacktopAndshopingchart
{
    backTop = [SuspendHelper backToTopButtonCreate];
    backTop.alpha = 0.0;
    [backTop addTarget:self action:@selector(backToTopBtn) forControlEvents:(UIControlEventTouchUpInside)];
    shopButton = [SuspendHelper shoppingButtonCreate];
    [shopButton addTarget:self action:@selector(shopButton) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)backToTopBtn
{
    [self.collectionView setContentOffset:CGPointMake(0, 0)];
}

- (void)shopButton
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shopVC" object:nil];
}
- (void)RefreshiForHeader
{
    
    self.collectionView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.bannerArr removeAllObjects];
        [self.hotListArr removeAllObjects];
        [self.collectionView.mj_header beginRefreshing];
        [self request];
        
        [self.collectionView.mj_header endRefreshing];
    }];
    
}
- (void)request {
    [self showProgressHUD];
    [PPNetworkHelper GET:[NSString stringWithFormat:@"%@%ld",NewShopURL,(long)self.model.appUrlId] parameters:@{} responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
     
        if ([responseObject[@"code"] integerValue] == 0) {
            self.title = responseObject[@"map"][@"collectionView"][@"title"];
            
            for (NSDictionary *dic in responseObject[@"map"][@"collectionView"][@"collectionBannerList"]) {
                NewShopModel *model = [NewShopModel new];
                [model setValuesForKeysWithDictionary:dic];
                [self.bannerArr addObject:model.url];
                [self.urlArr addObject:model];
            }
            //
            for (NSDictionary *dic in responseObject[@"map"][@"collectionView"][@"collectionGoodsViewList"]) {
                NewShopModel *model = [NewShopModel new];
                [model setValuesForKeysWithDictionary:dic];
                [self.hotListArr addObject:model];
            }
            
        }
        [self hideProgressHUD];
        [self.collectionView reloadData];
        
        
    } failure:^(NSError *error) {
        
    }];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.hotListArr.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NewShopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"newCell" forIndexPath:indexPath];
    cell.model = self.hotListArr[indexPath.item];
    cell.shopBtn.tag = 100 + indexPath.item;
    [cell.shopBtn addTarget:self action:@selector(shopbtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    return cell;
}
//加入购物车动画需要的图片
- (void )addanimationImageStr:(NSString *)imgstr
{
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(50, SCREEN_HEIGHT/2 - 50, 100, 100)];
    [imageV sd_setImageWithURL:[NSURL URLWithString:imgstr]];
    [self.view addSubview:imageV];
    //添加动画
    [imageV animationStartPoint:imageV.center endPoint:shopButton.center didStopAnimation:^{
        [imageV removeFromSuperview];
    }];
}
//加入购物车按钮
- (void)shopbtnAction:(UIButton *)sender
{
    [self addanimationImageStr:[self.hotListArr[sender.tag - 100] goodsUrl]];
    
    [ShopAddRequest requestForShop:[self.hotListArr[sender.tag - 100] goodsId] buycount:@"1"  enterperson:^{
        NewLoginViewController *login = [NewLoginViewController new];
        login.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:login animated:YES];
    }];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (isiPhone5or5sor5c) {
        return CGSizeMake(314, 120);
    } else {
    return CGSizeMake(SCREEN_WIDTH - 6, 150);
    }
    
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(3, 3, 3, 3);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
    
    self.sdc  = [SDCycleScrollView cycleScrollViewWithFrame:reusView.frame imageURLStringsGroup:_bannerArr];
   
    self.sdc.delegate = self;
    [reusView addSubview:_sdc];
    return reusView;

}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (isiPhone5or5sor5c) {
        return CGSizeMake(320, 150);
    } else{
    return CGSizeMake(SCREEN_WIDTH, 200);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detail = [DetailViewController new];
    detail.detailID = [self.hotListArr[indexPath.item] goodsId];
    [self.navigationController pushViewController:detail animated:YES];
}


@end
