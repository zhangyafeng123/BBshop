//
//  SubTitleView.h
//  pageViewControllerUser
//
//  Created by mibo02 on 16/12/12.
//  Copyright © 2016年 mibo02. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SubTitleView;

@protocol SubTitleViewDelegate <NSObject>

//
- (void)findSubTitleViewDidSelected:(SubTitleView *)titleView atIndex:(NSInteger )index title:(NSString *)title;

@end


@interface SubTitleView : UIView


//字标题视图的数据源
@property (nonatomic, strong)NSMutableArray <NSString *> *titleArray;
@property (nonatomic, weak) __weak id<SubTitleViewDelegate> delegate;

- (void)trans2ShowAtIndex:(NSInteger)index;




@end
