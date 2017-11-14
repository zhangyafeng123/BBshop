//
//  ExampleViewController.m
//  SegmentView
//
//  Created by mibo02 on 17/2/7.
//  Copyright © 2017年 tom.sun. All rights reserved.
//

#import "ExampleViewController.h"
#import "TimeCollectionViewCell.h"
#import "TimeView.h"
#import "TimeDetailViewController.h"
#import "TimeBtnView.h"
#define SCREEN_WIDTH     [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT    [UIScreen mainScreen].bounds.size.height
@interface ExampleViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,TimeBtnViewDelegate>
@property (nonatomic, strong)NSString *titleStr;
@property (nonatomic, strong)NSString *ButtonStr;
@property (nonatomic, strong)NSMutableArray *dataArray;
//model
@property (nonatomic, strong)TimeModel *timeModel;
@property (nonatomic, strong)NSString *timerStr;
@property (nonatomic, strong)MZTimerLabel  *timerLab;
@end

@implementation ExampleViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray new];
    }
    return _dataArray;
}
- (instancetype)initWithIndex:(NSInteger)index title:(NSString *)title subtitle:(NSString *)subtitle timerStr:(NSString *)timerstr
{
    self = [super init];
    if (self) {
        _titleStr = title;
        _ButtonStr = subtitle;
        _timerStr = timerstr;
        [PPNetworkHelper GET:seckillURL parameters:@{} responseCache:^(id responseCache) {
            
        } success:^(id responseObject) {
            
            if ([responseObject[@"code"] integerValue] == 0) {
                TimeModel *model = [TimeModel new];
                [model setValuesForKeysWithDictionary:responseObject[@"map"][@"seckillList"][index]];
                //保存下
                self.timeModel = model;
                
                for (NSDictionary *dic in model.timeArr) {
                     [self.dataArray addObject:dic];
                }
               
            }
            [self.collectionView reloadData];
           
            
            
        } failure:^(NSError *error) {
            
        }];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"TimeView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"timeHeader"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"TimeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TimeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    TimeBtnView *btnView = [[TimeBtnView alloc] init];
    if (isiPhone5or5sor5c) {
        btnView.frame = CGRectMake(0, 0, 145, 30);
    } else {
        btnView.frame = CGRectMake(0, 0, 190, 30);
    }
    
    btnView.delegate = self;
    [cell.buyButton addSubview:btnView];
    btnView.textlab.text = [NSString stringWithFormat:@"剩余%ld件",[self.dataArray[indexPath.item] quantity]];
    [btnView.buyBtn setTitle:self.ButtonStr forState:(UIControlStateNormal)];
    [btnView.buyBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    btnView.buyBtn.tag = 100 + indexPath.row;
    switch (self.timeModel.status) {
        case 1:
        {
            //未开始
            btnView.img.image = [UIImage imageNamed:@"闪电"];
            
            btnView.textlab.textColor = [UIColor lightGrayColor];
            btnView.layer.borderColor = [UIColor lightGrayColor].CGColor;
            btnView.buyBtn.backgroundColor = [UIColor lightGrayColor];
            
            
        }
            break;
        case 2:
        {
            //进行中
            btnView.img.image = [UIImage imageNamed:@"闪电-"];
            btnView.textlab.textColor = [UIColor redColor];
            btnView.layer.borderColor = [UIColor redColor].CGColor;
            btnView.buyBtn.backgroundColor = [UIColor redColor];
            
        }
            break;
        case 3:
        {
            //已结束
            btnView.img.image = [UIImage imageNamed:@"闪电"];
            
            btnView.textlab.textColor = [UIColor lightGrayColor];
            btnView.layer.borderColor = [UIColor lightGrayColor].CGColor;
            btnView.buyBtn.backgroundColor = [UIColor lightGrayColor];
        }
            break;
            
        default:
            break;
    }
    
    cell.subModel = self.dataArray[indexPath.item];
    return cell;
}
- (void)clickBtnAction:(UIButton *)sender
{
    TimeDetailViewController *detail = [TimeDetailViewController new];
    detail.timebuyStr = self.ButtonStr;
    
    detail.timeID = [self.dataArray[sender.tag - 100] id];
    [self.navigationController pushViewController:detail animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (isiPhone5or5sor5c) {
        return CGSizeMake(320, 135);
    } else {
       return CGSizeMake(SCREEN_WIDTH, 135);
    }
    
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_timerLab pause];
    CGFloat f = scrollView.contentOffset.y;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollView" object:nil userInfo:@{@"y":@(f)}];
   
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [_timerLab start];
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    TimeView *reusView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"timeHeader" forIndexPath:indexPath];
   
    //未开始
    if (self.timeModel.status == 1) {
      
        _timerLab = [[MZTimerLabel alloc] initWithLabel:reusView.leftlabel andTimerType:(MZTimerLabelTypeTimer)];
        [_timerLab setCountDownTime:self.timeModel.seconds];
        _timerLab.timeFormat = @"距离本场开始 HH : mm : ss";
        [_timerLab start];
        
     
    } else if (self.timeModel.status == 2){
        //进行中
        
        _timerLab = [[MZTimerLabel alloc] initWithLabel:reusView.leftlabel andTimerType:(MZTimerLabelTypeTimer)];
        
        [_timerLab setCountDownTime:self.timeModel.seconds];
        _timerLab.timeFormat = @"距离本场结束 HH : mm : ss";
        [_timerLab start];
       
    } else if (self.timeModel.status == 3){
        //已结束
        reusView.leftlabel.hidden = YES;
    }
    return reusView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (self.timeModel.status == 1) {
        return CGSizeMake(SCREEN_WIDTH, 60);
    } else if (self.timeModel.status == 2){
        return CGSizeMake(SCREEN_WIDTH, 60);
    } else if (self.timeModel.status == 3){
        if (self.dataArray.count == 0) {
            return CGSizeZero;
        } else {
        return CGSizeMake(SCREEN_WIDTH, 40);
        }
    } else {
        return CGSizeZero;
    }
   
}


@end
