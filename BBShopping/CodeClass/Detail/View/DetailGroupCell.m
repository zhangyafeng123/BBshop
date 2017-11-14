//
//  DetailGroupCell.m
//  BBShopping
//
//  Created by mibo02 on 17/2/16.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "DetailGroupCell.h"

@interface DetailGroupCell ()

{
    UIView *backView;
    UIView *newView;
    UILabel *nickLab, *secLab, *threeLab, *btnLab;
    UIImageView *imgV;
    
    NSTimer *countDownTimer;
    NSInteger timerallNumber;
  
}

@end


@implementation DetailGroupCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //90
        backView = [[UIView alloc] init];
        if (isiPhone5or5sor5c) {
            backView.frame = CGRectMake(20, 5, 320 - 40, 60);
             backView.layer.cornerRadius = 30;
            newView  = [[UIView alloc] initWithFrame:CGRectMake(2, 2, backView.frame.size.width - 50, 56)];
             newView.layer.cornerRadius = 30;
            imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
            imgV.layer.cornerRadius = 30;
            btnLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(newView.frame) - 30, 0, 60, 60)];
             nickLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgV.frame), 0, 80, 28)];
             secLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nickLab.frame), 0, 80, 28)];
            threeLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgV.frame) + 5, CGRectGetMaxY(nickLab.frame), 160, 28)];
        } else {
            
            backView.frame = CGRectMake(30, 5, SCREEN_WIDTH - 60, 80);
             backView.layer.cornerRadius = 40;
            newView  = [[UIView alloc] initWithFrame:CGRectMake(2, 2, backView.frame.size.width - 70, 76)];
             newView.layer.cornerRadius = 40;
            imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
            imgV.layer.cornerRadius = 40;
             btnLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(newView.frame) - 40, 0, 80, 80)];
             nickLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgV.frame) + 5, 0, 80, 38)];
             secLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nickLab.frame), 0, 80, 38)];
            threeLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgV.frame) + 5, CGRectGetMaxY(nickLab.frame), 160, 38)];
        }
        
        
        backView.backgroundColor = [ColorString colorWithHexString:@"#f9cd02"];
       
        backView.layer.masksToBounds = YES;
        [self addSubview:backView];
        //
        
        newView.backgroundColor = [UIColor whiteColor];
       
        newView.layer.masksToBounds = YES;
        [backView addSubview:newView];
        //
        
        imgV.image = [UIImage imageNamed:@"1.jpg"];
        
        imgV.layer.borderWidth = 2;
        imgV.tag = 102;
        imgV.layer.borderColor = [ColorString colorWithHexString:@"#f9cd02"].CGColor;
        imgV.layer.masksToBounds = YES;
        [backView addSubview:imgV];
       
        btnLab.backgroundColor = [ColorString colorWithHexString:@"#f9cd02"];
        btnLab.text = @"去参团";
        btnLab.textAlignment = NSTextAlignmentRight;
        btnLab.font = H16;
        btnLab.textColor = [UIColor whiteColor];
        [backView addSubview:btnLab];
        
       
        nickLab.textAlignment = NSTextAlignmentCenter;
        nickLab.font = H12;
        nickLab.tag = 103;
        [newView addSubview:nickLab];
       
        secLab.textColor =  [ColorString colorWithHexString:@"#f9cd02"];
        secLab.text = @"小明";
        secLab.tag = 104;
        secLab.font = H12;
        secLab.textAlignment = NSTextAlignmentLeft;
        [newView addSubview:secLab];
        
        
        
        threeLab.tag  = 105;
        threeLab.font = H13;
        threeLab.textAlignment = NSTextAlignmentLeft;
        threeLab.textColor = [UIColor blackColor];
        [newView addSubview:threeLab];
        
    }
    return self;
}

- (void)getgroupforModel:(DetailGroupModel *)model
{
    
    
    UIImageView *img = (UIImageView *)[self viewWithTag:102];
    [img sd_setImageWithURL:[NSURL URLWithString:model.headImgUrl]];
    UILabel *firstlab = (UILabel *)[self viewWithTag:103];
    firstlab.text = model.nickName;
    
    UILabel *secondlab = (UILabel *)[self viewWithTag:104];
    secondlab.text = [NSString stringWithFormat:@"差%ld人成团",model.groupNumber];
        timerallNumber = 0;
     timerallNumber  = model.invalidSeconds;
    //每次要把定时器移除然后在创建使用
    [countDownTimer invalidate];
    countDownTimer = nil;
   
    //设置定时器
    countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownAction) userInfo:nil repeats:YES];
}

- (void)countDownAction
{
    UILabel *threelabel   = (UILabel *)[self viewWithTag:105];
    //倒计时-1
    timerallNumber--;
    
    //重新计算 时/分/秒
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",timerallNumber/3600];
    
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(timerallNumber%3600)/60];
    
    NSString *str_second = [NSString stringWithFormat:@"%02ld",timerallNumber%60];
    
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    //修改倒计时标签及显示内容
    threelabel.text=[NSString stringWithFormat:@"剩余%@结束",format_time];
    
    
    //当倒计时到0时做需要的操作，比如验证码过期不能提交
    if(timerallNumber==0){
        
        [countDownTimer invalidate];
    }

    
}



@end
