//
//  MessageWuLiuViewController.m
//  BBShopping
//
//  Created by mibo02 on 17/3/22.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "MessageWuLiuViewController.h"
#import "wuliuTimeCell.h"
@interface MessageWuLiuViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MessageWuLiuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"物流消息";
    [self.tableView registerNib:[UINib nibWithNibName:@"wuliuTimeCell" bundle:nil] forCellReuseIdentifier:@"timecell"];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    wuliuTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"timecell" forIndexPath:indexPath];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}



@end
