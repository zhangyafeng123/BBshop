//
//  TotalGroupViewController.m
//  BBShopping
//
//  Created by mibo02 on 17/3/17.
//  Copyright © 2017年 mibo02. All rights reserved.
//
#import "orderAllModel.h"
#import "wuliuViewController.h"
#import "TotalGroupViewController.h"
#import "SegmentTapView.h"
#import "FlipTableView.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThreeViewController.h"
#import "FourViewController.h"
#import "MyGroupModel.h"
#import "SuccessGroupViewController.h"
#import "DoingGroupViewController.h"
#import "PingjiaViewController.h"

@interface TotalGroupViewController ()<SegmentTapViewDelegate,FlipTableViewDelegate>
@property (nonatomic, strong)SegmentTapView *segment;
@property (nonatomic, strong)FlipTableView *flipView;
@property (strong, nonatomic) NSMutableArray *controllsArray;


@end

@implementation TotalGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的拼团";
    self.navigationController.navigationBar.translucent = NO;
    [self initSegment];
    [self initFlipTableView];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(grouporderAction:) name:@"grouporder" object:nil];
    //查看物流
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wuliuAction:) name:@"wuliu" object:nil];
    //评价
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pingjiaAction:) name:@"pingjia" object:nil];
    
}
-(void)initSegment{
    self.segment = [[SegmentTapView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40) withDataArray:[NSArray arrayWithObjects:@"全部拼团",@"拼团中",@"拼团成功",@"拼团失败", nil] withFont:15];
    self.segment.delegate = self;
    [self.view addSubview:self.segment];
}
-(void)initFlipTableView{
    if (!self.controllsArray) {
        self.controllsArray = [[NSMutableArray alloc] init];
    }
    
    FirstViewController *first = [[FirstViewController alloc] initWithNibName:@"FirstViewController" bundle:nil];
  
    
    SecondViewController *second = [[SecondViewController alloc] initWithNibName:@"SecondViewController" bundle:nil];
  
    ThreeViewController *three  = [[ThreeViewController alloc] initWithNibName:@"ThreeViewController" bundle:nil];
    
    FourViewController *four = [[FourViewController alloc] initWithNibName:@"FourViewController" bundle:nil];
    
    
    [self.controllsArray addObject:first];
    [self.controllsArray addObject:second];
    [self.controllsArray addObject:three];
    [self.controllsArray addObject:four];
    
    self.flipView = [[FlipTableView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, self.view.frame.size.height - 104) withArray:_controllsArray];
    self.flipView.delegate = self;
    [self.view addSubview:self.flipView];
}
#pragma mark -------- select Index
-(void)selectedIndex:(NSInteger)index
{
    [self.flipView selectIndex:index];
}
-(void)scrollChangeToIndex:(NSInteger)index
{
    [self.segment selectIndex:index];
}
//查看物流
- (void)wuliuAction:(NSNotification *)not
{
    MyGroupModel *model = not.userInfo[@"wuliu"];
    wuliuViewController *wuliu  = [wuliuViewController new];
    wuliu.orderId = model.id;
    [self.navigationController pushViewController:wuliu animated:YES];
}
//评价
- (void)pingjiaAction:(NSNotification *)not
{
    MyGroupModel *model = not.userInfo[@"pingjia"];
    PingjiaViewController *pingjia = [PingjiaViewController new];
    pingjia.dataArray = model.groupArray;
    [self.navigationController pushViewController:pingjia animated:YES];
}
//点击跳转
- (void)grouporderAction:(NSNotification *)not
{
    MyGroupModel *model = not.userInfo[@"model"];
    
    //拼团中跳转的页面
        if (model.grouponStatus == 1) {
            DoingGroupViewController *doing = [DoingGroupViewController new];
            doing.doingModel = model;
            [self.navigationController pushViewController:doing animated:YES];
        } else {//拼团成功或者失败跳转的页面
            SuccessGroupViewController *success = [SuccessGroupViewController new];
            success.groupModel = model;
    
            [self.navigationController pushViewController:success animated:YES];
            
        }
    
}
//删除通知
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
