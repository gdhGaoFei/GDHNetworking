//
//  AppDelegate.m
//  GDHNetworkingDemo
//
//  Created by 高得华 on 16/11/28.
//  Copyright © 2016年 GaoFei. All rights reserved.
//

#import "AppDelegate.h"
#import "GDHNetworkingManager.h"

//正式库 上架时需要URL
static NSString * const baseURL = @"http://v.juhe.cn/";
//测试库 调试时需要URL
//static NSString * const baseURL = @"http://v.juhe.cn/";


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //监听网络状态
    [GDHNetworkingObject StartMonitoringNetworkStatus:^(GDHNetworkStatus status) {
        switch (status) {
            case GDHNetworkStatusUnknown://未知网络
                DTLog(@"未知网络");
                break;
            case GDHNetworkStatusNotReachable://没有网络
            {
                DTLog(@"网络无连接");
                SHOW_ALERT(@"网络连接断开,请检查网络!");
            }
                break;
            case GDHNetworkStatusReachableViaWWAN:
                DTLog(@"2、3、4G网络");
                break;
            case GDHNetworkStatusReachableViaWiFi:
                DTLog(@"WiFi网络");
                break;
            default:
                break;
        }
    }];
    //设置网络问题
    [GDHNetworkingObject updateBaseUrl:baseURL];
    //    [GDHNetworkObject updateBaseCacheDocuments:@"GDH_123"];
    [GDHNetworkingObject enableInterfaceDebug:YES];
    [GDHNetworkingObject setTimeout:15];
    // 配置请求和响应类型，由于部分伙伴们的服务器不接收JSON传过去，现在默认值改成了plainText
    [GDHNetworkingObject configRequestType:GDHRequestTypeJSON
                              responseType:GDHResponseTypeJSON
                       shouldAutoEncodeUrl:YES
                   callbackOnCancelRequest:NO];
    // 设置GET、POST请求都缓存
    [GDHNetworkingObject cacheGetRequest:YES shoulCachePost:YES];
    //    [GDHNetworkObject obtainDataFromLocalWhenNetworkUnconnected:YES];
    
    return YES;
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
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
