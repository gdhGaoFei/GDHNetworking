//
//  GDHNetworkAPI.h
//  GDHNetworking
//
//  Created by 高得华 on 16/10/26.
//  Copyright © 2016年 GaoFei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDHNetworkingManager.h"

@interface GDHNetworkAPI : NSObject

+(void)loadCreateWithDic:(id)dic withName:(NSString *)name withFileName:(NSString *)fileName;

/**获取汽车信息*/
+(void)getBusQueryWithCity:(NSString *)city
                   success:(GDHResponseSuccess)success
                     faile:(GDHResponseFail)faile
                   showHUD:(BOOL)showHUD
              refreshCache:(BOOL)refreshCache;

@end
