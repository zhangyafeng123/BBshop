//
//  PresentViewController.m
//  BBShopping
//
//  Created by mibo02 on 17/2/18.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "PresentViewController.h"
#import "PresentCell.h"
#import "PresentModel.h"
@interface PresentViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, copy)NSString *numberStr;
@property (nonatomic, copy)NSString *password;
@property (nonatomic, strong)UILabel *priceLab;
@end

@implementation PresentViewController
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray new];
    }
    return _dataArray;
}
//添加礼品卡点击事件
- (IBAction)buttonAction:(UIButton *)sender {
    
    if ([UserInfoManager isLoading]) {
        
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"添加礼品卡" message:@"" preferredStyle:(UIAlertControllerStyleAlert)];
        [alertC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            
            textField.placeholder = @"请输入礼品卡卡号";
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
            
        }];
        [alertC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"请输入密码";
            textField.secureTextEntry = YES;
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *okaction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            //请求
            [self requestForAddPresent];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
        }];
        
        [alertC addAction:cancel];
        [alertC addAction:okaction];
        [self presentViewController:alertC animated:YES completion:nil];
    } else {
        [MBProgressHUD showSuccess:@"未登录"];
    }

   
}
- (void)alertTextFieldDidChange:(NSNotification *)not
{
     UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    if (alertController) {
        self.numberStr = alertController.textFields.firstObject.text;
        self.password = alertController.textFields.lastObject.text;
    }
}
//获取礼品卡信息
- (void)requestForAddPresent
{
    if (self.numberStr.length == 0) {
        
        [MBProgressHUD showError:@"礼品卡卡号不能为空"];
    } else if (self.password.length == 0){
//        [NSThread sleepForTimeInterval:2];
//        [MBProgressHUD showError:@"请填写正确的密码"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请填写正确的密码" message:@"" delegate:self cancelButtonTitle:@"重新填写" otherButtonTitles:@"", nil];
        [alert show];
      
    } else {
        [self  showProgressHUD];
    [PPNetworkHelper setValue:[UserInfoManager getUserInfo].token forHTTPHeaderField:@"token"];
    [PPNetworkHelper POST:AddPresentURL parameters:@{ @"cardNo":self.numberStr, @"cardPassword":self.password } success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 9902) {
         
            [MBProgressHUD showError:responseObject[@"message"]];
        
        } else if ([responseObject[@"code"] integerValue] == 0){
            //
            [MBProgressHUD showError:@"添加成功"];
           
            [self.tableview reloadData];
        } else if ([responseObject[@"code"] integerValue] == 9902){
            
            [MBProgressHUD showError:responseObject[@"message"]];
           
        }
        [self hideProgressHUD];
        
    } failure:^(NSError *error) {
        
    }];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"礼品卡";
    [self.tableview registerNib:[UINib nibWithNibName:@"PresentCell" bundle:nil] forCellReuseIdentifier:@"presentCell"];
    
    self.tableview.emptyDataSetSource = self;
    self.tableview.emptyDataSetDelegate = self;
    [self createHeader];
    
    //请求礼品卡列表
    [self requestList];
    
}
- (void)requestListForInfomation:(NSInteger)inforid
{
    [PPNetworkHelper GET:[NSString stringWithFormat:@"%@?id=%ld",GetPresentInfomationURL,inforid] parameters:@{} success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            self.priceLab.text = [NSString stringWithFormat:@"¥%.2f",[responseObject[@"map"][@"giftCard"][@"cardBalance"] floatValue]];
        }
        
    } failure:^(NSError *error) {
        
    }];
}
- (void)requestList
{
    if ([UserInfoManager isLoading]) {
        [PPNetworkHelper setValue:[UserInfoManager getUserInfo].token forHTTPHeaderField:@"token"];
        [PPNetworkHelper GET:GetGiftCardListURL parameters:@{} success:^(id responseObject) {
            
            if ([responseObject[@"code"] integerValue] == 0) {
                for (NSDictionary *dic in responseObject[@"map"][@"giftCardList"]) {
                    PresentModel *model = [PresentModel new];
                    [model setValuesForKeysWithDictionary:dic];
                    [self.dataArray addObject:model];
                }
                if (self.dataArray.count != 0) {
                    //获取礼品卡信息
                    [self requestListForInfomation:[self.dataArray[0] id]];
                }
                
            }
            [self.tableview reloadData];
            
        } failure:^(NSError *error) {
            
        }];
    } else {
        [MBProgressHUD showError:@"请登录"];
    }
   
}

- (void)createHeader
{
    UIImageView *headV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 130)];
    headV.image = [UIImage imageNamed:@"present"];
   
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(30, 30, SCREEN_WIDTH - 60, 20)];
    lab.text = @"礼品卡余额";
    lab.textAlignment = NSTextAlignmentCenter;
    [headV addSubview:lab];
    
    self.priceLab = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(lab.frame) + 10, SCREEN_WIDTH - 60, 30)];
    self.priceLab.text = @"¥----";
    self.priceLab.font = [UIFont systemFontOfSize:30];
    self.priceLab.textAlignment = NSTextAlignmentCenter;
    [headV addSubview:self.priceLab];
    self.tableview.tableHeaderView = headV;
    
  
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PresentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"presentCell" forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self requestListForInfomation:[self.dataArray[indexPath.row] id]];
}


//返回标题
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂时没有礼品卡";
    UIFont *font = [UIFont systemFontOfSize:14];
    UIColor *color = [UIColor blackColor];
    NSMutableDictionary *attribult = [NSMutableDictionary new];
    [attribult setObject:font forKey:NSFontAttributeName];
    [attribult setObject:color forKey:NSForegroundColorAttributeName];
    return [[NSAttributedString alloc] initWithString:text attributes:attribult];
}
//详情标题（返回详情标题）
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"去添加一张吧~";
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    [attributes setObject:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName];
    [attributes setObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
    [attributes setValue:paragraph forKey:NSParagraphStyleAttributeName];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
    return attributeString;
}
//
//返回单张图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    
    return [UIImage imageNamed:@"无礼品卡"];
    
}



@end
