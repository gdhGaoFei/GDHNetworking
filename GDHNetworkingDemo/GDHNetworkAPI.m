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
    NSLog(@"%@的json数据结构=============================%@",name,string);
    
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
                            @"key":@"e97e5292887f3aa1f99ab7b451ad2ad9",};
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

@end
