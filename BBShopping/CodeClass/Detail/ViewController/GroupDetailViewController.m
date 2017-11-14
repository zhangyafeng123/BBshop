//
//  GroupDetailViewController.m
//  BBShopping
//
//  Created by mibo02 on 17/2/15.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "GroupDetailViewController.h"
#import "UILabel+YBAttributeTextTapAction.h"
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
#import "DetailGroupCell.h"
#import "DetailGroupModel.h"
#import "AddGroupViewController.h"
#import "WanFaNewViewController.h"
#import "JieSuanViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
// 弹出分享菜单需要导入的头文件
#import <ShareSDKUI/ShareSDK+SSUI.h>
// 自定义分享菜单栏需要导入的头文件
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>

#import <ShareSDKUI/SSUIEditorViewStyle.h>
#import "NewLoginViewController.h"
@interface GroupDetailViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,HJCAjustNumButtonDelegate,UIWebViewDelegate,YBAttributeTapActionDelegate,DetailTagViewDelegate,UIScrollViewDelegate>{
    NSString *strvalue1;
    NSString *strvalue2;
    UIButton *shopButton;
    NSTimer *countDownTimer;
     DetailTagView *tagView;
}

@property (weak, nonatomic) IBOutlet UIButton *backhomeButton;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;

//单独购买按钮
@property (weak, nonatomic) IBOutlet UIButton *personBuyButton;
//去开团
@property (weak, nonatomic) IBOutlet UIButton *groupButton;
//规格字典
@property (nonatomic, strong)NSDictionary *skuAllDic;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//轮播图数组
@property (nonatomic, strong)SDCycleScrollView *sdc;
@property (nonatomic, strong)NSMutableArray *PicArr;
@property (nonatomic, strong)NSMutableDictionary *dic;
@property (nonatomic, strong)NSMutableArray *contentArray;
@property (nonatomic, strong)NSMutableArray *tagBtnArray;
@property (nonatomic, strong)HJCAjustNumButton *numButton;
@property (nonatomic, strong)UIWebView *webView;
@property (nonatomic, strong)NSMutableArray *groupArr;
@property (nonatomic, strong)UIView *backV;
@end

@implementation GroupDetailViewController


/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    QWNViewController *qwnVC = [QWNViewController new];
    qwnVC.imagesArr = self.PicArr;
    qwnVC.index = [NSString stringWithFormat:@"%ld",index];;
    [self presentViewController:qwnVC animated:YES completion:nil];
}
- (NSMutableArray *)groupArr
{
    if (!_groupArr) {
        self.groupArr = [NSMutableArray new];
    }
    return _groupArr;
}
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
//返回首页
- (IBAction)homeback:(UIButton *)sender {
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
//团购购买跳转到结算
- (void)intoJieSuanViewSkuID:(NSInteger)skuid  buycount:(NSString *)buyStr groupID:(NSInteger)groupid
{
    if ([UserInfoManager isLoading]) {
        JieSuanViewController *jiesuan = [JieSuanViewController new];
        jiesuan.orderShopArray = [@[@{@"skuId":@(skuid),@"buyCount":(buyStr),@"groupId":@(groupid)}] mutableCopy];
        
        [self.navigationController pushViewController:jiesuan animated:YES];
    } else {
        NewLoginViewController *login = [NewLoginViewController new];
        [self.navigationController pushViewController:login animated:YES];
    }
   
}


//单独购买
- (IBAction)signbuyBunAction:(UIButton *)sender {
    
     [self buttonForTagAndquantity:sender.tag];
}
//去开团
- (IBAction)groupbuyBtnAction:(UIButton *)sender {
    
     [self buttonForTagAndquantity:sender.tag];
}
//判断规格进行购买
- (void)buttonForTagAndquantity:(NSInteger)tag
{
    if (self.tagBtnArray.count == 2) {
        //选择规格
        if (strvalue1.length > 0 && strvalue2.length > 0) {
            
            if ([self.skuAllDic[@"quantity"] integerValue] != 0) {
                if (tag == 350) {
                    //单独购买结算
                    [self intoJieSuanViewSkuID:[self.skuAllDic[@"skuId"] integerValue] buycount:_numButton.currentNum];
                } else {
                    [self intoJieSuanViewSkuID:[self.skuAllDic[@"skuId"] integerValue] buycount:_numButton.currentNum groupID:[self.dic[@"id"] integerValue]];
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
                if (tag == 350) {
                    [self intoJieSuanViewSkuID:[self.skuAllDic[@"skuId"] integerValue] buycount:_numButton.currentNum];
                } else {
                    [self intoJieSuanViewSkuID:[self.skuAllDic[@"skuId"] integerValue] buycount:_numButton.currentNum groupID:[self.dic[@"id"] integerValue]];
                }
            } else {
                [MBProgressHUD showError:@"库存不足"];
            }
        } else {
            [MBProgressHUD showError:@"请选择规格"];
        }
    } else {
        if ([self.dic[@"quantity"] integerValue] != 0) {
            
            if (tag == 350) {
                [self intoJieSuanViewSkuID:[self.dic[@"skuId"] integerValue] buycount:_numButton.currentNum];
            } else {
                [self intoJieSuanViewSkuID:[self.dic[@"skuId"] integerValue] buycount:_numButton.currentNum groupID:[self.dic[@"id"] integerValue]];
            }
            
        }else {
            [MBProgressHUD showError:@"库存不足"];
        }
    }
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self request];
    [self createbuttonforbacktopAndshopingchart];
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
    self.title = @"团购详情";
     self.navigationItem.rightBarButtonItem = [UIBarButtonItem CreateItemWithTarget:self ForAction:@selector(shareaction) WithImage:@"分享" WithHighlightImage:nil bageLab:@"" ishide:YES];
     self.navigationController.navigationBar.translucent = NO;
    //设置图片在上按钮在下
    [PriceLine initButton:_backhomeButton];
    [PriceLine initButton:_messageButton];
    
    
    self.personBuyButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.personBuyButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.personBuyButton.titleLabel.numberOfLines = 2;
    self.groupButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.groupButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.groupButton.titleLabel.numberOfLines = 2;
    [self.tableView registerNib:[UINib nibWithNibName:@"DetailFirstCell" bundle:nil] forCellReuseIdentifier:@"firstCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DetailSecondCell" bundle:nil] forCellReuseIdentifier:@"secondCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DetailThreedCell" bundle:nil] forCellReuseIdentifier:@"DetailThreedCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DetailFourCell" bundle:nil] forCellReuseIdentifier:@"DetailFourCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DetailFiveCell" bundle:nil] forCellReuseIdentifier:@"DetailFiveCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DetailSevenCell" bundle:nil] forCellReuseIdentifier:@"DetailSevenCell"];
    
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

//请求
- (void)request
{
    [self showProgressHUD];
    NSString *url  = [NSString stringWithFormat:@"%@%ld",groupDetailURL,(long)self.classid];
    [self.PicArr removeAllObjects];
    [PPNetworkHelper GET:url parameters:@{} responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 0){
            self.dic = responseObject[@"map"][@"goods"];
            //单独购买
            [self.personBuyButton setTitle:[NSString stringWithFormat:@"¥%.2f\n单独购买",[self.dic[@"groupBuyPrice"] floatValue]] forState:(UIControlStateNormal)];
            [self.groupButton setTitle:[NSString stringWithFormat:@"¥%.2f\n去开团",[self.dic[@"discountPrice"] floatValue]] forState:(UIControlStateNormal)];
            
            
            //轮播图
            NSString *str;
            for (int i = 1 ; i < 7; i ++) {
                str = [NSString stringWithFormat:@"picServerUrl%d",i];
                if (![self.dic[str] isEqualToString:@""]) {
                    [self.PicArr addObject:self.dic[str]];
                }
            }
            [self.tagBtnArray removeAllObjects];
            [self.groupArr removeAllObjects];
            for (NSDictionary *groupdic in responseObject[@"map"][@"goods"][@"grouponList"]) {
                DetailGroupModel *model = [DetailGroupModel new];
                [model setValuesForKeysWithDictionary:groupdic];
                [self.groupArr addObject:model];
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
        
        
      
        [self.tableView reloadData];
        
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(-5, 0, SCREEN_WIDTH, 1)];
        _webView.delegate = self;
        
        _webView.scrollView.scrollEnabled = NO;
        
        //预先加载url
        [self.webView loadHTMLString:self.dic[@"detail"] baseURL:nil];
        [self hideProgressHUD];
        
    } failure:^(NSError *error) {
        
    }];
}
- (void)createHeaderView
{
    if (isiPhone5or5sor5c) {
        self.sdc = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 64, SCREEN_HEIGHT, 250) imageURLStringsGroup:_PicArr];
    } else {
        self.sdc = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 64, SCREEN_HEIGHT, 300) imageURLStringsGroup:_PicArr];
    }
    
    self.sdc.delegate = self;
    self.tableView.tableHeaderView = self.sdc;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 7;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    }else if(section == 1) {
        return self.groupArr.count;
    } else if(section == 2){
        return self.tagBtnArray.count;
    } else if(section == 3){
        return 1;
    } else if(section == 4){
        return [self.dic[@"paramlist"] count];
    } else if (section == 5){
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
            cell.yuanlab.text = [NSString stringWithFormat:@"¥%.2f",[self.dic[@"groupBuyPrice"] floatValue]];
            cell.yuanlab.attributedText = [PriceLine priceLineMethod:cell.yuanlab.text];
            cell.priceLab.text = [NSString stringWithFormat:@"¥%.2f",[self.dic[@"discountPrice"] floatValue]];
            return cell;
        } else if(indexPath.row == 1) {
            DetailSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:@"secondCell" forIndexPath:indexPath];
            cell.leftLab.text = [NSString stringWithFormat:@"销量:%ld",[self.dic[@"salesNum"] integerValue]];
            cell.centerLab.text = self.dic[@"wetherPostage"];
            cell.rightLab.text = self.dic[@"sendAddress"];
            return cell;
        } else if (indexPath.row == 2){
            
            static NSString *str = @"pintuanwanfa";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:str];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
            NSArray *arr;
            if (isiPhone5or5sor5c) {
                arr = @[H11,H11];
            } else {
                arr = @[H12,H12];
            }
            cell.textLabel.attributedText = [ZLabel attributedTextArray:@[@"支付开通并邀请一人参团，人数不足自动退款，详见",@"拼团玩法"] textColors:@[[UIColor blackColor],[UIColor redColor]] textfonts:arr];
            [cell.textLabel yb_addAttributeTapActionWithStrings:@[@"拼团玩法"] delegate:self];
            cell.textLabel.numberOfLines = 0;
            return cell;
            
        } else {
            static NSString *str = @"tishi";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:str];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = @"小伙伴们正在发起团购，你可以直接参与";
            cell.textLabel.font = [UIFont systemFontOfSize:13];
            return cell;
            
        }
        
    } else if(indexPath.section == 1) {
        static NSString *str = @"cantuan";
        DetailGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[DetailGroupCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:str];
         
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell getgroupforModel:self.groupArr[indexPath.row]];
        return cell;
    } else if(indexPath.section == 2){
        DetailThreedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailThreedCell" forIndexPath:indexPath];
        
        cell.leftLab.text = [self.tagBtnArray[indexPath.row] name];
        DetailTimeModel *model =  self.tagBtnArray[indexPath.row];
        
        NSMutableArray *arr = [NSMutableArray new];
        for (subTimeDetailModel *newmodel in model.timeArr) {
            [arr addObject:newmodel.value];
        }
        tagView = [[DetailTagView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - CGRectGetMaxX(cell.leftLab.frame) + 20, cell.BtnView.frame.size.height) dataArr:arr];
        tagView.delegegate = self;
        
        [cell.BtnView addSubview:tagView];
        
        return cell;
    } else if(indexPath.section == 3){
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
        
    } else if (indexPath.section == 4){
        //
        DetailFiveCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailFiveCell" forIndexPath:indexPath];
        NSArray *arr = self.dic[@"paramlist"];
        cell.oneLab.text = arr[indexPath.row][@"paramName"];
        cell.twoLab.text = arr[indexPath.row][@"paramValue"];
        return cell;
    } else if (indexPath.section == 5){
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
        if (strvalue1.length != 0 && strvalue2.length != 0) {
            //请求
            [self requestfortagBtnAction:strvalue1 value2:strvalue2];
        }
        
        
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
        url = [NSString stringWithFormat:@"%@?id=%ld&skuValue1=%@&skuValue2=%@",clickGroupURL,self.classid,value1,value2];
    } else {
        url = [NSString stringWithFormat:@"%@?id=%ld&skuValue1=%@",clickGroupURL,self.classid,value1];
    }
    
    NSString *str1 = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    [self.groupArr removeAllObjects];
    [PPNetworkHelper GET:str1 parameters:@{} success:^(id responseObject) {
        
        self.skuAllDic = responseObject[@"map"][@"goods"];
        
        //第二个分区
        DetailSecondCell *secCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        secCell.leftLab.text = [NSString stringWithFormat:@"销量:%ld",[self.skuAllDic[@"salesNum"] integerValue]];
        //
        for (NSDictionary *secdic in self.skuAllDic[@"grouponList"]) {
            DetailGroupModel *model  = [DetailGroupModel new];
            [model setValuesForKeysWithDictionary:secdic];
             [self.groupArr addObject:model];
        }
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:(UITableViewRowAnimationFade)];
        
        //最后一个row
        DetailFourCell *fourcell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0   inSection:3]];
        
        fourcell.numberLab.text = [NSString stringWithFormat:@"库存:%ld件", [responseObject[@"map"][@"goods"][@"quantity"] integerValue]];
        
        //单独购买
        [self.personBuyButton setTitle:[NSString stringWithFormat:@"¥%.2f\n单独购买", [responseObject[@"map"][@"goods"][@"groupBuyPrice"] floatValue]] forState:(UIControlStateNormal)];
        
    } failure:^(NSError *error) {
        
    }];
}



/**
 *  YBAttributeTapActionDelegate
 *
 *  @param string  点击的字符串
 *  @param range   点击的字符串range
 *  @param index 点击的字符在数组中的index
 */
- (void)yb_attributeTapReturnString:(NSString *)string
                              range:(NSRange)range
                              index:(NSInteger)index
{
    WanFaNewViewController *wanfa = [WanFaNewViewController new];
    [self.navigationController pushViewController:wanfa animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 120;
        } else if(indexPath.row == 1) {
            return 40;
        } else if (indexPath.row == 2){
            return 50;
        } else {
            return 50;
        }
    } else if(indexPath.section == 1){
        if (isiPhone5or5sor5c) {
            return 70;
        } else {
            return 90;
        }
    } else if(indexPath.section == 2){
        if (self.tagBtnArray.count == 0) {
            return 0;
        } else {
            return tagView.frame.size.height + 10;
        }
    } else if(indexPath.section == 3){
        return 50;
    } else if (indexPath.section == 4){
        //设定字体格式
        NSDictionary*fontDt = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName,nil];
        NSArray *arr = self.dic[@"paramlist"];
        NSString *contentStr = arr[indexPath.row][@"paramValue"];
        CGRect rect = [contentStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 150, 0) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:fontDt context:nil];
        
        return rect.size.height + 17;
    } else if (indexPath.section == 5){
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
    if (section == 6) {
        return 40;
    } else {
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 6) {
        return 60;
    } else {
        return 10;
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UILabel *lab = [[UILabel alloc] init];
    if (section == 6) {
        lab.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
        lab.textAlignment = NSTextAlignmentCenter;
        lab.text = [NSString stringWithFormat:@"商品评论(%ld)",(unsigned long)self.contentArray.count];
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
    if (section == 6) {
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
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:5] withRowAnimation:(UITableViewRowAnimationFade)];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        AddGroupViewController *add = [AddGroupViewController new];
        add.actionId = [self.groupArr[indexPath.row] id];
        add.groupid = [self.dic[@"id"] integerValue];
        [self.navigationController pushViewController:add animated:YES];
    }
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    [cell setClipsToBounds:YES];
}




@end
