//
//  SuccessGroupViewController.m
//  BBShopping
//
//  Created by mibo02 on 17/3/16.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "SuccessGroupViewController.h"
#import "PinTuanCell.h"
#import "pintuanTwoCell.h"
#import "pintuanModel.h"
#import "pintuanNewCell.h"
#import "JieSuanViewController.h"
@interface SuccessGroupViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (weak, nonatomic) IBOutlet UIButton *groupButton;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)NSDictionary *dic;
@end

@implementation SuccessGroupViewController
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray new];
    }
    return _dataArray;
}
//更多拼团
- (IBAction)moreGroupButtonAction:(UIButton *)sender {
     [[NSNotificationCenter defaultCenter] postNotificationName:@"group" object:nil];
}
//我也要开团
- (IBAction)beginButton:(UIButton *)sender {
    JieSuanViewController *jiesuan = [JieSuanViewController new];
    
    jiesuan.orderShopArray = [@[@{@"buyCount":@1,@"skuId":@([_dic[@"skuId"] integerValue]),@"groupId":@([self.dic[@"groupId"] integerValue])}] mutableCopy];
    
    [self.navigationController pushViewController:jiesuan animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.groupModel.grouponStatus == 2) {
        self.title = @"拼团成功";
        [self.groupButton setTitle:@"我也要开团" forState:(UIControlStateNormal)];
    } else {
        self.title = @"拼团失败";
         [self.groupButton setTitle:@"重新开团" forState:(UIControlStateNormal)];
    }
     
    self.navigationController.navigationBar.translucent = NO;
    [self.collectionView registerNib:[UINib nibWithNibName:@"PinTuanCell" bundle:nil] forCellWithReuseIdentifier:@"pintuan"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"pintuanTwoCell" bundle:nil] forCellWithReuseIdentifier:@"pintuancell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"pintuanNewCell" bundle:nil] forCellWithReuseIdentifier:@"newcell"];
     [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self request];
}
- (void)request
{
    [self.dataArray removeAllObjects];
    [PPNetworkHelper GET:[NSString stringWithFormat:@"%@%ld/%ld?token=%@",grouponDetailURL,self.groupModel.grouponId,self.groupModel.activityGoodsLimitId,[UserInfoManager getUserInfo].token] parameters:@{} success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 0) {
            self.dic = responseObject[@"map"][@"goods"];
            for (NSDictionary *newdic in responseObject[@"map"][@"goods"][@"memberList"]) {
                pintuanModel *model = [pintuanModel new];
                [model setValuesForKeysWithDictionary:newdic];
                [self.dataArray addObject:model];
            }
          
        }
         [self.collectionView reloadData];
        
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
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH- 90, 15, 70, 70)];
        if (self.groupModel.grouponStatus == 2) {
            //成功
            img.image = [UIImage imageNamed:@"groupsuccess"];
        } else {
            //失败
            img.image = [UIImage imageNamed:@"groupfile"];
        }
        [cell.contentView  addSubview:img];
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
    UICollectionReusableView *reusView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    if (indexPath.section == 2) {
        UILabel *titlab = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 25)];
        titlab.textAlignment = NSTextAlignmentCenter;
        titlab.font = [UIFont fontWithName:@"CourierNewPSMT" size:15.0];
        [reusView addSubview:titlab];
        
        
        if (self.groupModel.grouponStatus == 2) {
            
            titlab.text = @"——————全部参团详情——————";
        } else {
            UILabel *toplab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
            toplab.font = H13;
            toplab.textAlignment = NSTextAlignmentCenter;
            [reusView addSubview:toplab];
            if ([self.dic[@"groupNumber"] integerValue] != 0) {
               toplab.text = [NSString stringWithFormat:@"还差%ld人",[self.dic[@"groupNumber"] integerValue]];
            }
           
            titlab.text = @"——————已结束——————";
        }
    }
    
    
    return reusView;

}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
       return CGSizeMake(SCREEN_WIDTH, 50);
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
