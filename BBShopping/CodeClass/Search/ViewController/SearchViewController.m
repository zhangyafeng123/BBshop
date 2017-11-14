//
//  SearchViewController.m
//  BBShopping
//
//  Created by mibo02 on 17/1/21.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "SearchViewController.h"
#import "ThridCell.h"
#import "SearchModel.h"
#import "Searchhistory.h"
#import "DetailViewController.h"
#import "ClassifyView.h"
#import "NewLoginViewController.h"
@interface SearchViewController ()<UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SearchhistoryDelegate,ClassifyViewDelegate,ThridCellbuyBtnDelegate>{
    UITextField *textField1;
    UIView *topView;
}
@property (nonatomic, strong)MJRefreshBackNormalFooter *mj;
//开始的页码
@property (nonatomic, assign)NSInteger StratPage;
@property (nonatomic, strong)UIView *NaView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
//历史记录页面
@property (nonatomic, strong)Searchhistory *searchView;
//hotPage
@property (nonatomic, strong)Searchhistory *hotView;
//历史记录数组
@property (nonatomic, strong)NSMutableArray *searchResultArray;
//tableViewArr
@property (nonatomic, strong)NSMutableArray *tabArr;

@property (nonatomic, strong)NSMutableArray *newtabArr;
//collectionArr
@property (nonatomic, strong)NSMutableArray *collArr;
//保存输入的关键词
@property (nonatomic, copy)NSString *interStr;

@end

@implementation SearchViewController
- (NSMutableArray *)collArr
{
    if (!_collArr) {
        self.collArr = [NSMutableArray new];
    }
    return _collArr;
}
- (NSMutableArray *)newtabArr
{
    if (!_newtabArr) {
        self.newtabArr = [NSMutableArray new];
    }
    return _newtabArr;
}
- (NSMutableArray *)tabArr
{
    if (!_tabArr) {
        self.tabArr = [NSMutableArray new];
    }
    return _tabArr;
}
- (NSMutableArray *)searchResultArray
{
    if (!_searchResultArray) {
        self.searchResultArray = [NSMutableArray new];
    }
    return _searchResultArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.navigationController.navigationBar.translucent = NO;
    
    self.StratPage = 1;
    //进行请求
    [self requestTableView];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    self.collectionView.hidden = YES;
    [self.collectionView registerNib:[UINib nibWithNibName:@"ThridCell" bundle:nil] forCellWithReuseIdentifier:@"ThridCell"];
   
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self createSearch];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.NaView removeFromSuperview];
}

//创建搜索框
- (void)createSearch
{
    self.NaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    _NaView.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar addSubview:_NaView];
    //显示在最上层
    [self.navigationController.navigationBar bringSubviewToFront:_NaView];
    //设置导航栏的样式
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    //取消按钮
    UIButton *cancelButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [cancelButton setTitle:@"取消" forState:(UIControlStateNormal)];
    [cancelButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    cancelButton.frame = CGRectMake(SCREEN_WIDTH - 80, 5, 80, 35);
    [cancelButton addTarget:self action:@selector(cancenButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.NaView addSubview:cancelButton];
    
    textField1 = [[UITextField alloc] initWithFrame:CGRectMake(20, 5, SCREEN_WIDTH - 100, 35)];
    textField1.layer.cornerRadius = 15;
    textField1.borderStyle = UITextBorderStyleRoundedRect;
    textField1.backgroundColor = [ColorString colorWithHexString:@"#eeeeee"];
    textField1.delegate = self;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 30, 15)];
    imageView.image = [UIImage imageNamed:@"搜索"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    textField1.leftView = imageView;
    textField1.leftViewMode = UITextFieldViewModeAlways;
    textField1.placeholder = @"请输入搜索关键词";
    textField1.clearsOnBeginEditing = YES;
    textField1.returnKeyType = UIReturnKeySearch;
  
    [textField1 becomeFirstResponder];
    [_NaView addSubview:textField1];
    
}
//请求tableview
- (void)requestTableView
{
    [self showProgressHUD];
    [PPNetworkHelper GET:SearchZDURL parameters:@{} success:^(id responseObject) {
        
        [self.tabArr removeAllObjects];
        if ([responseObject[@"code"] integerValue] == 0) {
            for (NSDictionary *dic in responseObject[@"map"][@"hotSearchList"]) {
                [self.tabArr addObject:dic[@"info"]];
            }
        
        }
        //创建热搜
        if (self.tabArr.count != 0) {
            self.hotView = [[Searchhistory alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0) dataArr:self.tabArr hide:YES backColor:[ColorString colorWithHexString:@"eeeeee"] TextStr:@"热搜" heightV:0];
            self.hotView.delegegate = self;
            [self.view addSubview:self.hotView];
        }
       
        [self hideProgressHUD];
        //判断本地数组
        self.searchResultArray = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"search"] mutableCopy];
        
        //创建历史记录页面
        if (self.searchResultArray.count != 0) {
            topView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.hotView.frame), SCREEN_WIDTH, 20)];
            topView.backgroundColor = [UIColor groupTableViewBackgroundColor];
            [self.view addSubview:topView];
            //创建
            _searchView = [[Searchhistory alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame), SCREEN_WIDTH, 0) dataArr:self.searchResultArray hide:NO backColor:[UIColor whiteColor] TextStr:@"历史记录" heightV:CGRectGetMaxY(topView.frame)];
            _searchView.delegegate = self;
            [self.view addSubview:_searchView];
            
        } else {
            //
            return;
        }
       
    } failure:^(NSError *error) {
        
    }];
}


//点击取消按钮
- (void)cancenButtonAction:(UIButton *)sender
{
    [self.NaView removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}


//请求collectionView
- (void)collectionViewRequest:(NSString *)textStr action:(NumberTypeActions)action
{
    [self showProgressHUD];
    //进行请求
    NSString *url = [NSString stringWithFormat:@"%@?info=%@&order=%ld&token=%@&start=%ld",SearchURL,textStr,action,[UserInfoManager getUserInfo].token,self.StratPage];
    NSString *str1 = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    [PPNetworkHelper GET:str1 parameters:@{} responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            
            
          //  [self.collArr removeAllObjects];
            
                for (NSDictionary *dic in responseObject[@"map"][@"goodsList"][@"list"]) {
                    SearchModel *model = [SearchModel new];
                    [model setValuesForKeysWithDictionary:dic];
                    [self.collArr addObject:model];
                }
          
        }
        
        if (self.collArr.count == 0) {
            [MBProgressHUD showError:@"无相关商品"];
            self.collectionView.hidden = YES;
            self.searchView.hidden = NO;
            self.hotView.hidden = NO;
            topView.hidden = NO;
        } else {
            self.collectionView.hidden = NO;
            self.searchView.hidden = YES;
            self.hotView.hidden = YES;
            topView.hidden = YES;
        }
        [self hideProgressHUD];
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
        //上拉刷新
        [self RefreshForCollection:responseObject action:action text:textStr];
        //将输入的字符串保存
        self.interStr = textStr;
        
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)RefreshForCollection:(id)responseObject  action:(NumberTypeActions)action text:(NSString *)text
{
    //判断是否是最后一页
    if ([responseObject[@"map"][@"goodsList"][@"pages"] integerValue] > self.StratPage) {
        
        self.StratPage += 1;
        //进入下拉加载
        _mj = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self.collectionView.mj_footer beginRefreshing];
            
            [self collectionViewRequest:text action:action];
            
            [self.collectionView.mj_footer endRefreshing];
        }];
        self.collectionView.mj_footer = _mj;
        
    } else {
        
        [_mj endRefreshingWithNoMoreData];
    }
}
#pragma mark----UITextFieldDelegate---

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (textField.text.length > 0) {
        
        //先进行清除
        [self.newtabArr removeAllObjects];
        
        for (NSString *str in self.tabArr) {
            if ([str containsString:textField.text]) {
                
                [self.newtabArr addObject:str];
            }
            
        }

        //
        [self collectionViewRequest:textField.text action:ActionTypeOne];
      
        //每次都清空一下
        [self.tabArr removeAllObjects];
        //保存到本地
        [self saveToLocation:textField.text];
       
    } else {
        //搜索内容不能为空
        [MBProgressHUD showError:@"搜索内容为空"];
    }
    
    return YES;
}
- (void)saveToLocation:(NSString *)str
{
    //如果数组中没有这个数据就添加进去
    if (![self.searchResultArray containsObject:str]) {
       [self.searchResultArray addObject:str];
        //存入本地
        [[NSUserDefaults standardUserDefaults] setObject:self.searchResultArray forKey:@"search"];
    } else {
        return;
    }
    
    
}
#pragma mark -----SearchhistoryDelegate----
//标签按钮点击事件
- (void)buttonClickAction:(NSString *)btnStr
{
    //弹回键盘
    [textField1 resignFirstResponder];
    textField1.text = btnStr;
    //调用请求
    [self collectionViewRequest:btnStr action:ActionTypeOne];
    //保存到本地
    [self saveToLocation:btnStr];
}
//删除按钮点击事件
- (void)buttonDeleteAction:(UIButton *)sender
{
    //删除topView
    [topView removeFromSuperview];
    [self.searchResultArray removeAllObjects];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"search"];
    [self.searchView removeFromSuperview];

}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 1) {
        return self.collArr.count;
    } else {
        return 0;
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        ThridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ThridCell" forIndexPath:indexPath];
        cell.delegate = self;
        cell.searchModel  = self.collArr[indexPath.item];
        
        return cell;
    } else {
        return nil;
    }
    
}

- (void)buyBtnAction:(ThridCell *)cell
{
    NSIndexPath *index = [self.collectionView indexPathForCell:cell];
    [ShopAddRequest requestForShop:[self.collArr[index.item] id] buycount:@"1" enterperson:^{
        NewLoginViewController *login = [NewLoginViewController new];
        login.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:login animated:YES];
    }];
   
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UICollectionReusableView *reusView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        
        //创建选项按钮
        ClassifyView *sortView = [[[NSBundle mainBundle] loadNibNamed:@"ClassifyView" owner:nil options:nil] firstObject];
        [sortView.secondBtn setImage:[UIImage imageNamed:@"价格"] forState:(UIControlStateNormal)];
        [sortView.thridBtn setImage:[[UIImage imageNamed:@"Save"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] forState:(UIControlStateNormal)];
        [sortView.firstBtn setTitleColor:[ColorString colorWithHexString:@"#f9cd02"] forState:(UIControlStateNormal)];
        sortView.delegate = self;
        sortView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 45);
        [reusView addSubview:sortView];
        return reusView;

    } else {
        return nil;
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
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 1) {
        return UIEdgeInsetsMake(3, 3, 3, 3);
    } else {
        return UIEdgeInsetsZero;
    }
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        DetailViewController *detail = [DetailViewController new];
        SearchModel *model = self.collArr[indexPath.item];
        detail.detailID = model.id;
        [self.navigationController pushViewController:detail animated:YES];
        
        [self.NaView removeFromSuperview];
    }
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGSizeMake(SCREEN_WIDTH, 45);
    } else {
        return CGSizeZero;
    }
    
}
- (void)clickClassifyViewButtonAction:(NSInteger)index classView:(ClassifyView *)classView
{
    self.StratPage = 1;
    [self.collArr removeAllObjects];
    switch (index) {
        case 0:
        {
            [self collectionViewRequest:self.interStr action:ActionTypeOne];
        }
            break;
        case 1:
        {
            self.view.tag = !self.view.tag;
            if (self.view.tag) {
                [self collectionViewRequest:self.interStr action:ActionTypeThree];
            } else {
                [self collectionViewRequest:self.interStr action:ActionTypeTwo];
            }
            
        }
            break;
        case 2:
        {
            [self collectionViewRequest:self.interStr action:ActionTypeFour];
        }
            break;
        case 3:
        {
            [self collectionViewRequest:self.interStr action:ActionTypeSix];
        }
            break;
            
        default:
            break;
    }
}


@end
