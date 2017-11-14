//
//  HomeFirstCell.m
//  BBShopping
//
//  Created by mibo02 on 17/1/20.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "HomeFirstCell.h"
#import "HomeModel.h"

@interface HomeFirstCell ()

@end

@implementation HomeFirstCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        UIScrollView *scrollview = [[UIScrollView alloc] init];
        if (isiPhone5or5sor5c) {
           scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, self.frame.size.height)];
           //70
            scrollview.contentSize  = CGSizeMake(20 * 120 + 20, 80);
        } else {
            scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height)];
             scrollview.contentSize  = CGSizeMake(20 * 160 + 20, 100);
        }
        
        scrollview.tag = 1000;
        scrollview.backgroundColor = [UIColor whiteColor];
        //计算宽度
        
        scrollview.showsHorizontalScrollIndicator = YES;
        scrollview.scrollEnabled = YES;
        
        for (int i = 0; i < 20; i++) {
            
            if (isiPhone5or5sor5c) {
                 _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * 130 + 10, 10, 120, 60)];
                 _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(20 + 10, 20, 100 - 10, 20)];
            } else {
               _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * 160 + 10, 10, 150, 80)];
                _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(30, 20, 120, 30)];
            }
            
            
            _imageView.backgroundColor = [UIColor clearColor];
            _imageView.userInteractionEnabled = YES;
            _imageView.tag = 100 + i;
            [scrollview addSubview:_imageView];
            //
            
            _titleLab.textAlignment = NSTextAlignmentCenter;
            _titleLab.font = H13;w
            _titleLab.tag = 120 + i;
            [_imageView addSubview:_titleLab];
            //点击事件
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
            [_imageView addGestureRecognizer:tap];
            
             [self addSubview:scrollview];
        }
  
    }
    return self;
}

//进行重新的赋值
- (void)collectviewCellForArray:(NSMutableArray *)arr
{
    if (arr.count <= 20) {
        UIScrollView *scrollview1 = (UIScrollView *)[self viewWithTag:1000];
        if (isiPhone5or5sor5c) {
             scrollview1.contentSize  = CGSizeMake(arr.count * 130 + 10, 80);
        } else {
           scrollview1.contentSize  = CGSizeMake(arr.count * 160 + 10, 100);
        }
        
        for (int i = 0; i < arr.count; i++) {
            HomeModel *model = arr[i];
            
            UIImageView *imageV = (UIImageView *)[self viewWithTag:100 + i];
            [imageV sd_setImageWithURL:[NSURL URLWithString:model.adpic]];
            //
            UILabel *lab = (UILabel *)[self viewWithTag:120 + i];
            lab.text = model.name;
          
        }

    } else {
        return;
    }
    
}
- (void)tapAction:(UITapGestureRecognizer *)tap
{
    
    if ([self.delegate respondsToSelector:@selector(tapClickAction:)]) {
        [self.delegate tapClickAction:tap.view.tag - 100];
    }
}
@end
