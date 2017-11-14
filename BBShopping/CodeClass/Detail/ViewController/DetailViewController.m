//
//  DetailViewController.m
//  BBShopping
//
//  Created by mibo02 on 17/2/5.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "DetailViewController.h"
#import "DetailFirstCell.h"
#import "DetailSecondCell.h"
#import "QWNViewController.h"
#import "DetailThreedCell.h"
#import "DetailTagModel.h"
#import "DetailTagView.h"
#import "DetailFourCell.h"
#import "HJCAjustNumButton.h"
#import "DetailFiveCell.h"
#import "DetailSevenCell.h"
#import "ContentModel.h"
#import "NewtagModel.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
// 弹出分享菜单需要导入的头文件
#import <ShareSDKUI/ShareSDK+SSUI.h>
// 自定义分享菜单栏需要导入的头文件
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>

#import <ShareSDKUI/SSUIEditorViewStyle.h>
#import "JieSuanViewController.h"
#import "NewLoginViewController.h"
@interface DetailViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,UIWebViewDelegate,DetailTagViewDelegate,UIScrollViewDelegate,UIScrollViewDelegate>{
    NSString *strvalue1;
    NSString *strvalue2;
    UIButton *shopButton;
    DetailTagView *tagView;
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;
//立即购买
@property (weak, nonatomic) IBOutlet UIButton *DetailBuyButton;

//加入购物车
@property (weak, nonatomic) IBOutlet UIButton *addbutton;
@property (weak, nonatomic) IBOutlet UIButton *backhomebutton;

@property (weak, nonatomic) IBOutlet UIButton *messagebutton;


@property (nonatomic, strong)SDCycleScrollView *sdc;
@property (nonatomic, strong)NSMutableArray *PicArr;

@property (nonatomic, strong)NSMutableDictionary *dic;
@property (nonatomic, strong)NSDictionary *BaseDic;
@property (nonatomic, strong)HJCAjustNumButton *numButton;

@property (nonatomic, strong)NSMutableArray *contentArray;

@property (nonatomic, strong)NSMutableArray *sku1NameTagArr;
@property (nonatomic, strong)NSMutableArray *sku1value;
@property (nonatomic, strong)NSMutableArray *sku2value;
@property (nonatomic, strong)UIWebView *webView;

@property (nonatomic, strong)NSDictionary *skuDic;


@property (nonatomic, strong)UIView *backV;
@end

@implementation DetailViewController



- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [[SDImageCache sharedImageCache] clearMemory];
    if (scrollView == self.tableview)
    {
        
        UITableView *tableview = (UITableView *)scrollView;
        CGFloat sectionHeaderHeight = 50;
        CGFloat sectionFooterHeight = 50;
        
        CGFloat offsetY = tableview.contentOffset.y;
        
        if (offsetY >= 0 && offsetY <= sectionHeaderHeight)
        {
            tableview.contentInset = UIEdgeInsetsMake(-offsetY, 0, -sectionFooterHeight, 0);
        }else if (offsetY >= sectionHeaderHeight && offsetY <= tableview.contentSize.height - tableview.frame.size.height - sectionFooterHeight)
        {
            tableview.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, -sectionFooterHeight, 0);
        }else if (offsetY >= tableview.contentSize.height - tableview.frame.size.height - sectionFooterHeight && offsetY <= tableview.contentSize.height - tableview.frame.size.height)
        {
            tableview.contentInset = UIEdgeInsetsMake(-offsetY, 0, -(tableview.contentSize.height - tableview.frame.size.height - sectionFooterHeight), 0);
        }
        
    }

}

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"%@",self.PicArr[0]);
    if (self.PicArr.count == 0) {
        [MBProgressHUD showError:@"加载中"];
    } else {
    QWNViewController *qwnVC = [QWNViewController new];
    qwnVC.imagesArr = _PicArr;
    qwnVC.index = [NSString stringWithFormat:@"%ld",index];;
    [self presentViewController:qwnVC animated:YES completion:nil];
    }
    
   
}
- (NSMutableArray *)sku1NameTagArr
{
    if (!_sku1NameTagArr) {
        self.sku1NameTagArr = [NSMutableArray new];
    }
    return _sku1NameTagArr;
}
- (NSMutableArray *)sku1value
{
    if (!_sku1value) {
        self.sku1value = [NSMutableArray new];
    }
    return _sku1value;
}
- (NSMutableArray *)sku2value
{
    if (!_sku2value) {
        self.sku2value = [NSMutableArray new];
    }
    return _sku2value;
}
- (NSMutableArray *)contentArray
{
    if (!_contentArray) {
        self.contentArray = [NSMutableArray new];
    }
    return _contentArray;
}


- (NSMutableArray *)PicArr
{
    if (!_PicArr) {
        self.PicArr = [[NSMutableArray alloc] init];
    }
    return _PicArr;
}


//返回首页
- (IBAction)backHome:(id)sender {
    
     [self.navigationController popToRootViewControllerAnimated:YES];
}
//客服
- (IBAction)serviceBtnAction:(UIButton *)sender {
    UIWindow *window = [UIApplication sharedApplication].windows[0];
    
    if (isiPhone5or5sor5c) {
        _backV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT)];
        _backV.backgroundColor = RGBA(108, 108, 108,0.7);
        [window addSubview:_backV];
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake((320 - 300) / 2, (SCREEN_HEIGHT - 400) / 2, 300, 400)];
        imageV.image = [UIImage imageNamed:@"客服助手-弹窗形式_03"];
        [_backV addSubview:imageV];
    } else {
        _backV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _backV.backgroundColor = RGBA(108, 108, 108,0.7);
        [window addSubview:_backV];
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 300) / 2, (SCREEN_HEIGHT - 400) / 2, 300, 400)];
        imageV.image = [UIImage imageNamed:@"客服助手-弹窗形式_03"];
        [_backV addSubview:imageV];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapaction)];
    [_backV addGestureRecognizer:tap];
    
}
- (void)tapaction
{
    [_backV removeFromSuperview];
}

//当有规格时加入购物车请求
- (void)addshopingRequest
{
    [PPNetworkHelper setValue:[UserInfoManager getUserInfo].token forHTTPHeaderField:@"token"];
    
    NSDictionary *addDic = @{
                             
                             @"store_user_id":[NSString stringWithFormat:@"%ld",[self.BaseDic[@"store_user_id"] integerValue]],
                             @"store_id":[NSString stringWithFormat:@"%ld",[self.BaseDic[@"store"][@"id"] integerValue]],
                             @"goods_id":[NSString stringWithFormat:@"%ld",[self.skuDic[@"goodsId"] integerValue]],
                             @"sku_id":[NSString stringWithFormat:@"%ld",[self.skuDic[@"id"] integerValue]],
                             @"goodsName":self.dic[@"goodsName"],
                             @"fh_user_id":[NSString stringWithFormat:@"%ld",[self.BaseDic[@"store"][@"userId"] integerValue]],
                             @"group_buy_price":[NSString stringWithFormat:@"%.2f",[self.skuDic[@"groupBuyPrice"] floatValue]],
                             @"shop_market_price":[NSString stringWithFormat:@"%.2f",[self.skuDic[@"shopMarketPrice"] floatValue]],
                             @"ex_factory_price":[NSString stringWithFormat:@"%.2f",[self.skuDic[@"exFactoryPrice"] floatValue]],
                             @"quantity":[NSString stringWithFormat:@"%ld",[self.skuDic[@"quantity"] integerValue]],
                             @"buyCount":self.numButton.currentNum,
                             @"userType":[NSString stringWithFormat:@"%ld",[self.BaseDic[@"userType"] integerValue]],
                             @"pic_server_url1":self.PicArr[0],
                             @"store_name":self.BaseDic[@"store_name"]
                             
                             };
    
    
    [PPNetworkHelper POST:addGoodsToCartURL parameters:addDic success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 0) {
            
            [MBProgressHUD showError:@"加入购物车成功"];
        } else if ([responseObject[@"code"] integerValue] == 9999){
           
            NewLoginViewController *login = [NewLoginViewController new];
            [self.navigationController pushViewController:login animated:YES];
        }
        
    } failure:^(NSError *error) {
        
    }];

}

//加入购物车
- (IBAction)addBtnAction:(UIButton *)sender {
 
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(sender.origin.x + 20, sender.origin.y, 50, 50)];
    [imageV sd_setImageWithURL:[NSURL URLWithString:self.PicArr[0]]];
    [self.view addSubview:imageV];
    [imageV animationStartPoint:imageV.center endPoint:shopButton.center didStopAnimation:^{
        [imageV removeFromSuperview];
    }];
    
    if (self.sku1NameTagArr.count == 2) {
        //选择规格
        if (strvalue1.length > 0 && strvalue2.length > 0) {
            
            if ([self.skuDic[@"quantity"] integerValue] != 0) {
                //调用
                [self addshopingRequest];
                
            } else {
                [MBProgressHUD showError:@"库存不足"];
            }
        } else {
            [MBProgressHUD showError:@"请选择规格"];
        }
        
        
    } else if (self.sku1NameTagArr.count == 1){
        
        if (strvalue1.length > 0) {
            if ([self.skuDic[@"quantity"] integerValue] != 0) {
                [self addshopingRequest];
            } else {
                [MBProgressHUD showError:@"库存不足"];
            }
        } else {
            [MBProgressHUD showError:@"请选择规格"];
        }
    } else {
        if ([self.dic[@"quantitySum"] integerValue] != 0) {
            
            [ShopAddRequest requestForShop:[self.BaseDic[@"detail"][@"goodsId"] integerValue] buycount:self.numButton.currentNum  enterperson:^{
                NewLoginViewController *login = [NewLoginViewController new];
                login.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:login animated:YES];
            }];
        }else {
            [MBProgressHUD showError:@"库存不足"];
        }
    }
  
}
//跳转到结算
- (void)intoJieSuanViewSkuID:(NSInteger)skuid  buycount:(NSString *)buyStr
{
    if ([UserInfoManager isLoading]) {
        JieSuanViewController *jiesuan = [JieSuanViewController new];
        
        jiesuan.orderShopArray = [@[@{@"skuId":@(skuid),@"buyCount":(buyStr)}] mutableCopy];
        
        [self.navigationController pushViewController:jiesuan animated:YES];
    } else {
        NewLoginViewController *login = [NewLoginViewController new];
        [self.navigationController pushViewController:login animated:YES];
    }
}
//立即购买
- (IBAction)buyButtonAction:(UIButton *)sender {

    
    if (self.sku1NameTagArr.count == 2) {
        //选择规格
        if (strvalue1.length > 0 && strvalue2.length > 0) {
            
            if ([self.skuDic[@"quantity"] integerValue] != 0) {
                //跳转到结算
                [self intoJieSuanViewSkuID:[self.skuDic[@"id"] integerValue] buycount:_numButton.currentNum];
            } else {
                [MBProgressHUD showError:@"库存不足"];
            }
        } else {
            [MBProgressHUD showError:@"请选择规格"];
        }
        
        
    } else if (self.sku1NameTagArr.count == 1){
        
        if (strvalue1.length > 0) {
            if ([self.skuDic[@"quantity"] integerValue] != 0) {
                //跳转到结算
                [self intoJieSuanViewSkuID:[self.skuDic[@"id"] integerValue] buycount:_numButton.currentNum];
                
            } else {
                [MBProgressHUD showError:@"库存不足"];
            }
        } else {
            [MBProgressHUD showError:@"请选择规格"];
        }
    } else {
        if ([self.dic[@"quantitySum"] integerValue] != 0) {
            
            //跳转到结算
            [self intoJieSuanViewSkuID:[self.BaseDic[@"sku_id"] integerValue] buycount:_numButton.currentNum];
        }else {
            [MBProgressHUD showError:@"库存不足"];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
   
    [shopButton removeFromSuperview];
}
- (void)shareaction
{
   
    NSString *wechaturl = @"https://itunes.apple.com/cn/app/%E9%82%A6%E9%82%A6%E8%B4%AD/id1217331895?mt=8";
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray *imageArray;
    if (self.PicArr.count != 0) {
        imageArray = @[self.PicArr[0]];
    } else {
        imageArray = @[@"AppIcon"];
    }
    // （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    [shareParams SSDKSetupShareParamsByText:@"邦邦购，安心食品购买平台"
                                     images:imageArray
                                        url:[NSURL URLWithString:wechaturl]
                                      title:[NSString stringWithFormat:@"%@  %@",[NSString stringWithFormat:@"¥%.2f",[self.BaseDic[@"group_buy_price"] floatValue]],self.dic[@"goodsName"]]
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
    self.title = @"商品详情";
    self.navigationController.navigationBar.translucent = NO;
      self.navigationItem.rightBarButtonItem = [UIBarButtonItem CreateItemWithTarget:self ForAction:@selector(shareaction) WithImage:@"分享" WithHighlightImage:nil bageLab:@"" ishide:YES];
    [PriceLine initButton:_backhomebutton];
    [PriceLine initButton:_messagebutton];
    self.tableview.rowHeight=UITableViewAutomaticDimension;//自动换行（iOS8.0之后是默认值，不用再设置）
    self.tableview.estimatedRowHeight = 150;//预设高度（注意并不是最小高度）只是为了设置contentsize
    
    [self.tableview registerNib:[UINib nibWithNibName:@"DetailFirstCell" bundle:nil] forCellReuseIdentifier:@"firstCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"DetailSecondCell" bundle:nil] forCellReuseIdentifier:@"secondCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"DetailThreedCell" bundle:nil] forCellReuseIdentifier:@"DetailThreedCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"DetailFourCell" bundle:nil] forCellReuseIdentifier:@"DetailFourCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"DetailFiveCell" bundle:nil] forCellReuseIdentifier:@"DetailFiveCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"DetailSixCell" bundle:nil] forCellReuseIdentifier:@"DetailSixCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"DetailSevenCell" bundle:nil] forCellReuseIdentifier:@"DetailSevenCell"];
    
    NSString *url  =[NSString stringWithFormat:@"%@?goodsId=%ld",DetailURL,self.detailID];
    
    [self request:url];
   
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self createbuttonforbacktopAndshopingchart];
}
- (void)createbuttonforbacktopAndshopingchart
{
    shopButton = [SuspendHelper shoppingButtonCreate];
    [shopButton addTarget:self action:@selector(shopButton) forControlEvents:(UIControlEventTouchUpInside)];
}
- (void)shopButton
{
     [[NSNotificationCenter defaultCenter] postNotificationName:@"shopVC" object:nil];
}
- (void)request:(NSString *)url
{
    [self showProgressHUD];
    [PPNetworkHelper GET:url parameters:@{} responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        
        [self.sku1NameTagArr removeAllObjects];
        [self.sku2value removeAllObjects];
        [self.sku1value removeAllObjects];
        if ([responseObject[@"code"] integerValue] == 0) {
            self.BaseDic = responseObject[@"map"];
            self.dic = responseObject[@"map"][@"goods"];
            //轮播图
            NSString *str;
            for (int i = 1 ; i < 7; i ++) {
                str = [NSString stringWithFormat:@"picServerUrl%d",i];
                if (![self.dic[str] isEqualToString:@""] &&self.dic[str]) {
                    NSLog(@"%@",self.dic[str]);
                    [self.PicArr addObject:self.dic[str]];
                }
            }
            
            NSMutableArray *firstkey = [NSMutableArray new];
            NSMutableArray *firstValue = [NSMutableArray new];
            NSMutableArray *secondkey = [NSMutableArray new];
            NSMutableArray *secondValue = [NSMutableArray new];
            [firstkey removeAllObjects];
            [firstValue removeAllObjects];
            [secondkey removeAllObjects];
            [secondValue removeAllObjects];
            //标签tag选择
            if ([self.dic[@"skulist"] count] != 0) {
                for (NSDictionary *tagDic in self.dic[@"skulist"]) {
                    if (tagDic[@"sku1Name"]) {
                        [firstkey addObject:  tagDic[@"sku1Name"]];
                        [firstValue addObject:tagDic[@"sku1Value"]];
                    }
                    
                    if (tagDic[@"sku2Name"]) {
                        [secondkey addObject:tagDic[@"sku2Name"]];
                        [secondValue addObject:tagDic[@"sku2Value"]];
                    }
                }
            }
            
            for (NSString *str in firstkey) {
                if (![self.sku1NameTagArr containsObject:str]) {
                    [self.sku1NameTagArr addObject:str];
                }
            }
            
            if (secondkey.count != 0) {
                for (NSString *str in secondkey) {
                    if ([str isEqualToString:@""]) {
                        
                    }else if (![self.sku1NameTagArr containsObject:str]) {
                        [self.sku1NameTagArr addObject:str];
                    }
                }
            }
            for (NSString *str1 in firstValue) {
                if ([str1 isEqualToString:@""]) {
                    
                }else if (![self.sku1value containsObject:str1]) {
                    [self.sku1value addObject:str1];
                }
            }
            if (secondValue.count != 0) {
                for (NSString *str in secondValue) {
                    if ([str isEqualToString:@""]) {
                      
                    } else if (![self.sku2value containsObject:str]) {
                        [self.sku2value addObject:str];
                    }
                }
            }
            
            //评论
            for (NSDictionary *dic in self.BaseDic[@"goodsRateList1"]) {
                ContentModel *model = [ContentModel new];
                [model setValuesForKeysWithDictionary:dic];
                [self.contentArray addObject:model];
            }
            
            
            //createHeaderView
            [self createHeaderView];
         
            [self.tableview reloadData];
            //创建webview
            _webView = [[UIWebView alloc]initWithFrame:CGRectMake(-5, 0, SCREEN_WIDTH, 1)];
            _webView.delegate = self;
            
            _webView.scrollView.scrollEnabled = NO;
            
            //预先加载url
            [self.webView loadHTMLString:self.BaseDic[@"detail"][@"detail"] baseURL:nil];
            
        } else if ([responseObject[@"code"] integerValue] == -1){
            [MBProgressHUD showError:responseObject[@"message"]];
        }
       
         [self hideProgressHUD];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)createHeaderView
{
    if (isiPhone5or5sor5c) {
      self.sdc = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 64, 320, 250) imageURLStringsGroup:_PicArr];
        self.sdc.delegate = self;
        self.tableview.tableHeaderView = self.sdc;
    } else {
       self.sdc = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 64, SCREEN_HEIGHT, 300) imageURLStringsGroup:_PicArr];
        self.sdc.delegate = self;
        self.tableview.tableHeaderView = self.sdc;
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        
        return self.sku1NameTagArr.count  + 3;
    } else if(section == 1) {
        return [self.dic[@"paramlist"] count];
    } else if(section == 2){
        return 1;
    } else {
        return self.contentArray.count;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            DetailFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:@"firstCell" forIndexPath:indexPath];
            cell.titleLab.text = self.dic[@"goodsName"];
            cell.subTitLab.text = self.dic[@"subTitle"];
            cell.yuanlab.hidden = YES;
            cell.priceLab.text = [NSString stringWithFormat:@"¥%.2f",[self.BaseDic[@"group_buy_price"] floatValue]];
            return cell;
        } else if(indexPath.row == 1) {
            DetailSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:@"secondCell" forIndexPath:indexPath];
            cell.leftLab.text = [NSString stringWithFormat:@"销量:%ld",[self.dic[@"salesNumSum"] integerValue]];
           
            cell.centerLab.text = self.BaseDic[@"wetherPostage"];
            cell.rightLab.text = self.BaseDic[@"sendAddress"];
            return cell;
        } else if (indexPath.row == self.sku1NameTagArr.count + 2){
            //此时是最后一个cell
            DetailFourCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailFourCell" forIndexPath:indexPath];
            cell.numberLab.text = [NSString stringWithFormat:@"库存:%ld件",[self.dic[@"quantitySum"] integerValue]];
            self.numButton = [[HJCAjustNumButton alloc] init];
            self.numButton.frame = CGRectMake(0, 0, 95, 30);
            self.numButton.currentNum = @"1";
           
            [cell.PriceView addSubview:self.numButton];
            // 内容更改的block回调
            self.numButton.callBack = ^(NSString *currentNum){
               
            };
            
            return cell;
        } else {
            DetailThreedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailThreedCell" forIndexPath:indexPath];
            
            NSArray *arr = @[self.sku1value,self.sku2value];
            cell.leftLab.text = self.sku1NameTagArr[indexPath.row - 2];
            
           
            tagView = [[DetailTagView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - CGRectGetMaxX(cell.leftLab.frame) + 20, cell.BtnView.frame.size.height) dataArr:arr[indexPath.row - 2]];
            tagView.delegegate = self;
            [cell.BtnView addSubview:tagView];
            
            return cell;
        }

    } else if(indexPath.section == 1) {
        //规格
        DetailFiveCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailFiveCell" forIndexPath:indexPath];
        NSArray *arr = self.dic[@"paramlist"];
        cell.oneLab.text = arr[indexPath.row][@"paramName"];
        cell.twoLab.text = arr[indexPath.row][@"paramValue"];
        return cell;
    } else if(indexPath.section == 2){
        static NSString *identifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
            
        }
        
        [cell.contentView addSubview:_webView];
        return cell;
    } else {
        DetailSevenCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailSevenCell" forIndexPath:indexPath];
        HCSStarRatingView *starRatingView = [[HCSStarRatingView alloc] initWithFrame:CGRectMake(0, 0, 100, 16)];
        starRatingView.allowsHalfStars = NO;
        starRatingView.value = [self.contentArray[indexPath.row] evaluation];
        starRatingView.tintColor = [ColorString colorWithHexString:@"#f9cd02"];
        [cell.StarView addSubview:starRatingView];
        UIView *clearV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 16)];
        clearV.backgroundColor = [UIColor clearColor];
        [starRatingView addSubview:clearV];
        cell.model = self.contentArray[indexPath.row];
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 120;
        } else if(indexPath.row == 1) {
            return 40;
        } else if (indexPath.row == self.sku1NameTagArr.count + 2){
            return 50;
        } else {
            if (self.sku1NameTagArr.count == 0) {
                return 0;
            } else {
                return tagView.frame.size.height + 10;
            }
        }
    } else if(indexPath.section == 1){
        //设定字体格式
        NSDictionary*fontDt = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName,nil];
        NSArray *arr = self.dic[@"paramlist"];
        NSString *contentStr = arr[indexPath.row][@"paramValue"];
        CGRect rect = [contentStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 150, 0) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:fontDt context:nil];
        
        return rect.size.height + 17;
    } else if(indexPath.section == 2){
        return _webView.frame.size.height;
    } else {
        //设定字体格式
        NSDictionary*fontDt = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName,nil];
        NSString *contentStr = [self.contentArray[indexPath.row] content];
        NSString *backStr  = [self.contentArray[indexPath.row] replyContent];
        CGRect rect = [contentStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 40, 0) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:fontDt context:nil];
        CGRect rect1 = [backStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 150 - 17, 0) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:fontDt context:nil];
        if (![[self.contentArray[indexPath.row] replyContent] isEqualToString:@""]) {
            
             return rect.size.height+rect1.size.height + 120;
        } else {
            return rect.size.height + 120;
        }
      
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 3) {
        return 40;
    } else {
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 3) {
        return 60;
    } else {
        return 10;
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UILabel *lab = [[UILabel alloc] init];
    if (section == 3) {
        lab.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
        lab.textAlignment = NSTextAlignmentCenter;
        lab.text = [NSString stringWithFormat:@"商品评论(%ld)",self.contentArray.count];
        lab.backgroundColor = [UIColor whiteColor];
    } else {
        lab.frame = CGRectMake(0, 0, SCREEN_WIDTH, 10);
        lab.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return lab;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UILabel *lab = [[UILabel alloc] init];
    lab.backgroundColor = [UIColor groupTableViewBackgroundColor];
    if (section == 3) {
        lab.textAlignment = NSTextAlignmentCenter;
      
        lab.text = @"—————— 没有更多了哦 ——————";
        lab.font = [UIFont fontWithName:@"CourierNewPSMT" size:15.0];
        lab.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60);
    } else {
        lab.frame = CGRectMake(0, 0, SCREEN_WIDTH, 10);
    }
    return lab;
}

#pragma mark - UIWebView Delegate Methods
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    //定义JS字符串
    NSString *script = [NSString stringWithFormat: @"var script = document.createElement('script');"
                        "script.type = 'text/javascript';"
                        "script.text = \"function ResizeImages() { "
                        "var myimg;"
                        "var maxwidth=%f;" //屏幕宽度
                        "for(i=0;i <document.images.length;i++){"
                        "myimg = document.images[i];"
                        "myimg.height = maxwidth / (myimg.width/myimg.height);"
                        "myimg.width = maxwidth;"
                        "}"
                        "}\";"
                        "document.getElementsByTagName('p')[0].appendChild(script);",SCREEN_WIDTH];
    
    //添加JS
    [webView stringByEvaluatingJavaScriptFromString:script];
    
    //添加调用JS执行的语句
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    //获取到webview的高度
    CGFloat height = [[self.webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
    
    self.webView.frame = CGRectMake(self.webView.frame.origin.x,self.webView.frame.origin.y, SCREEN_WIDTH, height);
    [self.tableview reloadData];
}

//标签按钮点击事件
- (void)buttonClickAction:(NSString *)btnStr
{
    if (self.sku1NameTagArr.count == 2) {
        
        for (NSString *str in self.sku1value) {
            if ([str isEqualToString:btnStr]) {
                strvalue1 = str;
            }
        }
        for (NSString *str in self.sku2value) {
            if ([str isEqualToString:btnStr]) {
                strvalue2 = str;
            }
        }
     
        [self requestfortagBtnAction:strvalue1 value2:strvalue2];
        
    } else if (self.sku1NameTagArr.count == 1){
        strvalue1 = btnStr;
        [self requestfortagBtnAction:btnStr value2:nil];
    }
    
}

//规格选择请求
- (void)requestfortagBtnAction:(NSString *)value1 value2:(NSString *)value2
{
    NSString *url;
    if (value2) {
      url = [NSString stringWithFormat:@"%@?goodsId=%ld&sku1Value=%@&sku2Value=%@",SkudetailURL,self.detailID,value1,value2];
    } else {
        url = [NSString stringWithFormat:@"%@?goodsId=%ld&sku1Value=%@",SkudetailURL,self.detailID,value1];
    }
    
        NSString *str1 = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [PPNetworkHelper GET:str1 parameters:@{} success:^(id responseObject) {
    
            self.skuDic = responseObject[@"map"][@"goodsSkuStockPriceDTO"];
            //第一个row
            DetailFirstCell *cell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            cell.priceLab.text = [NSString stringWithFormat:@"¥%.2f",[responseObject[@"map"][@"goodsSkuStockPriceDTO"][@"groupBuyPrice"] floatValue]];
            //第二个row
            DetailSecondCell *secCell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            secCell.leftLab.text = [NSString stringWithFormat:@"销量:%ld",[responseObject[@"map"][@"goodsSkuStockPriceDTO"][@"salesNum"] integerValue]];
            
            //最后一个row
            DetailFourCell *fourcell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.sku1NameTagArr.count + 2 inSection:0]];
           
            fourcell.numberLab.text = [NSString stringWithFormat:@"库存:%ld件", [responseObject[@"map"][@"goodsSkuStockPriceDTO"][@"quantity"] integerValue]];
            
        } failure:^(NSError *error) {
            
        }];
}



@end
