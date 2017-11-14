//
//  ClassifyView.m
//  BBShopping
//
//  Created by mibo02 on 17/2/10.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "ClassifyView.h"

@interface ClassifyView ()
@property (nonatomic, strong)NSMutableArray *btnArray;

@end

@implementation ClassifyView
- (NSMutableArray *)btnArray
{
    if (!_btnArray) {
        self.btnArray = [NSMutableArray new];
        [self.btnArray addObject:self.firstBtn];
        [self.btnArray addObject:self.secondBtn];
        [self.btnArray addObject:self.thridBtn];
        [self.btnArray addObject:self.fourBtn];
    }
    return _btnArray;
}

- (IBAction)classifyButtonAction:(UIButton *)sender
{
    
    [self unselecteBtn:sender.tag];
    
    
    if ([self.delegate respondsToSelector:@selector(clickClassifyViewButtonAction:classView:)]) {
        [self.delegate clickClassifyViewButtonAction:sender.tag - 100 classView:self];
    }
    
}
- (void)unselecteBtn:(NSInteger)tags
{
    for (UIButton *btn in self.btnArray) {
        if (btn.tag != tags) {
            [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        } else {
            [btn setTitleColor:[ColorString colorWithHexString:@"#f9cd02"] forState:(UIControlStateNormal)];
        }
    }
  
}



@end
