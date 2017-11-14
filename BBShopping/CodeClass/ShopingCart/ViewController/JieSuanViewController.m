//
//  JieSuanViewController.m
//  BBShopping
//
//  Created by mibo02 on 17/2/20.
//  Copyright © 2017年 mibo02. All rights reserved.
//
#import "dingdanpresentView.h"
#import "JieSuanViewController.h"
#import "jiesuanCell.h"
#import "jiesuanSecondCell.h"
#import "jiesuanThreeCell.h"
#import "AddressViewController.h"
#import "ShoppingModel.h"
#import "HJCAjustNumButton.h"
#import "presentOrderView.h"
#import "PresentModel.h"
#import "xiadanViewController.h"
#import "fangshiCell.h"
#import "popfangshiView.h"
#import "jiesuanModel.h"
#import "presentOrderCell.h"
#import "jiesuansectionTableVCell.h"
@interface JieSuanViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UITextFieldDelegate,presentOrderViewDelegate>

@property (nonatomic, copy)NSString *numberStr;
@property (nonatomic, copy)NSString *password;

@property (nonatomic, strong)presentOrderView *scrollPresentV;

@property (nonatomic, strong)HJCAjustNumButton *NumButton;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong)NSMutableArray *presentArr;
@property (weak, nonatomic) IBOutlet UILabel *allLabel;
//礼品显示余额view
@property (nonatomic, strong)dingdanpresentView *dingdanpreV;
//留言数组
@property (nonatomic, strong)NSMutableArray *liuyanArray;
//分区数组
@property (nonatomic, strong)NSMutableArray *storeArr;
//结算参数数组
@property (nonatomic, strong)NSMutableArray *Forarr;
//保存物流数组
@property (nonatomic, strong)NSMutableArray *typeArr;
//保存按钮数组
@property (nonatomic, strong)NSMutableArray *buttonArray;
//物流cell
@property (nonatomic,strong)UITableViewCell *typeCell;
//选择对应的物流
@property (nonatomic, copy)NSString *wuliuselectStr;
//底部视图
@property (nonatomic, strong)UIView *bottomView;
@property (nonatomic, strong)popfangshiView *fangshiView;

//数据
@property (nonatomic, strong)NSDictionary *alldic;
//是否选中礼品卡
@property (nonatomic, assign)BOOL isSelectPresent;


//如果不是选择默认的礼品卡id
@property (nonatomic, assign)NSInteger presentID;

//是否禁用键盘弹起
@property (nonatomic, assign)BOOL wasKeyboardManagerEnabled;
@end

@implementation JieSuanViewController

- (NSMutableArray *)liuyanArray
{
    if (!_liuyanArray) {
        self.liuyanArray = [NSMutableArray new];
    }
    return _liuyanArray;
}
- (NSMutableArray *)Forarr
{
    if (!_Forarr) {
        self.Forarr = [NSMutableArray new];
    }
    return _Forarr;
}

- (NSMutableArray *)buttonArray
{
    if (!_buttonArray) {
        self.buttonArray =  [NSMutableArray new];
    }
    return _buttonArray;
}
- (NSMutableArray *)typeArr
{
    if (!_typeArr) {
        self.typeArr = [NSMutableArray new];
    }
    return _typeArr;
}
- (NSMutableArray *)storeArr
{
    if (!_storeArr) {
        self.storeArr = [NSMutableArray new];
    }
    return _storeArr;
}
- (NSMutableArray *)presentArr
{
    if (!_presentArr) {
        self.presentArr = [NSMutableArray new];
    }
    return _presentArr;
}

//下单按钮

- (IBAction)orderButtonAction:(UIButton *)sender {
    
    if ([self.alldic[@"addressId"] integerValue] == 0) {
        [MBProgressHUD showError:@"请添加收货地址"];
        return;
    }
    if ([self.alldic[@"error"] isEqualToString:@""]) {
        //请求下单接口
        [self requestForOrder];
        
        
        
    } else {
        [MBProgressHUD showSuccess:self.alldic[@"error"]];
    }
    
    
}
#pragma mark------------TextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
//    NSLog(@"%@",textField.text);
   //
    [self.liuyanArray addObject:textField.text];
    
}
//禁用键盘弹起

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:_wasKeyboardManagerEnabled];
}
//创建订单//使用礼品卡
- (void)requestForOrder
{
    //每次创建删除留言数组
  //  [self.liuyanArray removeAllObjects];
    //留言的字符串拼接
    NSString *string;
   
    if (self.liuyanArray.count == 0) {
        for (int i = 0; i < self.storeArr.count; i++) {
            [_liuyanArray addObject:[NSString stringWithFormat:@"未留言%d",i + 1]];
        }
        string = [_liuyanArray componentsJoinedByString:@"$<bbg>@"];
        
    } else {
        string = [_liuyanArray componentsJoinedByString:@"$<bbg>@"];
    }

    //判断是购物车进入还是其他
    NSString *sources;
    if (self.shopingNumbersign == 1) {
        //购物车进入
        sources = @"0";
    } else {
        sources = @"1";
    }
    
    [PPNetworkHelper setValue:[UserInfoManager getUserInfo].token forHTTPHeaderField:@"token"];
    
    NSDictionary *orderdic;
    
    //秒杀界面不能用礼品卡(判断)
    if ([self.alldic[@"allowUseGiftCard"] integerValue]== 0) {
        if (self.isSelectPresent == YES) {
            [MBProgressHUD showError:@"该商品不能使用礼品卡"];
            
        } else {
        orderdic = @{
                     
                     @"receiveName":self.alldic[@"name"],
                     @"receiveProvince":self.alldic[@"receiveProvince"],
                     @"receiveCity":self.alldic[@"receiveCity"],
                     @"receiveArea":self.alldic[@"receiveArea"],
                     @"receiveAddress":self.alldic[@"receiveAddress"],
                     @"receiveMobile":self.alldic[@"mobile"],
                     @"takeType":@"1",
                     @"buyerMessage":string,
                     @"postage":@"0",
                     @"totalPrice":[NSString stringWithFormat:@"%.2f",[self.alldic[@"totalMoney"] floatValue]],
                     //实际付款
                     @"realPayment": [NSString stringWithFormat:@"%.2f",[self.alldic[@"totalMoney"] floatValue]],
                     @"source":sources,
                     @"cartsJson":self.alldic[@"cartsJson"]
                     };
        }
        
    } else {
   
       //可以使用礼品卡
        
    if (self.isSelectPresent == YES) {
   //     NSLog(@"选中了");
        //相等说明是默认的选中的礼品卡
        if (self.presentID == [self.alldic[@"giftCardId"] integerValue] || self.presentID == 0) {
            orderdic = @{
                         @"receiveName":self.alldic[@"name"],
                         @"receiveProvince":self.alldic[@"receiveProvince"],
                         @"receiveCity":self.alldic[@"receiveCity"],
                         @"receiveArea":self.alldic[@"receiveArea"],
                         @"receiveAddress":self.alldic[@"receiveAddress"],
                         @"receiveMobile":self.alldic[@"mobile"],
                         @"takeType":@"1",
                         @"buyerMessage":string,
                         @"postage":@"0",
                         @"totalPrice":[NSString stringWithFormat:@"%.2f",[self.alldic[@"totalMoney"] floatValue]],
                         //实际付款
                         @"realPayment": [NSString stringWithFormat:@"%.2f",[self.alldic[@"totalMoney"] floatValue]],
                         @"source":sources,
                         
                         @"cardId":[NSString stringWithFormat:@"%ld",[self.alldic[@"giftCardId"] integerValue]],
                         @"cartsJson":self.alldic[@"cartsJson"]
                         };

        } else {
            
            orderdic = @{
                         @"receiveName":self.alldic[@"name"],
                         @"receiveProvince":self.alldic[@"receiveProvince"],
                         @"receiveCity":self.alldic[@"receiveCity"],
                         @"receiveArea":self.alldic[@"receiveArea"],
                         @"receiveAddress":self.alldic[@"receiveAddress"],
                         @"receiveMobile":self.alldic[@"mobile"],
                         @"takeType":@"1",
                         @"buyerMessage":string,
                         @"postage":@"0",
                         @"totalPrice":[NSString stringWithFormat:@"%.2f",[self.alldic[@"totalMoney"] floatValue]],
                         //实际付款
                         @"realPayment": [NSString stringWithFormat:@"%.2f",[self.alldic[@"totalMoney"] floatValue]],
                         @"source":sources,
                         
                         @"cardId":[NSString stringWithFormat:@"%ld",self.presentID],
                         @"cartsJson":self.alldic[@"cartsJson"]
                         };
        }
        
    } else {
     //   NSLog(@"未选中");
        
        orderdic = @{
                     
                     @"receiveName":self.alldic[@"name"],
                     @"receiveProvince":self.alldic[@"receiveProvince"],
                     @"receiveCity":self.alldic[@"receiveCity"],
                     @"receiveArea":self.alldic[@"receiveArea"],
                     @"receiveAddress":self.alldic[@"receiveAddress"],
                     @"receiveMobile":self.alldic[@"mobile"],
                     @"takeType":@"1",
                     @"buyerMessage":string,
                     @"postage":@"0",
                    @"totalPrice":[NSString stringWithFormat:@"%.2f",[self.alldic[@"totalMoney"] floatValue]],
                     //实际付款
                     @"realPayment": [NSString stringWithFormat:@"%.2f",[self.alldic[@"totalMoney"] floatValue]],
                     @"source":sources,
                     @"cartsJson":self.alldic[@"cartsJson"]
                     };
        
    }
    
    }
    
    [PPNetworkHelper POST:createorderURl parameters:orderdic success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == -1) {
            [MBProgressHUD showError:responseObject[@"message"]];
        } else if ([responseObject[@"code"] integerValue] == 0){
           
                xiadanViewController *xiadan = [xiadanViewController new];
            //详细地址
            NSString *str =self.alldic[@"receiveAddress"];
            xiadan.addressNew = str;
                xiadan.xiadanDic = responseObject[@"map"][@"orderInfo"];
                
                [self.navigationController pushViewController:xiadan animated:YES];
          
        }
        
    } failure:^(NSError *error) {
        
    }];
}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    _wasKeyboardManagerEnabled = [[IQKeyboardManager sharedManager] isEnabled];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    
    //将要出现的时候进行初始化
    self.fangshiView = [[[NSBundle mainBundle] loadNibNamed:@"popfangshiView" owner:nil options:nil] firstObject];
    self.fangshiView.frame  =CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 400);
    self.fangshiView.poptableView.delegate = self;
    self.fangshiView.poptableView.dataSource = self;
    [self.fangshiView.poptableView registerNib:[UINib nibWithNibName:@"fangshiCell" bundle:nil] forCellReuseIdentifier:@"fangshicell"];
   //结算请求在添加完成礼品卡之后也要调用
    [self requestForAllVC];

}
- (void)requestForAllVC
{
    //结算请求
    [self.Forarr removeAllObjects];
    if (self.shopingNumbersign == 1) {
        //从购物车进入多个或者一个
        for (ShoppingModel *model in self.orderShopArray) {
            NSDictionary *subdic= @{@"skuId":@(model.skuId),@"buyCount":@(model.buycount),@"cartId":@(model.id)};
            
            [self.Forarr addObject:subdic];
        }
        NSDictionary *dic = @{@"goodsList":self.Forarr};
        
     
        [self requestListForJieSuan:dic];
        
    } else {
        //从详情进入
        NSDictionary *dic = @{@"goodsList":self.orderShopArray};
        [self requestListForJieSuan:dic];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"确认订单";
  
    [self.tableview registerNib:[UINib nibWithNibName:@"presentOrderCell" bundle:nil] forCellReuseIdentifier:@"presentOrder"];
    [self.tableview registerNib:[UINib nibWithNibName:@"jiesuanCell" bundle:nil] forCellReuseIdentifier:@"jiesuanCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"jiesuanSecondCell" bundle:nil] forCellReuseIdentifier:@"jiesuanSecondCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"jiesuanThreeCell" bundle:nil] forCellReuseIdentifier:@"jiesuanThreeCell"];
    
    //通知弹出式图出来（选择快递方式)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(typeAction:) name:@"typeMoney" object:nil];
    //改变数量通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changenumberForsectionCell:) name:@"currentNum" object:nil];
    
}
- (void)typeAction:(NSNotification *)not
{
   
    self.typeArr = not.userInfo[@"type"];
    UIWindow *window = [UIApplication sharedApplication].windows[0];
    self.bottomView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.bottomView.backgroundColor = RGBA(108, 108, 108,0.7);
    [window  addSubview:self.bottomView ];
    [self.bottomView  addSubview:self.fangshiView];
    [UIView animateWithDuration:0.5 animations:^{
        self.fangshiView.frame  =CGRectMake(0, SCREEN_HEIGHT - 400, SCREEN_WIDTH, 400);
    }];
    [self.fangshiView.poptableView reloadData];
    [self.fangshiView.okbutton addTarget:self action:@selector(okbuttonaction:) forControlEvents:(UIControlEventTouchUpInside)];
}
//结算请求
- (void)requestListForJieSuan:(NSDictionary *)dic
{
    [self showProgressHUD];
    //买家留言
    [PPNetworkHelper setValue:[UserInfoManager getUserInfo].token forHTTPHeaderField:@"token"];
    //先将滑动式图删除
    [_scrollPresentV removeFromSuperview];
    
    [self.storeArr removeAllObjects];
    [self.presentArr removeAllObjects];
    [PPNetworkHelper POST:buynowURL parameters:dic success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 0) {
            self.alldic = responseObject[@"map"];
            
            self.allLabel.text = [NSString stringWithFormat:@"合计:¥%.2f",[self.alldic[@"totalMoney"] floatValue]];
            
            for (NSDictionary *dic in responseObject[@"map"][@"storeList"]) {
                jiesuanModel *model = [jiesuanModel new];
                [model setValuesForKeysWithDictionary:dic];
                [self.storeArr addObject:model];
                
                
            }
            for (NSDictionary *perdic in responseObject[@"map"][@"giftCardList"]) {
                PresentModel *premodel = [PresentModel new];
                [premodel setValuesForKeysWithDictionary:perdic];
                [self.presentArr addObject:premodel];
            }
            
            //刚开始默认选中
            if (self.presentArr.count == 0) {
                self.isSelectPresent = NO;
            } else {
                if ([self.alldic[@"allowUseGiftCard"] integerValue]== 0){
                    self.isSelectPresent = NO;
                } else {
                     self.isSelectPresent = YES;
                }
               
            }
            
        } else if ([responseObject[@"code"] integerValue] == 40000){
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
        [self hideProgressHUD];
        [self.tableview reloadData];
        
        
    } failure:^(NSError *error) {
        
    }];

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.tableview) {
        return self.storeArr.count + 2;
    } else {
        return 1;
    }
   
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableview) {
    
        if (section == 0) {
            return 1;
        } else if (section == self.storeArr.count + 1){
            //最后一个分区
            return 1;
        } else {
            NSMutableArray *centerarr = [self.storeArr[section - 1] listArray];
            //
            if (centerarr.count > 1) {
                
                return 3;
                
            } else {
                jiesuanListModel *listmodel = centerarr[0];
                NSMutableArray *rowarr = listmodel.storeArray;
                //中间的分区
                return rowarr.count + 4;
            }
            
        }
    } else {
        //弹出视图返回的个数
        return _typeArr.count;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableview) {
       
        
        if (indexPath.section == 0) {
            if ([self.alldic[@"addressId"] integerValue] != 0) {
                jiesuanCell *cell = [tableView dequeueReusableCellWithIdentifier:@"jiesuanCell" forIndexPath:indexPath];
                 cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.nameLab.text = [NSString stringWithFormat:@"收货人:%@",self.alldic[@"name"]];
                cell.phoneLab.text = self.alldic[@"mobile"];
                cell.locationLab.text = self.alldic[@"receiveAddress"];
                
                return cell;
            } else {
                static NSString *str1 = @"addressNO";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str1];
                if (!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:str1];
                }
                 cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.text = @"收货地址:请添加您的收货人信息";
                cell.imageView.image = [UIImage imageNamed:@"地址"];
                return cell;
            }

            } else if (indexPath.section == _storeArr.count + 1){
                //最后一个分区
                //此时秒杀进入没有礼品卡
//                if ([self.alldic[@"allowUseGiftCard"] integerValue]== 0) {
//                    
//                    return [[UITableViewCell alloc] init];
//                    
//                } else {
                presentOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"presentOrder" forIndexPath:indexPath];
                //创建的时候就先删除
                [_scrollPresentV removeFromSuperview];
                if (isiPhone5or5sor5c) {
                    _scrollPresentV = [[presentOrderView alloc] initWithFrame:CGRectMake(0, 0, 320, 100) arr:self.presentArr canuser:[self.alldic[@"allowUseGiftCard"] integerValue]];
                    _scrollPresentV.delegate  = self;
                    [cell.contentView addSubview:_scrollPresentV];
                } else {
                    _scrollPresentV = [[presentOrderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100) arr:self.presentArr canuser:[self.alldic[@"allowUseGiftCard"] integerValue]];
                    _scrollPresentV.delegate  = self;
                    [cell.contentView addSubview:_scrollPresentV];
                }
//                if ([self.alldic[@"allowUseGiftCard"] integerValue]== 0) {
//                    _scrollPresentV.subview.backgroundColor = [UIColor lightGrayColor];
//                    
//                }
//                
                return cell;
                    
                
                
            } else {
                NSMutableArray *centerarr = [self.storeArr[indexPath.section - 1] listArray];
                //如果是多种模板的话。
                if (centerarr.count > 1) {
                    
                    if (indexPath.row == 0) {
                        static NSString *str = @"sectionCell";
                        jiesuansectionTableVCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
                        if (!cell) {
                            cell = [[jiesuansectionTableVCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:str arr:centerarr];
                        }
                        return cell;
                        
    
                    } else if (indexPath.row == 2){
                        //买家留言
                        jiesuanThreeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"jiesuanThreeCell" forIndexPath:indexPath];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        cell.textfield.delegate = self;
                        return cell;
                    } else {
                        //商品金额
                        static NSString *str1 = @"money";
                        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str1];
                        if (!cell) {
                            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:str1];
                        }
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        cell.textLabel.text = @"商品金额";
                        cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%.2f",[self.storeArr[indexPath.section - 1] storeTotalMoney]];
                        return cell;
                    }
                    
                    
                } else {
                    //
                    jiesuanListModel *listmodel = centerarr[0];
                    NSMutableArray *rowarr = listmodel.storeArray;
                    
                    //中间的
                    if (indexPath.row == rowarr.count) {
                        //商品金额
                        static NSString *str1 = @"money";
                        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str1];
                        if (!cell) {
                            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:str1];
                        }
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        cell.textLabel.text = @"商品金额";
                        cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%.2f",[listmodel goodsTotal]];
                        return cell;
                    } else if (indexPath.row == rowarr.count + 1){
                        static NSString *str1 = @"fangshi";
                        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str1];
                        if (!cell) {
                            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:str1];
                        }
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        cell.textLabel.text = @"配送方式";
                        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",listmodel.logisticsCompany];
                        
                        return cell;
                    } else if (indexPath.row == rowarr.count + 2){
                        static NSString *str1 = @"yunfei";
                        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str1];
                        if (!cell) {
                            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:str1];
                        }
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        cell.textLabel.text = @"运费";
                        cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%.2f",listmodel.postageTotal];
                        return cell;
                    } else if(indexPath.row == rowarr.count + 3){
                        //买家留言
                        jiesuanThreeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"jiesuanThreeCell" forIndexPath:indexPath];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        cell.textfield.delegate = self;
                        return cell;
                    } else {
                        jiesuanSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:@"jiesuanSecondCell" forIndexPath:indexPath];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        //model
                        jiesuanSubModel *model = rowarr[indexPath.row];
                        //标题
                        cell.titleLab.text = [model goodsName];
                        cell.priceLab.text = [NSString stringWithFormat:@"¥%@",[model groupBuyPrice]];
                        cell.skuLab.text = model.sku;
                        //图片
                        [cell.imageV sd_setImageWithURL:[NSURL URLWithString:model.picServerUrl1] placeholderImage:[UIImage imageNamed:@""]];
                        self.NumButton = [[HJCAjustNumButton alloc] init];
                        self.NumButton.frame = CGRectMake(0, 0, 90, 30);
                        
                        self.NumButton.currentNum = [NSString stringWithFormat:@"%ld",(long)[model buyCount]];
                        
                        [cell.backView addSubview:self.NumButton];
                        // 内容更改的block回调
                        WS(weakself);
                        self.NumButton.callBack = ^(NSString *currentNum){
                    //        NSLog(@"%@", currentNum);
                            [weakself requestNeworder:currentNum.integerValue skuid:model.skuId];
                            
                        };
                        return cell;
                    }
                }

                }
            } else {
            fangshiCell *cell =[tableView dequeueReusableCellWithIdentifier:@"fangshicell" forIndexPath:indexPath];
             cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.leftlab.text = [_typeArr[indexPath.row] logisticsCompany];
           
            
            cell.rightbutton.tag = 100 + indexPath.row;
           
            [self.buttonArray addObject:cell.rightbutton];
           
            [cell.rightbutton addTarget:self action:@selector(fangshibuttonaction:) forControlEvents:(UIControlEventTouchUpInside)];
            if ([_typeArr[indexPath.row] selected]) {
                [cell.rightbutton setImage:[UIImage imageNamed:@"选中"] forState:(UIControlStateNormal)];
            } else {
                 [cell.rightbutton setImage:[UIImage imageNamed:@"未选中"] forState:(UIControlStateNormal)];
            }
            return cell;
        }
}

//改变数量通知
- (void)changenumberForsectionCell:(NSNotification *)not
{
    NSInteger num = [not.userInfo[@"number"] integerValue];
    NSInteger skid  = [not.userInfo[@"skuid"] integerValue];
    [self requestNeworder:num skuid:skid];
}

- (void)requestNeworder:(NSInteger)num skuid:(NSInteger)skuid
{
//    NSLog(@"%ld",num);
    [self.Forarr removeAllObjects];
    if (self.shopingNumbersign == 1) {
        //从购物车进入
        NSDictionary *subdic;
        for (ShoppingModel *model in self.orderShopArray) {
            
            if (skuid == model.skuId) {
                subdic= @{@"skuId":@(model.skuId),@"buyCount":@(num),@"cartId":@(model.id)};
            } else {
                subdic= @{@"skuId":@(model.skuId),@"buyCount":@(model.buycount),@"cartId":@(model.id)};
            }
            
            [self.Forarr addObject:subdic];
        }
        NSDictionary *dic = @{@"goodsList":self.Forarr};
        [self requestListForJieSuan:dic];
       
    } else {
        
        NSDictionary *otherdic;
        //找到对应的商品相关参数(修改数量进行重新请求)
        otherdic = self.orderShopArray[0];
        
        NSMutableDictionary *changedic = [[NSMutableDictionary alloc] initWithDictionary:otherdic];

        [changedic setObject:@(num) forKey:@"buyCount"];
       
        [self.Forarr addObject:changedic];
        
        NSDictionary *dic = @{@"goodsList":self.Forarr};
        
        [self requestListForJieSuan:dic];
    }
    
}
//礼品卡按钮
- (void)presentbuttonAction:(UIButton *)sender
{
    
    sender.selected =!sender.selected;
    if (sender.selected) {
       self.dingdanpreV.priceLab.text = self.alldic[@"giftCardName"];
       self.isSelectPresent = YES;
    } else {
        self.dingdanpreV.priceLab.text = @"";
         self.isSelectPresent = NO;
    }
}

//物流方式按钮
- (void)fangshibuttonaction:(UIButton *)sender
{
    
     [sender setImage:[UIImage imageNamed:@"选中"] forState:(UIControlStateNormal)];
    //找到对应的物流
    NSString *wuliustr = [_typeArr[sender.tag - 100] logisticsCompany];
    self.wuliuselectStr = wuliustr;
     self.typeCell.detailTextLabel.text = self.wuliuselectStr;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"typeName" object:nil userInfo:@{@"names":wuliustr}];
    
    [self settypebuttonunselect:sender.tag];
}
- (void)settypebuttonunselect:(NSInteger)normaltag
{
        for (UIButton *btn in self.buttonArray) {
            if (btn.tag != normaltag) {
                [btn setImage:[UIImage imageNamed:@"未选中"] forState:(UIControlStateNormal)];
            }
        }
}
#pragma mark --- headerView-footerView---
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableview) {
        if (section == 0) {
            return nil;
        } else if (section == self.storeArr.count + 1){
            //此时秒杀进入没有礼品卡
//            if ([self.alldic[@"allowUseGiftCard"] integerValue] == 0){
//                
//                
//                return nil;
//            } else {
            
            //最后一个分区
            self.dingdanpreV = [[[NSBundle mainBundle] loadNibNamed:@"dingdanpresentView" owner:nil options:nil] firstObject];
            
            self.dingdanpreV.priceLab.text = self.alldic[@"giftCardName"];
                if (self.presentArr.count == 0) {
                     self.dingdanpreV.offButton.selected = NO;
                } else {
                    if ([self.alldic[@"allowUseGiftCard"] integerValue] == 0) {
                        self.dingdanpreV.offButton.selected = NO;
                    } else {
                        self.dingdanpreV.offButton.selected = YES;
                    }
                   
                }
           
            [self.dingdanpreV.offButton addTarget:self action:@selector(presentbuttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
            
            return self.dingdanpreV;
                
//            }
        } else {
            UIView *storyName = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
            UILabel *lab  = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH -20, 45)];
            lab.text = [self.storeArr[section - 1] name];
            [storyName addSubview:lab];
          
            return storyName;
        }
        
    } else {
        return nil;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableview) {
        if (section == 0) {
            return 0;
        } else if (section == self.storeArr.count + 1){
            //此时秒杀进入没有礼品卡
//            if ([self.alldic[@"allowUseGiftCard"] integerValue]== 0){
//                return 0;
//            } else {
                //返回head高度
                return 44;
//            }
        } else {
            return 45;
        }
    } else {
        return 0;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (tableView == self.tableview) {
        if (section == self.storeArr.count + 1) {
            return nil;
        } else if(section == 0){
            UIView *view = [UIView new];
            view.backgroundColor = [UIColor groupTableViewBackgroundColor];
            view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 10);
            return view;
        } else {
            NSMutableArray *centerarr = [self.storeArr[section - 1] listArray];
            //
            jiesuanListModel *listmodel = centerarr[0];
            NSMutableArray *rowarr = listmodel.storeArray;
            
            UIView *storeV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
            UILabel *rightlab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 0, 90, 45)];
            rightlab.textAlignment = NSTextAlignmentRight;
            rightlab.text = [NSString stringWithFormat:@"合计:%.2f",[self.storeArr[section - 1] storeTotalMoney]];
            [storeV addSubview:rightlab];
            
            UILabel *leftlab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(rightlab.frame) - 100, 0, 90, 45)];
            leftlab.text = [NSString stringWithFormat:@"共%ld件商品",rowarr.count];
            leftlab.textAlignment = NSTextAlignmentRight;
            [storeV addSubview:leftlab];
           
            return storeV;
        }
    } else {
        return nil;
    }
  
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if (tableView == self.tableview) {
      
        
        if (indexPath.section == 0) {
            
            if ([self.alldic[@"addressId"] integerValue] == 0) {
                return 70;
            } else {
                return 100;
            }
        } else if (indexPath.section == self.storeArr.count + 1){
            return 100;
        } else {
            NSMutableArray *centerarr = [self.storeArr[indexPath.section - 1] listArray];
            
            
            if (centerarr.count > 1) {
                NSInteger i = 0;
                for (jiesuanListModel *jmodel in centerarr) {
                    i += jmodel.storeArray.count;
                }
             //   NSLog(@"结算----------------%ld",i);
                if (indexPath.row == 0) {
                    return centerarr.count * 88 + i * 100;
                } else {
                    return 44;
                }
            } else {
            //
            jiesuanListModel *listmodel = centerarr[0];
            NSMutableArray *rowarr = listmodel.storeArray;
            //中间的分区
            if (indexPath.row >= rowarr.count) {
                return 44;
            } else {
                
                return 100;
               
            }
            }
        }
        
    } else {
        return 50;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView == self.tableview) {
        if (section == 0) {
            return 10;
        } else if (section == self.storeArr.count + 1){
            return 0;
        } else {
            return 45;
        }
 
        
    } else {
        return 0;
    }
  
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableview) {
       
        if (indexPath.section == 0) {
            AddressViewController *add = [AddressViewController new];
            [self.navigationController pushViewController:add animated:YES];
        } else if (indexPath.section == self.storeArr.count + 1){
            //最后一个分区
        } else {
            //中间的分区
            NSMutableArray *centerarr = [self.storeArr[indexPath.section - 1] listArray];
            //
            jiesuanListModel *listmodel = centerarr[0];
            NSMutableArray *rowarr = listmodel.storeArray;
            if (indexPath.row == rowarr.count + 1) {
                UIWindow *window = [UIApplication sharedApplication].windows[0];
                self.bottomView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                self.bottomView.backgroundColor = RGBA(108, 108, 108,0.7);
                [window  addSubview:self.bottomView ];
                [self.bottomView  addSubview:self.fangshiView];
                //
                [UIView animateWithDuration:0.5 animations:^{
                    self.fangshiView.frame  =CGRectMake(0, SCREEN_HEIGHT - 400, SCREEN_WIDTH, 400);
                }];
                
                NSLog(@"section:%ld,row:%ld",indexPath.section,indexPath.row);
                UITableViewCell *cell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
                self.typeCell = cell;
                //弹出视图赋值
                [self.typeArr removeAllObjects];
                for (jiesuantakeTypeModel *typemodel in listmodel.takeTypeArray) {
                    [self.typeArr addObject:typemodel];
                }
                [self.fangshiView.poptableView reloadData];
                
                [self.fangshiView.okbutton addTarget:self action:@selector(okbuttonaction:) forControlEvents:(UIControlEventTouchUpInside)];
            }
        }
        
    }
   
}

- (void)okbuttonaction:(UIButton *)sender
{
    [UIView animateWithDuration:0.5 animations:^{
        self.fangshiView.frame  = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 400);
    }];
    [self.bottomView removeFromSuperview];
   
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tableview)
    {
        
        UITableView *tableview = (UITableView *)scrollView;
        CGFloat sectionHeaderHeight = 45;
        CGFloat sectionFooterHeight = 45;
        CGFloat offsetY = tableview.contentOffset.y;
        
        if (offsetY >= 0 && offsetY <= sectionHeaderHeight)
        {
            tableview.contentInset = UIEdgeInsetsMake(-offsetY, 0, -sectionFooterHeight, 0);
        }else if (offsetY >= sectionHeaderHeight && offsetY <= tableview.contentSize.height - tableview.frame.size.height - sectionFooterHeight)
        {
            tableview.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, -sectionFooterHeight, 0);
        }else if (offsetY >= tableview.contentSize.height - tableview.frame.size.height - sectionFooterHeight && offsetY <= tableview.contentSize.height - tableview.frame.size.height)
        {
            tableview.contentInset = UIEdgeInsetsMake(-offsetY, 0, -(tableview.contentSize.height - tableview.frame.size.height - sectionFooterHeight), 0);
        }
        
    }
}

#pragma mark---------礼品卡点击事件
- (void)addbuttonpresentOrder:(UIButton *)sender
{
    
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

}
- (void)alertTextFieldDidChange:(NSNotification *)not
{
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    if (alertController) {
        self.numberStr = alertController.textFields.firstObject.text;
        self.password = alertController.textFields.lastObject.text;
    }
}
//礼品卡点击事件
- (void)subviewpresentOrder:(NSInteger)tags
{
    PresentModel *presentM = self.presentArr[tags];
    self.dingdanpreV.priceLab.text = [NSString stringWithFormat:@"余额：¥%.2f",presentM.cardBalance];

    self.presentID = presentM.id;
    
}
//添加礼品卡请求
//获取礼品卡信息
- (void)requestForAddPresent
{
    if (self.numberStr.length == 0) {
        //1秒之后执行
       
        [MBProgressHUD showError:@"礼品卡卡号不能为空"];
     
    } else if (self.password.length == 0){
        //1秒之后执行
       
        [MBProgressHUD showError:@"请填写正确的密码"];
       
    } else {
        [PPNetworkHelper setValue:[UserInfoManager getUserInfo].token forHTTPHeaderField:@"token"];
        [PPNetworkHelper POST:AddPresentURL parameters:@{ @"cardNo":self.numberStr, @"cardPassword":self.password } success:^(id responseObject) {
            
            
            if ([responseObject[@"code"] integerValue] == 9902) {
                
                //1秒之后执行
              
                [MBProgressHUD showError:responseObject[@"message"]];
               
            } else if ([responseObject[@"code"] integerValue] == 0){

                //将页面进行重新请求
                [self requestForAllVC];
                [MBProgressHUD showError:@"添加成功"];
               
              
            } else if ([responseObject[@"code"] integerValue] == 9902){
                //1秒之后执行
                
                [MBProgressHUD showError:responseObject[@"message"]];
             
                
            }
            
            
        } failure:^(NSError *error) {
            
        }];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
