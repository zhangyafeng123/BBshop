//
//  TimeDetailViewController.m
//  BBShopping
//
//  Created by mibo02 on 17/2/13.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "TimeDetailViewController.h"
#import "ContentModel.h"
#import "DetailFirstCell.h"
#import "DetailSecondCell.h"
#import "QWNViewController.h"
#import "DetailThreedCell.h"
#import "DetailTimeModel.h"
#import "DetailTagView.h"
#import "DetailFourCell.h"
#import "HJCAjustNumButton.h"
#import "DetailFiveCell.h"
#import "DetailSevenCell.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
// 弹出分享菜单需要导入的头文件
#import <ShareSDKUI/ShareSDK+SSUI.h>
// 自定义分享菜单栏需要导入的头文件
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>

#import <ShareSDKUI/SSUIEditorViewStyle.h>
#import "JieSuanViewController.h"
#import "NewLoginViewController.h"
@interface TimeDetailViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,HJCAjustNumButtonDelegate,UIWebViewDelegate,DetailTagViewDelegate,UIScrollViewDelegate>{
    NSString *strvalue1;
    NSString *strvalue2;
    DetailTagView *tagView;
    UIButton *shopButton;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *personBuyButton;
@property (weak, nonatomic) IBOutlet UIButton *BuyButton;

@property (weak, nonatomic) IBOutlet UIButton *backhomeButton;
@property (weak, nonatomic) IBOutlet UIButton *messagebutton;

//轮播图数组
@property (nonatomic, strong)SDCycleScrollView *sdc;
@property (nonatomic, strong)NSMutableArray *PicArr;
@property (nonatomic, strong)NSMutableDictionary *dic;
@property (nonatomic, strong)NSMutableArray *contentArray;
@property (nonatomic, strong)NSMutableArray *tagBtnArray;
@property (nonatomic, strong)HJCAjustNumButton *numButton;
@property (nonatomic, strong)UIWebView *webView;

@property (nonatomic, strong)UIView *backV;
//规格字典
@property (nonatomic, strong)NSDictionary *skuAllDic;
@end

@implementation TimeDetailViewController
- (NSMutableArray *)PicArr
{
    if (!_PicArr) {
        self.PicArr = [NSMutableArray new];
    }
    return _PicArr;
}
- (NSMutableArray *)contentArray
{
    if (!_contentArray) {
        self.contentArray = [NSMutableArray new];
    }
    return _contentArray;
}
- (NSMutableArray *)tagBtnArray
{
    if (!_tagBtnArray) {
        self.tagBtnArray = [NSMutableArray new];
    }
    return _tagBtnArray;
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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [shopButton removeFromSuperview];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [[SDImageCache sharedImageCache] clearMemory];
    if (scrollView == self.tableView)
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
    
    QWNViewController *qwnVC = [QWNViewController new];
    qwnVC.imagesArr = self.PicArr;
    qwnVC.index = [NSString stringWithFormat:@"%ld",index];;
    [self presentViewController:qwnVC animated:YES completion:nil];
}


- (IBAction)backHome:(UIButton *)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)serviceButtonAction:(UIButton *)sender {
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
- (IBAction)personBuyAction:(UIButton *)sender {
    [self buttontagAndquantity:sender.tag];
}

- (IBAction)buyButtonAction:(UIButton *)sender
{
    [self buttontagAndquantity:sender.tag];
}
//单独购买跳转到结算
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
//秒杀购买
- (void)intojiesuanViewMiaoShaBuyingSkuID:(NSInteger)skuid buycount:(NSString *)buyStr miaoshaID:(NSInteger)miaoshaid
{
    if ([UserInfoManager isLoading]) {
        JieSuanViewController *jiesuan = [JieSuanViewController new];
        
        jiesuan.orderShopArray = [@[@{@"skuId":@(skuid),@"buyCount":(buyStr),@"seckillId":@(miaoshaid)}] mutableCopy];
        
        [self.navigationController pushViewController:jiesuan animated:YES];
    } else {
        NewLoginViewController *login = [NewLoginViewController new];
        [self.navigationController pushViewController:login animated:YES];
    }
   
}



- (void)buttontagAndquantity:(NSInteger)tag
{
    if (self.tagBtnArray.count == 2) {
        //选择规格
        if (strvalue1.length > 0 && strvalue2.length > 0) {
            
            if ([self.skuAllDic[@"quantity"] integerValue] != 0) {
                //单独购买
                if (tag == 150) {
                    [self intoJieSuanViewSkuID:[self.skuAllDic[@"skuId"] integerValue] buycount:self.numButton.currentNum];
                } else {
                    //秒杀购买
                    [self intojiesuanViewMiaoShaBuyingSkuID:[self.skuAllDic[@"skuId"] integerValue] buycount:self.numButton.currentNum miaoshaID:self.timeID];
                }
                
            } else {
                [MBProgressHUD showError:@"库存不足"];
            }
        } else {
            [MBProgressHUD showError:@"请选择规格"];
        }
        
        
    } else if (self.tagBtnArray.count == 1){
        
        if (strvalue1.length > 0) {
            if ([self.skuAllDic[@"quantity"] integerValue] != 0) {
               
                //单独购买
                if (tag == 150) {
                    [self intoJieSuanViewSkuID:[self.skuAllDic[@"skuId"] integerValue] buycount:self.numButton.currentNum];
                } else {
                    //
                     [self intojiesuanViewMiaoShaBuyingSkuID:[self.skuAllDic[@"skuId"] integerValue] buycount:self.numButton.currentNum miaoshaID:self.timeID];
                }
                
            } else {
                [MBProgressHUD showError:@"库存不足"];
            }
        } else {
            [MBProgressHUD showError:@"请选择规格"];
        }
    } else {
        if ([self.dic[@"quantity"] integerValue] != 0) {
            
            
            //单独购买
            if (tag == 150) {
                [self intoJieSuanViewSkuID:[self.dic[@"skuId"] integerValue] buycount:self.numButton.currentNum];
            } else {
                //
                 [self intojiesuanViewMiaoShaBuyingSkuID:[self.dic[@"skuId"] integerValue] buycount:self.numButton.currentNum miaoshaID:self.timeID];
            }
        }else {
            [MBProgressHUD showError:@"库存不足"];
        }
    }
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
                                      title:[NSString stringWithFormat:@"%@  %@",[NSString stringWithFormat:@"¥%.2f",[self.dic[@"discountPrice"] floatValue]],self.dic[@"goodsName"]]
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
    self.title = @"秒杀详情";
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem CreateItemWithTarget:self ForAction:@selector(shareaction) WithImage:@"分享" WithHighlightImage:nil bageLab:@"" ishide:YES];
     self.navigationController.navigationBar.translucent = NO;
    [PriceLine initButton:_backhomeButton];
    [PriceLine initButton:_messagebutton];
    self.personBuyButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.personBuyButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.personBuyButton.titleLabel.numberOfLines = 2;
    self.BuyButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.BuyButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.BuyButton.titleLabel.numberOfLines = 2;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DetailFirstCell" bundle:nil] forCellReuseIdentifier:@"firstCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DetailSecondCell" bundle:nil] forCellReuseIdentifier:@"secondCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DetailThreedCell" bundle:nil] forCellReuseIdentifier:@"DetailThreedCell"];
     [self.tableView registerNib:[UINib nibWithNibName:@"DetailFourCell" bundle:nil] forCellReuseIdentifier:@"DetailFourCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DetailFiveCell" bundle:nil] forCellReuseIdentifier:@"DetailFiveCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DetailSevenCell" bundle:nil] forCellReuseIdentifier:@"DetailSevenCell"];
    
    [self request:[NSString stringWithFormat:@"%@/%ld",seckilDetaukURL,self.timeID]];
    
}
- (void)request:(NSString *)url
{
     [self showProgressHUD];
    [PPNetworkHelper GET:url parameters:@{} success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0){
            self.dic = responseObject[@"map"][@"goods"];
            //设置购买按钮状态
            if ([self.timebuyStr isEqualToString:@"抢购中"]) {
                [_BuyButton setTitle:[NSString stringWithFormat:@"¥%.2f\n去抢购",[self.dic[@"discountPrice"] floatValue]] forState:(UIControlStateNormal)];
            } else if ([self.timebuyStr isEqualToString:@"即将开始"]){
                [_BuyButton setTitle:[NSString stringWithFormat:@"¥%.2f\n即将开始",[self.dic[@"discountPrice"] floatValue]] forState:(UIControlStateNormal)];
                _BuyButton.userInteractionEnabled = NO;
                _BuyButton.backgroundColor = [UIColor lightGrayColor];
            } else if ([self.timebuyStr isEqualToString:@"已经结束"]){
                [_BuyButton setTitle:[NSString stringWithFormat:@"¥%.2f\n已经结束",[self.dic[@"discountPrice"] floatValue]] forState:(UIControlStateNormal)];
                _BuyButton.userInteractionEnabled = NO;
                _BuyButton.backgroundColor = [UIColor lightGrayColor];
            }
            //单独购买
            [self.personBuyButton setTitle:[NSString stringWithFormat:@"%.2f\n单独购买",[self.dic[@"groupBuyPrice"] floatValue]] forState:(UIControlStateNormal)];
            
            
            //轮播图
            NSString *str;
            for (int i = 1 ; i < 7; i ++) {
                str = [NSString stringWithFormat:@"picServerUrl%d",i];
                if (![self.dic[str] isEqualToString:@""] && self.dic[str] != nil) {
                    [self.PicArr addObject:self.dic[str]];
                }
            }
            //tag
            if ([self.dic[@"skuList1"] count] != 0 && [self.dic[@"skuList2"] count] != 0) {
                NSMutableArray *skuarr = [NSMutableArray new];
                [skuarr addObject:self.dic[@"skuList1"][0]];
                [skuarr addObject:self.dic[@"skuList2"][0]];
                
                for (NSDictionary *dic1 in skuarr) {
                    DetailTimeModel *model = [DetailTimeModel new];
                    [model setValuesForKeysWithDictionary:dic1];
                    [self.tagBtnArray addObject:model];
                }
                
            } else if ([self.dic[@"skuList1"] count] != 0 || [self.dic[@"skuList2"] count] != 0){
                
                DetailTimeModel *model = [DetailTimeModel new];
                [model setValuesForKeysWithDictionary:self.dic[@"skuList1"][0]];
                [self.tagBtnArray addObject:model];
                
                
            } else {
                
            }
            //评论
            for (NSDictionary *dic in self.dic[@"rateList"][@"list"]) {
                ContentModel *model = [ContentModel new];
                [model setValuesForKeysWithDictionary:dic];
                [self.contentArray addObject:model];
            }
        }
        //createHeaderView
        [self createHeaderView];
        
       
        [self hideProgressHUD];
        [self.tableView reloadData];
        
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(-5, 0, SCREEN_WIDTH, 1)];
        _webView.delegate = self;
       
        _webView.scrollView.scrollEnabled = NO;
        
        //预先加载url
        [self.webView loadHTMLString:self.dic[@"detail"] baseURL:nil];
        
        
    } failure:^(NSError *error) {
        
    }];
}
- (void)createHeaderView
{
    if (isiPhone5or5sor5c) {
        self.sdc = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 64, 320, 250) imageURLStringsGroup:_PicArr];
        self.sdc.delegate = self;
        self.tableView.tableHeaderView = self.sdc;
    }else {
        self.sdc = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 64, SCREEN_HEIGHT, 300) imageURLStringsGroup:_PicArr];
        self.sdc.delegate = self;
        self.tableView.tableHeaderView = self.sdc;
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.tagBtnArray.count + 3;
    }else if(section == 1) {
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
            cell.priceLab.text = [NSString stringWithFormat:@"¥%.2f",[self.dic[@"discountPrice"] floatValue]];
            return cell;
        } else if(indexPath.row == 1) {
            DetailSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:@"secondCell" forIndexPath:indexPath];
            cell.leftLab.text = [NSString stringWithFormat:@"销量:%ld",[self.dic[@"salesNum"] integerValue]];
            cell.centerLab.text = self.dic[@"wetherPostage"];
            cell.rightLab.text = self.dic[@"sendAddress"];
            return cell;
        } else if (indexPath.row == self.tagBtnArray.count + 2){
            //此时是最后一个cell
            DetailFourCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailFourCell" forIndexPath:indexPath];
            cell.numberLab.text = [NSString stringWithFormat:@"库存:%ld件",[self.dic[@"quantity"] integerValue]];
           
            self.numButton = [[HJCAjustNumButton alloc] init];
            self.numButton.frame = CGRectMake(0, 0, 95, 30);
             self.numButton.currentNum = @"1";
            self.numButton.delegate = self;
            [cell.PriceView addSubview:self.numButton];
            // 内容更改的block回调
            self.numButton.callBack = ^(NSString *currentNum){
                NSLog(@"%@", currentNum);
            };
            return cell;
        } else {
            DetailThreedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailThreedCell" forIndexPath:indexPath];
            
            cell.leftLab.text = [self.tagBtnArray[indexPath.row - 2] name];
            DetailTimeModel *model =  self.tagBtnArray[indexPath.row - 2];
            
            NSMutableArray *arr = [NSMutableArray new];
            for (subTimeDetailModel *newmodel in model.timeArr) {
                [arr addObject:newmodel.value];
            }
            tagView = [[DetailTagView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - CGRectGetMaxX(cell.leftLab.frame) + 20, cell.BtnView.frame.size.height) dataArr:arr];
            tagView.delegegate = self;
            
            tagView.tag = 1000+indexPath.row - 2;
            
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


//标签按钮点击事件
- (void)buttonClickAction:(NSString *)btnStr
{
    if (self.tagBtnArray.count == 2) {
        DetailTimeModel *model =  self.tagBtnArray[0];
        for (subTimeDetailModel *newmodel in model.timeArr) {
            if ([newmodel.value isEqualToString:btnStr]) {
                strvalue1 = btnStr;
            }
        }
        DetailTimeModel *newmodel1 = self.tagBtnArray[1];
        for (subTimeDetailModel *newmodel in newmodel1.timeArr) {
            if ([newmodel.value isEqualToString:btnStr]) {
                strvalue2 = btnStr;
            }
        }
        //请求
        [self requestfortagBtnAction:strvalue1 value2:strvalue2];
        
        
    } else if (self.tagBtnArray.count == 1){
        strvalue1 = btnStr;
        [self requestfortagBtnAction:btnStr value2:nil];
    }
}

//规格选择请求
- (void)requestfortagBtnAction:(NSString *)value1 value2:(NSString *)value2
{
    NSString *url;
    if (value2) {
        url = [NSString stringWithFormat:@"%@?id=%ld&skuValue1=%@&skuValue2=%@",seckilgetSkuInfoURL,self.timeID,value1,value2];
    } else {
        url = [NSString stringWithFormat:@"%@?id=%ld&skuValue1=%@",seckilgetSkuInfoURL,self.timeID,value1];
    }
    
    NSString *str1 = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [PPNetworkHelper GET:str1 parameters:@{} success:^(id responseObject) {
        
        self.skuAllDic = responseObject[@"map"][@"goods"];
        //第二个row
        DetailSecondCell *secCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        secCell.leftLab.text = [NSString stringWithFormat:@"销量:%ld",[responseObject[@"map"][@"goods"][@"salesNum"] integerValue]];
        
        
        //最后一个row
        DetailFourCell *fourcell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.tagBtnArray.count + 2 inSection:0]];
        
        fourcell.numberLab.text = [NSString stringWithFormat:@"库存:%ld件", [responseObject[@"map"][@"goods"][@"quantity"] integerValue]];
        
        //单独购买
        [self.personBuyButton setTitle:[NSString stringWithFormat:@"¥%.2f\n单独购买", [responseObject[@"map"][@"goods"][@"groupBuyPrice"] floatValue]] forState:(UIControlStateNormal)];
        
    } failure:^(NSError *error) {
        
    }];
}


- (void)clickButtonAction:(UIButton *)sender
{
    NSLog(@"%ld",sender.tag);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 120;
        } else if(indexPath.row == 1) {
            return 40;
        } else if (indexPath.row == self.tagBtnArray.count + 2){
            return 50;
        } else {
            
            if (self.tagBtnArray.count == 0) {
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
        
        //22是Label 上下约束之和
        //2是NSStringDrawingUsesLineFragmentOrigin属性不包括线条的宽度，所以这里需要添加上下两条线条的宽度
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
        lab.font = [UIFont fontWithName:@"CourierNewPSMT" size:15.0];
        lab.text = @"—————— 没有更多了哦 ——————";
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
                        "document.getElementsByTagName('p')[0].appendChild(script);",self.view.frame.size.width];
    
    //添加JS
    [webView stringByEvaluatingJavaScriptFromString:script];
    
    //添加调用JS执行的语句
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    //获取到webview的高度
    CGFloat height = [[self.webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
   
    self.webView.frame = CGRectMake(self.webView.frame.origin.x,self.webView.frame.origin.y, SCREEN_WIDTH, height);
    [self.tableView reloadData];
}


@end
