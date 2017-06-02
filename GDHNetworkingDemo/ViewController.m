//
//  ViewController.m
//  GDHNetworkingDemo
//
//  Created by 高得华 on 16/11/28.
//  Copyright © 2016年 GaoFei. All rights reserved.
//

#import "ViewController.h"
#import "GDHNetworkAPI.h"
#import "XMLDictionary.h"

@interface ViewController ()<GDHNetworkDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 通常放在appdelegate就可以了
    [GDHNetworkingObject updateBaseUrl:@"http://60.205.224.161/user/"];
    [GDHNetworkingObject enableInterfaceDebug:YES];
    
    // 配置请求和响应类型，由于部分伙伴们的服务器不接收JSON传过去，现在默认值改成了plainText
    [GDHNetworkingObject configRequestType:GDHRequestTypePlainText
                        responseType:GDHResponseTypeJSON
                 shouldAutoEncodeUrl:YES
             callbackOnCancelRequest:NO];

    //设置请求头
    NSDictionary * headers = @{@"token":@"3780e7691c1941f5a6b87dff04cca6fc",};
    [GDHNetworkingObject configCommonHttpHeaders:headers];
    // 设置GET、POST请求都缓存
    [GDHNetworkingObject cacheGetRequest:YES shoulCachePost:YES];
    //参数
    NSDictionary * dict = @{@"headUrl":@"/head/2017/6/2/5d0a52a2bd0a4b7d9935213578a82dc2.jpg",
                            @"nickName":@"麦宠GDH",
                            @"userType":@(2),};
    [GDHNetworkingManager postReqeustWithURL:@"api/user/doComplete" params:dict successBlock:^(id returnData) {
        NSLog(@"%@",returnData);
    } failureBlock:^(NSError *error) {
        NSLog(@"%@",error);
    } progress:nil refreshCache:false showView:self.view];
    
    NSDictionary * dict1 = @{@"phone":@"13678890524",
                            @"password":@"123456",};
    [GDHNetworkingManager postReqeustWithURL:@"api/login" params:dict1 successBlock:^(id returnData) {
        NSLog(@"%@",returnData);
    } failureBlock:^(NSError *error) {
        NSLog(@"%@",error);
    } progress:nil refreshCache:false showView:self.view];
}
/**block回调数据*/
- (IBAction)blockBtnAct:(id)sender {
//    [GDHNetworkAPI getBusQueryWithCity:@"青岛"
//                               success:^(id returnData) {
//                                   [GDHNetworkAPI loadCreateWithDic:returnData withName:@"block回调数据" withFileName:@"block"];
//                               } faile:^(NSError *error) {
//                                   NSLog(@"=======error =======%@======",error);
//                               } showView:self.view refreshCache:NO];
    
    
    [GDHNetworkAPI getNewsQuerysuccess:^(id returnData) {
        
    } faile:^(NSError *error) {
        DTLog(@"=======error =======%@======",error);
    } showView:self.view refreshCache:YES];
    
}
/**Delegate回调数据*/
- (IBAction)delegateBtnAct:(id)sender {
    NSDictionary * parm = @{@"key":@"89640cff0e8e385e53e6995a4e41a043",
                            @"dtype":@"json",
                            @"word":@"高"};
    [GDHNetworkingManager getRequstWithURL:@"xhzd/query"
                                    params:parm
                                  delegate:self
                                  progress:nil refreshCache:NO showView:self.view];
}
/**SEL回调数据*/
- (IBAction)selBtnAct:(id)sender {

    NSDictionary * parm = @{@"key":@"89640cff0e8e385e53e6995a4e41a043",
                            @"dtype":@"json",
                            @"word":@"高"};
    [GDHNetworkingManager getRequstWithURL:@"xhzd/query"
                                    params:parm
                                    target:self
                                    action:@selector(finishedRequest:didFaild:)
                                  progress:^(int64_t bytesRead, int64_t totalBytesRead, int64_t totalBytesExpectedToRead) {
                                      NSLog(@"========%lld====",totalBytesExpectedToRead);
                                  } refreshCache:NO showView:self.view];
}
/**上传图片*/
- (IBAction)upLoadImageBtnAct:(id)sender {
    
    [GDHNetworkAPI getXMLNewsQuerysuccess:^(id returnData) {
        [GDHNetworkAPI loadCreateWithDic:returnData withName:@"block回调数据" withFileName:@"block"];
    } faile:^(NSError *error) {
        DTLog(@"=======error =======%@======",error);
    } showView:self.view refreshCache:YES];
    
//    [GDHNetworkAPI getXMLBusQueryWithCity:@"青岛" success:^(id returnData) {
//        [GDHNetworkAPI loadCreateWithDic:returnData withName:@"block回调数据" withFileName:@"block"];
//    } faile:^(NSError *error) {
//        DTLog(@"=======error =======%@======",error);
//    } showView:self.view refreshCache:YES];
    
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
                                showView:self.view
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
