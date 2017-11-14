//
//  PingjiaViewController.m
//  BBShopping
//
//  Created by mibo02 on 17/3/10.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "PingjiaViewController.h"
#import "pingjiaCell.h"
#import "orderDetailModel.h"
@interface PingjiaViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation PingjiaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评价";
    
     self.navigationController.navigationBar.translucent = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"pingjiaCell" bundle:nil] forCellReuseIdentifier:@"pingjia"];
    
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([self.dataArray[0] isKindOfClass:[MyGroupsubModel class]]){
        for (MyGroupsubModel *model in self.dataArray) {
            model.context = textView.text;
            NSLog(@"%@",model.context);
        }
    } else {
        for (orderSubModel *model in self.dataArray) {
            model.context = textView.text;
            NSLog(@"%@",model.context);
        }
    }
    
}
- (IBAction)okbuttonAction:(UIButton *)sender {
    
    
    NSMutableArray *arr  = [NSMutableArray new];
    
    if ([self.dataArray[0] isKindOfClass:[orderDetailModel class]]) {
        for (orderDetailModel *model in self.dataArray) {
            NSLog(@"%@----------%@",model.context,model.score);
            if (model.context.length == 0) {
                [MBProgressHUD showError:@"内容不能为空"];
                return;
            }
            if (model.score.length == 0) {
                [MBProgressHUD showSuccess:@"未评分"];
                return;
            }
            NSDictionary *newdic = @{@"goodsId":[NSString stringWithFormat:@"%ld",model.goodsId],@"rateType":@"1",@"orderNo":model.orderNo,@"context":model.context,@"goodsScore":model.score};
            [arr addObject:newdic];
        }

    } else if ([self.dataArray[0] isKindOfClass:[MyGroupsubModel class]]){
        for (MyGroupsubModel *model in self.dataArray) {
            NSLog(@"%@----------%@",model.context,model.score);
            if (model.context.length == 0) {
                [MBProgressHUD showError:@"内容不能为空"];
                return;
            }
            if (model.score.length == 0) {
                [MBProgressHUD showSuccess:@"未评分"];
                return;
            }
            NSDictionary *newdic = @{@"goodsId":[NSString stringWithFormat:@"%ld",model.id],@"rateType":@"1",@"orderNo":model.orderNo,@"context":model.context,@"goodsScore":model.score};
            [arr addObject:newdic];
        }
    } else {
        for (orderSubModel *model in self.dataArray) {
          
            if (model.context.length == 0) {
                [MBProgressHUD showError:@"内容不能为空"];
                return;
            }
            if (model.score.length == 0) {
                [MBProgressHUD showSuccess:@"未评分"];
                return;
            }
            NSDictionary *newdic = @{@"goodsId":[NSString stringWithFormat:@"%ld",model.goodsId],@"rateType":@"1",@"orderNo":model.orderNo,@"context":model.context,@"goodsScore":model.score};
            [arr addObject:newdic];
        }
    }
    
    
    NSDictionary *dic = @{@"rateList":arr};
    
    [PPNetworkHelper setValue:[UserInfoManager getUserInfo].token forHTTPHeaderField:@"token"];
    [PPNetworkHelper POST:saveRateURL parameters:dic success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(NSError *error) {
        
    }];
  
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    pingjiaCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pingjia" forIndexPath:indexPath];
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:[self.dataArray[indexPath.row] goodsPicurl]]];
    cell.firstLab.text = [self.dataArray[indexPath.row] goodsName];
    cell.secLab.text = [NSString stringWithFormat:@"¥%.2f",[self.dataArray[indexPath.row] goodsPrice]];
    
    cell.textV.delegate = self;
    HCSStarRatingView *starView = [[HCSStarRatingView alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    
    starView.maximumValue = 5;
    starView.minimumValue = 0;
    starView.value = 0;
    starView.tag = 180+indexPath.row;
    starView.tintColor = [ColorString colorWithHexString:@"#f9cd02"];
     [starView addTarget:self action:@selector(didChangeValue:) forControlEvents:UIControlEventValueChanged];
    [cell.starView addSubview:starView];
    return cell;
}
- (void)didChangeValue:(HCSStarRatingView *)sender
{
    if ([self.dataArray[0] isKindOfClass:[orderDetailModel class]]) {
        for (orderDetailModel *model in self.dataArray) {
            model.score = [NSString stringWithFormat:@"%.0f",sender.value];
            NSLog(@"%@",model.score);
        }
    } else  if ([self.dataArray[0] isKindOfClass:[MyGroupsubModel class]]) {
        for (MyGroupsubModel *model in self.dataArray) {
            model.score = [NSString stringWithFormat:@"%.0f",sender.value];
            NSLog(@"%@",model.score);
        }
    } else {
        for (orderSubModel *model in self.dataArray) {
            model.score = [NSString stringWithFormat:@"%.0f",sender.value];
            NSLog(@"%@",model.score);
        }
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 300;
}


@end
