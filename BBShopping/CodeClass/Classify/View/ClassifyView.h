//
//  ClassifyView.h
//  BBShopping
//
//  Created by mibo02 on 17/2/10.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MonTitleViewButton.h"
@class ClassifyView;
@protocol ClassifyViewDelegate <NSObject>

- (void)clickClassifyViewButtonAction:(NSInteger)index classView:(ClassifyView *)classView;

@end

@interface ClassifyView : UIView
@property (nonatomic, assign)id<ClassifyViewDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
@property (weak, nonatomic) IBOutlet MonTitleViewButton *secondBtn;
@property (weak, nonatomic) IBOutlet MonTitleViewButton *thridBtn;
@property (weak, nonatomic) IBOutlet UIButton *fourBtn;


@end
