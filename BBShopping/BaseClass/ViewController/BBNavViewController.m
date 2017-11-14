//
//  BBNavViewController.m
//  BBShopping
//
//  Created by mibo02 on 17/1/16.
//  Copyright © 2017年 mibo02. All rights reserved.
//
#import "PersonViewController.h"
#import "BBNavViewController.h"
#import "SearchViewController.h"
#import "xiadanViewController.h"
#import "PresentQueRenZhiFuViewController.h"
#import "SuccessPayViewController.h"
@interface BBNavViewController ()
@property (nonatomic, strong)id popGesture;
@end

@implementation BBNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

// MARK:- 拦截导航控制器的push方法
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    [super pushViewController:viewController animated:animated];  // 重写系统的方法，一般都要进行还原
    
    // 给非根控制器左侧设置按钮
    if (self.viewControllers.count > 1) {  // 如果是非根控制器
        //判断是不是搜索页面
        if ([viewController isKindOfClass:[SearchViewController class]]) {
            viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem CreateItemWithTarget:self ForAction:@selector(backClick) WithImage:@"" WithHighlightImage:nil bageLab:@"" ishide:YES];
        } else if ([viewController isKindOfClass:[xiadanViewController class]] || [viewController isKindOfClass:[PresentQueRenZhiFuViewController class]] || [viewController isKindOfClass:[SuccessPayViewController class]]){

            // 设置返回按钮
            viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem CreateItemWithTarget:self ForAction:@selector(backClicknew) WithImage:@"返回" WithHighlightImage:@"" bageLab:@"" ishide:YES];
            
        } else {
          
                // 设置返回按钮
                viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem CreateItemWithTarget:self ForAction:@selector(backClick) WithImage:@"返回" WithHighlightImage:@"" bageLab:@"" ishide:YES];
        }
    }
}

// MARK:- 左侧返回按钮
- (void)backClick {
    
        // 导航控制器出站，实现返回
        [self popViewControllerAnimated:YES];
   
}

- (void)backClicknew
{
    [self popToRootViewControllerAnimated:YES];
    [self performSelector:@selector(entertoPerson) withObject:nil afterDelay:1];
    
}
- (void)entertoPerson
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ertersecondpay" object:nil];
}

@end
