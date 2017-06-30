//
//  GDHNetworkingManager.m
//  GDHNetworkingDemo
//
//  Created by 高得华 on 16/11/28.
//  Copyright © 2016年 GaoFei. All rights reserved.
//

#import "GDHNetworkingManager.h"
#import "MBProgressHUD.h"
#import <CommonCrypto/CommonDigest.h>
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "XMLDictionary.h"

// ========= 加密措施 ==========
@interface NSString (md5)
+ (NSString *)hybnetworking_md5:(NSString *)string;
@end

@implementation NSString (md5)
+ (NSString *)hybnetworking_md5:(NSString *)string {
    if (string == nil || [string length] == 0) {
        return nil;
    }
    unsigned char digest[CC_MD5_DIGEST_LENGTH], i;
    CC_MD5([string UTF8String], (int)[string lengthOfBytesUsingEncoding:NSUTF8StringEncoding], digest);
    NSMutableString *ms = [NSMutableString string];
    
    for (i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [ms appendFormat:@"%02x", (int)(digest[i])];
    }
    return [ms copy];
}

@end

#pragma marlk  ============  网络请求请求管理着 =============

@interface GDHNetworkingManager ()

@end

@implementation GDHNetworkingManager

#pragma mark - GET 请求的三种回调方法
/**
 *   GET请求的公共方法 一下三种方法都调用这个方法 根据传入的不同参数觉得回调的方式
 *
 *   @param url           ur
 *   @param params   paramsDict
 *   @param target       target
 *   @param action       action
 *   @param delegate     delegate
 *   @param successBlock successBlock
 *   @param failureBlock failureBlock
 *   @param progress      进度回调
 *   @param refreshCache 是否刷新缓存。由于请求成功也可能没有数据，对于业务失败，只能通过人为手动判断
 *   @param showView     showView为nil时 则不显示 showView不为nil时则显示加载框
 */
+ (GDHURLSessionTask *)getRequstWithURL:(NSString*)url
                                 params:(NSDictionary*)params
                                 target:(id)target
                                 action:(SEL)action
                               delegate:(id)delegate
                           successBlock:(GDHResponseSuccess)successBlock
                           failureBlock:(GDHResponseFail)failureBlock
                               progress:(GDHGetProgress)progress
                           refreshCache:(BOOL)refreshCache
                               showView:(UIView *)showView
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:params];
    return [GDHNetworkingObject initWithtype:GDHNetWorkTypeGET url:url params:mutableDict refreshCache:refreshCache delegate:delegate target:target action:action hashValue:0 showView:showView progress:progress successBlock:successBlock failureBlock:failureBlock];
}


/**
 *   GET请求通过Block 回调结果
 *
 *   @param url          url
 *   @param paramsDict   paramsDict
 *   @param successBlock  成功的回调
 *   @param failureBlock  失败的回调
 *   @param progress      进度回调
 *   @param refreshCache 是否刷新缓存。由于请求成功也可能没有数据，对于业务失败，只能通过人为手动判断
 *   @param showView     showView为nil时 则不显示 showView不为nil时则显示加载框
 */
+ (GDHURLSessionTask *)getRequstWithURL:(NSString *)url
                                 params:(NSDictionary *)paramsDict
                           successBlock:(GDHResponseSuccess)successBlock
                           failureBlock:(GDHResponseFail)failureBlock
                               progress:(GDHGetProgress)progress
                           refreshCache:(BOOL)refreshCache
                               showView:(UIView *)showView{
    return [self getRequstWithURL:url params:paramsDict target:nil action:nil delegate:nil successBlock:successBlock failureBlock:failureBlock progress:progress refreshCache:refreshCache showView:showView];
}

/**
 *   GET请求通过代理回调
 *
 *   @param url         url
 *   @param paramsDict  请求的参数
 *   @param delegate    delegate
 *   @param progress      进度回调
 *   @param refreshCache 是否刷新缓存。由于请求成功也可能没有数据，对于业务失败，只能通过人为手动判断
 *   @param showView     showView为nil时 则不显示 showView不为nil时则显示加载框
 */
+ (GDHURLSessionTask *)getRequstWithURL:(NSString*)url
                                 params:(NSDictionary*)paramsDict
                               delegate:(id<GDHNetworkDelegate>)delegate
                               progress:(GDHGetProgress)progress
                           refreshCache:(BOOL)refreshCache
                               showView:(UIView *)showView{
    return [self getRequstWithURL:url params:paramsDict target:nil action:nil delegate:delegate successBlock:nil failureBlock:nil progress:progress refreshCache:refreshCache showView:showView];
}
/**
 *   get 请求通过 taget 回调方法
 *
 *   @param url         url
 *   @param paramsDict  请求参数的字典
 *   @param target      target
 *   @param action      action
 *   @param progress      进度回调
 *   @param refreshCache 是否刷新缓存。由于请求成功也可能没有数据，对于业务失败，只能通过人为手动判断
 *   @param showView     showView为nil时 则不显示 showView不为nil时则显示加载框
 */
+ (GDHURLSessionTask *)getRequstWithURL:(NSString*)url
                                 params:(NSDictionary*)paramsDict
                                 target:(id)target
                                 action:(SEL)action
                               progress:(GDHGetProgress)progress
                           refreshCache:(BOOL)refreshCache
                               showView:(UIView *)showView{
    return [self getRequstWithURL:url params:paramsDict target:target action:action delegate:nil successBlock:nil failureBlock:nil progress:progress refreshCache:refreshCache showView:showView];
}

#pragma mark - 发送 POST 请求的方法

/**
 *   发送一个 POST请求的公共方法 传入不同的回调参数决定回调的方式
 *
 *   @param url           ur
 *   @param params   paramsDict
 *   @param target       target
 *   @param action       action
 *   @param delegate     delegate
 *   @param successBlock successBlock
 *   @param failureBlock failureBlock
 *   @param progress      进度回调
 *   @param refreshCache 是否刷新缓存。由于请求成功也可能没有数据，对于业务失败，只能通过人为手动判断
 *   @param showView     showView为nil时 则不显示 showView不为nil时则显示加载框
 */
+ (GDHURLSessionTask *)postReqeustWithURL:(NSString*)url
                                   params:(NSDictionary*)params
                                   target:(id)target
                                   action:(SEL)action
                                 delegate:(id<GDHNetworkDelegate>)delegate
                             successBlock:(GDHResponseSuccess)successBlock
                             failureBlock:(GDHResponseFail)failureBlock
                                 progress:(GDHGetProgress)progress
                             refreshCache:(BOOL)refreshCache
                                 showView:(UIView *)showView{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:params];
    return [GDHNetworkingObject initWithtype:GDHNetWorkTypePOST url:url params:mutableDict refreshCache:refreshCache delegate:delegate target:target action:action hashValue:1 showView:showView progress:progress successBlock:successBlock failureBlock:failureBlock];
}

/**
 *   通过 Block回调结果
 *
 *   @param url           url
 *   @param paramsDict    请求的参数字典
 *   @param successBlock  成功的回调
 *   @param failureBlock  失败的回调
 *   @param progress      进度回调
 *   @param refreshCache 是否刷新缓存。由于请求成功也可能没有数据，对于业务失败，只能通过人为手动判断
 *   @param showView     showView为nil时 则不显示 showView不为nil时则显示加载框
 */
+ (GDHURLSessionTask *)postReqeustWithURL:(NSString*)url
                                   params:(NSDictionary*)paramsDict
                             successBlock:(GDHResponseSuccess)successBlock
                             failureBlock:(GDHResponseFail)failureBlock
                                 progress:(GDHGetProgress)progress
                             refreshCache:(BOOL)refreshCache
                                 showView:(UIView *)showView{
    return [self postReqeustWithURL:url params:paramsDict target:nil action:nil delegate:nil successBlock:successBlock failureBlock:failureBlock progress:progress refreshCache:refreshCache showView:showView];
}
/**
 *   post请求通过代理回调
 *
 *   @param url         url
 *   @param paramsDict  请求的参数
 *   @param delegate    delegate
 *   @param progress      进度回调
 *   @param refreshCache 是否刷新缓存。由于请求成功也可能没有数据，对于业务失败，只能通过人为手动判断
 *   @param showView     showView为nil时 则不显示 showView不为nil时则显示加载框
 */
+ (GDHURLSessionTask *)postReqeustWithURL:(NSString*)url
                                   params:(NSDictionary*)paramsDict
                                 delegate:(id<GDHNetworkDelegate>)delegate
                                 progress:(GDHGetProgress)progress
                             refreshCache:(BOOL)refreshCache
                                 showView:(UIView *)showView{
    return [self postReqeustWithURL:url params:paramsDict target:nil action:nil delegate:delegate successBlock:nil failureBlock:nil progress:progress refreshCache:refreshCache showView:showView];
}
/**
 *   post 请求通过 target 回调结果
 *
 *   @param url         url
 *   @param paramsDict  请求参数的字典
 *   @param target      target
 *   @param progress      进度回调
 *   @param refreshCache 是否刷新缓存。由于请求成功也可能没有数据，对于业务失败，只能通过人为手动判断
 *   @param showView     showView为nil时 则不显示 showView不为nil时则显示加载框
 */
+ (GDHURLSessionTask *)postReqeustWithURL:(NSString*)url
                                   params:(NSDictionary*)paramsDict
                                   target:(id)target
                                   action:(SEL)action
                                 progress:(GDHGetProgress)progress
                             refreshCache:(BOOL)refreshCache
                                 showView:(UIView *)showView{
    return [self postReqeustWithURL:url params:paramsDict target:target action:action delegate:nil successBlock:nil failureBlock:nil progress:progress refreshCache:refreshCache showView:showView];
}

@end


#pragma mark ============ 网络请求的基类 =================

@interface GDHNetworkingObject ()<MBProgressHUDDelegate>

/**当前网络是否可以使用**/
@property (nonatomic, assign) BOOL networkError;

/**!
 * 菊花展示  展示只支持 MBProgressHUD
 */
@property (nonatomic, strong) MBProgressHUD * hud;

/**请求数据**/
@property (nonatomic, assign) GDHRequestType requestType;
/**响应数据**/
@property (nonatomic, assign) GDHResponseType responseType;

@end

//=========== 静态变量
static NSString * sg_privateNetworkBaseUrl     = nil;//baseURL
static NSString * sg_baseCacheDocuments        = @"GDHNetworkCaches";//默认的缓存路径
static BOOL sg_isBaseURLChanged                = YES;//是否更换baseURL
static NSTimeInterval sg_timeout               = 60.0f;//默认请求时间为60秒
static BOOL sg_shoulObtainLocalWhenUnconnected = NO;//检测网络是否异常
static BOOL sg_cacheGet                        = YES;//是否从缓存中Get
static BOOL sg_cachePost                       = NO;//是否从缓存中post
static GDHNetworkStatus sg_networkStatus       = GDHNetworkStatusReachableViaWiFi;//当前出入什么网络
static NSUInteger sg_maxCacheSize              = 0;//默认缓存大小
static BOOL sg_isEnableInterfaceDebug          = NO;//是否打印获取到的数据
static GDHResponseType sg_responseType         = GDHResponseTypeJSON;//响应数据默认类型
static GDHRequestType  sg_requestType          = GDHRequestTypePlainText;//请求数据的默认类型
static BOOL sg_shouldAutoEncode                = NO;//是否允许自动编码URL
static BOOL sg_shouldCallbackOnCancelRequest   = YES;//当取消请求时，是否要回调
static NSDictionary *sg_httpHeaders            = nil;//请求头字典
static NSMutableArray *sg_requestTasks;//所有的请求数组
static AFHTTPSessionManager *sg_sharedManager  = nil;
static GDHResponseType sg_responseType_first   = GDHResponseTypeJSON;//响应数据默认类型
static GDHRequestType  sg_requestType_first    = GDHRequestTypePlainText;//请求数据的默认类型
static BOOL sg_requestType_complete            = NO;//请求数据的默认类型
static BOOL sg_responseType_complete           = NO;//响应数据默认类型

@implementation GDHNetworkingObject

/**
 *  单例
 *
 *  @return GDHNetworkObject的单例对象
 */
+ (GDHNetworkingObject *)sharedInstance{
    
    static GDHNetworkingObject *handler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handler = [[GDHNetworkingObject alloc] init];
    });
    return handler;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.networkError = NO;
        cachePath();
    }
    return self;
}

/*!
 *
 *  用于指定网络请求接口的基础url，如：
 *  http://henishuo.com或者http://101.200.209.244
 *  通常在AppDelegate中启动时就设置一次就可以了。如果接口有来源
 *  于多个服务器，可以调用更新
 *
 *  @param baseUrl 网络接口的基础url
 */
+ (void)updateBaseUrl:(NSString *)baseUrl{
    if (![baseUrl isEqualToString:sg_privateNetworkBaseUrl] && baseUrl && baseUrl.length) {
        sg_isBaseURLChanged = YES;//baseURL已经更换
    } else {
        sg_isBaseURLChanged = NO;//baseURL没有更换
    }
    sg_privateNetworkBaseUrl = baseUrl;
}
/**返回baseURL*/
+ (NSString *)baseUrl{
    return sg_privateNetworkBaseUrl;
}

/**!
 项目中默认的网络缓存路径,也可以当做项目中的缓存路线,根据需求自行设置
 默认路径是(GDHNetworkCaches)
 格式是:@"Documents/GDHNetworkCaches",只需要字符串即可。
 
 @param baseCache 默认路径是(GDHNetworkCaches)
 */
+ (void)updateBaseCacheDocuments:(NSString *)baseCache {
    if (baseCache != nil && baseCache.length > 0) {
        sg_baseCacheDocuments = baseCache;
        if (![[NSFileManager defaultManager] fileExistsAtPath:cachePath() isDirectory:nil]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:cachePath()
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:nil];
        }
    }
}
/**!
 项目中默认的网络缓存路径,也可以当做项目中的缓存路线,根据需求自行设置
 
 @return 格式是:@"Documents/GDHNetworkCaches"
 */
+ (NSString *)baseCache {
    return [NSString stringWithFormat:@"Documents/%@",sg_baseCacheDocuments];
}

/**
 *	设置请求超时时间，默认为60秒
 *
 *	@param timeout 超时时间
 */
+ (void)setTimeout:(NSTimeInterval)timeout{
    sg_timeout = timeout;
}

/**
 *	当检查到网络异常时，是否从从本地提取数据。默认为NO。一旦设置为YES,当设置刷新缓存时，
 *  若网络异常也会从缓存中读取数据。同样，如果设置超时不回调，同样也会在网络异常时回调，除非
 *  本地没有数据！
 *
 *	@param shouldObtain	YES/NO
 */
+ (void)obtainDataFromLocalWhenNetworkUnconnected:(BOOL)shouldObtain{
    sg_shoulObtainLocalWhenUnconnected = shouldObtain;
    if (sg_shoulObtainLocalWhenUnconnected && (sg_cacheGet || sg_cachePost)) {
        [self StartMonitoringNetworkStatus:nil];
    }
}

/**
 *
 *	默认只缓存GET请求的数据，对于POST请求是不缓存的。如果要缓存POST获取的数据，需要手动调用设置
 *  对JSON类型数据有效，对于PLIST、XML不确定！
 *
 *	@param isCacheGet	    默认为YES
 *	@param shouldCachePost	默认为NO
 */
+ (void)cacheGetRequest:(BOOL)isCacheGet shoulCachePost:(BOOL)shouldCachePost{
    sg_cacheGet = isCacheGet;
    sg_cachePost = shouldCachePost;
}

/**
 *
 *	获取缓存总大小/bytes
 *
 *	@return 缓存大小
 */
+ (unsigned long long)totalCacheSize{
    NSString *directoryPath = cachePath();
    BOOL isDir = NO;
    unsigned long long total = 0;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:&isDir]) {
        if (isDir) {
            NSError *error = nil;
            NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryPath error:&error];
            
            if (error == nil) {
                for (NSString *subpath in array) {
                    NSString *path = [directoryPath stringByAppendingPathComponent:subpath];
                    NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:path
                                                                                          error:&error];
                    if (!error) {
                        total += [dict[NSFileSize] unsignedIntegerValue];
                    }
                }
            }
        }
    }
    
    return total;
}

/**
 *	默认不会自动清除缓存，如果需要，可以设置自动清除缓存，并且需要指定上限。当指定上限>0M时，
 *  若缓存达到了上限值，则每次启动应用则尝试自动去清理缓存。
 *
 *	@param mSize				缓存上限大小，单位为M（兆），默认为0，表示不清理
 */
+ (void)autoToClearCacheWithLimitedToSize:(NSUInteger)mSize{
    sg_maxCacheSize = mSize;
}

/**
 *
 *	清除缓存
 */
- (BOOL)clearCaches{
    NSString *directoryPath = cachePath();
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:nil]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:directoryPath error:&error];
        
        if (error) {
            NSLog(@"GDHNetworking clear caches error: %@", error);
            return NO;
        } else {
            NSLog(@"GDHNetworking clear caches ok");
            return YES;
        }
    }else{
        return NO;
    }
}

/*!
 *
 *  开启或关闭接口打印信息
 *
 *  @param isDebug 开发期，最好打开，默认是NO
 */
+ (void)enableInterfaceDebug:(BOOL)isDebug{
    sg_isEnableInterfaceDebug = isDebug;
}
+ (BOOL)isDebug {
    return sg_isEnableInterfaceDebug;
}

/*!
 *
 *  配置请求格式，默认为JSON。如果要求传XML或者PLIST，请在全局配置一下
 *
 *  @param requestType 请求格式，默认为JSON
 *  @param responseType 响应格式，默认为JSON
 *  @param shouldAutoEncode YES or NO,默认为NO，是否自动encode url
 *  @param shouldCallbackOnCancelRequest 当取消请求时，是否要回调，默认为YES
 */
+ (void)configRequestType:(GDHRequestType)requestType
             responseType:(GDHResponseType)responseType
      shouldAutoEncodeUrl:(BOOL)shouldAutoEncode
  callbackOnCancelRequest:(BOOL)shouldCallbackOnCancelRequest{
    sg_requestType_first  = requestType;
    sg_responseType_first = responseType;
    sg_shouldAutoEncode   = shouldAutoEncode;
    sg_shouldCallbackOnCancelRequest = shouldCallbackOnCancelRequest;
}

/**!
 *  配置请求格式，默认为JSON。如果要求传XML或者PLIST，请在全局配置一下
 *
 *  @param requestType 请求格式，默认为JSON
 *  @param responseType 响应格式，默认为JSON
 *  @param requestChange 改变请求格式 请设置为YES
 *  @param responseChange 改变响应格式 请设置为YES
 */
+ (void)ChangeRequestType:(GDHRequestType)requestType
             responseType:(GDHResponseType)responseType
            requestChange:(BOOL)requestChange
           responseChange:(BOOL)responseChange {
    sg_requestType           = requestType;
    sg_responseType          = responseType;
    sg_requestType_complete  = requestChange;
    sg_responseType_complete = responseChange;
}


+ (BOOL)shouldEncode {
    return sg_shouldAutoEncode;
}
/*!
 *
 *  配置公共的请求头，只调用一次即可，通常放在应用启动的时候配置就可以了
 *
 *  @param httpHeaders 只需要将与服务器商定的固定参数设置即可
 */
+ (void)configCommonHttpHeaders:(NSDictionary *)httpHeaders{
    sg_httpHeaders = httpHeaders;
}

//获取所有的请求
+ (NSMutableArray *)allTasks {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (sg_requestTasks == nil) {
            sg_requestTasks = [[NSMutableArray alloc] init];
        }
    });
    
    return sg_requestTasks;
}

/**
 *
 *	取消所有请求
 */
+ (void)cancelAllRequest{
    @synchronized(self) {
        [[self allTasks] enumerateObjectsUsingBlock:^(GDHURLSessionTask * _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task isKindOfClass:[GDHURLSessionTask class]]) {
                [task cancel];
            }
        }];
        
        [[self allTasks] removeAllObjects];
    };
}
/**
 *
 *	取消某个请求。如果是要取消某个请求，最好是引用接口所返回来的HYBURLSessionTask对象，
 *  然后调用对象的cancel方法。如果不想引用对象，这里额外提供了一种方法来实现取消某个请求
 *
 *	@param url				URL，可以是绝对URL，也可以是path（也就是不包括baseurl）
 */
+ (void)cancelRequestWithURL:(NSString *)url{
    if (url == nil) {
        return;
    }
    
    @synchronized(self) {
        [[self allTasks] enumerateObjectsUsingBlock:^(GDHURLSessionTask * _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task isKindOfClass:[GDHURLSessionTask class]]
                && [task.currentRequest.URL.absoluteString hasSuffix:url]) {
                [task cancel];
                [[self allTasks] removeObject:task];
                return;
            }
        }];
    };
}

/**
 监听网络状态的变化
 
 @param statusBlock 返回网络枚举类型:GDHNetworkStatus
 */
+ (void)StartMonitoringNetworkStatus:(GDHNetworkStatusBlock)statusBlock {
    if (![[NSFileManager defaultManager] fileExistsAtPath:cachePath() isDirectory:nil]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:cachePath()
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }
    
    AFNetworkReachabilityManager *reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    
    [reachabilityManager startMonitoring];
    [reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable){//网络无连接
            sg_networkStatus = GDHNetworkStatusNotReachable;
            [GDHNetworkingObject sharedInstance].networkError = YES;
            //            DTLog(@"网络无连接");
            //SHOW_ALERT(@"网络连接断开,请检查网络!");
            if (statusBlock) {
                statusBlock (sg_networkStatus);
            }
        } else if (status == AFNetworkReachabilityStatusUnknown){//未知网络
            sg_networkStatus = GDHNetworkStatusUnknown;
            [GDHNetworkingObject sharedInstance].networkError = NO;
            //            DTLog(@"未知网络");
            if (statusBlock) {
                statusBlock (sg_networkStatus);
            }
        } else if (status == AFNetworkReachabilityStatusReachableViaWWAN){//2，3，4G网络
            sg_networkStatus = GDHNetworkStatusReachableViaWWAN;
            [GDHNetworkingObject sharedInstance].networkError = NO;
            //            DTLog(@"2，3，4G网络");
            if (statusBlock) {
                statusBlock (sg_networkStatus);
            }
        } else if (status == AFNetworkReachabilityStatusReachableViaWiFi){//WIFI网络
            sg_networkStatus = GDHNetworkStatusReachableViaWiFi;
            [GDHNetworkingObject sharedInstance].networkError = NO;
            //            DTLog(@"WIFI网络");
            if (statusBlock) {
                statusBlock (sg_networkStatus);
            }
        }
    }];
}

//获取默认缓存位置
static inline NSString *cachePath() {
    return [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",sg_baseCacheDocuments]];
}


#pragma mark - 创建一个网络请求项
/**
 *  创建一个网络请求项
 *
 *  @param url          网络请求URL
 *  @param networkType  网络请求方式
 *  @param params       网络请求参数
 *  @param refreshCache 是否获取缓存。无网络或者获取数据失败则获取本地缓存数据
 *  @param delegate     网络请求的委托，如果没有取消网络请求的需求，可传nil
 *  @param showView     showView为nil时 则不显示 showView不为nil时则显示加载框
 *  @param successBlock 请求成功后的block
 *  @param failureBlock 请求失败后的block
 *
 *  @return 根据网络请求的委托delegate而生成的唯一标示
 */
+ (GDHURLSessionTask *)initWithtype:(GDHNetWorkType)networkType
                                url:(NSString *)url
                             params:(NSDictionary *)params
                       refreshCache:(BOOL)refreshCache
                           delegate:(id)delegate
                             target:(id)target
                             action:(SEL)action
                          hashValue:(NSUInteger)hashValue
                           showView:(UIView *)showView
                           progress:(GDHDownloadProgress)progress
                       successBlock:(GDHResponseSuccess)successBlock
                       failureBlock:(GDHResponseFail)failureBlock{
    
    GDHNetworkingObject * object = [GDHNetworkingObject sharedInstance];
    
    object.delegate = delegate;
    object.tagrget  = target;
    object.select   = action;
    
    if (showView != nil) {
        [MBProgressHUD showHUDAddedTo:showView animated:YES];
    }
    
    if ([self shouldEncode]) {
        url = [self encodeUrl:url];
    }
    
    AFHTTPSessionManager *manager = [GDHNetworkingObject manager];
    NSString *absolute = [self absoluteUrlWithPath:url];
    
    if ([self baseUrl] == nil) {
        if ([NSURL URLWithString:url] == nil) {
            DTLog(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
            SHOW_ALERT(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
            if (showView != nil) {
                [MBProgressHUD hideAllHUDsForView:showView animated:YES];
            }
            if (failureBlock) {
                failureBlock(nil);
            }
            //还原初始值
            [GDHNetworkingObject huanyuanchushizhi];
            return nil;
        }
    } else {
        NSURL *absoluteURL = [NSURL URLWithString:absolute];
        
        if (absoluteURL == nil) {
            DTLog(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
            SHOW_ALERT(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
            if (showView != nil) {
                [MBProgressHUD hideAllHUDsForView:showView animated:YES];
            }
            if (failureBlock) {
                failureBlock(nil);
            }
            //还原初始值
            [GDHNetworkingObject huanyuanchushizhi];
            return nil;
        }
    }
    
    GDHURLSessionTask *session = nil;
    
    if (networkType == GDHNetWorkTypeGET) {//GET请求
        if (sg_cacheGet) {//需要获取缓存
            if (sg_networkStatus == GDHNetworkStatusNotReachable ||  sg_networkStatus == GDHNetworkStatusUnknown) {
                id response = [GDHNetworkingObject cahceResponseWithURL:absolute parameters:params];

                if (refreshCache && response) {//缓存数据中存在
                    
                    if (successBlock) {//block返回数据
                        [self successResponse:response callback:successBlock];
                    }
                    
                    if (delegate) {//代理
                        if ([object.delegate respondsToSelector:@selector(requestDidFinishLoading:)]) {
                            [object.delegate requestDidFinishLoading:[self tryToParseData:response]];
                        };
                    }
                    
                    //方法
                    [object performSelector:@selector(finishedRequest: didFaild:) withObject:[self tryToParseData:response] withObject:nil];
                    
                    if ([self isDebug]) {
                        [self logWithSuccessResponse:response url:absolute params:params];
                    }
                    
                    if (showView) [MBProgressHUD hideAllHUDsForView:showView animated:true];
                    
                    //还原初始值
                    [GDHNetworkingObject huanyuanchushizhi];
                    return nil;
                }else{
                    if (showView) [MBProgressHUD hideAllHUDsForView:showView animated:true];
                    if (failureBlock) failureBlock(nil);
                    SHOW_ALERT(@"网络连接断开,请检查网络!");
                    //还原初始值
                    [GDHNetworkingObject huanyuanchushizhi];
                    return nil;
                }
            }
        }
        
        session = [manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            if (progress) {
                progress(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount,downloadProgress.totalUnitCount-downloadProgress.completedUnitCount);
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            //Block
            if (successBlock) [self successResponse:responseObject callback:successBlock];
            
            if (delegate) {//delegate
                if ([object.delegate respondsToSelector:@selector(requestDidFinishLoading:)]) {
                    [object.delegate requestDidFinishLoading:[self tryToParseData:responseObject]];
                };
            }
            
            //方法
            [object performSelector:@selector(finishedRequest: didFaild:) withObject:[self tryToParseData:responseObject] withObject:nil];
            
            if (sg_cacheGet) {
                [self cacheResponseObject:responseObject request:absolute parameters:params];
            }
            
            [[self allTasks] removeObject:task];
            
            if ([self isDebug]) {
                [self logWithSuccessResponse:responseObject url:absolute params:params];
            }
            
            if (showView) [MBProgressHUD hideAllHUDsForView:showView animated:YES];
            
            //还原初始值
            [GDHNetworkingObject huanyuanchushizhi];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [[self allTasks] removeObject:task];
            
            if ([error code] < 0 && refreshCache) {// 获取缓存
                id response = [GDHNetworkingObject cahceResponseWithURL:absolute parameters:params];
                
                if (response) {
                    if (successBlock) {//block返回数据
                        [self successResponse:response callback:successBlock];
                    }
                    
                    if (delegate) {//代理
                        if ([object.delegate respondsToSelector:@selector(requestDidFinishLoading:)]) {
                            [object.delegate requestDidFinishLoading:[self tryToParseData:response]];
                        };
                    }
                    //方法
                    [object performSelector:@selector(finishedRequest: didFaild:) withObject:[self tryToParseData:response] withObject:nil];
                    
                    if ([self isDebug]) {
                        [self logWithSuccessResponse:response url:absolute params:params];
                    }
                    if (showView) {
                        [MBProgressHUD hideAllHUDsForView:showView animated:YES];
                    }
                    
                } else {
                    
                    //block
                    [self handleCallbackWithError:error fail:failureBlock];
                    
                    //代理
                    if ([object.delegate respondsToSelector:@selector(requestdidFailWithError:)]) {
                        [object.delegate requestdidFailWithError:error];
                    }
                    //方法
                    [object performSelector:@selector(finishedRequest: didFaild:) withObject:nil withObject:error];
                    
                    if ([self isDebug]) {
                        [self logWithFailError:error url:absolute params:params];
                    }
                    if (showView) {
                        [MBProgressHUD hideAllHUDsForView:showView animated:YES];
                    }
                }
            } else {
                //block
                [self handleCallbackWithError:error fail:failureBlock];
                
                //代理
                if ([object.delegate respondsToSelector:@selector(requestdidFailWithError:)]) {
                    [object.delegate requestdidFailWithError:error];
                }
                //方法
                [object performSelector:@selector(finishedRequest: didFaild:) withObject:nil withObject:error];
                
                if ([self isDebug]) {
                    [self logWithFailError:error url:absolute params:params];
                }
                
                if (showView) {
                    [MBProgressHUD hideAllHUDsForView:showView animated:YES];
                }
            }
            //还原初始值
            [GDHNetworkingObject huanyuanchushizhi];
        }];
        
    }else if (networkType == GDHNetWorkTypePOST){//POST请求
        if (sg_cachePost) {
            if (sg_networkStatus == GDHNetworkStatusNotReachable ||  sg_networkStatus == GDHNetworkStatusUnknown) {// 获取缓存 ===> 没有网
                id response = [GDHNetworkingObject cahceResponseWithURL:absolute parameters:params];

                if (refreshCache && response) {//===>获取缓存数据
                    if (successBlock) {//block返回数据
                        [self successResponse:response callback:successBlock];
                    }
                    
                    if (delegate) {//代理
                        if ([object.delegate respondsToSelector:@selector(requestDidFinishLoading:)]) {
                            [object.delegate requestDidFinishLoading:[self tryToParseData:response]];
                        };
                    }
                    
                    //方法
                    [object performSelector:@selector(finishedRequest: didFaild:) withObject:[self tryToParseData:response] withObject:nil];
                    
                    if ([self isDebug]) {
                        [self logWithSuccessResponse:response url:absolute params:params];
                    }
                    
                    if (showView) [MBProgressHUD hideAllHUDsForView:showView animated:true];
                    
                    //还原初始值
                    [GDHNetworkingObject huanyuanchushizhi];
                    
                    return nil;

                }else{
                    if (showView) [MBProgressHUD hideAllHUDsForView:showView animated:true];
                    if (failureBlock) failureBlock(nil);
                    SHOW_ALERT(@"网络连接断开,请检查网络!");
                    //还原初始值
                    [GDHNetworkingObject huanyuanchushizhi];
                    return nil;
                }
            }
        }
        
        session = [manager POST:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            if (progress) {
                progress(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount,downloadProgress.totalUnitCount-downloadProgress.completedUnitCount);
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (successBlock) {//block返回数据
                [self successResponse:responseObject callback:successBlock];
            }
            
            if (delegate) {//代理
                if ([object.delegate respondsToSelector:@selector(requestDidFinishLoading:)]) {
                    [object.delegate requestDidFinishLoading:[self tryToParseData:responseObject]];
                };
            }
            
            //方法
            [object performSelector:@selector(finishedRequest: didFaild:) withObject:[self tryToParseData:responseObject] withObject:nil];
            
            if ([self isDebug]) {
                [self logWithSuccessResponse:responseObject
                                         url:absolute
                                      params:params];
            }
            
            if (sg_cachePost) {
                [self cacheResponseObject:responseObject request:absolute  parameters:params];
            }
            
            [[self allTasks] removeObject:task];
            
            if ([self isDebug]) {
                [self logWithSuccessResponse:responseObject
                                         url:absolute
                                      params:params];
            }
            
            if (showView != nil) {
                [MBProgressHUD hideAllHUDsForView:showView animated:YES];
            }
            
            //还原初始值
            [GDHNetworkingObject huanyuanchushizhi];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [[self allTasks] removeObject:task];
            
            if ([error code] < 0 && refreshCache) {// 获取缓存
                id response = [GDHNetworkingObject cahceResponseWithURL:absolute
                                                             parameters:params];
                
                if (response) {
                    if (successBlock) {//block返回数据
                        [self successResponse:response callback:successBlock];
                    }
                    
                    if (delegate) {//代理
                        if ([object.delegate respondsToSelector:@selector(requestDidFinishLoading:)]) {
                            [object.delegate requestDidFinishLoading:[self tryToParseData:response]];
                        };
                    }
                    
                    //方法
                    [object performSelector:@selector(finishedRequest: didFaild:) withObject:[self tryToParseData:response] withObject:nil];
                    
                    if ([self isDebug]) {
                        [self logWithSuccessResponse:response
                                                 url:absolute
                                              params:params];
                    }
                    
                    if (showView != nil) {
                        [MBProgressHUD hideAllHUDsForView:showView animated:YES];
                    }
                    
                } else {
                    [self handleCallbackWithError:error fail:failureBlock];
                    //代理
                    if ([object.delegate respondsToSelector:@selector(requestdidFailWithError:)]) {
                        [object.delegate requestdidFailWithError:error];
                    }
                    //方法
                    [object performSelector:@selector(finishedRequest: didFaild:) withObject:nil withObject:error];
                    if ([self isDebug]) {
                        [self logWithFailError:error url:absolute params:params];
                    }
                }
                
                if (showView != nil) {
                    [MBProgressHUD hideAllHUDsForView:showView animated:YES];
                }
            } else {
                [self handleCallbackWithError:error fail:failureBlock];
                
                //代理
                if ([object.delegate respondsToSelector:@selector(requestdidFailWithError:)]) {
                    [object.delegate requestdidFailWithError:error];
                }
                //方法
                [object performSelector:@selector(finishedRequest: didFaild:) withObject:nil withObject:error];
                
                if ([self isDebug]) {
                    [self logWithFailError:error url:absolute params:params];
                }
                
                if (showView != nil) {
                    [MBProgressHUD hideAllHUDsForView:showView animated:YES];
                }
            }
            
            //还原初始值
            [GDHNetworkingObject huanyuanchushizhi];
        }];
        
    }
    
    if (session) {
        [[self allTasks] addObject:session];
    }
    
    return session;
}

#pragma mark - Private
+ (AFHTTPSessionManager *)manager {
    @synchronized (self) {
        
        GDHNetworkingObject * networkObject = [GDHNetworkingObject sharedInstance];
        
        // 只要不切换baseurl，就一直使用同一个session manager
        if (sg_sharedManager == nil || sg_isBaseURLChanged) {
            // 开启转圈圈
            [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
            
            AFHTTPSessionManager *manager = nil;;
            if ([GDHNetworkingObject baseUrl] != nil) {
                manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:[GDHNetworkingObject baseUrl]]];
            } else {
                manager = [AFHTTPSessionManager manager];
            }
            
            if (!sg_requestType_complete) {//请求数据
                networkObject.requestType = sg_requestType_first;
            }else{
                networkObject.requestType = sg_requestType;
            }
            
            switch (networkObject.requestType) {
                case GDHRequestTypeJSON: {
                    manager.requestSerializer = [AFJSONRequestSerializer serializer];
                    break;
                }
                case GDHRequestTypePlainText: {
                    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
                    break;
                }
                default: {
                    break;
                }
            }
            
            if (!sg_responseType_complete) {//响应数据
                networkObject.responseType = sg_responseType_first;
            }else{
                networkObject.responseType = sg_responseType;
            }
            
            
            switch (networkObject.responseType) {
                case GDHResponseTypeJSON: {
                    manager.responseSerializer = [AFJSONResponseSerializer serializer];
                    break;
                }
                case GDHResponseTypeXML: {
                    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
                    break;
                }
                case GDHResponseTypeData: {
                    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                    break;
                }
                default: {
                    break;
                }
            }
            
            manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
            
            
            for (NSString *key in sg_httpHeaders.allKeys) {
                if (sg_httpHeaders[key] != nil) {
                    [manager.requestSerializer setValue:sg_httpHeaders[key] forHTTPHeaderField:key];
                }
            }
            
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                                      @"text/html",
                                                                                      @"text/json",
                                                                                      @"text/plain",
                                                                                      @"text/javascript",
                                                                                      @"text/xml",
                                                                                      @"image/*"]];
            
            manager.requestSerializer.timeoutInterval = sg_timeout;
            
            // 设置允许同时最大并发数量，过大容易出问题
            manager.operationQueue.maxConcurrentOperationCount = 3;
            sg_sharedManager = manager;
        }
    }
    
    return sg_sharedManager;
}

+ (NSString *)absoluteUrlWithPath:(NSString *)path {
    if (path == nil || path.length == 0) {
        return @"";
    }
    
    if ([self baseUrl] == nil || [[self baseUrl] length] == 0) {
        return path;
    }
    
    NSString *absoluteUrl = path;
    
    if (![path hasPrefix:@"http://"] && ![path hasPrefix:@"https://"]) {
        if ([[self baseUrl] hasSuffix:@"/"]) {
            if ([path hasPrefix:@"/"]) {
                NSMutableString * mutablePath = [NSMutableString stringWithString:path];
                [mutablePath deleteCharactersInRange:NSMakeRange(0, 1)];
                absoluteUrl = [NSString stringWithFormat:@"%@%@",
                               [self baseUrl], mutablePath];
            } else {
                absoluteUrl = [NSString stringWithFormat:@"%@%@",[self baseUrl], path];
            }
        } else {
            if ([path hasPrefix:@"/"]) {
                absoluteUrl = [NSString stringWithFormat:@"%@%@",[self baseUrl], path];
            } else {
                absoluteUrl = [NSString stringWithFormat:@"%@/%@",
                               [self baseUrl], path];
            }
        }
    }
    
    return absoluteUrl;
}

+ (NSString *)encodeUrl:(NSString *)url {
    return [self hyb_URLEncode:url];
}
+ (NSString *)hyb_URLEncode:(NSString *)url {
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    // 采用下面的方式反而不能请求成功
    //  NSString *newString =
    //  CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
    //                                                            (CFStringRef)url,
    //                                                            NULL,
    //                                                            CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
    //  if (newString) {
    //    return newString;
    //  }
    //
    //  return url;
}

+ (id)cahceResponseWithURL:(NSString *)url parameters:params {
    id cacheData = nil;
    
    if (url) {
        // Try to get datas from disk
        NSString *directoryPath = cachePath();
        NSString *absoluteURL = [self generateGETAbsoluteURL:url params:params];
        NSString *key = [NSString hybnetworking_md5:absoluteURL];
        NSString *path = [directoryPath stringByAppendingPathComponent:key];
        
        NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
        if (data) {
            cacheData = data;
            DTLog(@"Read data from cache for url: %@\n", url);
        }
    }
    
    return cacheData;
}

+ (void)successResponse:(id)responseData callback:(GDHResponseSuccess)success {
    if (success) {
        success([self tryToParseData:responseData]);
    }
}

//尝试解析请求下来的数据
+ (id)tryToParseData:(id)responseData {
    if ([responseData isKindOfClass:[NSData class]]) {
        // 尝试解析成JSON
        if (responseData == nil) {
            return responseData;
        } else {
            NSError *error = nil;
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseData
                                                                     options:NSJSONReadingMutableContainers
                                                                       error:&error];
            
            if (error != nil) {
                return responseData;
            } else {
                return response;
            }
        }
    } else if ([responseData isKindOfClass:[NSXMLParser class]]){
        return [NSDictionary dictionaryWithXMLParser:responseData];
    }else  {
        return responseData;
    }
}

/**----解析数据*/
+ (void)logWithSuccessResponse:(id)response url:(NSString *)url params:(NSDictionary *)params {
    
    NSDictionary * dic = (NSDictionary *)[GDHNetworkingObject tryToParseData:response];
    if ([response isKindOfClass:[NSXMLParser class]]) {
        dic = [NSDictionary dictionaryWithXMLParser:response];
    }
    
    NSString * string = @"解析数据出错";
    if (dic != nil) {
        NSData * data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    DTLog(@"\n");
    DTLog(@"\nRequest success, URL: %@\n params:%@\n response:%@\n\n",
          [self generateGETAbsoluteURL:url params:params],
          params, string);
}

/**-----解析数据*/
// 仅对一级字典结构起作用
+ (NSString *)generateGETAbsoluteURL:(NSString *)url params:(id)params {
    if (params == nil || ![params isKindOfClass:[NSDictionary class]] || ((NSDictionary *)params).count == 0) {
        return url;
    }
    
    NSString *queries = @"";
    for (NSString *key in params) {
        id value = [params objectForKey:key];
        
        if ([value isKindOfClass:[NSDictionary class]]) {
            continue;
        } else if ([value isKindOfClass:[NSArray class]]) {
            continue;
        } else if ([value isKindOfClass:[NSSet class]]) {
            continue;
        } else {
            queries = [NSString stringWithFormat:@"%@%@=%@&",
                       (queries.length == 0 ? @"&" : queries),
                       key,
                       value];
        }
    }
    
    if (queries.length > 1) {
        queries = [queries substringToIndex:queries.length - 1];
    }
    
    if (([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"]) && queries.length > 1) {
        if ([url rangeOfString:@"?"].location != NSNotFound
            || [url rangeOfString:@"#"].location != NSNotFound) {
            url = [NSString stringWithFormat:@"%@%@", url, queries];
        } else {
            queries = [queries substringFromIndex:1];
            url = [NSString stringWithFormat:@"%@?%@", url, queries];
        }
    }
    
    return url.length == 0 ? queries : url;
}

+ (void)cacheResponseObject:(id)responseObject request:(NSString *)request parameters:params {
    responseObject = [self tryToParseData:responseObject];
    if (request && responseObject && ![responseObject isKindOfClass:[NSNull class]]) {
        NSString *directoryPath = cachePath();
        
        NSError *error = nil;
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:nil]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:&error];
            if (error) {
                DTLog(@"create cache dir error: %@\n", error);
                return;
            }
        }
        
        NSString *absoluteURL = [self generateGETAbsoluteURL:request params:params];
        NSString *key = [NSString hybnetworking_md5:absoluteURL];
        NSString *path = [directoryPath stringByAppendingPathComponent:key];
        NSDictionary *dict = (NSDictionary *)responseObject;
        
        NSData *data = nil;
        if ([dict isKindOfClass:[NSData class]]) {
            data = responseObject;
        } else {
            data = [NSJSONSerialization dataWithJSONObject:dict
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:&error];
        }
        
        if (data && error == nil) {
            BOOL isOk = [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil];
            if (isOk) {
                DTLog(@"cache file ok for request: %@\n", absoluteURL);
            } else {
                DTLog(@"cache file error for request: %@\n", absoluteURL);
            }
        }
    }
}


+ (void)handleCallbackWithError:(NSError *)error fail:(GDHResponseFail)fail {
    if ([error code] == NSURLErrorCancelled) {
        if (sg_shouldCallbackOnCancelRequest) {
            if (fail) {
                fail(error);
            }
        }
    } else {
        if (fail) {
            fail(error);
        }
    }
}

+ (void)logWithFailError:(NSError *)error url:(NSString *)url params:(id)params {
    NSString *format = @" params: ";
    if (params == nil || ![params isKindOfClass:[NSDictionary class]]) {
        format = @"";
        params = @"";
    }
    
    DTLog(@"\n");
    if ([error code] == NSURLErrorCancelled) {
        DTLog(@"\nRequest was canceled mannully, URL: %@ %@%@\n\n",
              [self generateGETAbsoluteURL:url params:params],
              format,
              params);
    } else {
        DTLog(@"\nRequest error, URL: %@ %@%@\n errorInfos:%@\n\n",
              [self generateGETAbsoluteURL:url params:params],
              format,
              params,
              [error localizedDescription]);
    }
}


/**
 *
 *	图片上传接口，若不指定baseurl，可传完整的url
 *
 *	@param image			图片对象
 *	@param url				上传图片的接口路径，如/path/images/
 *	@param filename		给图片起一个名字，默认为当前日期时间,格式为"yyyyMMddHHmmss"，后缀为`jpg`
 *	@param name				与指定的图片相关联的名称，这是由后端写接口的人指定的，如imagefiles
 *	@param mimeType		默认为image/jpeg
 *	@param parameters	参数
 *	@param progress		上传进度
 *  @param showView     showView为nil时 则不显示 showView不为nil时则显示加载框
 *	@param success		上传成功回调
 *	@param fail		    上传失败回调
 *
 */
+ (void)uploadWithImage:(UIImage *)image
                                   url:(NSString *)url
                              filename:(NSString *)filename
                                  name:(NSString *)name
                              mimeType:(NSString *)mimeType
                            parameters:(NSDictionary *)parameters
                              showView:(UIView *)showView
                              progress:(GDHUploadProgress)progress
                               success:(SuccessImagesBlock)success
                                  fail:(FailureImagesBlock)fail {
    [GDHNetworkingObject uploadWithImages:@[image] url:url filename:filename name:name mimeType:mimeType parameters:parameters showView:showView progress:progress success:success fail:fail];
}


/**
 *
 *	图片上传接口，若不指定baseurl，可传完整的url
 *
 *	@param images			图片对象数组
 *	@param url				上传图片的接口路径，如/path/images/
 *	@param filename		给图片起一个名字，默认为当前日期时间,格式为"yyyyMMddHHmmss"，后缀为`jpg`
 *	@param name				与指定的图片相关联的名称，这是由后端写接口的人指定的，如imagefiles
 *	@param mimeType		默认为image/jpeg
 *	@param parameters	参数
 *	@param progress		上传进度
 *  @param showView     showView为nil时 则不显示 showView不为nil时则显示加载框
 *	@param success		上传成功回调
 *	@param fail		    上传失败回调
 *
 */
+ (void)uploadWithImages:(NSArray <UIImage *>*)images
                     url:(NSString *)url
                filename:(NSString *)filename
                    name:(NSString *)name
                mimeType:(NSString *)mimeType
              parameters:(NSDictionary *)parameters
                showView:(UIView *)showView
                progress:(GDHUploadProgress)progress
                 success:(SuccessImagesBlock)success
                    fail:(FailureImagesBlock)fail {
    
    // 准备保存结果的数组，元素个数与上传的图片个数相同，先用 NSNull 占位
    NSMutableArray * result      = [NSMutableArray array];
    NSMutableArray * errorresult = [NSMutableArray array];
    NSMutableArray * errorimage  = [NSMutableArray arrayWithArray:images];
    
    for (NSInteger i = 0; i < images.count; i++) {
        [result addObject:[NSNull null]];
        [errorresult addObject:[NSNull null]];
    }
    
    if (sg_networkStatus == GDHNetworkStatusNotReachable ||  sg_networkStatus == GDHNetworkStatusUnknown ) {
        SHOW_ALERT(@"网络连接断开,请检查网络!");
        if (fail) {
            fail(errorimage, errorresult);
        }
        //还原初始值
        [GDHNetworkingObject huanyuanchushizhi];
        return ;
    }
    
    if (showView) {
        [GDHNetworkingObject sharedInstance].hud = [MBProgressHUD showHUDAddedTo:showView animated:YES];
        [GDHNetworkingObject sharedInstance].hud.mode = MBProgressHUDModeDeterminate;
        //[MBProgressHUD showHUDAddedTo:showView animated:YES];
    }
    
    if ([self baseUrl] == nil) {
        if ([NSURL URLWithString:url] == nil) {
            DTLog(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
            if (showView != nil) {
                [MBProgressHUD hideAllHUDsForView:showView animated:YES];
            }
            if (fail) {
                fail(errorimage, errorresult);
            }
            //还原初始值
            [GDHNetworkingObject huanyuanchushizhi];
            return;
        }
    } else {
        if ([NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [self baseUrl], url]] == nil) {
            DTLog(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
            if (showView != nil) {
                [MBProgressHUD hideAllHUDsForView:showView animated:YES];
            }
            if (fail) {
                fail(errorimage, errorresult);
            }
            //还原初始值
            [GDHNetworkingObject huanyuanchushizhi];
            return;
        }
    }
    
    if ([self shouldEncode]) {
        url = [self encodeUrl:url];
    }
    
    NSString *absolute = [self absoluteUrlWithPath:url];
    
    AFHTTPSessionManager *manager = [GDHNetworkingObject manager];
    
    dispatch_group_t group = dispatch_group_create();
    for (NSInteger i = 0; i < images.count; i++) {
        dispatch_group_enter(group);
        UIImage * image = images[i];
        
        GDHURLSessionTask *session = [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            NSData *imageData = UIImageJPEGRepresentation(image, 1);
            NSString *imageFileName = filename;
            if (filename == nil || ![filename isKindOfClass:[NSString class]] || filename.length == 0) {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"yyyyMMddHHmmss";
                NSString *str = [formatter stringFromDate:[NSDate date]];
                imageFileName = [NSString stringWithFormat:@"%@.jpg", str];
            }
            
            // 上传图片，以文件流的格式
            [formData appendPartWithFileData:imageData name:name fileName:imageFileName mimeType:mimeType];
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            if (images.count == 1) {
                if (progress) {
                    progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
                }
                [GDHNetworkingObject sharedInstance].hud.progress = (CGFloat)(uploadProgress.completedUnitCount) / (CGFloat)uploadProgress.totalUnitCount;
            }else{
                CGFloat pro = (CGFloat)uploadProgress.completedUnitCount/uploadProgress.totalUnitCount;
                DTLog(@"%lf",pro);
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            /*
            //====== 这是准确的做法 以下==========
            NSDictionary * dict = (NSDictionary *)responseObject;
            if ([dict[@"status"] integerValue] == 200) {
                DTLog(@"第 %d 张图片上传成功: %@", (int)i + 1, responseObject);
                @synchronized (result) { // NSMutableArray 是线程不安全的，所以加个同步锁
                    result[i] = responseObject;
                }
                @synchronized (errorimage) { // NSMutableArray 是线程不安全的，所以加个同步锁
                    [errorimage removeObject:images[i]];
                }
            }
            //====== 这是准确的做法 以上==========
            */
            
            //====== 这是通用的做法 以下==== 不算太准确 ======
            
            DTLog(@"第 %d 张图片上传成功: %@", (int)i + 1, responseObject);
            @synchronized (result) { // NSMutableArray 是线程不安全的，所以加个同步锁
                result[i] = responseObject;
            }
            @synchronized (errorimage) { // NSMutableArray 是线程不安全的，所以加个同步锁
                [errorimage removeObject:images[i]];
            }
            
            //====== 这是通用的做法 以上==== 不算太准确 ======

            
            dispatch_group_leave(group);
            [[self allTasks] removeObject:task];
            if ([self isDebug]) [self logWithSuccessResponse:responseObject url:absolute params:parameters];
            if (showView != nil) [MBProgressHUD hideAllHUDsForView:showView animated:YES];
            //还原初始值
            [GDHNetworkingObject huanyuanchushizhi];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            @synchronized (errorresult) { // NSMutableArray 是线程不安全的，所以加个同步锁
                if (error) errorresult[i] = error;
            }
            DTLog(@"第 %d 张图片上传失败: %@", (int)i + 1, error);
            dispatch_group_leave(group);
            
            [[self allTasks] removeObject:task];
            if ([self isDebug]) [self logWithFailError:error url:absolute params:nil];
            if (showView != nil) [MBProgressHUD hideAllHUDsForView:showView animated:YES];
            //还原初始值
            [GDHNetworkingObject huanyuanchushizhi];
        }];
        
        [session resume];
        if (session) [[self allTasks] addObject:session];
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        DTLog(@"上传完成!");
        if (success) {
            success(result, errorimage);
        }
        if (fail) {
            fail(errorimage, errorresult);
        }
    });
}

/**
 *
 *	上传文件操作
 *
 *	@param url						上传路径
 *	@param uploadingFile	待上传文件的路径
 *  @param showView     showView为nil时 则不显示 showView不为nil时则显示加载框
 *	@param progress			上传进度
 *	@param success				上传成功回调
 *	@param fail					上传失败回调
 *
 */        
+ (GDHURLSessionTask *)uploadFileWithUrl:(NSString *)url
                           uploadingFile:(NSString *)uploadingFile
                                showView:(UIView *)showView
                                progress:(GDHUploadProgress)progress
                                 success:(GDHResponseSuccess)success
                                    fail:(GDHResponseFail)fail{
    
    if (sg_networkStatus == GDHNetworkStatusNotReachable ||  sg_networkStatus == GDHNetworkStatusUnknown ) {
        SHOW_ALERT(@"网络连接断开,请检查网络!");
        if (fail) {
            fail(nil);
        }
        //还原初始值
        [GDHNetworkingObject huanyuanchushizhi];
        return nil;
    }
    
    if (showView) {
        [GDHNetworkingObject sharedInstance].hud = [MBProgressHUD showHUDAddedTo:showView animated:YES];
        [GDHNetworkingObject sharedInstance].hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
        //[MBProgressHUD showHUDAddedTo:showView animated:YES];
    }
    
    if ([NSURL URLWithString:uploadingFile] == nil) {
        DTLog(@"uploadingFile无效，无法生成URL。请检查待上传文件是否存在");
        if (showView != nil) {
            [MBProgressHUD hideAllHUDsForView:showView animated:YES];
        }
        if (fail) {
            fail(nil);
        }
        //还原初始值
        [GDHNetworkingObject huanyuanchushizhi];
        return nil;
    }
    
    NSURL *uploadURL = nil;
    if ([self baseUrl] == nil) {
        uploadURL = [NSURL URLWithString:url];
    } else {
        uploadURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [self baseUrl], url]];
    }
    
    if (uploadURL == nil) {
        DTLog(@"URLString无效，无法生成URL。可能是URL中有中文或特殊字符，请尝试Encode URL");
        if (showView != nil) {
            [MBProgressHUD hideAllHUDsForView:showView animated:YES];
        }
        if (fail) {
            fail(nil);
        }
        //还原初始值
        [GDHNetworkingObject huanyuanchushizhi];
        return nil;
    }
    
    AFHTTPSessionManager *manager = [GDHNetworkingObject manager];
    NSURLRequest *request = [NSURLRequest requestWithURL:uploadURL];
    GDHURLSessionTask *session = nil;
    
    [manager uploadTaskWithRequest:request fromFile:[NSURL URLWithString:uploadingFile] progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
        }
        [GDHNetworkingObject sharedInstance].hud.progress = (CGFloat)(uploadProgress.completedUnitCount) / (CGFloat)uploadProgress.totalUnitCount;
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        [[self allTasks] removeObject:session];
        
        [self successResponse:responseObject callback:success];
        
        if (error) {
            [self handleCallbackWithError:error fail:fail];
            
            if ([self isDebug]) {
                [self logWithFailError:error url:response.URL.absoluteString params:nil];
            }
            
            if (showView != nil) {
                [MBProgressHUD hideAllHUDsForView:showView animated:YES];
            }
            //还原初始值
            [GDHNetworkingObject huanyuanchushizhi];
            
        } else {
            if ([self isDebug]) {
                [self logWithSuccessResponse:responseObject
                                         url:response.URL.absoluteString
                                      params:nil];
            }
            
            if (showView != nil) {
                [MBProgressHUD hideAllHUDsForView:showView animated:YES];
            }
            if (fail) {
                fail(nil);
            }
            //还原初始值
            [GDHNetworkingObject huanyuanchushizhi];
        }
    }];
    
    if (session) {
        [[self allTasks] addObject:session];
    }
    
    return session;
}

/*!
 *
 *  下载文件
 *
 *  @param url           下载URL
 *  @param saveToPath    下载到哪个路径下
 *  @param showView     showView为nil时 则不显示 showView不为nil时则显示加载框
 *  @param progressBlock 下载进度
 *  @param success       下载成功后的回调
 *  @param failure       下载失败后的回调
 */
+ (GDHURLSessionTask *)downloadWithUrl:(NSString *)url
                            saveToPath:(NSString *)saveToPath
                              showView:(UIView *)showView
                              progress:(GDHDownloadProgress)progressBlock
                               success:(GDHResponseSuccess)success
                               failure:(GDHResponseFail)failure{
    
    if (sg_networkStatus == GDHNetworkStatusNotReachable ||  sg_networkStatus == GDHNetworkStatusUnknown ) {
        SHOW_ALERT(@"网络连接断开,请检查网络!");
        failure(nil);
        [GDHNetworkingObject huanyuanchushizhi];
        return nil;
    }
    
    if (showView) {
        [GDHNetworkingObject sharedInstance].hud = [MBProgressHUD showHUDAddedTo:showView animated:YES];
        [GDHNetworkingObject sharedInstance].hud.mode = MBProgressHUDModeDeterminate;
        //[MBProgressHUD showHUDAddedTo:showView animated:YES];MBProgressHUDModeDeterminate
    }
    
    if ([self baseUrl] == nil) {
        if ([NSURL URLWithString:url] == nil) {
            DTLog(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
            if (showView != nil) {
                [MBProgressHUD hideAllHUDsForView:showView animated:YES];
            }
            failure(nil);
            [GDHNetworkingObject huanyuanchushizhi];
            return nil;
        }
    } else {
        if ([NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [self baseUrl], url]] == nil) {
            DTLog(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
            if (showView != nil) {
                [MBProgressHUD hideAllHUDsForView:showView animated:YES];
            }
            failure(nil);
            [GDHNetworkingObject huanyuanchushizhi];
            return nil;
        }
    }
    
    NSURLRequest *downloadRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFHTTPSessionManager *manager = [GDHNetworkingObject manager];
    
    GDHURLSessionTask *session = nil;
    
    session = [manager downloadTaskWithRequest:downloadRequest progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progressBlock) {
            progressBlock(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount,downloadProgress.totalUnitCount-downloadProgress.completedUnitCount);
        }
        
        [GDHNetworkingObject sharedInstance].hud.progress = (CGFloat)(downloadProgress.completedUnitCount) / (CGFloat)downloadProgress.totalUnitCount;
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:saveToPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        [[self allTasks] removeObject:session];
        
        if (error == nil) {
            
            if ([self isDebug]) {
                DTLog(@"Download success for url %@",
                      [self absoluteUrlWithPath:url]);
            }
            
            if (showView != nil) {
                [MBProgressHUD hideAllHUDsForView:showView animated:YES];
            }
            
            if (success) {
                success(filePath.absoluteString);
                [GDHNetworkingObject huanyuanchushizhi];
            }
            
        } else {
            [self handleCallbackWithError:error fail:failure];
            
            if ([self isDebug]) {
                DTLog(@"Download fail for url %@, reason : %@",
                      [self absoluteUrlWithPath:url],
                      [error description]);
            }
            
            if (showView != nil) {
                [MBProgressHUD hideAllHUDsForView:showView animated:YES];
            }
            failure(nil);
            [GDHNetworkingObject huanyuanchushizhi];
        }
    }];
    
    [session resume];
    if (session) {
        [[self allTasks] addObject:session];
    }
    
    return session;
}

- (void)finishedRequest:(id)data didFaild:(NSError*)error
{
    if ([self.tagrget respondsToSelector:self.select]) {
        [self.tagrget performSelector:@selector(finishedRequest:didFaild:) withObject:data withObject:error];
    }
}

- (MBProgressHUD *)hud {
    if (!_hud) {
        _hud = [[MBProgressHUD alloc] init];
        // 隐藏时候从父控件中移除
        _hud.removeFromSuperViewOnHide = YES;
        // YES代表需要蒙版效果
        _hud.dimBackground = YES;
    }
    return _hud;
}

+ (void)huanyuanchushizhi {
    sg_requestType_complete  = NO;
    sg_responseType_complete = NO;
}



@end
















