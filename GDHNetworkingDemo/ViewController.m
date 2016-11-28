//
//  ViewController.m
//  GDHNetworkingDemo
//
//  Created by 高得华 on 16/11/28.
//  Copyright © 2016年 GaoFei. All rights reserved.
//

#import "ViewController.h"
#import "GDHNetworkAPI.h"

@interface ViewController ()<GDHNetworkDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
/**block回调数据*/
- (IBAction)blockBtnAct:(id)sender {
    [GDHNetworkAPI getBusQueryWithCity:@"青岛"
                               success:^(id returnData) {
                                   [GDHNetworkAPI loadCreateWithDic:returnData withName:@"block回调数据" withFileName:@"block"];
                               } faile:^(NSError *error) {
                                   NSLog(@"=======error =======%@======",error);
                               } showHUD:YES refreshCache:NO];
}
/**Delegate回调数据*/
- (IBAction)delegateBtnAct:(id)sender {
    NSDictionary * parm = @{@"station":@"北京",
                            @"key":@"e97e5292887f3aa1f99ab7b451ad2ad9",};
    [GDHNetworkingManager getRequstWithURL:@"onebox/bus/query"
                                    params:parm
                                  delegate:self
                                  progress:nil refreshCache:NO showHUD:YES];
}
/**SEL回调数据*/
- (IBAction)selBtnAct:(id)sender {
    NSDictionary * parm = @{@"station":@"广州",
                            @"key":@"e97e5292887f3aa1f99ab7b451ad2ad9",};
    [GDHNetworkingManager getRequstWithURL:@"onebox/bus/query"
                                    params:parm
                                    target:self
                                    action:@selector(finishedRequest:didFaild:)
                                  progress:^(int64_t bytesRead, int64_t totalBytesRead, int64_t totalBytesExpectedToRead) {
                                      NSLog(@"========%lld====",totalBytesExpectedToRead);
                                  } refreshCache:NO showHUD:YES];
}
/**上传图片*/
- (IBAction)upLoadImageBtnAct:(id)sender {
    
    /*
     [GDHNetworkingObject uploadWithImage:<#(UIImage *)#>
     url:(NSString *)
     filename:<#(NSString *)#>
     name:<#(NSString *)#>
     mimeType:<#(NSString *)#>
     parameters:<#(NSDictionary *)#>
     showHUD:<#(BOOL)#>
     progress:<#^(int64_t bytesWritten, int64_t totalBytesWritten)progress#>
     success:<#^(id returnData)success#>
     fail:<#^(NSError *error)fail#>];
     */
}
/**上传文件*/
- (IBAction)upLoadFileBtnAct:(id)sender {
    /*
     [GDHNetworkingObject uploadFileWithUrl:<#(NSString *)#>
     uploadingFile:<#(NSString *)#>
     showHUD:<#(BOOL)#>
     progress:<#^(int64_t bytesWritten, int64_t totalBytesWritten)progress#>
     success:<#^(id returnData)success#>
     fail:<#^(NSError *error)fail#>];
     */
}
/**下载文件*/
- (IBAction)downLoadFileBtnAct:(id)sender {
    
    DTLog(@"[GDHNetworkObject baseCache] ========%@===========",[GDHNetworkingObject baseCache]);
    NSString * path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/GDHNetworking.zip",[GDHNetworkingObject baseCache]]];//
    NSLog(@"文件路径======%@=========", path);
    [GDHNetworkingObject downloadWithUrl:@"https://codeload.github.com/gdhGaoFei/GDHNetwork/zip/master"
                              saveToPath:path
                                 showHUD:YES
                                progress:^(int64_t bytesRead, int64_t totalBytesRead, int64_t totalBytesExpectedToRead) {
                                    NSLog(@"=========%lld=====%lld=====",totalBytesRead,totalBytesExpectedToRead);
                                }
                                 success:^(id returnData) {
                                  //                                  [GDHNetworkAPI loadCreateWithDic:returnData withName:@"下载文件" withFileName:@"downFile"];
                                 }
                                 failure:^(NSError *error) {
                                  
                                 }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - GDHNetworkDelegate

- (void)requestDidFinishLoading:(NSDictionary *)returnData
{
    NSLog(@"-----%@",returnData);
    [GDHNetworkAPI loadCreateWithDic:returnData withName:@"北京汽车站" withFileName:@"delegate"];
}

- (void)requestdidFailWithError:(NSError *)error
{
    NSLog(@"=======error =======%@======",error);
}
#pragma mark - target
- (void)finishedRequest:(id)data didFaild:(NSError*)error
{
    NSLog(@"---%@-%@",data,error);
}


@end
