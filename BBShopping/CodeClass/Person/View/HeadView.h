//
//  HeadView.h
//  BBShopping
//
//  Created by mibo02 on 17/1/16.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HeadViewDelegate <NSObject>

- (void)selectBtnAction:(UIButton *)sender;

@end

@interface HeadView : UIView
@property (nonatomic, assign)id<HeadViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame imageStr:(NSString *)btnImage nickName:(NSString *)nickname;


@end
