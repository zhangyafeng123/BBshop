//
//  HomepageViewController.m
//  SegmentView
//
//  Created by tom.sun on 16/5/31.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "HomepageViewController.h"
#import "SegmentViewController.h"
#import "ExampleViewController.h"
#import "TimeModel.h"

@interface HomepageViewController ()

@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)NSMutableArray *titleArr;
//显示
@property (nonatomic, strong)NSMutableArray *subtitleArr;
@property (nonatomic, strong)NSMutableArray *TimerArr;

@property (nonatomic, strong)UIImageView *imageV;
@end

@implementation HomepageViewController

- (NSMutableArray *)TimerArr
{
    if (!_TimerArr) {
        self.TimerArr = [NSMutableArray new];
    }
    return _TimerArr;
}

- (NSMutableArray *)titleArr
{
    if (!_titleArr) {
        self.titleArr = [NSMutableArray new];
    }
    return _titleArr;
}
- (NSMutableArray *)subtitleArr
{
    if (!_subtitleArr) {
        self.subtitleArr = [NSMutableArray new];
    }
    return _subtitleArr;
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
    self.title = @"限时秒杀";
    self.view.backgroundColor = [UIColor whiteColor];
    [self request];
    
    if (self.dataArray.count == 0) {
        _imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
        _imageV.image = [UIImage imageNamed:@"秒杀即将开始.jpg"];
        [self.view addSubview:_imageV];
    } else {
        [_imageV removeFromSuperview];
    }
    
}
- (void)request
{
    
    [PPNetworkHelper GET:seckillURL parameters:@{} responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 0) {
            for (NSDictionary *dic in responseObject[@"map"][@"seckillList"]) {
                TimeModel *model = [TimeModel new];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArray addObject:model];
                NSString *str;
                NSString *newStr;
                if (model.status == 1) {
                    str = [NSString stringWithFormat:@"%@\n即将开始",model.name];
                    newStr = @"即将开始";
                } else if (model.status == 2){
                    str  = [NSString stringWithFormat:@"%@\n进行中",model.name];
                    newStr = @"抢购中";
                } else if (model.status == 3){
                    str = [NSString stringWithFormat:@"%@\n已经结束",model.name];
                    newStr = @"已经结束";
                }
                [self.TimerArr addObject:model.name];
                [self.titleArr addObject:str];
                [self.subtitleArr addObject:newStr];
                
                
            }
            
            SegmentViewController *vc = [[SegmentViewController alloc]init];
            
            vc.titleArray = self.titleArr;
            NSMutableArray *controlArray = [[NSMutableArray alloc]init];
            for (int i = 0; i < vc.titleArray.count; i ++) {
                ExampleViewController *vc = [[ExampleViewController alloc]initWithIndex:i title:self.titleArr[i] subtitle:self.subtitleArr[i] timerStr:self.TimerArr[i]];
                
                [controlArray addObject:vc];
                [vc.collectionView reloadData];
            }
            
            if (self.titleArr.count == 2) {
                vc.buttonWidth = SCREEN_WIDTH / 2;
            } else if (self.titleArr.count == 1){
                vc.buttonWidth = SCREEN_WIDTH;
            } else if (self.titleArr.count == 0){
                return ;
            } else {
                vc.buttonWidth = SCREEN_WIDTH / 3;
            }
            
            vc.headViewBackgroundColor = [UIColor darkGrayColor];
            
            vc.subViewControllers = controlArray;
            vc.buttonHeight = 45;
            
            [vc initSegment];
            
            [vc addParentController:self];
        }
    } failure:^(NSError *error) {
        
    }];
}


@end
