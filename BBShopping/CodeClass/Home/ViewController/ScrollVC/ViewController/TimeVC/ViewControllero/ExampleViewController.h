//
//  ExampleViewController.h
//  SegmentView
//
//  Created by mibo02 on 17/2/7.
//  Copyright © 2017年 tom.sun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeModel.h"

@interface ExampleViewController : UIViewController
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

- (instancetype)initWithIndex:(NSInteger)index title:(NSString *)title subtitle:(NSString *)subtitle timerStr:(NSString *)timerstr;

@end
