//
//  QWNViewController.h
//  图片轮播
//
//  Created by allenqu on 16/10/29.
//  Copyright © 2016年 allenqu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QWNViewController : UIViewController <UIScrollViewDelegate>

@property(nonatomic,strong)NSArray *imagesArr;
@property(nonatomic,strong)NSString *index;

@end
