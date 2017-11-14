//
//  Searchhistory.h
//  BBShopping
//
//  Created by mibo02 on 17/2/6.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchhistoryDelegate <NSObject>
//标签按钮点击事件
- (void)buttonClickAction:(NSString *)btnStr;
//删除按钮点击事件
- (void)buttonDeleteAction:(UIButton *)sender;

@end

@interface Searchhistory : UIView

@property (nonatomic, assign)id<SearchhistoryDelegate>delegegate;

- (instancetype)initWithFrame:(CGRect)frame dataArr:(NSArray *)array hide:(BOOL)hide backColor:(UIColor *)backcolor TextStr:(NSString *)textstr heightV:(CGFloat)orginForV;



@end
