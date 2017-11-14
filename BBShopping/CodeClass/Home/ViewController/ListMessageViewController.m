//
//  ListMessageViewController.m
//  BBShopping
//
//  Created by mibo02 on 17/3/22.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "ListMessageViewController.h"
#import "MessageViewController.h"
#import "kefuViewController.h"
#import "MessageWuLiuViewController.h"
@interface ListMessageViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ListMessageViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息中心";
    self.navigationController.navigationBar.translucent = NO;
    self.tableView.scrollEnabled = NO;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"message";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:str];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    if (indexPath.row == 0) {
//        cell.textLabel.text = @"通知中心";
//        cell.detailTextLabel.text = @"欢迎加入邦邦购!在这里你可以放心购买。";
//        cell.imageView.image = [UIImage imageNamed:@"通知-(1)"];
//    } else if (indexPath.row == 1){
        cell.textLabel.text = @"客服中心";
        cell.detailTextLabel.text = @"客服在线时间为09:00-24.00";
        cell.imageView.image = [UIImage imageNamed:@"客服-(1)"];
//    } else {
//        cell.textLabel.text = @"物流提示";
//        cell.detailTextLabel.text = @"已经被签收了，快拆开包裹看看";
//        cell.imageView.image = [UIImage imageNamed:@"物流"];
//    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row == 0) {
//        MessageViewController *message = [MessageViewController new];
//        [self.navigationController pushViewController:message animated:YES];
//    } else if (indexPath.row == 1){
        kefuViewController *kefu = [kefuViewController new];
        [self.navigationController pushViewController:kefu animated:YES];
//    } else {
//        MessageWuLiuViewController *wuliu = [MessageWuLiuViewController new];
//        [self.navigationController pushViewController:wuliu animated:YES];
//    }
}

@end
