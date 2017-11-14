//
//  SafeSetViewController.m
//  BBShopping
//
//  Created by mibo02 on 17/1/17.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "SafeSetViewController.h"
#import "SafeFirstViewController.h"
#import "safeMessageViewController.h"
@interface SafeSetViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSArray *arr1;
//@property (nonatomic, strong)NSDictionary *newdic;
@end

@implementation SafeSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"安全设置";
    _arr1 = @[@"设置提现密码",@"忘记提现密码",@"消息提醒设置",@"清除缓存",@"版本"];
    
    UIView *footv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    footv.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btn setTitle:@"退出当前账号" forState:(UIControlStateNormal)];
    btn.backgroundColor = [ColorString colorWithHexString:@"#f9cd02"];
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    btn.frame = CGRectMake(30, 30, SCREEN_WIDTH - 60, 40);
    [btn addTarget:self action:@selector(btnaction) forControlEvents:(UIControlEventTouchUpInside)];
    [footv addSubview:btn];
    self.tableView.tableFooterView = footv;
}

- (void)btnaction
{
    if ([UserInfoManager isLoading]) {
        //请求
        [PPNetworkHelper GET:logoutURL parameters:@{} success:^(id responseObject) {
            if ([responseObject[@"code"] integerValue] == 0) {
                [UserInfoManager cleanUserInfo];
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        } failure:^(NSError *error) {
            
        }];
    } else {
        [MBProgressHUD showError:@"还未登录"];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"safe";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:str];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = _arr1[indexPath.row];
    if (indexPath.row == 4) {
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"V%@",version];
    } else if (indexPath.row == 3){
        NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fM",[self folderSizeAtPath:cachePath]];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        SafeFirstViewController *first = [SafeFirstViewController new];
        first.actionNumber = 0;
        [self.navigationController pushViewController:first animated:YES];
    } else if(indexPath.row == 1){
        SafeFirstViewController *first = [SafeFirstViewController new];
        first.actionNumber = 2;
        [self.navigationController pushViewController:first animated:YES];
    } else if (indexPath.row == 3){
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell.detailTextLabel.text.length != 0) {
            cell.detailTextLabel.text = @"";
            NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
            [self clearCache:cachePath];
            
            [MBProgressHUD showError:@"清除成功"];
        }else{
            [MBProgressHUD showError:@"暂无缓存"];
        }
        
    } else if(indexPath.row == 2){
        safeMessageViewController *message = [safeMessageViewController new];
        [self.navigationController pushViewController:message animated:YES];
    }
    
}

#pragma mark --- 清除缓存
/**计算文件的大小*/
- (float)fileSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size/1024.0/1024.0;
    } else{
        return 0;
    }
}
/**获取文件目录的大小*/
- (float)folderSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    float folderSize;
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            folderSize += [self fileSizeAtPath:absolutePath];
        }
        return folderSize;
    }
    return 0;
}
/**清理缓存*/
- (void)clearCache:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            //可以在这里加入条件过滤不想删除的文件
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
}


@end
