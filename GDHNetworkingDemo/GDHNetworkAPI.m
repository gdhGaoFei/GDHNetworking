//
//  GDHNetworkAPI.m
//  GDHNetworking
//
//  Created by 高得华 on 16/10/26.
//  Copyright © 2016年 GaoFei. All rights reserved.
//

#import "GDHNetworkAPI.h"

@implementation GDHNetworkAPI

+(void)loadCreateWithDic:(id)dic withName:(NSString *)name withFileName:(NSString *)fileName{
    NSData * data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString * string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    DTLog(@"%@的json数据结构=============================%@",name,string);
    
    NSString *fileNmae = [NSString stringWithFormat:@"Documents/GDHNetworkingCaches/%@",fileName];
    //创建文本路径
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:fileNmae];
    NSLog(@"path is %@",path);
    BOOL isOk = [data writeToFile:path atomically:YES];
    if (isOk) {
        NSLog(@"json 写入成功");
    }
}

/**获取汽车信息*/
+(void)getBusQueryWithCity:(NSString *)city
                   success:(GDHResponseSuccess)success
                     faile:(GDHResponseFail)faile
                  showView:(UIView *)showView
              refreshCache:(BOOL)refreshCache{
    NSDictionary * parm = @{@"station":city,
                            @"key":@"e97e5292887f3aa1f99ab7b451ad2ad9",
                            @"dtype":@"json"};
    [GDHNetworkingManager getRequstWithURL:@"onebox/bus/query"
                                    params:parm
                              successBlock:^(id returnData) {
                                  if (success) {
                                      success(returnData);
                                  }
                               }
                               failureBlock:^(NSError *error) {
                                   if (faile) {
                                       faile(error);
                                   }
                               }
                                   progress:nil
                               refreshCache:refreshCache
                                  showView:showView];
}

/**获取汽车信息*/
+(void)getXMLBusQueryWithCity:(NSString *)city
                      success:(GDHResponseSuccess)success
                        faile:(GDHResponseFail)faile
                     showView:(UIView *)showView
                 refreshCache:(BOOL)refreshCache {
    
    [GDHNetworkingObject ChangeRequestType:GDHRequestTypeJSON responseType:GDHResponseTypeXML requestChange:NO responseChange:YES];
    
    NSDictionary * parm = @{@"station":city,
                            @"key":@"e97e5292887f3aa1f99ab7b451ad2ad9",
                            @"dtype":@"xml"};
    [GDHNetworkingManager getRequstWithURL:@"onebox/bus/query"
                                    params:parm
                              successBlock:^(id returnData) {
                                  if (success) {
                                      success(returnData);
                                  }
                              }
                              failureBlock:^(NSError *error) {
                                  if (faile) {
                                      faile(error);
                                  }
                              }
                                  progress:nil
                              refreshCache:refreshCache
                                  showView:showView];
}

/**获取汽车信息*/
+(void)getNewsQuerysuccess:(GDHResponseSuccess)success
                     faile:(GDHResponseFail)faile
                  showView:(UIView *)showView
              refreshCache:(BOOL)refreshCache {
    NSDictionary * parm = @{@"key":@"89640cff0e8e385e53e6995a4e41a043",
                            @"dtype":@"json",
                            @"word":@"高"};
    
    [GDHNetworkingManager getRequstWithURL:@"xhzd/query"
                                    params:parm
                              successBlock:^(id returnData) {
                                  if (success) {
                                      success(returnData);
                                  }
                              }
                              failureBlock:^(NSError *error) {
                                  if (faile) {
                                      faile(error);
                                  }
                              }
                                  progress:nil
                              refreshCache:refreshCache
                                  showView:showView];
}

/**获取汽车信息*/
+(void)getXMLNewsQuerysuccess:(GDHResponseSuccess)success
                        faile:(GDHResponseFail)faile
                     showView:(UIView *)showView
                 refreshCache:(BOOL)refreshCache {
    [GDHNetworkingObject ChangeRequestType:GDHRequestTypeJSON responseType:GDHResponseTypeXML requestChange:NO responseChange:YES];
    
    NSDictionary * parm = @{@"key":@"89640cff0e8e385e53e6995a4e41a043",
                            @"dtype":@"xml",
                            @"word":@"高"};
    
    [GDHNetworkingManager getRequstWithURL:@"xhzd/query"
                                    params:parm
                              successBlock:^(id returnData) {
                                  if (success) {
                                      success(returnData);
                                  }
                              }
                              failureBlock:^(NSError *error) {
                                  if (faile) {
                                      faile(error);
                                  }
                              }
                                  progress:nil
                              refreshCache:refreshCache
                                  showView:showView];

}

@end
