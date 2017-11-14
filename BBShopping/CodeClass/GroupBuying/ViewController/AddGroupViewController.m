//
//  AddGroupViewController.m
//  BBShopping
//
//  Created by mibo02 on 17/2/16.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "AddGroupViewController.h"
#import "PinTuanCell.h"
#import "pintuanTwoCell.h"
#import "pintuanModel.h"
#import "pintuanNewCell.h"
#import "JieSuanViewController.h"
#import "NewLoginViewController.h"
@interface AddGroupViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionview;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)NSDictionary *dic;
@end

@implementation AddGroupViewController
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray new];
    }
    return _dataArray;
}
- (IBAction)moreButtonaction:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)addbuttonaction:(UIButton *)sender {
    if ([UserInfoManager isLoading]) {
        //到订单界面
        JieSuanViewController *jiesuan = [JieSuanViewController new];
        
        jiesuan.orderShopArray = [@[@{@"skuId":@([self.dic[@"skuId"] integerValue]),@"buyCount":@(1),@"grouponId":@(self.actionId),@"groupId":@(self.groupid)}] mutableCopy];
        [self.navigationController pushViewController:jiesuan animated:YES];
    } else {
        NewLoginViewController *login = [NewLoginViewController new];
        [self.navigationController pushViewController:login animated:YES];
    }
   
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"参团详情";
    self.navigationController.navigationBar.translucent = NO;
    [self.collectionview registerNib:[UINib nibWithNibName:@"PinTuanCell" bundle:nil] forCellWithReuseIdentifier:@"pintuan"];
    [self.collectionview registerNib:[UINib nibWithNibName:@"pintuanTwoCell" bundle:nil] forCellWithReuseIdentifier:@"pintuancell"];
    [self.collectionview registerNib:[UINib nibWithNibName:@"pintuanNewCell" bundle:nil] forCellWithReuseIdentifier:@"newcell"];
    [self.collectionview registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self request];
}
- (void)request
{
    [PPNetworkHelper GET:[NSString stringWithFormat:@"%@%ld/%ld",groupDetaiAddlURL,self.actionId,self.groupid] parameters:@{} success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            self.dic = responseObject[@"map"][@"goods"];
            for (NSDictionary *newdic in responseObject[@"map"][@"goods"][@"memberList"]) {
                pintuanModel *model = [pintuanModel new];
                [model setValuesForKeysWithDictionary:newdic];
                [self.dataArray addObject:model];
            }
        }
        [self.collectionview reloadData];
        
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
        if (![self.dic[@"skuName1"] isEqualToString:@""] && ![self.dic[@"skuName2"] isEqualToString:@""]) {
            cell.subtitleLab.text = [NSString stringWithFormat:@"%@:%@ %@:%@",self.dic[@"skuName1"],self.dic[@"skuValue1"],self.dic[@"skuName2"],self.dic[@"skuValue2"]];
        } else if (![self.dic[@"skuName1"] isEqualToString:@""]){
             cell.subtitleLab.text = [NSString stringWithFormat:@"%@:%@",self.dic[@"skuName1"],self.dic[@"skuValue1"]];
        } else {
            cell.subtitleLab.text = @"";
        }
        if (self.dic[@"skuName1"] && self.dic[@"skuName2"]) {
            cell.subtitleLab.text = [NSString stringWithFormat:@"%@:%@ %@:%@",self.dic[@"skuName1"],self.dic[@"skuValue1"],self.dic[@"skuName2"],self.dic[@"skuValue2"]];
        } else if (self.dic[@"skuName1"]){
            cell.subtitleLab.text = [NSString stringWithFormat:@"%@:%@",self.dic[@"skuName1"],self.dic[@"skuValue1"]];
        } else {
            cell.subtitleLab.text = @"";
        }
       
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
        
        cell.model = self.dataArray[indexPath.row];
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
                titlab.textAlignment = NSTextAlignmentCenter;
                titlab.font = H14;
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
