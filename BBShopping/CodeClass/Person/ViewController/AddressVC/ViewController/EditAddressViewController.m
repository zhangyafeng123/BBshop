//
//  EditAddressViewController.m
//  BBShopping
//
//  Created by mibo02 on 17/2/20.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "EditAddressViewController.h"
#import "EditAddressCell.h"
#import "AddressdetailCell.h"
#import "AddressFooterV.h"
#import "FLTextView.h"
@interface EditAddressViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong)NSDictionary *editDic;
@property (weak, nonatomic) IBOutlet UIPickerView *pickView;
@property (nonatomic, strong)NSMutableArray *shengArr;
@property (nonatomic, strong)NSMutableArray *shiArr;
@property (nonatomic, strong)NSMutableArray *quArr;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (nonatomic, strong)FLTextView *textV;
@end

@implementation EditAddressViewController

- (IBAction)cancelBtn:(UIButton *)sender {
    [UIView animateWithDuration:0.1 animations:^{
        self.backView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 265);
    }];
}
- (IBAction)okbutton:(UIButton *)sender {
    UITableViewCell *cell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    if (self.provinceStr.length == 0) {
        [MBProgressHUD showError:@"省不能为空"];
        return;
    }
    if (self.cityStr.length == 0) {
        [MBProgressHUD showError:@"市不能为空"];
        return;
    }
    if (self.districtStr.length == 0) {
        [MBProgressHUD showError:@"区不能为空"];
        return;
    }
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%@%@",self.provinceStr,self.cityStr,self.districtStr];
    
    [UIView animateWithDuration:0.1 animations:^{
        self.backView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 265);
    }];
}
- (NSMutableArray *)shengArr
{
    if (!_shengArr) {
        self.shengArr = [NSMutableArray new];
    }
    return _shengArr;
}
- (NSMutableArray *)shiArr
{
    if (!_shiArr) {
        self.shiArr = [NSMutableArray new];
    }
    return _shiArr;
}
- (NSMutableArray *)quArr
{
    if (!_quArr) {
        self.quArr = [NSMutableArray new];
    }
    return _quArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑地址";
    
   //
    [self.tableview registerNib:[UINib nibWithNibName:@"EditAddressCell" bundle:nil] forCellReuseIdentifier:@"EditAddressCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"AddressdetailCell" bundle:nil] forCellReuseIdentifier:@"AddressdetailCell"];
    
   //请求省
    [PPNetworkHelper GET:getLocationURL parameters:@{} success:^(id responseObject) {
        for (NSDictionary *dic in responseObject[@"map"][@"provinceList"]) {
            [self.shengArr addObject:dic[@"value"]];
        }
        [self.pickView reloadAllComponents];
        
    } failure:^(NSError *error) {
        
    }];
    
   
    //获取个人信息
    [self getpersonInfomation];
    //创建保存按钮
    [self createfooter];
}
- (void)getpersonInfomation
{
    if (self.btnstr.length > 0) {
        [self showProgressHUD];
        [PPNetworkHelper setValue:[UserInfoManager getUserInfo].token forHTTPHeaderField:@"token"];
        [PPNetworkHelper GET:[NSString stringWithFormat:@"%@?id=%ld",getAddressURL,self.editid] parameters:@{} success:^(id responseObject) {
            
            if ([responseObject[@"code"] integerValue] == 0) {
                self.editDic = responseObject[@"map"];
            }
            [self.tableview reloadData];
            [self hideProgressHUD];
        } failure:^(NSError *error) {
            
        }];
    }
}
- (void)createfooter
{
    UIView *foot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    foot.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIButton *savebtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    savebtn.frame = CGRectMake(30, 30, SCREEN_WIDTH - 60, 40);
    savebtn.backgroundColor =  [ColorString colorWithHexString:@"#f9cd02"];
    [savebtn setTitle:@"保存" forState:(UIControlStateNormal)];
    [foot addSubview:savebtn];
    if (self.btnstr.length > 0) {
        [savebtn setTitle:_btnstr forState:(UIControlStateNormal)];
    }
    
    [savebtn addTarget:self action:@selector(saveButtonActon:) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.tableview.tableFooterView = foot;
}
//点击保存
- (void)saveButtonActon:(UIButton *)sender
{
    if ([UserInfoManager isLoading]) {
  
    [PPNetworkHelper setValue:[UserInfoManager getUserInfo].token forHTTPHeaderField:@"token"];
    NSLog(@"sendertitle:%@",sender.titleLabel.text);
    if ([sender.titleLabel.text isEqualToString:@"编辑完成"]) {
        
        if (self.nameStr.length ==0) {
            
            self.nameStr  =   self.editDic[@"name"];
        }
        if (self.phoneStr.length == 0) {
          
            self.phoneStr = self.editDic[@"mobile"];
        }

        if (self.detailStr.length == 0) {
           
            self.detailStr = self.editDic[@"address"];
        }
        NSArray *arr = [self getarrayDetail];
       
        if (self.provinceStr.length ==0) {
            self.provinceStr = arr[0];
        }
        if (self.cityStr.length == 0) {
            self.cityStr = arr[1];
        }
        if (self.districtStr.length == 0) {
            self.districtStr = arr[2];
        }
        
        NSDictionary *newdic = @{@"name":_nameStr,@"mobile":_phoneStr,@"province":_provinceStr,@"city":_cityStr,@"district":_districtStr,@"address":_detailStr,@"id":@([self.editDic[@"id"] integerValue])};
        
        [PPNetworkHelper POST:editAddressURL parameters:newdic success:^(id responseObject) {
            
            if ([responseObject[@"code"] integerValue] == 0) {
                
                [self.navigationController popViewControllerAnimated:YES];
                
            } else if ([responseObject[@"code"] integerValue] == 40000){
                [MBProgressHUD showError:responseObject[@"message"]];
            }
        } failure:^(NSError *error) {
            
        }];
        
    } else {
        
        if (self.nameStr.length ==0) {
            [MBProgressHUD showError:@"姓名不能为空"];
            return;
        } else if (self.nameStr.length > 11){
            [MBProgressHUD showError:@"不能超过11位字符"];
            return;
        }
        if (self.phoneStr.length == 0) {
            [MBProgressHUD showError:@"电话不能为空"];
            return;
        }
        if (![self.phoneStr isMobileNumber]) {
            [MBProgressHUD showError:@"请填写正确的手机号"];
            return;
        }
        if (self.cityStr == 0) {
            [MBProgressHUD showError:@"地区不能为空"];
            return;
        }
        if (self.detailStr.length == 0) {
            [MBProgressHUD showError:@"详细地址不能为空"];
            return;
        }
        NSDictionary *dic = @{@"name":_nameStr,@"mobile":_phoneStr,@"province":_provinceStr,@"city":_cityStr,@"district":_districtStr,@"address":_detailStr};
        [PPNetworkHelper POST:addAddressURL parameters:dic success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 9901) {
            [MBProgressHUD showError:responseObject[@"message"]];
        } else if ([responseObject[@"code"] integerValue] == 40000){
            [MBProgressHUD showError:responseObject[@"message"]];
        } else if ([responseObject[@"code"] integerValue] == 0){
            [MBProgressHUD showError:responseObject[@"message"]];
            //调用保存接口
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(NSError *error) {
        
    }];
        
    }
        
    } else {
        [MBProgressHUD showError:@"请登录"];
    }
   
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 100) {
        _nameStr
        = textField.text;
    } else {
        _phoneStr = textField.text;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            EditAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditAddressCell" forIndexPath:indexPath];
            cell.leftLab.text = @"收货人姓名";
            cell.textField.placeholder = @"请输入姓名";
            cell.textField.tag  = 100;
            cell.textField.delegate = self;
            if (self.btnstr.length > 0) {
                cell.textField.text = self.editDic[@"name"];
            }
            return cell;
        }
            break;
        case 1:
        {
            EditAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditAddressCell" forIndexPath:indexPath];
            cell.leftLab.text = @"联系电话";
            cell.textField.delegate = self;
            cell.textField.placeholder = @"请输入电话";
            cell.textField.tag = 101;
            if (self.btnstr.length > 0) {
                cell.textField.text = self.editDic[@"mobile"];
            }
            return cell;
        }
            break;
        case 2:
        {
            static NSString *str = @"address";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:str];
            }
            cell.textLabel.text = @"省、市、区";
            cell.detailTextLabel.font = H15;
            //当编辑进入时候
            cell.detailTextLabel.text = [self getDetail];
            
            return cell;
        }
            break;
        case 3:
        {
            static NSString *str = @"address";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:str];
                
            }
            cell.textLabel.text = @"街道";
                return cell;
        }
            break;
        case 4:
        {
            AddressdetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddressdetailCell" forIndexPath:indexPath];
            self.textV = [[FLTextView alloc] initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH - 10, cell.frame.size.height - 10)];
            if (isiPhone5or5sor5c) {
                self.textV.frame = CGRectMake(5, 5, 310, cell.frame.size.height - 10);
            } else {
                self.textV.frame = CGRectMake(5, 5, SCREEN_WIDTH - 10, cell.frame.size.height - 10);
            }
            [cell.contentView addSubview:self.textV];
            self.textV.text = self.editDic[@"address"];
           
            
            if ([self.editDic[@"address"] length]== 0) {
                 self.textV.placeholder = @"请填写详细地址";
            } else {
                 self.textV.placeholder = @"";
            }
            self.textV.font = H15;
            self.textV.placeholderFont  = H15;
            self.textV.textContentBlock = ^(NSString *str){
               _detailStr = str;
            };
            return cell;
        }
            break;
        default:
           return  [UITableViewCell new];
            break;
    }
}

//详细地址编辑封装
- (NSString *)getDetail
{
    if (self.btnstr.length > 0) {
        NSString *str1, *str2, *str3;
        for (NSDictionary *sheng in self.editDic[@"provinceList"]) {
            if ([sheng[@"selected"] integerValue] == 1) {
                str1 = sheng[@"value"];
            }
        }
        for (NSDictionary *shi in self.editDic[@"cityList"]) {
            if ([shi[@"selected"] integerValue] == 1) {
                str2 = shi[@"value"];
            }
        }
        for (NSDictionary *qu in self.editDic[@"districtList"]) {
            if ([qu[@"selected"] integerValue] == 1) {
                str3 = qu[@"value"];
            }
        }
        
        return  [NSString stringWithFormat:@"%@%@%@",str1,str2,str3];
        
    } else {
        return @"";
    }
}
//将其分割添加到数组中
- (NSArray *)getarrayDetail
{
    if (self.btnstr.length > 0) {
        NSString *str1, *str2, *str3;
        for (NSDictionary *sheng in self.editDic[@"provinceList"]) {
            if ([sheng[@"selected"] integerValue] == 1) {
                str1 = sheng[@"value"];
            }
        }
        for (NSDictionary *shi in self.editDic[@"cityList"]) {
            if ([shi[@"selected"] integerValue] == 1) {
                str2 = shi[@"value"];
            }
        }
        for (NSDictionary *qu in self.editDic[@"districtList"]) {
            if ([qu[@"selected"] integerValue] == 1) {
                str3 = qu[@"value"];
            }
        }
        NSArray *arr = @[str1, str2, str3];
        return arr;
        
    } else {
        return @[];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 4) {
        return 85;
    } else {
        return 44;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
        //键盘回收。
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        [self indextwoaction];
        
    } else if (indexPath.row == 3){
        [MBProgressHUD showError:@"暂无街道"];
    }
}
- (void)indextwoaction
{
    [UIView animateWithDuration:0.1 animations:^{
        self.backView.frame = CGRectMake(0, SCREEN_HEIGHT - 265, SCREEN_WIDTH, 265);
    }];
   
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    AddressFooterV *foot = [[[NSBundle mainBundle] loadNibNamed:@"View" owner:nil options:nil] firstObject];
    if (self.btnstr.length > 0) {
        [foot.saveButton setTitle:_btnstr forState:(UIControlStateNormal)];
    }
    
    [foot.saveButton addTarget:self action:@selector(saveButtonActon:) forControlEvents:(UIControlEventTouchUpInside)];
    
    return foot;
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        if (self.shengArr.count != 0) {
           return self.shengArr.count;
        } else {
            return 0;
        }
        
    } else if (component == 1){
        if (self.shiArr.count != 0) {
             return self.shiArr.count;
        } else {
            return 0;
        }
      
    } else {
        if (self.quArr.count != 0) {
            return self.quArr.count;
        } else {
            return 0;
        }
       
    }
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    if (component == 0) {
        if (self.shengArr[row]) {
            return self.shengArr[row];
        } else {
            return 0;
        }
    
    } else if (component == 1){
        if (self.shiArr.count!= 0) {
          return self.shiArr[row];
        } else {
            return 0;
        }
        
    } else {
        if (self.quArr.count != 0) {
            return self.quArr[row];
        } else {
            return 0;
        }
        
    }
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if (component == 0) {
       
        [self.quArr removeAllObjects];
        
        NSString *url = [NSString stringWithFormat:@"%@?province=%@",getLocationURL,self.shengArr[row]];
        NSString *str1 = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [self.shiArr removeAllObjects];
                [PPNetworkHelper GET:str1 parameters:@{} success:^(id responseObject) {
                    for (NSDictionary *dic in responseObject[@"map"][@"cityList"]) {
                        [self.shiArr addObject:dic[@"value"]];
                    }
                    [self.pickView reloadAllComponents];
                   
            } failure:^(NSError *error) {
        
        }];
       
        //先进行删除
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"sheng"];
        [[NSUserDefaults standardUserDefaults] setObject:self.shengArr[row] forKey:@"sheng"];
        
    } else if (component == 1){
        
     
       
        NSString *url = [NSString stringWithFormat:@"%@?province=%@&city=%@",getLocationURL,[[NSUserDefaults standardUserDefaults] objectForKey:@"sheng"],self.shiArr[row]];
       
        NSString *str1 = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [self.quArr removeAllObjects];
        
        [PPNetworkHelper GET:str1 parameters:@{} success:^(id responseObject) {
            for (NSDictionary *dic in responseObject[@"map"][@"districtList"]) {
                [self.quArr addObject:dic[@"value"]];
            }
            [self.pickView reloadAllComponents];
            
        } failure:^(NSError *error) {
            
        }];
        
    }
    if (component == 1) {
        if (self.shiArr.count != 0) {
            self.cityStr = self.shiArr[row];
        } else {
            return;
        }
        
    } else if (component == 2){
        if (self.quArr.count != 0) {
            self.districtStr = self.quArr[row];
        } else {
            return;
        }
        
    } else {
        if (self.shengArr.count != 0) {
          self.provinceStr = self.shengArr[row];
        } else {
            return;
        }
        
    }
    
   
}


@end
