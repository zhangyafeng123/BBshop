//
//  jiesuansectionTableVCell.m
//  BBShopping
//
//  Created by mibo02 on 17/3/21.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "jiesuansectionTableVCell.h"
#import "jiesuanSecondCell.h"
#import "jiesuanModel.h"
#import "HJCAjustNumButton.h"
@interface jiesuansectionTableVCell ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tabV;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)NSMutableArray *newArr;
@property (nonatomic, copy)NSString *newstr;
@property (nonatomic, assign)NSInteger sections;
@property (nonatomic, assign)NSInteger rows;
@property (nonatomic, strong)HJCAjustNumButton *NumButton;
@end

@implementation jiesuansectionTableVCell
- (NSMutableArray *)newArr
{
    if (!_newArr) {
        self.newArr = [NSMutableArray new];
    }
    return _newArr;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  arr:(NSMutableArray *)arrnew;
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.dataArray = arrnew;
        NSInteger i = 0;
        for (jiesuanListModel *model in self.dataArray) {
            i+= model.storeArray.count;
        }
   
        self.tabV = [[UITableView alloc] init];
        
        if (isiPhone5or5sor5c) {
            self.tabV.frame = CGRectMake(0, 0, 320, i * 100 + self.dataArray.count * 88);
        } else {
            self.tabV.frame = CGRectMake(0, 0, SCREEN_WIDTH, i * 100 + self.dataArray.count * 88);
        }
        [self.tabV registerNib:[UINib nibWithNibName:@"jiesuanSecondCell" bundle:nil] forCellReuseIdentifier:@"jiesuanSecondCell"];
        self.tabV.delegate = self;
        self.tabV.dataSource = self;
        self.tabV.scrollEnabled = NO;
        [self.contentView addSubview:self.tabV];
        //通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectNameAction:) name:@"typeName" object:nil];
    }
    return self;
}
- (void)selectNameAction:(NSNotification *)not
{
    self.newstr = not.userInfo[@"names"];
    UITableViewCell *cell = [self.tabV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.rows inSection:self.sections]];
    cell.detailTextLabel.text = self.newstr;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    jiesuanListModel *model1 = self.dataArray[section];
    
    return model1.storeArray.count + 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     jiesuanListModel *model1 = self.dataArray[indexPath.section];
    if (indexPath.row == model1.storeArray.count) {
        static NSString *str1 = @"fangshi";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str1];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:str1];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"配送方式";
        
       
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",model1.logisticsCompany];
        
        
        return cell;
    } else if (indexPath.row == model1.storeArray.count + 1){
        static NSString *str1 = @"yunfei";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str1];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:str1];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"运费";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%.2f",model1.postageTotal];
        return cell;
    } else {
        jiesuanSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:@"jiesuanSecondCell" forIndexPath:indexPath];
        jiesuanListModel *model1 = self.dataArray[indexPath.section];
        jiesuanSubModel *model = model1.storeArray[indexPath.row];
        [cell.imageV sd_setImageWithURL:[NSURL URLWithString:model.picServerUrl1]];
        //标题
        cell.titleLab.text = [model goodsName];
        cell.priceLab.text = [NSString stringWithFormat:@"¥%@",[model groupBuyPrice]];
        cell.skuLab.text = model.sku;
        self.NumButton = [[HJCAjustNumButton alloc] init];
        self.NumButton.frame = CGRectMake(0, 0, 90, 30);
        
        self.NumButton.currentNum = [NSString stringWithFormat:@"%ld",(long)[model buyCount]];
      
        self.NumButton.callBack = ^(NSString *currentNum){
         
            [[NSNotificationCenter defaultCenter] postNotificationName:@"currentNum" object:nil userInfo:@{@"number":currentNum,@"skuid":@(model.skuId)}];
      
            
        };
        [cell.backView addSubview:self.NumButton];
        
          return cell;
    }
  
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    jiesuanListModel *model1 = self.dataArray[indexPath.section];
    if (indexPath.row == model1.storeArray.count) {
        return 44;
    } else if (indexPath.row == model1.storeArray.count + 1){
        return 44;
    } else {
        return 100;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     jiesuanListModel *model1 = self.dataArray[indexPath.section];
    if (indexPath.row == model1.storeArray.count) {
        
        self.sections = indexPath.section;
        self.rows = indexPath.row;
       //配送方式
        [[NSNotificationCenter defaultCenter] postNotificationName:@"typeMoney" object:nil userInfo:@{@"type":model1.takeTypeArray}];
        
    }
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
