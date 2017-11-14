//
//  ShouHouViewController.m
//  BBShopping
//
//  Created by mibo02 on 17/3/8.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "ShouHouViewController.h"
#import "shenqingCollectionViewCell.h"
#import "OrderViewController.h"
@interface ShouHouViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *topImageV;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UITextView *textview;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (nonatomic, strong)UIActionSheet *actionSheet;
@property (nonatomic, strong)NSMutableArray *ImageSArray;


@end

@implementation ShouHouViewController
- (NSMutableArray *)ImageSArray
{
    if (!_ImageSArray) {
        self.ImageSArray = [NSMutableArray new];
    }
    return _ImageSArray;
}
- (IBAction)tijiaoButton:(UIButton *)sender {
    if (self.textview.text.length == 0) {
        [MBProgressHUD showError:@"内容不能为空"];
        return;
    }
    
    if (self.name.text.length == 0) {
        [MBProgressHUD showError:@"联系人不能为空"];
        return;
    }
    if (self.phone.text.length == 0) {
        [MBProgressHUD showError:@"手机号不能为空"];
        return;
    }
    if (![self.phone.text isMobileNumber]) {
        [MBProgressHUD showError:@"请输入正确的手机号"];
        return;
    }
    NSMutableDictionary *mdic = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < self.ImageSArray.count; i++) {
        [mdic setValue:self.ImageSArray[i] forKey:[NSString stringWithFormat:@"proofPic%d",i+1]];
    }
    NSDictionary *pramDic = @{@"orderId":[NSString stringWithFormat:@"%ld",[self.shouhouDic[@"orderId"] integerValue]],@"orderNo":self.shouhouDic[@"orderNo"],@"goodsId":[NSString stringWithFormat:@"%ld",[self.shouhouDic[@"goodsId"] integerValue]],@"skuId":[NSString stringWithFormat:@"%ld",[self.shouhouDic[@"skuId"] integerValue]],@"appId":[NSString stringWithFormat:@"%ld",[self.shouhouDic[@"appId"] integerValue]],@"userName":self.name.text,@"mobile":self.phone.text,@"feedbackProblem":self.textview.text};
    
    [mdic addEntriesFromDictionary:pramDic];
    
    [PPNetworkHelper POST:customerapplyAddURL parameters:mdic success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 0) {
            
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
            [MBProgressHUD showSuccess:@"客服会在一个工作日主动联系您"];
        }
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.scrollView.contentSize = CGSizeMake(350, 60);
    self.title = @"申请售后";
    [self.collectionView registerClass:[shenqingCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    [self.topImageV sd_setImageWithURL:[NSURL URLWithString:self.shouhouDic[@"goodsPicurl"]]];
    self.titleLab.text = self.shouhouDic[@"goodsName"];
    self.priceLab.text = [NSString stringWithFormat:@"%.2f",[self.shouhouDic[@"goodsPrice"] floatValue]];
      [_addButton addTarget:self action:@selector(addButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)addButtonAction:(UIButton *)sender
{
    if (_ImageSArray.count >= 5) {
        [MBProgressHUD showError:@"最多添加5张"];
        
    } else {
       [self callActionSheetFunc];
    }
    
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
          
            [self.ImageSArray addObject:responObject[@"map"][@"url"]];
            
        }
        
        [self.collectionView reloadData];
        
        [self hideProgressHUD];
        
        
        
    } failure:^(NSError *error) {
        
    }];
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.ImageSArray.count;
}
- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    shenqingCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:_ImageSArray[indexPath.row]]];

    cell.deleteBtn.tag = indexPath.row + 160;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    return cell;
}
- (void)deleteBtnAction:(UIButton *)sender
{
    [self.ImageSArray removeObject:self.ImageSArray[sender.tag - 160]];
    [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:sender.tag - 160 inSection:0]]];
    [self.collectionView reloadData];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return   CGSizeMake(50, 50);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(4, 4, 10, 4);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
