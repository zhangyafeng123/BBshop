//
//  HomeViewController.m
//  BBShopping
//
//  Created by mibo02 on 17/1/16.
//  Copyright © 2017年 mibo02. All rights reserved.
//
#import "ExampleViewController.h"
#import "HomeViewController.h"
#import "ChosenViewController.h"
#import "NewShopViewController.h"
#import "SecondCell.h"
#import "ThridCell.h"
#import "HomeModel.h"
#import "FooterView.h"
#import "HomeFirstCell.h"
#import "AdsCell.h"
#import "LastCell.h"
#import "SearchViewController.h"
#import "HomepageViewController.h"
#import "YearView.h"
#import "DetailViewController.h"
#import "ShiJieView.h"
#import "ClassifyDetailViewController.h"
#import "DetailViewController.h"
#import "WebViewViewController.h"
#import "ListMessageViewController.h"
#import "GroupDetailViewController.h"
#import "TimeDetailViewController.h"
#import "ChosenViewController.h"
#import "NewShopViewController.h"
#import "ClassifyDetailViewController.h"
#import "NewLoginViewController.h"
@interface HomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SDCycleScrollViewDelegate,ThridCellbuyBtnDelegate,HomeFirstCellDelegate,UIScrollViewDelegate>
{
    UIButton *backTop;
    
}
@property (nonatomic, strong)NSMutableArray *urlArr;
//hotTitle
@property (nonatomic, strong)NSDictionary *hotDic;
//yearPicture
@property (nonatomic, strong)NSDictionary *yearPic;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong)SDCycleScrollView *sdc;
//轮播图
@property (nonatomic, strong)NSMutableArray *bannerArr;
//导航栏
@property (nonatomic, strong)NSMutableArray *shortArr;
//hotGoodListArr
@property (nonatomic, strong)NSMutableArray *hotListArr;
//storeyDataList
@property (nonatomic, strong)NSMutableArray *storeyArray;
//楼层modelArr
@property (nonatomic, strong)NSMutableArray *NameArray;
@property (nonatomic, strong)NSMutableArray *subtitleArr;
//广告
@property (nonatomic, strong)NSMutableArray *adsArray;
//更多
@property (nonatomic, strong)NSMutableArray *moreArray;
//goodsList
@property (nonatomic, strong)NSMutableArray *goodsListArr;
//分区
@property (nonatomic, strong)NSMutableArray *sectionArr;

//NavView
@property (nonatomic, strong)UIView *NaView;

@end

@implementation HomeViewController
- (NSMutableArray *)urlArr
{
    if (!_urlArr) {
        self.urlArr = [NSMutableArray new];
    }
    return _urlArr;
}
- (NSMutableArray *)sectionArr
{
    if (!_sectionArr) {
        self.sectionArr = [NSMutableArray new];
    }
    return _sectionArr;
}
- (NSMutableArray *)goodsListArr
{
    if (!_goodsListArr) {
        self.goodsListArr = [NSMutableArray new];
    }
    return _goodsListArr;
}
- (NSMutableArray *)subtitleArr
{
    if (!_subtitleArr) {
        self.subtitleArr = [NSMutableArray new];
    }
    return _subtitleArr;
}
- (NSMutableArray *)NameArray
{
    if (!_NameArray) {
        self.NameArray = [NSMutableArray new];
    }
    return _NameArray;
}
- (NSMutableArray *)adsArray
{
    if (!_adsArray) {
        self.adsArray = [NSMutableArray new];
    }
    return _adsArray;
}
- (NSMutableArray *)moreArray
{
    if (!_moreArray) {
        _moreArray = [NSMutableArray new];
    }
    return _moreArray;
}
- (NSMutableArray *)storeyArray
{
    if (!_storeyArray) {
        self.storeyArray = [NSMutableArray new];
    }
    return _storeyArray;
}

- (NSMutableArray *)hotListArr
{
    if (!_hotListArr) {
        self.hotListArr = [NSMutableArray new];
    }
    return _hotListArr;
}
- (NSMutableArray *)shortArr
{
    if (!_shortArr) {
        self.shortArr = [NSMutableArray new];
    }
    return _shortArr;
}
- (NSMutableArray *)bannerArr
{
    if (!_bannerArr) {
        self.bannerArr = [NSMutableArray new];
    }
    return _bannerArr;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [[SDImageCache sharedImageCache]clearMemory];
    
    if (scrollView.contentOffset.y> SCREEN_HEIGHT) {
        backTop.alpha = 1.0;
    } else {
        backTop.alpha = 0.0;
    }
}

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    [self homeBannerActionsVC:index];
}
//点击广告图
- (void)getindexforadsurl:(NSInteger)index
{
    switch ([self.adsArray[index] appUrlType]) {
        case 0:
        {
            [MBProgressHUD showError:@"无链接"];
            return;
        }
            break;
        case 1:
        {
            if ([[_adsArray[index] appAdUrl] isEqualToString:@""]) {
                [MBProgressHUD showError:@"无链接"];
                return;
            } else {
                WebViewViewController *web = [WebViewViewController new];
                
                web.url = [self.adsArray[index] appAdUrl];
                web.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:web animated:YES];
            }
        }
            break;
        case 2:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"group" object:nil];
        }
            break;
        case 3:
        {
            ExampleViewController *examp = [ExampleViewController new];
            examp.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:examp animated:YES];
        }
            break;
        case 4:
        {
            NewShopViewController *new  = [[NewShopViewController alloc] init];
            new.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:new animated:YES];
        }
            break;
        case 5:
        {
            ChosenViewController *chose  = [ChosenViewController new];
            chose.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:chose animated:YES];
        }
            break;
        case 6:
        {
            DetailViewController *detail = [DetailViewController new];
            detail.detailID = [self.adsArray[index] appUrlId];
            detail.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detail animated:YES];
        }
            break;
        case 7:
        {
            TimeDetailViewController *time = [TimeDetailViewController new];
            time.timeID = [self.adsArray[index] appUrlId];
            time.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:time animated:YES];
        }
            break;
        case 8:
        {
            GroupDetailViewController *group = [GroupDetailViewController new];
            group.classid = [self.adsArray[index] appUrlId];
            group.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:group animated:YES];
        }
            break;
        default:
            break;
    }

}
- (void)homeBannerActionsVC:(NSInteger)index
{
    /* 1:外部链接 ，此时图片的链接地址调用appAdUrl：APP链接地址
     0:无链接
     2:团购，此时图片的链接到团购
     3:秒杀，此时图片的链接到秒杀
     4:新品上市，此时图片的链接到新品上市
     5:精选好货，此时图片的链接到精选好货
     6:商品详情，此时图片的链接到普通商品详情
     7:秒杀详情，此时图片的链接到秒杀商品详情
     8:团购详情，此时图片的链接到团购商品详情
     */
    
    switch ([self.urlArr[index] appUrlType]) {
        case 0:
        {
            [MBProgressHUD showError:@"无链接"];
            return;
        }
            break;
        case 1:
        {
            if ([[_urlArr[index] appAdUrl] isEqualToString:@""]) {
                 [MBProgressHUD showError:@"无链接"];
                return;
            } else {
            WebViewViewController *web = [WebViewViewController new];
            
            web.url = [self.urlArr[index] appAdUrl];
            web.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:web animated:YES];
            }
        }
            break;
        case 2:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"group" object:nil];
        }
            break;
        case 3:
        {
            HomepageViewController *examp = [HomepageViewController new];
            examp.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:examp animated:YES];
        }
            break;
        case 4:
        {
            NewShopViewController *new  = [[NewShopViewController alloc] init];
            new.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:new animated:YES];
        }
            break;
        case 5:
        {
            ChosenViewController *chose  = [ChosenViewController new];
            chose.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:chose animated:YES];
        }
            break;
        case 6:
        {
            DetailViewController *detail = [DetailViewController new];
            detail.detailID = [self.urlArr[index] appUrlId];
            detail.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detail animated:YES];
        }
            break;
        case 7:
        {
            TimeDetailViewController *time = [TimeDetailViewController new];
            time.timeID = [self.urlArr[index] appUrlId];
            time.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:time animated:YES];
        }
            break;
        case 8:
        {
            GroupDetailViewController *group = [GroupDetailViewController new];
            group.classid = [self.urlArr[index] appUrlId];
            group.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:group animated:YES];
        }
            break;
        default:
            break;
    }
}

//创建搜索View
- (void)createNavView
{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem CreateItemWithTarget:self ForAction:@selector(MessageAction) WithImage:@"消息" WithHighlightImage:nil bageLab:@"" ishide:YES];
    self.NaView = [[UIView alloc] initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH - 70, 35)];
    _NaView.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar addSubview:_NaView];
    //显示在最上层
    [self.navigationController.navigationBar bringSubviewToFront:_NaView];
    //设置导航栏的样式
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    //将搜索按钮添加到sdc上
    UIButton *searchBtn = [SuspendHelper searchHomeCreate:[ColorString colorWithHexString:@"#eeeeee"]];
    [searchBtn addTarget:self action:@selector(searchBtnAction) forControlEvents:(UIControlEventTouchUpInside)];
    [_NaView addSubview:searchBtn];

}
- (void)searchBtnAction
{
    //进入搜索界面
    SearchViewController *search = [SearchViewController new];
    search.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:search animated:YES];
}
//通知界面
- (void)MessageAction
{
    ListMessageViewController *list = [ListMessageViewController new];
    list.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:list animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    
    //进入消息的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterMessageAction) name:@"homeMessage" object:nil];
    //当页面将要出现的时候创建
    [self createBackTopBtnAndShopBtn];
    //创建Na
    [self createNavView];
    [self request];
    
    [_collectionView registerClass:[HomeFirstCell class] forCellWithReuseIdentifier:@"firstCell"];
    [_collectionView registerNib:[UINib nibWithNibName:@"SecondCell" bundle:nil] forCellWithReuseIdentifier:@"SecondCell"];
    [_collectionView registerNib:[UINib nibWithNibName:@"ThridCell" bundle:nil] forCellWithReuseIdentifier:@"ThridCell"];
    [_collectionView registerNib:[UINib nibWithNibName:@"AdsCell" bundle:nil] forCellWithReuseIdentifier:@"adsCell"];
    [_collectionView registerNib:[UINib nibWithNibName:@"LastCell" bundle:nil] forCellWithReuseIdentifier:@"LastCell"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [_collectionView registerNib:[UINib nibWithNibName:@"FooterView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    [_collectionView registerNib:[UINib nibWithNibName:@"YearView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Year"];
     [_collectionView registerNib:[UINib nibWithNibName:@"ShiJieView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"shijie"];
    [self RefreshiForHeader];
   
}
//通知进入消息页面
- (void)enterMessageAction
{
    ListMessageViewController *message  =[ListMessageViewController new];
    message.hidesBottomBarWhenPushed = YES;
    //message.typeMessages = 1;
    [self.navigationController pushViewController:message animated:YES];
    //可以在这里做区分，物流还是消息还是其他
   
    
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)RefreshiForHeader
{
    
    self.collectionView.mj_header  = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        [self.bannerArr removeAllObjects];
        [self.shortArr removeAllObjects];
        [self.hotListArr removeAllObjects];
        [self.storeyArray removeAllObjects];
        [self.moreArray removeAllObjects];
        [self.adsArray removeAllObjects];
        [self.NameArray removeAllObjects];
        [self.subtitleArr removeAllObjects];
        [self.goodsListArr removeAllObjects];
        [self.sectionArr removeAllObjects];
        [self.collectionView.mj_header beginRefreshing];
        [self request];
        
        [self.collectionView.mj_header endRefreshing];
    }];
    
}
- (void)request {
    
    //显示菊花
    [self showProgressHUD];
    [PPNetworkHelper GET:HomeURL parameters:@{} responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 0) {
            //banner
            for (NSDictionary *dic in responseObject[@"map"][@"indexView"][@"bannerList"]) {
                HomeModel *model = [HomeModel new];
                [model setValuesForKeysWithDictionary:dic];
                [self.bannerArr addObject:model.adpic];
                [self.urlArr addObject:model];
            }
            //shortAdList
            for (NSDictionary *dic in responseObject[@"map"][@"indexView"][@"shortAdList"]) {
                HomeModel *model = [HomeModel new];
                [model setValuesForKeysWithDictionary:dic];
                [self.shortArr addObject:model];
            }
            //hottitle
            _hotDic  = responseObject[@"map"][@"indexView"][@"hotTitle"];
            
            //picYear
            if ([responseObject[@"map"][@"indexView"][@"longAdList"] count] != 0) {
                _yearPic = responseObject[@"map"][@"indexView"][@"longAdList"][0];
            }
            //hotGoodLists
            for (NSDictionary *dic in responseObject[@"map"][@"indexView"][@"hotGoodsList"]) {
                HomeModel *model = [HomeModel new];
                [model setValuesForKeysWithDictionary:dic];
                [self.hotListArr addObject:model];
            }
            //storeyDataList
            
            for (NSDictionary *dic in responseObject[@"map"][@"indexView"][@"storeyDataList"]) {
                //广告图片
                HomeModel *model = [HomeModel new];
                [model setValuesForKeysWithDictionary:dic];
                [self.moreArray addObject:model.morePic];
                //分区头
                [self.NameArray addObject:model.storeyName];
                [self.subtitleArr addObject:model.subTitle];
                //分区个数
                [self.sectionArr addObject:model];
                if ([dic[@"detailList"] count] != 0) {
                    for (NSDictionary *dic1 in dic[@"detailList"]) {
                        HomeModel *model = [HomeModel new];
                        [model setValuesForKeysWithDictionary:dic1];
                        [self.adsArray addObject:model];
                    }
                } else {
                    [self.adsArray addObject:@""];
                }
            
            }
           
        }
        //隐藏菊花
        [self hideProgressHUD];
        [_collectionView reloadData];
    } failure:^(NSError *error) {
        
    }];
   
}

- (void)createBackTopBtnAndShopBtn
{
    backTop = [SuspendHelper backToTopButtonCreate];
    [backTop addTarget:self action:@selector(backToTopBtn) forControlEvents:(UIControlEventTouchUpInside)];
    
}
- (void)backToTopBtn
{
    [_collectionView setContentOffset:CGPointMake(0, 0)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.NaView.hidden = NO;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.NaView.hidden = YES ;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    backTop.hidden = NO;
  
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    backTop.hidden = YES;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2 + _sectionArr.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    if (section == 0) {
        return 1;
    } else if (section == 1){
        return _hotListArr.count;
    } else{
        NSMutableArray *arr = [self.sectionArr[section - 2] GoodsListArray];
        return arr.count + 2;
    }
   
}
- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    if (indexPath.section == 0) {
        static NSString *identify = @"firstCell";
        HomeFirstCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        cell.delegate = self;
        [cell collectviewCellForArray:_shortArr];
        return cell;
    } else if (indexPath.section == 1){
        SecondCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SecondCell" forIndexPath:indexPath];
        cell.buyBtn.tag = indexPath.item;
        [cell.buyBtn addTarget:self action:@selector(SecondBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        cell.model = _hotListArr[indexPath.item];
        
        return cell;
    } else {
        
        NSMutableArray *arr = [self.sectionArr[indexPath.section - 2] GoodsListArray];
        
        //广告图Cell
        if (indexPath.row == 0) {
            AdsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"adsCell" forIndexPath:indexPath];
            [cell.imageadsV  sd_setImageWithURL:[NSURL URLWithString:[_adsArray[indexPath.section - 2] adpic]]];
         
            return cell;
        } else if(indexPath.row == arr.count + 1){
        //点击更多
            LastCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LastCell" forIndexPath:indexPath];
            [cell.lastImage sd_setImageWithURL:[NSURL URLWithString:self.moreArray[indexPath.section - 2]]];
            return cell;
        } else {
            //中间的
            SubModel *submodel  = arr[indexPath.row - 1];
            ThridCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"ThridCell" forIndexPath:indexPath];
            cell.delegate = self;
            cell.model = submodel;
            
            return cell;
        }
    }
}
//第一个分区点击事件
- (void)tapClickAction:(NSInteger)number
{
    HomeModel *modelnew = self.shortArr[number];
    if (modelnew.appUrlType == 3) {
        //进入秒杀
        HomepageViewController *time = [HomepageViewController new];
        time.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:time animated:YES];
    } else if (modelnew.appUrlType == 4){
        //新品上市
        NewShopViewController *new = [NewShopViewController new];
        new.model = modelnew;
        new.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:new animated:YES];
    } else if (modelnew.appUrlType == 5){
        ChosenViewController *chosen = [ChosenViewController new];
        chosen.hidesBottomBarWhenPushed = YES;
        chosen.model = modelnew;
        [self.navigationController pushViewController:chosen animated:YES];

    }

}
//加入购物车动画需要的图片
- (void )addanimationImageStr:(NSString *)imgstr
{
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 50, SCREEN_HEIGHT/2 - 50, 100, 100)];
    [imageV sd_setImageWithURL:[NSURL URLWithString:imgstr]];
    [self.view addSubview:imageV];
    //添加动画
    [imageV animationStartPoint:imageV.center endPoint:CGPointMake(300, SCREEN_HEIGHT) didStopAnimation:^{
        [imageV removeFromSuperview];
    }];
}
//第二个分区购买点击事件
- (void)SecondBtnAction:(UIButton *)sender
{
    
    HomeModel *model = _hotListArr[sender.tag];
    //调用
    [self addanimationImageStr:model.adpic];
    //将其加入购物车
    [ShopAddRequest requestForShop:model.id buycount:@"1"  enterperson:^{
        NewLoginViewController *login = [NewLoginViewController new];
        login.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:login animated:YES];
    }];
    
    
}
//第三个分区代理方法
- (void)buyBtnAction:(ThridCell *)cell
{
    
    NSIndexPath *indexpath = [self.collectionView indexPathForCell:cell];
    NSMutableArray *arr = [self.sectionArr[indexpath.section - 2] GoodsListArray];
    SubModel *model  = arr[indexpath.row - 1];
    
    [self addanimationImageStr:model.goodsUrl];
    
    [ShopAddRequest requestForShop:model.id buycount:@"1"  enterperson:^{
        NewLoginViewController *login = [NewLoginViewController new];
        login.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:login animated:YES];
    }];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (isiPhone5or5sor5c) {
            return CGSizeMake(320, 80);
        } else {
            return CGSizeMake(SCREEN_WIDTH, 100);
        }
        
    } else if (indexPath.section == 1){
        if (isiPhone5or5sor5c) {
            return CGSizeMake(320 - 6, 230);
        } else {
            return CGSizeMake(SCREEN_WIDTH - 6, 295);
        }
    } else {
      NSMutableArray *arr = [self.sectionArr[indexPath.section - 2] GoodsListArray];
        if (indexPath.row == 0) {
            if (isiPhone5or5sor5c) {
                return CGSizeMake(320 - 6, 150);
            } else {
                return CGSizeMake(SCREEN_WIDTH - 6, 200);
            }
    
        } else if(indexPath.row == arr.count + 1) {
            if (isiPhone5or5sor5c) {
                return CGSizeMake(311 / 2 + 3, 240);
            } else {
                return CGSizeMake((SCREEN_WIDTH - 9) / 2 + 1.5, 270);
            }
        }else {
            if (isiPhone5or5sor5c) {
                return CGSizeMake(311 / 2, 240);
            } else {
                return CGSizeMake((SCREEN_WIDTH - 9) / 2, 270);
            }
        }
        
    }
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(3, 3, 3, 3);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (indexPath.section == 0) {
            UICollectionReusableView *reusView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
            self.sdc  = [SDCycleScrollView cycleScrollViewWithFrame:reusView.frame imageURLStringsGroup:_bannerArr];
            
            self.sdc.delegate = self;
            [reusView addSubview:_sdc];
            return reusView;
        } else {
            return nil;
        }

    } else {
      
        
        if (indexPath.section == 0) {
            
            if (_yearPic) {
                YearView *yearV = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Year" forIndexPath:indexPath];
                yearV.yearLab.text = _hotDic[@"name"];
                
                [yearV.YearImage sd_setImageWithURL:[NSURL URLWithString:_yearPic[@"adpic"]]];
                
                return yearV;
            } else {
                ShiJieView *shi = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"shijie" forIndexPath:indexPath];
                shi.shijieLab.text = _hotDic[@"name"];
                return shi;
            }
            
            
        } else {
            
            FooterView *footview = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"footer" forIndexPath:indexPath];
            //判断是不是最后一个
            if (indexPath.section == self.NameArray.count + 1) {
          
                return nil;
            } else {
                footview.firstLab.text = _NameArray[indexPath.section - 1];
                footview.firstLab.font = H20;
                footview.bottomLab.text = _subtitleArr[indexPath.section - 1];
                
            }
             return footview;
        }
        
        
        return nil;
       
    }

}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        if (isiPhone5or5sor5c) {
            return CGSizeMake(320, 150);
        } else {
        return CGSizeMake(SCREEN_WIDTH, 200);
        }
    } else {
        return CGSizeMake(SCREEN_WIDTH, 0);
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (section == _NameArray.count  + 1) {
        return CGSizeZero;
    } else {
        if (section == 0) {
            if (_yearPic) {
               return CGSizeMake(SCREEN_WIDTH, 220);
            } else {
                return CGSizeMake(SCREEN_WIDTH, 50);
            }
            
        } else {
            return CGSizeMake(SCREEN_WIDTH, 100);
        }
    }
    
}

//点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detail = [DetailViewController new];
    detail.hidesBottomBarWhenPushed = YES;
    
    if (indexPath.section == 1){
       
       HomeModel *model =  _hotListArr[indexPath.item];
        detail.detailID = model.id;
        [self.navigationController pushViewController:detail animated:YES];
    } else {
        
        NSMutableArray *arr = [self.sectionArr[indexPath.section - 2] GoodsListArray];
        HomeModel *model = self.sectionArr[indexPath.section - 2];
        
        //广告图Cell
        if (indexPath.row == 0) {
            
            [self getindexforadsurl:indexPath.section - 2];

            if (self.adsArray[indexPath.section - 2]) {
                
            }
            
        } else if(indexPath.row == arr.count + 1){
            //点击更多
            ClassifyDetailViewController *classDetail = [ClassifyDetailViewController new];
            //标识
            classDetail.newtypeid = 1;
            classDetail.homeMoreindex = model.id;
            classDetail.adsTitle = model.storeyName;
            classDetail.hidesBottomBarWhenPushed = YES;
            
            
            [self.navigationController pushViewController:classDetail animated:YES];
            
        } else {
            //中间的
            SubModel *submodel  = arr[indexPath.row - 1];
            detail.detailID = submodel.id;
            [self.navigationController pushViewController:detail animated:YES];
        }
    }
}

@end
