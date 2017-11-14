//
//  AppDelegate.m
//  BBShopping
//
//  Created by mibo02 on 17/1/16.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "AppDelegate.h"
#import "PersonModel.h"
#import "BBTabBarViewController.h"


// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件

#import <UserNotifications/UserNotifications.h>

#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

static NSString *const jPushTestAppID = @"5b70fd82c3f713dba6f8b5db";
static NSString *const publishChannel = @"APP Store";

@interface AppDelegate ()<WXApiDelegate,JPUSHRegisterDelegate,UIAlertViewDelegate>
@property (nonatomic, strong)BBTabBarViewController *tabbVC;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    [NSThread sleepForTimeInterval:2];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //
    self.tabbVC =[[BBTabBarViewController alloc] init];
    
    self.window.rootViewController = self.tabbVC;
    
    [self.window makeKeyAndVisible];
    
    // 注册apns通知
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) // iOS10
    {

        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge | UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];

    }
    else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) // iOS8, iOS9
    {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil];
    }
    else // iOS7
    {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert) categories:nil];
    }

    //注册
    [JPUSHService setupWithOption:launchOptions appKey:jPushTestAppID
                          channel:publishChannel
                 apsForProduction:NO
            advertisingIdentifier:nil];
    
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0)
        {
            
            //iOS10获取registrationID放到这里了, 可以存到缓存里, 用来标识用户单独发送推送
            //先删除
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"registerID"];
            //
            [[NSUserDefaults standardUserDefaults] setValue:registrationID forKey:@"registerID"];
            
        }
        else
        {
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    
    //微信注册
    [WXApi registerApp:@"wxc6d54533357aa8df"];
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册，
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    [ShareSDK registerApp:@"BBShopping"
     
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeMail),
                            @(SSDKPlatformTypeSMS),
                            @(SSDKPlatformTypeCopy),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ),
                            @(SSDKPlatformTypeRenren),
                            @(SSDKPlatformTypeGooglePlus)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
           
             case SSDKPlatformTypeWechat:
                 //这个是微信的相关信息
                 [appInfo SSDKSetupWeChatByAppId:@"wxc6d54533357aa8df"
                                       appSecret:@"cb8c058032940a093f9b0f69f1e48f80"];
                 break;
            default:
                 break;
         }
     }];
 
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1 & alertView.tag == 20) {
        NSString *url = @"https://itunes.apple.com/cn/app/%E9%82%A6%E9%82%A6%E8%B4%AD/id1217331895?mt=8";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support（当程序在前台时，收到推送弹出的通知）
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionSound); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
    // NSLog(@"%@---------1",userInfo);
    //弹出消息框
    //[self getPushMessageAtStateActive:userInfo];
    
   
    
}
#pragma mark -- 程序运行时收到通知

-(void)getPushMessageAtStateActive:(NSDictionary *)pushMessageDic{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"订单消息提醒"
                                                                             message:[[pushMessageDic objectForKey:@"aps"]objectForKey:@"alert"]
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"查看"
                                                            style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                                
                                                                
                                                                self.tabbVC.selectedIndex = 0;
                                                                //发送通知
                                                                [[NSNotificationCenter defaultCenter] postNotificationName:@"homeMessage" object:NSIsNilTransformerName];
                                                            }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                                               
                                                           }];
    
    [alertController addAction:confirmAction];
    [alertController addAction:cancelAction];
    [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
    
}


// iOS 10 Support(程序关闭后，通过点击推送弹出的通知)
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionSound);  // 系统要求执行这个方法
    //此时进入通知消息界面
    
  //  NSLog(@"%@---------1",userInfo);
    
    self.tabbVC.selectedIndex = 0;
    //发送通知
   // [[NSNotificationCenter defaultCenter] postNotificationName:@"homeMessage" object:NSIsNilTransformerName];
    
}
//// iOS 7 Support
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    if (application.applicationState == UIApplicationStateActive) {
        //程序运行时收到通知，先弹出消息框
        
       // [self getPushMessageAtStateActive:userInfo];
        
    } else {
        //程序未运行
//        self.tabbVC.selectedIndex = 0;
//        //发送通知
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"homeMessage" object:NSIsNilTransformerName];
    }
    
    [application setApplicationIconBadgeNumber:0];
    
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
   // NSLog(@"%@-----------2",userInfo);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
    
    [application setApplicationIconBadgeNumber:0];
    if (application.applicationState == UIApplicationStateActive) {
        //程序运行时收到通知，先弹出消息框
        
     //   [self getPushMessageAtStateActive:userInfo];
        
    } else {
        //程序未运行
//        self.tabbVC.selectedIndex = 0;
//        //发送通知
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"homeMessage" object:NSIsNilTransformerName];
    }
}
//支付
//9.0前的方法，为了适配低版本 保留
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
         
      //      NSLog(@"result = %@",resultDic);
            NSString *resultStatus = [resultDic objectForKey:@"resultStatus"];
            NSString *memo;
            if ([resultStatus intValue] == 9000) {
                
                [MBProgressHUD showSuccess:@"支付成功"];
                
                [self performSelector:@selector(zhifubaoSuccessNotification) withObject:nil afterDelay:0.5];
                memo = @"支付成功!";
            }else {
                switch ([resultStatus intValue]) {
                    case 4000:
                        memo = @"失败原因:订单支付失败!";
                        [MBProgressHUD showSuccess:@"支付失败"];
                        break;
                    case 6001:
                        memo = @"失败原因:用户中途取消!";
                        [MBProgressHUD showSuccess:@"您已取消支付"];
                        //发送通知返回到主界面
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelPay" object:nil];
                        break;
                    case 6002:
                        memo = @"失败原因:网络连接出错!";
                        [MBProgressHUD showSuccess:@"网络连接出错"];
                        break;
                    case 8000:
                        memo = @"正在处理中...";
                        [MBProgressHUD showSuccess:@"正在处理中"];
                        break;
                    default:
                        memo = [resultDic objectForKey:@"memo"];
                        break;
                }
            }

        }];
        return YES;
    } else if([url.host isEqualToString:@"pay"]){
        return [WXApi handleOpenURL:url delegate:self];
    } else {
        return NO;
    }
    
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
         //   NSLog(@"result = %@",resultDic);
          
            NSString *resultStatus = [resultDic objectForKey:@"resultStatus"];
            NSString *memo;
            if ([resultStatus intValue] == 9000) {
                
                [MBProgressHUD showSuccess:@"支付成功"];
                
                [self performSelector:@selector(zhifubaoSuccessNotification) withObject:nil afterDelay:0.5];
                
                memo = @"支付成功!";
            }else {
                switch ([resultStatus intValue]) {
                    case 4000:
                        memo = @"失败原因:订单支付失败!";
                        [MBProgressHUD showSuccess:@"支付失败"];
                        break;
                    case 6001:
                        memo = @"失败原因:用户中途取消!";
                        [MBProgressHUD showSuccess:@"您已取消支付"];
                        //发送通知返回到主界面
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelPay" object:nil];
                        break;
                    case 6002:
                        memo = @"失败原因:网络连接出错!";
                        [MBProgressHUD showSuccess:@"网络连接出错"];
                        break;
                    case 8000:
                        memo = @"正在处理中...";
                        [MBProgressHUD showSuccess:@"正在处理中"];
                        break;
                    default:
                        memo = [resultDic objectForKey:@"memo"];
                        break;
                }
            }

        }];
        return YES;
    } else if([url.host isEqualToString:@"pay"]){
        return [WXApi handleOpenURL:url delegate:self];
    } else {
        return NO;
    }
}
//一秒之后执行
- (void)zhifubaoSuccessNotification
{
      [[NSNotificationCenter defaultCenter] postNotificationName:@"safePayback" object:nil];
}
//9.0后的方法
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
       //     NSLog(@"%@",resultDic);
            NSString *resultStatus = [resultDic objectForKey:@"resultStatus"];
            NSString *memo;
            if ([resultStatus intValue] == 9000) {
                
                [MBProgressHUD showSuccess:@"支付成功"];
                [self performSelector:@selector(zhifubaoSuccessNotification) withObject:nil afterDelay:0.5];
              
                
                memo = @"支付成功!";
            }else {
                switch ([resultStatus intValue]) {
                    case 4000:
                        memo = @"失败原因:订单支付失败!";
                        [MBProgressHUD showSuccess:@"支付失败"];
                        break;
                    case 6001:
                        memo = @"失败原因:用户中途取消!";
                        [MBProgressHUD showSuccess:@"您已取消支付"];
                        //发送通知返回到主界面
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelPay" object:nil];
                        break;
                    case 6002:
                        memo = @"失败原因:网络连接出错!";
                        [MBProgressHUD showSuccess:@"网络连接出错"];
                        break;
                    case 8000:
                        memo = @"正在处理中...";
                        [MBProgressHUD showSuccess:@"正在处理中"];
                        break;
                    default:
                        memo = [resultDic objectForKey:@"memo"];
                        break;
                }
            }  
         
        }];
        return YES;
    } else if([url.host isEqualToString:@"pay"]){
        return [WXApi handleOpenURL:url delegate:self];
    } else {
        return NO;
    }
}
#pragma mark - WXApiDelegate
-(void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp*response=(PayResp*)resp;  // 微信终端返回给第三方的关于支付结果的结构体
        switch (response.errCode) {
            case WXSuccess:
            {// 支付成功，向后台发送消息
            //    NSLog(@"支付成功");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"WX_PaySuccess" object:nil];
            }
                break;
            case WXErrCodeCommon:
            { //签名错误、未注册APPID、项目设置APPID不正确、注册的APPID与设置的不匹配、其他异常等
                [MBProgressHUD showError:@"支付失败"];
                
            }
                break;
            case WXErrCodeUserCancel:
            { //用户点击取消并返回
                [MBProgressHUD showError:@"取消支付"];
                //发送通知返回到主界面
                [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelPay" object:nil];
            }
                break;
            case WXErrCodeSentFail:
            { //发送失败
                [MBProgressHUD showError:@"发送失败"];
            }
                break;
            case WXErrCodeUnsupport:
            { //微信不支持
                [MBProgressHUD showError:@"微信不支持"];
            }
                break;
            case WXErrCodeAuthDeny:
            { //授权失败
                [MBProgressHUD showError:@"授权失败"];
            }
                break;
            default:
                break;
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
//    //即将进入的时候
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [JPUSHService setBadge:0];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
   
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
//清除通知中心
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
