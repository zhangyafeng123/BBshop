//
//  ClassifyDetailViewController.m
//  BBShopping
//
//  Created by mibo02 on 17/2/10.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "ClassifyDetailViewController.h"
#import "ThridCell.h"
#import "ClassDetailModel.h"
#import "SearchViewController.h"
#import "ClassifyView.h"
#import "DetailViewController.h"
#import "HomeMoreModel.h"
#import "NewLoginViewController.h"
@interface ClassifyDetailViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ClassifyViewDelegate,ThridCellbuyBtnDelegate,UIScrollViewDelegate>{
    ClassifyView *sortView;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong)NSMutableArray *dataArray;


//开始的页码
@property (nonatomic, assign)NSInteger StratPage;
@property (nonatomic, strong)MJRefreshBackStateFooter *mj;
@end

@implementation ClassifyDetailViewController
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [[SDImageCache sharedImageCache]clearMemory];
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
    self.StratPage = 1;
    [_collectionView registerNib:[UINib nibWithNibName:@"ThridCell" bundle:nil] forCellWithReuseIdentifier:@"ThridCell"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    if (self.newtypeid == 3) {
        //分类进入详情
        self.title = self.sortModel.cateName;
        //刚开始为综合
        [self request:ActionTypeOne];
        
    } else{
        self.title = self.adsTitle;
        //刚开始为综合
        [self requestForHome:ActionTypeOne];
    }
    
    [self RefreshiForHeader];
    
}
//头部刷新只是刷新前十条数据并没有什么改变，数组在刷新的时候要清空.
- (void)RefreshiForHeader
{
    
    self.collectionView.mj_header  = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        [self.dataArray removeAllObjects];
        [self.collectionView.mj_header beginRefreshing];
        self.StratPage = 1;
        if (self.newtypeid == 3) {
            //刚开始为综合
            [self request:ActionTypeOne];
            
        } else {
            [self requestForHome:ActionTypeOne];
        }
        
        [self.collectionView.mj_header endRefreshing];
    }];
  
}
//首页加载更多
- (void)requestForHome:(NumberTypeActions)type
{
    [self showProgressHUD];
    [PPNetworkHelper GET:[NSString stringWithFormat:@"%@?storeyId=%ld&order=%ld&start=%ld",HomeMoreURL,self.homeMoreindex,(long)type,(long)_StratPage] parameters:@{} responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 0) {
            for (NSDictionary *dic in responseObject[@"map"][@"goodsList"][@"list"]) {
                HomeMoreModel *model = [HomeMoreModel new];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArray addObject:model];
            }
            
        }
         [self hideProgressHUD];
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
       
        //上拉刷新
        [self RefreshForCollection:responseObject action:type];
            
    } failure:^(NSError *error) {

    }];
}
- (void)RefreshForCollection:(id)responseObject  action:(NumberTypeActions)action
{
    //判断是否是最后一页
    if ([responseObject[@"map"][@"goodsList"][@"pages"] integerValue] > self.StratPage) {
        
        self.StratPage += 1;
        //进入下拉加载
        _mj = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
            [self.collectionView.mj_footer beginRefreshing];
            if (self.newtypeid == 3) {
                 [self request:action];
                
            } else {
               [self requestForHome:action];
            }
            
            [self.collectionView.mj_footer endRefreshing];
        }];
        self.collectionView.mj_footer = _mj;
        
    } else {
        
        self.collectionView.mj_footer.state  = MJRefreshStateNoMoreData;
       // [_mj endRefreshingWithNoMoreData];
    }
}
//分类进入详情
- (void)request:(NumberTypeActions)type
{
    NSString *url= [NSString stringWithFormat:@"%@?order=%ld&cateId=%ld&start=%ld",SortDetailURl,(long)type,self.sortModel.id,(long)self.StratPage];
    
    [self showProgressHUD];
    [PPNetworkHelper GET:url parameters:@{} responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            for (NSDictionary *dic in responseObject[@"map"][@"goodsList"][@"list"]) {
                ClassDetailModel *model = [ClassDetailModel new];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArray addObject:model];
            }
        }
         [self hideProgressHUD];
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
        //上拉刷新
        [self RefreshForCollection:responseObject action:type];
    } failure:^(NSError *error) {
        
    }];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 1) {
         return self.dataArray.count;
    } else {
        return 0;
    }
   
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        ThridCell  *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ThridCell" forIndexPath:indexPath];
        cell.delegate = self;
        
        if (self.newtypeid == 3) {
            if (self.dataArray.count != 0) {
               cell.detailModel = self.dataArray[indexPath.row];
            }
            
        } else {
            if (self.dataArray.count != 0) {
                 cell.moreModel = self.dataArray[indexPath.row];
            }
           
        }
        return cell;
    } else {
        return nil;
    }
    
}
- (void)buyBtnAction:(ThridCell *)cell
{
    NSIndexPath *index = [self.collectionView indexPathForCell:cell];
    if (self.newtypeid == 3) {
        NSDictionary *dic =  [self.dataArray[index.row] goodsSku];
        NSInteger i = [dic[@"id"] integerValue];

        [ShopAddRequest requestForShop:i buycount:@"1" enterperson:^{
            NewLoginViewController *login = [NewLoginViewController new];
            login.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:login animated:YES];
        }];
        
    } else {

        [ShopAddRequest requestForShop:[self.dataArray[index.row] id] buycount:@"1" enterperson:^{
            NewLoginViewController *login = [NewLoginViewController new];
            login.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:login animated:YES];
        }];
    }
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section== 0) {
        UICollectionReusableView *reusView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        reusView.backgroundColor = [UIColor whiteColor];
        //将搜索按钮添加到sdc上
        UIButton *searchBtn = [SuspendHelper searchButtonCreate:[ColorString colorWithHexString:@"#eeeeee"]];
        
        [searchBtn addTarget:self action:@selector(searchBtnAction1) forControlEvents:(UIControlEventTouchUpInside)];
        
        //创建选项按钮
        sortView = [[[NSBundle mainBundle] loadNibNamed:@"ClassifyView" owner:nil options:nil] firstObject];
        
        [sortView.secondBtn setImage:[UIImage imageNamed:@"价格"] forState:(UIControlStateNormal)];
        [sortView.thridBtn setImage:[[UIImage imageNamed:@"Save"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] forState:(UIControlStateNormal)];
      
        [sortView.firstBtn setTitleColor:[ColorString colorWithHexString:@"#f9cd02"] forState:(UIControlStateNormal)];
        sortView.delegate = self;
        if (self.newtypeid == 3) {
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
            [img sd_setImageWithURL:[NSURL URLWithString:self.sortModel.mainPic]];
            
            [reusView addSubview:img];
            
            sortView.frame = CGRectMake(0, 200, SCREEN_WIDTH, 45);
           
            
        } else {
            //从首页点击更多进入的
            sortView.frame = CGRectMake(0, 33 + 10 + 10, SCREEN_WIDTH, 45);
            
        }
        
        [reusView addSubview:searchBtn];
        [reusView addSubview:sortView];
        return reusView;

    } else {
        return nil;
    }
    
}

- (void)clickClassifyViewButtonAction:(NSInteger)index classView:(ClassifyView *)classView
{
   // NSLog(@"%ld",index);
    [self.dataArray removeAllObjects];
    self.StratPage = 1;
    switch (index) {
        case 0:
        {
            
            if (self.newtypeid == 3) {
                [self request:ActionTypeOne];
                
                
            } else {
                //首页进入
                [self requestForHome:ActionTypeOne];
            }
        }
            break;
        case 1:
        {
            if (self.newtypeid == 3) {
                self.view.tag = !self.view.tag;
                if (self.view.tag) {
                    [self request:ActionTypeThree];
                } else {
                    [self request:ActionTypeTwo];
                }
                
            } else {
                
                classView.tag = !classView.tag;
                if (classView.tag) {
                    
                    //首页进入（价格降序）
                    [self requestForHome:ActionTypeThree];
                } else {
                    //首页进入(价格升序)
                    [self requestForHome:ActionTypeTwo];
                }
            }
        }
            break;
        case 2:
        {
            if (self.newtypeid == 3) {
                [self request:ActionTypeFour];
            } else {
                //首页进入
                [self requestForHome:ActionTypeFour];
                
            }
        }
            break;
        case 3:
        {
            if (self.newtypeid == 3) {
                [self request:ActionTypeSix];
            } else {
                //首页进入
                [self requestForHome:ActionTypeSix];
            }
        }
            break;
            
        default:
            break;
    }
    
}
- (void)searchBtnAction1
{
    //进入搜索界面
    SearchViewController *search = [SearchViewController new];
    search.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:search animated:YES];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        if (self.newtypeid == 3) {
            return CGSizeMake(SCREEN_WIDTH, 245);
            
        } else {
            
            return CGSizeMake(SCREEN_WIDTH, 98);
        }
    } else {
        return CGSizeZero;
    }
    
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 1) {
       return UIEdgeInsetsMake(3, 3, 3, 3);
    } else {
    return UIEdgeInsetsZero;
    }
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (isiPhone5or5sor5c) {
            return CGSizeMake(311 / 2, 247);
        } else {
             return CGSizeMake((SCREEN_WIDTH - 9) / 2, 270);
        }
      
    } else {
        return CGSizeZero;
    }
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        DetailViewController *detail = [DetailViewController new];
        if (self.newtypeid == 3) {
            ClassDetailModel *model  = self.dataArray[indexPath.item];
            
            detail.detailID = model.id;
        } else {
            HomeMoreModel *model = self.dataArray[indexPath.item];
            detail.detailID = model.id;
            
        }
        
        [self.navigationController pushViewController:detail animated:YES];

    }
}


@end
