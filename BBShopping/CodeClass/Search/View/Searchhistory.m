//
//  Searchhistory.m
//  BBShopping
//
//  Created by mibo02 on 17/2/6.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "Searchhistory.h"

@implementation Searchhistory

- (instancetype)initWithFrame:(CGRect)frame dataArr:(NSArray *)array hide:(BOOL)hide backColor:(UIColor *)backcolor TextStr:(NSString *)textstr heightV:(CGFloat)orginForV
{
    if (self = [super initWithFrame:frame]) {
        //历史记录
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 60, 40)];
        lab.text = textstr;
        lab.textAlignment = NSTextAlignmentLeft;
        lab.font = H15;
        [self addSubview:lab];
        //删除按钮
        UIButton  *deleteBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        deleteBtn.hidden = hide;
        deleteBtn.frame = CGRectMake(CGRectGetMaxX(lab.frame), 10, 25, 40);
        [deleteBtn setImage:[UIImage imageNamed:@"删除"] forState:(UIControlStateNormal)];
       
        [deleteBtn addTarget:self action:@selector(deleteBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:deleteBtn];
        for (int i = 0; i < array.count; i++) {
            NSString *name = array[i];
            static UIButton *recordBtn = nil;
            UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
            CGRect rect = [name boundingRectWithSize:CGSizeMake(self.frame.size.width - 20, 30) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:btn.titleLabel.font} context:nil];
            CGFloat BtnW = rect.size.width + 10;
            CGFloat BtnH = rect.size.height + 10;
            [btn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
            if (i == 0)
            {
                btn.frame = CGRectMake(0, 50, BtnW, BtnH);
            } else {
                CGFloat yuWidth = self.frame.size.width - 20 - recordBtn.frame.origin.x - recordBtn.frame.size.width;
                if (yuWidth >= rect.size.width) {
                    btn.frame = CGRectMake(recordBtn.frame.origin.x + recordBtn.frame.size.width + 10, recordBtn.frame.origin.y, BtnW, BtnH);
                } else {
                    btn.frame = CGRectMake(0, recordBtn.frame.origin.y + recordBtn.frame.size.height + 10, BtnW, BtnH);
                }
            }
            btn.backgroundColor = backcolor;
            [btn setTitle:name forState:(UIControlStateNormal)];
            btn.titleLabel.font = H15;
            [self addSubview:btn];
            self.frame = CGRectMake(10, orginForV, SCREEN_WIDTH - 20, CGRectGetMaxY(btn.frame)+10);
           
            recordBtn = btn;
            btn.tag = 100 + i;
            [btn addTarget:self action:@selector(BtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
            
            
        }
    }
    return self;
}

- (void)deleteBtnAction:(UIButton *)sender
{
    //执行代理
    if ([self.delegegate respondsToSelector:@selector(buttonDeleteAction:)]) {
        [self.delegegate buttonDeleteAction:sender];
    }
}

- (void)BtnClick:(UIButton *)sender
{
    if ([self.delegegate respondsToSelector:@selector(buttonClickAction:)]) {
        [self.delegegate buttonClickAction:sender.titleLabel.text];
    }
}
@end
