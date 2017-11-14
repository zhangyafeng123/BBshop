//
//  QWNViewController.m
//  图片轮播
//
//  Created by allenqu on 16/10/29.
//  Copyright © 2016年 allenqu. All rights reserved.
//

#import "QWNViewController.h"
#import "UIImageView+WebCache.h"
#define SCREEN_WIDETH [UIScreen mainScreen].bounds.size.width
//屏幕的高
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface QWNViewController ()

@property(nonatomic,strong)UIPageControl *page;
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UIScrollView *imageBgView;
@property(nonatomic,strong)NSMutableArray *images;
@property(nonatomic,strong)UIScrollView *scrView;

@end

@implementation QWNViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.scrView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDETH, SCREEN_HEIGHT)];
    self.scrView.pagingEnabled = YES;
    self.scrView.contentSize = CGSizeMake(SCREEN_WIDETH * self.imagesArr.count, SCREEN_HEIGHT);
    self.scrView.delegate = self;
    self.images = [[NSMutableArray alloc]init];
    for (int i = 0; i < self.imagesArr.count; i++) {
        self.imageBgView = [[UIScrollView alloc] init];
        self.imageBgView.tag = i;
        self.imageBgView.delegate = self;
        self.imageBgView.maximumZoomScale = 2;
        self.imageBgView.minimumZoomScale = 1;
        self.imageBgView.scrollEnabled = NO;
        self.imageBgView.showsHorizontalScrollIndicator = NO;
        self.imageBgView.showsVerticalScrollIndicator = NO;
        self.imageBgView.backgroundColor = [UIColor clearColor];
        self.imageBgView.frame = CGRectMake(i*SCREEN_WIDETH, 0, SCREEN_WIDETH, SCREEN_HEIGHT);
        [self.scrView addSubview:self.imageBgView];
        
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDETH, SCREEN_HEIGHT)];
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.imagesArr[i]]];
        
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.imageBgView addSubview:self.imageView];
        if (self.imageView.image != nil) {
            [self.images addObject:self.imageView.image];
            
        } else {
           // [MBProgressHUD showError:@"长按保存图片"];
        }
       
        
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)];
        //设置长按时间
        longPressGesture.view.tag = i;
        longPressGesture.minimumPressDuration = 0.5;
        [self.imageBgView addGestureRecognizer:longPressGesture];
    }
    
    
    
    [self.scrView setContentOffset:CGPointMake(SCREEN_WIDETH * [self.index intValue], 0)];
    
    self.page = [[UIPageControl alloc]initWithFrame:CGRectMake(SCREEN_WIDETH/2 - 50, SCREEN_HEIGHT - 50, 100, 20)];
    self.page.numberOfPages = self.imagesArr.count;//总的图片页数
    self.page.currentPage = [self.index intValue]; //当前页
    self.page.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.page];
    [self.view addSubview:self.scrView];

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    tapGesture.numberOfTapsRequired = 1; //点击次数
    tapGesture.numberOfTouchesRequired = 1; //点击手指数
    [self.view addGestureRecognizer:tapGesture]; //轻击手势触发
}

//长按手势触发方法
-(void)longPressGesture:(UILongPressGestureRecognizer *)sender
{
    UILongPressGestureRecognizer *longPress = sender;
    if (longPress.state == UIGestureRecognizerStateBegan)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认保存?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (self.images.count != 0) {
                UIImageWriteToSavedPhotosAlbum(self.images[sender.view.tag], self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
            } else {
                [MBProgressHUD showError:@"请重试"];
            }
            
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"保存成功" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    
    UIAlertController *alertController1 = [UIAlertController alertControllerWithTitle:@"保存失败" message:@"请允许程序访问你的相机" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction1 = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController1 addAction:okAction1];
    
    
    if (!error) {
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        [self presentViewController:alertController1 animated:YES completion:nil];
    }
}

//轻击手势触发方法
-(void)tapGesture:(UITapGestureRecognizer *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


//监听事件
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //更新UIPageControl的当前页
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.frame;
    [self.page setCurrentPage:offset.x / bounds.size.width];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return scrollView.subviews[0];
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
