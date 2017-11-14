//
//  BBTabBarViewController.m
//  BBShopping
//
//  Created by mibo02 on 17/1/16.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "BBTabBarViewController.h"
#import "HomeViewController.h"
#import "ClassifyViewController.h"
#import "GroupBuyingViewController.h"
#import "PersonViewController.h"
#import "NewLoginViewController.h"
#import "BBNavViewController.h"
#import "ShopingViewController.h"
#import "OrderViewController.h"
@interface BBTabBarViewController ()

@end

@implementation BBTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.barTintColor = [UIColor whiteColor];
    //首页
    HomeViewController *home = [[HomeViewController alloc] init];
    [self createChildVCWithVC:home TitleTop:@"" TitleBottom:@"首页" Image:@"home" SelectedImage:@"homeselect"];
    //分类
    ClassifyViewController *cla = [ClassifyViewController new];
    [self createChildVCWithVC:cla TitleTop:@"分类" TitleBottom:@"分类" Image:@"classed" SelectedImage:@"classedselect"];
    //团购
    GroupBuyingViewController *group = [GroupBuyingViewController new];
    [self createChildVCWithVC:group TitleTop:@"团购" TitleBottom:@"团购" Image:@"tuangou" SelectedImage:@"tuangouselect"];
    //购物车
    ShopingViewController *shop = [ShopingViewController new];
    [self createChildVCWithVC:shop TitleTop:@"购物车" TitleBottom:@"购物车" Image:@"gouwuche" SelectedImage:@"gouwucheselect"];
    //我的
    PersonViewController *person = [PersonViewController new];
    [self createChildVCWithVC:person TitleTop:@"我的" TitleBottom:@"我的" Image:@"me" SelectedImage:@"meselect"];
    //接受通知。
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(personViewAction) name:@"shopVC" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(personViewActionhome) name:@"homeVC" object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nornalAction) name:@"enterPerson" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupAction) name:@"group" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterordernewsuccess) name:@"ordernewenterorder" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(entersecondAction) name:@"ertersecondpay" object:nil];
}
//进入未支付订单界面
- (void)entersecondAction
{
    self.selectedIndex = 4;
    [self performSelector:@selector(newpaycancelAction) withObject:nil afterDelay:0.5];
}
- (void)newpaycancelAction
{
      [[NSNotificationCenter defaultCenter] postNotificationName:@"newentersecondpay" object:nil];
}
//进入全部订单界面
- (void)enterordernewsuccess
{
    self.selectedIndex = 4;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"othernewertersuccessorderVC" object:nil];
}

- (void)groupAction
{
    self.selectedIndex = 2;
}
//- (void)nornalAction
//{
//    self.selectedIndex = 4;
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"enterLogin" object:nil];
//   
//}
- (void)personViewActionhome
{
    self.selectedIndex = 0;
}
- (void)personViewAction{
    
    self.selectedIndex = 3;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)createChildVCWithVC:(BaseViewController *)childVC TitleTop:(NSString *)title TitleBottom:(NSString *)bottomTitle Image:(NSString *)image SelectedImage:(NSString *)selectedImage
{
    //设置控制器的文字
    childVC.title = title;
    childVC.tabBarItem.title = bottomTitle;
    
    //设置子控制器图片
    childVC.tabBarItem.image = [UIImage imageNamed:image];
    childVC.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[ColorString colorWithHexString:@"#f9cd02"]} forState:(UIControlStateSelected)];

    BBNavViewController *nav = [[BBNavViewController alloc] initWithRootViewController:childVC];
    nav.navigationBar.barTintColor = [UIColor whiteColor];
    [nav.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor blackColor]}];
  
    [self addChildViewController:nav];
}

@end
