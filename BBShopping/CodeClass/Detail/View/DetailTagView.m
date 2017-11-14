//
//  DetailTagView.m
//  BBShopping
//
//  Created by mibo02 on 17/2/9.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "DetailTagView.h"

@interface DetailTagView ()
@property (nonatomic, strong)NSMutableArray *buttonArr;
@end


@implementation DetailTagView

- (instancetype)initWithFrame:(CGRect)frame dataArr:(NSMutableArray *)array
{
    if (self = [super initWithFrame:frame]) {
        
        for (int i = 0; i < array.count; i++) {
            NSString *name = array[i];
            static UIButton *recordBtn = nil;
            UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
            CGRect rect = [name boundingRectWithSize:CGSizeMake(self.frame.size.width - 20, 25) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:btn.titleLabel.font} context:nil];
            CGFloat BtnW = rect.size.width + 5;
            CGFloat BtnH = rect.size.height + 5;
            btn.layer.masksToBounds = YES;
            btn.layer.cornerRadius = 5;
            btn.layer.borderWidth = 0.5;
            btn.titleLabel.font = H13;
            btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
            [btn setTitleColor:[ColorString colorWithHexString:@"#f9cd02"] forState:(UIControlStateSelected)];
            [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
            
            if (i == 0)
            {
                btn.frame = CGRectMake(0, 0, BtnW, BtnH);
            } else {
                CGFloat yuWidth = self.frame.size.width - 5 - recordBtn.frame.origin.x - recordBtn.frame.size.width;
                if (yuWidth >= rect.size.width) {
                    btn.frame = CGRectMake(recordBtn.frame.origin.x + recordBtn.frame.size.width + 5, recordBtn.frame.origin.y, BtnW, BtnH);
                } else {
                    btn.frame = CGRectMake(0, recordBtn.frame.origin.y + recordBtn.frame.size.height + 5, BtnW, BtnH);
                }
            }
            
            [btn setTitle:name forState:(UIControlStateNormal)];
            [self addSubview:btn];
            self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 120, CGRectGetMaxY(btn.frame)+5);
            recordBtn = btn;
            btn.tag = 100 + i;
            [btn addTarget:self action:@selector(BtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
            
            [self.buttonArr addObject:btn];
        }
    }
    return self;
}


- (void)BtnClick:(UIButton *)sender
{
    
    sender.selected = YES;
    
    [self unselectedAllButton:sender];
    
    if (sender.selected) {
        sender.layer.borderColor = [ColorString colorWithHexString:@"#f9cd02"].CGColor;
    }
    if ([self.delegegate respondsToSelector:@selector(buttonClickAction:)]) {
        [self.delegegate buttonClickAction:sender.titleLabel.text];
    }
    
    
}

//对所有按钮颜色执行反选操作
- (void)unselectedAllButton:(UIButton *)sender
{
    for (UIButton *sbtn in self.buttonArr) {
        if (sbtn == sender) {
            continue;
        }
        sbtn.selected = NO;
        sbtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
}

- (NSMutableArray *)buttonArr
{
    if (!_buttonArr) {
        self.buttonArr = [NSMutableArray new];
    }
    return _buttonArr;
}




@end
