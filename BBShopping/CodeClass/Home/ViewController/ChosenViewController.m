//
//  ChosenViewController.m
//  BBShopping
//
//  Created by mibo02 on 17/1/21.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "ChosenViewController.h"
#import "ChosenCell.h"
#import "ChosenModel.h"
#import "DetailViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
// 弹出分享菜单需要导入的头文件
#import <ShareSDKUI/ShareSDK+SSUI.h>
// 自定义分享菜单栏需要导入的头文件
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>

#import <ShareSDKUI/SSUIEditorViewStyle.h>
#import "NewLoginViewController.h"
@interface ChosenViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SDCycleScrollViewDelegate>{
    UIButton *backTop;
    UIButton *shopButton;
}
@property (nonatomic, strong)SDCycleScrollView *sdc;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong)NSMutableArray *arr;
@property (nonatomic, strong)NSMutableArray *bannerArray;

@end

@implementation ChosenViewController
- (NSMutableArray *)bannerArray
{
    if (!_bannerArray) {
        self.bannerArray = [NSMutableArray new];
    }
    return _bannerArray;
}
- (NSMutableArray *)arr
{
    if (!_arr) {
        self.arr = [NSMutableArray new];
    }
    return _arr;
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
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
 //   NSLog(@"%ld",index);
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
    if (self.bannerArray.count != 0) {
        imageArray = @[self.bannerArray[0]];
    } else {
        imageArray = @[@"AppIcon"];
    }
   
    
    // （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    [shareParams SSDKSetupShareParamsByText:@"邦邦购，安心食品购买平台"
                                     images:imageArray
                                        url:[NSURL URLWithString:wechaturl]
                                      title:self.model.name
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
    self.title = self.model.name;
   self.navigationItem.rightBarButtonItem = [UIBarButtonItem CreateItemWithTarget:self ForAction:@selector(shareaction) WithImage:@"分享" WithHighlightImage:nil bageLab:@"" ishide:YES];
    [self createbuttonforbacktopAndshopingchart];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ChosenCell" bundle:nil] forCellWithReuseIdentifier:@"ChosenCell"];
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
        [self.arr removeAllObjects];
        [self.collectionView.mj_header beginRefreshing];
        [self request];
        
        [self.collectionView.mj_header endRefreshing];
    }];
    
}
- (void)request
{
    
    [self showProgressHUD];
    [PPNetworkHelper GET:[NSString stringWithFormat:@"%@%ld",ChosenShopURL,self.model.appUrlId] parameters:@{} responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        
        for (NSDictionary *bannerdic in responseObject[@"map"][@"bannerList"]) {
            [self.bannerArray addObject:bannerdic[@"url"]];
        }
        
        for (NSDictionary *dic in responseObject[@"map"][@"goodsList"]) {
            ChosenModel *model  = [ChosenModel new];
            [model setValuesForKeysWithDictionary:dic];
            [self.arr addObject:model];
        }
        [self hideProgressHUD];
        [self.collectionView reloadData];
    } failure:^(NSError *error) {
        
    }];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ChosenCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ChosenCell" forIndexPath:indexPath];
    cell.model = _arr[indexPath.item];
    cell.priceBtn.tag = 100 + indexPath.item;
    [cell.priceBtn addTarget:self action:@selector(btnaction:) forControlEvents:(UIControlEventTouchUpInside)];
    return cell;
}
//加入购物车动画需要的图片
- (void )addanimationImageStr:(NSString *)imgstr
{
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 50, SCREEN_HEIGHT/2 - 50, 100, 100)];
    [imageV sd_setImageWithURL:[NSURL URLWithString:imgstr]];
    [self.view addSubview:imageV];
    //添加动画
    [imageV animationStartPoint:imageV.center endPoint:shopButton.center didStopAnimation:^{
        [imageV removeFromSuperview];
    }];
}
- (void)btnaction:(UIButton *)sender
{
    [self addanimationImageStr:[self.arr[sender.tag - 100] goodsUrl]];
    
    [ShopAddRequest requestForShop:[self.arr[sender.tag - 100] goodsId] buycount:@"1" enterperson:^{
        NewLoginViewController *login = [NewLoginViewController new];
        login.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:login animated:YES];
    }];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (isiPhone5or5sor5c) {
        return CGSizeMake(320 - 6, 230);
    } else {
       return CGSizeMake(SCREEN_WIDTH - 6, 245);
    }
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(3, 3, 3, 3);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detail = [DetailViewController new];
    detail.detailID = [self.arr[indexPath.item] goodsId];
    [self.navigationController pushViewController:detail animated:YES];
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
    
    self.sdc  = [SDCycleScrollView cycleScrollViewWithFrame:reusView.frame imageURLStringsGroup:_bannerArray];
    
    self.sdc.delegate = self;
    [reusView addSubview:_sdc];
    return reusView;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (isiPhone5or5sor5c) {
        return CGSizeMake(320, 200);
    } else {
        return CGSizeMake(SCREEN_WIDTH, 200);
    }
    
}


@end
