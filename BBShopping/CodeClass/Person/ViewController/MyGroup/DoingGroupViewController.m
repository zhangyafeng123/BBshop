//
//  DoingGroupViewController.m
//  BBShopping
//
//  Created by mibo02 on 17/3/16.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "DoingGroupViewController.h"
#import "PinTuanCell.h"
#import "pintuanTwoCell.h"
#import "pintuanModel.h"
#import "pintuanNewCell.h"
#import "JieSuanViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
// 弹出分享菜单需要导入的头文件
#import <ShareSDKUI/ShareSDK+SSUI.h>
// 自定义分享菜单栏需要导入的头文件
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>

#import <ShareSDKUI/SSUIEditorViewStyle.h>

@interface DoingGroupViewController ()
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)NSDictionary *dic;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionview;

@property (nonatomic, copy)NSString *url;

@end

@implementation DoingGroupViewController
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray new];
    }
    return _dataArray;
}
- (IBAction)moreButton:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"group" object:nil];
}

- (IBAction)shareButton:(UIButton *)sender
{
    
    MyGroupsubModel *model = self.doingModel.groupArray[0];
    NSString *wechaturl = [NSString stringWithFormat:@"https://bbgmall.wb1688.com/activity/groupon/20187/%ld?template=esmall",self.doingModel.activityGoodsLimitId];
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray = @[model.goodsPicurl];
    
   // （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    [shareParams SSDKSetupShareParamsByText:@"邦邦购，安心食品购买平台"
                                     images:imageArray
                                        url:[NSURL URLWithString:wechaturl]
                                      title:[NSString stringWithFormat:@"我刚才发现了一个超值好货，赶紧来跟我一起拼团吧! %@",model.goodsName]
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

- (IBAction)cantuanButton:(UIButton *)sender
{
    JieSuanViewController *jiesuan = [JieSuanViewController new];
    jiesuan.orderShopArray = [@[@{@"buyCount":@1,@"grouponId":@(self.doingModel.grouponId),@"skuId":@([self.dic[@"skuId"] integerValue]),@"groupId":@([self.dic[@"groupId"] integerValue])}] mutableCopy];
    [self.navigationController pushViewController:jiesuan animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"拼团中";
    self.navigationController.navigationBar.translucent = NO;
    [self.collectionview registerNib:[UINib nibWithNibName:@"PinTuanCell" bundle:nil] forCellWithReuseIdentifier:@"pintuan"];
    [self.collectionview registerNib:[UINib nibWithNibName:@"pintuanTwoCell" bundle:nil] forCellWithReuseIdentifier:@"pintuancell"];
    [self.collectionview registerNib:[UINib nibWithNibName:@"pintuanNewCell" bundle:nil] forCellWithReuseIdentifier:@"newcell"];
    [self.collectionview registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self request];

}
- (void)request
{
    NSString *newurl  = [NSString stringWithFormat:@"%@%ld/%ld?token=%@",grouponDetailURL,self.doingModel.grouponId,self.doingModel.activityGoodsLimitId,[UserInfoManager getUserInfo].token];
    self.url = newurl;
    
    [self showProgressHUD];
    [PPNetworkHelper GET:newurl parameters:@{} success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 0) {
            
         
            self.dic = responseObject[@"map"][@"goods"];
            for (NSDictionary *newdic in responseObject[@"map"][@"goods"][@"memberList"]) {
                pintuanModel *model = [pintuanModel new];
                [model setValuesForKeysWithDictionary:newdic];
                [self.dataArray addObject:model];
            }
            
        }
        [self.collectionview reloadData];
        [self hideProgressHUD];
    } failure:^(NSError *error) {
        
    }];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 2) {
        return self.dataArray.count;
    } else if (section == 1){
        return self.dataArray.count + [self.dic[@"groupNumber"] integerValue];
    } else {
        return 1;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        PinTuanCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"pintuan" forIndexPath:indexPath];
        cell.titleLab.text = self.dic[@"goodsName"];
        [cell.imageV sd_setImageWithURL:[NSURL URLWithString:self.dic[@"picServerUrl1"]]];
        cell.subtitleLab.text = @"";
        
        cell.priceLab.text = [NSString stringWithFormat:@"拼团价:¥%.2f",[self.dic[@"discountPrice"] floatValue]];
        
        return cell;
    } else if(indexPath.section == 1){
        pintuanNewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"newcell" forIndexPath:indexPath];
        if (indexPath.row == 0) {
            cell.smallbutton.hidden = NO;
        } else {
            cell.smallbutton.hidden = YES;
        }
        if (indexPath.row < self.dataArray.count) {
            [cell.bigimage sd_setImageWithURL:[NSURL URLWithString:[self.dataArray[indexPath.row] headImgUrl]] placeholderImage:[UIImage imageNamed:@"chengyuan"]];
        }
        
        return cell;
    } else {
        pintuanTwoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"pintuancell" forIndexPath:indexPath];
        pintuanModel *model = self.dataArray[indexPath.row];
        [cell.lastImg sd_setImageWithURL:[NSURL URLWithString:model.headImgUrl]];
        if (model.whetherHead == 1) {
            
            cell.titlelab.text = [NSString stringWithFormat:@"团长%@%@开团",model.nickName,model.createTime];
        } else {
            cell.titlelab.text = [NSString stringWithFormat:@"团员%@%@开团",model.nickName,model.createTime];
        }
        
        return cell;
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (isiPhone5or5sor5c) {
            return CGSizeMake(320, 100);
        } else {
            return CGSizeMake(SCREEN_WIDTH, 100);
        }
    } else if (indexPath.section == 1){
        return CGSizeMake(45, 45);
    } else {
        if (isiPhone5or5sor5c) {
            return CGSizeMake(320, 60);
        } else {
            return  CGSizeMake(SCREEN_WIDTH, 60);
        }
        
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
    if (indexPath.section == 2) {
    UICollectionReusableView *reusView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
    
        UILabel *toplab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
        toplab.font = H13;
        if ([self.dic[@"groupNumber"] integerValue] != 0) {
            toplab.text = [NSString stringWithFormat:@"还差%ld人",[self.dic[@"groupNumber"] integerValue]];
        }
       
        toplab.textAlignment = NSTextAlignmentCenter;
        [reusView addSubview:toplab];
        
        
        if ([self.dic[@"invalidSeconds"] integerValue] != 0) {
            UILabel *titlab = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 25)];
             titlab.font = [UIFont fontWithName:@"CourierNewPSMT" size:15.0];
            titlab.textAlignment = NSTextAlignmentCenter;
            [reusView addSubview:titlab];
            MZTimerLabel *timerlab = [[MZTimerLabel alloc] initWithLabel:titlab andTimerType:(MZTimerLabelTypeTimer)];
           [timerlab setCountDownTime:[self.dic[@"invalidSeconds"] integerValue]];
            timerlab.timeFormat = @"——剩余 HH时mm分ss秒 结束——";
            
            [timerlab start];
        }
        
    return reusView;
    } else {
        return nil;
    }
    } else {
        return nil;
    }
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        return CGSizeMake(SCREEN_WIDTH, 45);
    } else {
        return CGSizeZero;
    }
    
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 1) {
        return UIEdgeInsetsMake(30, 30, 30, 30);
    } else {
        return UIEdgeInsetsMake(10, 10, 10, 10);
    }
}



@end
