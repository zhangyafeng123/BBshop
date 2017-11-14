//
//  SetViewController.m
//  BBShopping
//
//  Created by mibo02 on 17/1/17.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "SetViewController.h"
#import "DateView.h"
#import "sexnewCell.h"
#import "ChangePhoneViewController.h"
@interface SetViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITextFieldDelegate>{
    UIButton *imgButton;
    UITextField *textfield;
}
@property (nonatomic, strong)UIActionSheet *actionSheet;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy)NSString *imgStr;

@property (nonatomic, strong)NSArray *arr;
@property (nonatomic, strong)UIButton *manButton;
@property (nonatomic, strong)UIButton *womenButton;
@property (nonatomic, strong)DateView *dateView;
@end


@implementation SetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _arr = @[@"昵称",@"性别",@"头像",@"出生日期"];
    self.title = @"个人信息";
    self.navigationController.navigationBar.translucent = NO;
    [_tableView registerNib:[UINib nibWithNibName:@"SettingCell" bundle:nil] forCellReuseIdentifier:@"SettingCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"sexnewCell" bundle:nil] forCellReuseIdentifier:@"sexcell"];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *str = @"first";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:str];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"头像";
        imgButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 5, 50, 50)];
        imgButton.layer.cornerRadius = 25;
        imgButton.layer.masksToBounds = YES;
        if (self.setDic[@"headimgurl"]) {
            [imgButton sd_setImageWithURL:[NSURL URLWithString:self.setDic[@"headimgurl"]] forState:(UIControlStateNormal) placeholderImage:[UIImage imageNamed:@"未登录"]];
        }
        [imgButton addTarget:self action:@selector(imgbuttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [cell.contentView addSubview:imgButton];
        return cell;
    } else if (indexPath.row == 1){
        static NSString *str = @"second";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:str];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"姓名";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        textfield= [[UITextField alloc] initWithFrame:CGRectMake(150, 0, SCREEN_WIDTH - 150 - 30, 44)];
        textfield.delegate = self;
        textfield.textAlignment = NSTextAlignmentRight;
        textfield.clearsOnBeginEditing = YES;
        textfield.clearButtonMode = UITextFieldViewModeAlways;
        textfield.borderStyle = UITextBorderStyleNone;
        if (self.setDic[@"nickname"]) {
            textfield.text  = self.setDic[@"nickname"];
        } else {
            textfield.text = @"未设置";
        }
        [cell.contentView addSubview:textfield];
        
        return cell;
    } else if (indexPath.row == 2){
        sexnewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"sexcell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([self.setDic[@"gender"] isEqualToString:@"0"]) {
            cell.manbutton.selected = YES;
        } else if([self.setDic[@"gender"] isEqualToString:@"1"]){
            cell.womenbutton.selected = YES;
        } else {
            cell.manbutton.selected = NO;
            cell.womenbutton.selected = NO;
        }
        
        [cell.manbutton addTarget:self action:@selector(manbuttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
       
        [cell.womenbutton addTarget:self action:@selector(womenbuttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        return cell;
    } else if (indexPath.row == 3){
        static NSString *str = @"three";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:str];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"电话";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.text = self.setDic[@"mobile"];
        return cell;
    } else {
        static NSString *str = @"second";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:str];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"出生日期";
        if ([self.setDic[@"birthday"] length] > 0) {
            cell.detailTextLabel.text = self.setDic[@"birthday"];
        } else {
           cell.detailTextLabel.text = @"未设置";
        }
       
        return cell;
    }
}
- (void)manbuttonAction:(UIButton *)sender
{
    sexnewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0 ]];
    cell.womenbutton.selected = NO;
    sender.selected = YES;
}
- (void)womenbuttonAction:(UIButton *)sender
{
    sexnewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0 ]];
    cell.manbutton.selected = NO;
    sender.selected = YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"textfiled:---%@",textField.text);
}
- (void)imgbuttonAction:(UIButton *)sender
{
    [self callActionSheetFunc];
}
- (void)callActionSheetFunc{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil];
    }else{
        self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:@"取消"destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
    }
    
    self.actionSheet.tag = 1000;
    [self.actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 1000) {
        NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 0:
                    //来源:相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 1:
                    //来源:相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
                case 2:
                    return;
            }
        }
        else {
            if (buttonIndex == 2) {
                return;
            } else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        
        [self presentViewController:imagePickerController animated:YES completion:^{
            
        }];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self showProgressHUD];
    [ColorString uploadPOST:commonuploadImgURL parameters:@{@"file":[@"image1" dataUsingEncoding:NSUTF8StringEncoding]} consImage:image success:^(id responObject) {
        
        if ([responObject[@"code"] integerValue] == 0) {
            [MBProgressHUD showError:responObject[@"message"]];
            self.imgStr = responObject[@"map"][@"url"];
            
            [imgButton sd_setImageWithURL:[NSURL URLWithString:responObject[@"map"][@"url"]] forState:(UIControlStateNormal)];
        
        }
        [self hideProgressHUD];
        
    } failure:^(NSError *error) {
        
    }];
 
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 60;
    } else {
        return 44;
    }
}

- (IBAction)completeButtonAction:(UIButton *)sender
{
    sexnewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    
     UITableViewCell *cell1 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    if (textfield.text.length == 0) {
        [MBProgressHUD showError:@"昵称不能为空"];
        return;
    } else if (textfield.text.length > 11){
        [MBProgressHUD showError:@"不能超过11个字符"];
        return;
    }
    
     NSDictionary *newdic;
    if (self.imgStr.length == 0) {
        self.imgStr = self.setDic[@"headimgurl"];
    }
    
    if (cell.manbutton.selected) {
        
        
        newdic = @{@"nickname":textfield.text,@"headimgurl":self.imgStr,@"birthday":cell1.detailTextLabel.text,@"gender":@"0"};
        
        
        [self requetForchanged:newdic];
    } else if (cell.womenbutton.selected){
        newdic = @{@"nickname":textfield.text,@"headimgurl":self.imgStr,@"birthday":cell1.detailTextLabel.text,@"gender":@"1"};
        
           [self requetForchanged:newdic];
    } else {
        [MBProgressHUD showError:@"性别未选择"];
    }
    
}

//修改请求
-(void)requetForchanged:(NSDictionary *)dic
{
    
    //请求
    [PPNetworkHelper POST:updateUserInfoURL parameters:dic success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 0) {
             [self.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

//
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 4) {
        [UIView animateWithDuration:0.5 animations:^{
           _dateView.frame = CGRectMake(0, SCREEN_HEIGHT - 300, SCREEN_WIDTH, 300);
        }];
        
        [_dateView.cancelBtn addTarget:self action:@selector(cancelButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [_dateView.compBtn addTarget:self action:@selector(compButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
    } else if (indexPath.row == 3){
        ChangePhoneViewController *change = [ChangePhoneViewController new];
        change.str =self.setDic[@"mobile"];
        [self.navigationController pushViewController:change animated:YES];
    }
}
- (void)cancelButtonAction:(UIButton *)sender
{
    [UIView animateWithDuration:0.5 animations:^{
        _dateView.frame = CGRectMake(0, SCREEN_HEIGHT , SCREEN_WIDTH, 300);
    }];
    
}
- (void)compButtonAction:(UIButton *)sender
{
    [UIView animateWithDuration:0.5 animations:^{
      _dateView.frame = CGRectMake(0, SCREEN_HEIGHT , SCREEN_WIDTH, 300);
    }];
    
    NSString *str = [NSString stringWithFormat:@"%@",_dateView.DataPicker.date];
    NSArray *arr = [str componentsSeparatedByString:@" "];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    cell.detailTextLabel.text = arr[0];
}
//当这个页面将要消失的时候

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_dateView removeFromSuperview];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //初始DateView
    _dateView = [[[NSBundle mainBundle] loadNibNamed:@"View" owner:nil options:nil] firstObject];
    
    _dateView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 300);
    [self.view addSubview:_dateView];
}




@end
