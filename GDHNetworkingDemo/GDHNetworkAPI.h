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
                  showView:(UIView *)showView
              refreshCache:(BOOL)refreshCache;

/**获取汽车信息*/
+(void)getXMLBusQueryWithCity:(NSString *)city
                   success:(GDHResponseSuccess)success
                     faile:(GDHResponseFail)faile
                  showView:(UIView *)showView
              refreshCache:(BOOL)refreshCache;

/**获取汽车信息*/
+(void)getNewsQuerysuccess:(GDHResponseSuccess)success
                     faile:(GDHResponseFail)faile
                  showView:(UIView *)showView
              refreshCache:(BOOL)refreshCache;

/**获取汽车信息*/
+(void)getXMLNewsQuerysuccess:(GDHResponseSuccess)success
                        faile:(GDHResponseFail)faile
                     showView:(UIView *)showView
                 refreshCache:(BOOL)refreshCache;

@end
