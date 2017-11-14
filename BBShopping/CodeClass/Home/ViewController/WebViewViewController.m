//
//  WebViewViewController.m
//  BBShopping
//
//  Created by mibo02 on 17/3/8.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "WebViewViewController.h"

@interface WebViewViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation WebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.title = @"广告页";
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [_webView loadRequest:request];
}
- (void) webViewDidStartLoad:(UIWebView *)webView
{
    [self showProgressHUD];
}
- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideProgressHUD];
}
- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MBProgressHUD showError:@"未知错误"];
}

@end
