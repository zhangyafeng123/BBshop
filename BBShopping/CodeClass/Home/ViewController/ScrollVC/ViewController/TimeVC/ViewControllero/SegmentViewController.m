//
//  SegmentViewController.m
//  SegmentView
//
//  Created by tom.sun on 16/5/26.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "SegmentViewController.h"

#define HEADBTN_TAG                 10000
#define Default_BottomLineColor     [UIColor redColor]
#define Default_ButtonHeight        45
#define Default_TitleColor          [UIColor blackColor]
#define Default_HeadViewBackgroundColor  [UIColor whiteColor]
#define Default_FontSize            16
#define MainScreenWidth             [[UIScreen mainScreen]bounds].size.width
#define MainScreenHeight            [[UIScreen mainScreen]bounds].size.height

@interface SegmentViewController ()<UIScrollViewDelegate>

@property (nonatomic, assign) NSInteger selectIndex;

@end

@implementation SegmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(action:) name:@"scrollView" object:nil];
}
//通知执行方法
- (void)action:(NSNotification *)not
{
    if ([not.userInfo[@"y"] floatValue] < 0) {
        [UIView animateWithDuration:0.5 animations:^{
            [self.firstScrollView setContentOffset:CGPointMake(0, 0)];
        }];
    } else if([not.userInfo[@"y"] floatValue] > 0){
        [UIView animateWithDuration:0.5 animations:^{
            [self.firstScrollView setContentOffset:CGPointMake(0, 245)];
        }];
    }
   
    
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"scrollView" object:nil];
}


- (void)initSegment
{
    self.firstScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
    self.firstScrollView.contentSize = CGSizeMake(MainScreenWidth,  MainScreenHeight + 245);
    [self.view addSubview:self.firstScrollView];
    
    //添加图片
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    imageV.image = [UIImage imageNamed:@"秒杀即将开始.jpg"];
    [self.firstScrollView addSubview:imageV];
    [self addButtonInScrollHeader:_titleArray];
    [self addContentViewScrollView:_subViewControllers];
}

/*!
 *  @brief  根据传入的title数组新建button显示在顶部scrollView上
 *
 *  @param titleArray  title数组
 */
- (void)addButtonInScrollHeader:(NSArray *)titleArray
{
    self.headerView.frame = CGRectMake(0, 200, MainScreenWidth, self.buttonHeight);
    if (_segmentHeaderType == 0) {
        self.headerView.contentSize = CGSizeMake(self.buttonWidth * titleArray.count, self.buttonHeight);
    }
    else {
        self.headerView.contentSize = CGSizeMake(MainScreenWidth, self.buttonHeight);
    }
    [self.firstScrollView addSubview:self.headerView];
    
    for (NSInteger index = 0; index < titleArray.count; index++) {
        UIButton *segmentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        segmentBtn.frame = CGRectMake(self.buttonWidth * index, 0, self.buttonWidth, self.buttonHeight);
        [segmentBtn setTitle:titleArray[index] forState:UIControlStateNormal];
        segmentBtn.titleLabel.font = [UIFont systemFontOfSize:self.fontSize];
        segmentBtn.tag = index + HEADBTN_TAG;
        segmentBtn.titleLabel.font = H15;
        segmentBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        segmentBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        segmentBtn.titleLabel.numberOfLines = 2;
        
        [segmentBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [segmentBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.headerView addSubview:segmentBtn];
        if (index == 0) {
            segmentBtn.selected = YES;
            segmentBtn.backgroundColor = [ColorString colorWithHexString:@"#f9cd02"];
            self.selectIndex = segmentBtn.tag;
        }
    }
    
}


/*!
 *  @brief  根据传入的viewController数组，将viewController的view添加到显示内容的scrollView
 *
 *  @param subViewControllers  viewController数组
 */
- (void)addContentViewScrollView:(NSArray *)subViewControllers
{
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.buttonHeight + 200, MainScreenWidth, MainScreenHeight - self.buttonHeight)];
    _mainScrollView.contentSize = CGSizeMake(MainScreenWidth * subViewControllers.count, MainScreenHeight - self.buttonHeight);
    [_mainScrollView setPagingEnabled:YES];
    if (_segmentControlType == 0) {
        _mainScrollView.scrollEnabled = YES;
    }
    else {
        _mainScrollView.scrollEnabled = NO;
    }
    [_mainScrollView setShowsVerticalScrollIndicator:NO];
    [_mainScrollView setShowsHorizontalScrollIndicator:NO];
    _mainScrollView.bounces = NO;
    _mainScrollView.delegate = self;
    [self.firstScrollView addSubview:_mainScrollView];
    [subViewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        UIViewController *viewController = (UIViewController *)_subViewControllers[idx];
        viewController.view.frame = CGRectMake(idx * MainScreenWidth, 0, MainScreenWidth, _mainScrollView.frame.size.height);
        [_mainScrollView addSubview:viewController.view];
        [self addChildViewController:viewController];
    }];
}

- (void)addParentController:(UIViewController *)viewController
{
    if ([viewController respondsToSelector:@selector(edgesForExtendedLayout)])
    {
        viewController.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [viewController addChildViewController:self];
    [viewController.view addSubview:self.view];
}

- (void)btnClick:(UIButton *)button
{
    [_mainScrollView scrollRectToVisible:CGRectMake((button.tag - HEADBTN_TAG) *MainScreenWidth, 0, MainScreenWidth, _mainScrollView.frame.size.height) animated:YES];
    [self didSelectSegmentIndex:button.tag];
}

/*!
 *  @brief  设置顶部选中button下方线条位置
 *
 *  @param index 第几个
 */
- (void)didSelectSegmentIndex:(NSInteger)index
{
    UIButton *btn = (UIButton *)[self.view viewWithTag:self.selectIndex];
    btn.selected = NO;
    btn.backgroundColor = [UIColor clearColor];
    self.selectIndex = index;
    UIButton *currentSelectBtn = (UIButton *)[self.view viewWithTag:index];
    currentSelectBtn.selected = YES;
    currentSelectBtn.backgroundColor = [ColorString colorWithHexString:@"#f9cd02"];
    
}

#pragma mark - ScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _mainScrollView) {
        float xx = scrollView.contentOffset.x * (_buttonWidth / MainScreenWidth) - _buttonWidth;
        [_headerView scrollRectToVisible:CGRectMake(xx, 0, MainScreenWidth, _headerView.frame.size.height) animated:YES];
        NSInteger currentIndex = scrollView.contentOffset.x / MainScreenWidth;
        [self didSelectSegmentIndex:currentIndex + HEADBTN_TAG];
    }
    
}


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView;
{
    float xx = scrollView.contentOffset.x * (_buttonWidth / MainScreenWidth) - _buttonWidth;
    [_headerView scrollRectToVisible:CGRectMake(xx, 0, MainScreenWidth, _headerView.frame.size.height) animated:YES];
}

#pragma mark - setter/getter
- (UIScrollView *)headerView
{
    if (_headerView == nil) {
        _headerView = [[UIScrollView alloc] init];
        [_headerView setShowsVerticalScrollIndicator:NO];
        [_headerView setShowsHorizontalScrollIndicator:NO];
        _headerView.bounces = NO;
        _headerView.backgroundColor = self.headViewBackgroundColor;
    }
    return _headerView;
}

- (UIColor *)headViewBackgroundColor
{
    if (_headViewBackgroundColor == nil) {
        _headViewBackgroundColor = Default_HeadViewBackgroundColor;
    }
    return _headViewBackgroundColor;
}



- (CGFloat)fontSize
{
    if (_fontSize == 0) {
        _fontSize = Default_FontSize;
    }
    return _fontSize;
}

- (CGFloat)buttonWidth
{
    if (_buttonWidth == 0) {
        _buttonWidth = MainScreenWidth / 6;
    }
    return _buttonWidth;
}

- (CGFloat)buttonHeight
{
    if (_buttonHeight == 0) {
        _buttonHeight = Default_ButtonHeight;
    }
    return _buttonHeight;
}


@end
