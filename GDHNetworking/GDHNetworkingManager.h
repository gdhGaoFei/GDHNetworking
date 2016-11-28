//
//  GDHNetworkingManager.h
//  GDHNetworkingDemo
//
//  Created by 高得华 on 16/11/28.
//  Copyright © 2016年 GaoFei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import <CommonCrypto/CommonDigest.h>
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"

@class GDHNetworkingObject;//网络请求的基类
@protocol GDHNetworkingObject
@end


#pragma mark ========== Block / Delegate / 枚举 ============
#pragma mark ==== 宏定义 =======
// 项目打包上线都不会打印日志，因此可放心。
#ifdef DEBUG
#define DTLog(s, ... ) NSLog( @"[%@ in line %d] ===============>%@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define DTLog(s, ... )
#endif

#define SHOW_ALERT(_msg_)  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:_msg_ delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];\
[alert show];


#pragma mark ========= // 枚举 及block \\ ===========
//============== 枚举 ===============
/**
 *  请求类型
 */
typedef NS_ENUM(NSUInteger, GDHNetWorkType) {
    GDHNetWorkTypeGET = 1,   /**< GET请求 */
    GDHNetWorkTypePOST       /**< POST请求 */
};

typedef NS_ENUM(NSUInteger, GDHResponseType) {//响应数据的枚举
    GDHResponseTypeJSON = 1, // 默认
    GDHResponseTypeXML  = 2, // XML
    // 特殊情况下，一转换服务器就无法识别的，默认会尝试转换成JSON，若失败则需要自己去转换
    GDHResponseTypeData = 3,
};

typedef NS_ENUM(NSUInteger, GDHRequestType) {//请求数据的枚举
    GDHRequestTypeJSON = 1, // 默认
    GDHRequestTypePlainText  = 2 // 普通text/html
};

typedef NS_ENUM(NSInteger, GDHNetworkStatus) {//获取网络的枚举
    GDHNetworkStatusUnknown          = -1,//未知网络
    GDHNetworkStatusNotReachable     = 0,//网络无连接
    GDHNetworkStatusReachableViaWWAN = 1,//2，3，4G网络
    GDHNetworkStatusReachableViaWiFi = 2,//WIFI网络
};

//============ blcok ================

/**!
 网络监测的block
 */
/**!
 网络监测的block
 */
typedef void (^GDHNetworkStatusBlock) (GDHNetworkStatus status);

/*!
 *
 *  下载进度 get or post
 *
 *  @param bytesRead                 已下载的大小
 *  @param totalBytesRead            文件总大小
 *  @param totalBytesExpectedToRead 还有多少需要下载
 */
typedef void (^GDHDownloadProgress)(int64_t bytesRead,
int64_t totalBytesRead,
int64_t totalBytesExpectedToRead);

typedef GDHDownloadProgress GDHGetProgress;
typedef GDHDownloadProgress GDHPostProgress;

/*!
 *
 *  上传进度
 *
 *  @param bytesWritten              已上传的大小
 *  @param totalBytesWritten         总上传大小
 */
typedef void (^GDHUploadProgress)(int64_t bytesWritten,
int64_t totalBytesWritten);


@class NSURLSessionTask;

// 请勿直接使用NSURLSessionDataTask,以减少对第三方的依赖
// 所有接口返回的类型都是基类NSURLSessionTask，若要接收返回值
// 且处理，请转换成对应的子类类型
typedef NSURLSessionTask GDHURLSessionTask;
typedef void(^GDHResponseSuccess)(id returnData);
typedef void(^GDHResponseFail)(NSError * error);



#pragma mark ========  代理  ================
@protocol GDHNetworkDelegate <NSObject>//请求封装的代理协议

@optional
/**
 *   请求结束
 *
 *   @param returnData 返回的数据
 */
- (void)requestDidFinishLoading:(id)returnData;
/**
 *   请求失败
 *
 *   @param error 失败的 error
 */
- (void)requestdidFailWithError:(NSError*)error;

/**
 *   网络请求项即将被移除掉
 *
 *   @param itme 网络请求项
 */
- (void)netWorkWillDealloc:(GDHURLSessionTask *) itme;

@end


#pragma marlk  ============  网络请求请求管理着 =============

//网络请求请求管理着
@interface GDHNetworkingManager : NSObject

/**
 *   GET请求通过Block 回调结果
 *
 *   @param url          url
 *   @param paramsDict   paramsDict
 *   @param successBlock  成功的回调
 *   @param failureBlock  失败的回调
 *   @param progress      进度回调
 *  @param refreshCache 是否刷新缓存。由于请求成功也可能没有数据，对于业务失败，只能通过人为手动判断
 *   @param showHUD      是否加载进度指示器
 */
+ (void)getRequstWithURL:(NSString *)url
                  params:(NSDictionary *)paramsDict
            successBlock:(GDHResponseSuccess)successBlock
            failureBlock:(GDHResponseFail)failureBlock
                progress:(GDHGetProgress)progress
            refreshCache:(BOOL)refreshCache
                 showHUD:(BOOL)showHUD;

/**
 *   GET请求通过代理回调
 *
 *   @param url         url
 *   @param paramsDict  请求的参数
 *   @param delegate    delegate
 *   @param progress      进度回调
 *   @param refreshCache 是否刷新缓存。由于请求成功也可能没有数据，对于业务失败，只能通过人为手动判断
 *   @param showHUD    是否转圈圈
 */
+ (void)getRequstWithURL:(NSString*)url
                  params:(NSDictionary*)paramsDict
                delegate:(id<GDHNetworkDelegate>)delegate
                progress:(GDHGetProgress)progress
            refreshCache:(BOOL)refreshCache
                 showHUD:(BOOL)showHUD;
/**
 *   get 请求通过 taget 回调方法
 *
 *   @param url         url
 *   @param paramsDict  请求参数的字典
 *   @param target      target
 *   @param action      action
 *   @param progress      进度回调
 *   @param refreshCache 是否刷新缓存。由于请求成功也可能没有数据，对于业务失败，只能通过人为手动判断
 *   @param showHUD     是否加载进度指示器
 */
+ (void)getRequstWithURL:(NSString*)url
                  params:(NSDictionary*)paramsDict
                  target:(id)target
                  action:(SEL)action
                progress:(GDHGetProgress)progress
            refreshCache:(BOOL)refreshCache
                 showHUD:(BOOL)showHUD;

#pragma mark - 发送 POST 请求的方法
/**
 *   通过 Block回调结果
 *
 *   @param url           url
 *   @param paramsDict    请求的参数字典
 *   @param successBlock  成功的回调
 *   @param failureBlock  失败的回调
 *   @param progress      进度回调
 *   @param refreshCache 是否刷新缓存。由于请求成功也可能没有数据，对于业务失败，只能通过人为手动判断
 *   @param showHUD       是否加载进度指示器
 */
+ (void)postReqeustWithURL:(NSString*)url
                    params:(NSDictionary*)paramsDict
              successBlock:(GDHResponseSuccess)successBlock
              failureBlock:(GDHResponseFail)failureBlock
                  progress:(GDHGetProgress)progress
              refreshCache:(BOOL)refreshCache
                   showHUD:(BOOL)showHUD;
/**
 *   post请求通过代理回调
 *
 *   @param url         url
 *   @param paramsDict  请求的参数
 *   @param delegate    delegate
 *   @param progress      进度回调
 *   @param refreshCache 是否刷新缓存。由于请求成功也可能没有数据，对于业务失败，只能通过人为手动判断
 *   @param showHUD    是否转圈圈
 */
+ (void)postReqeustWithURL:(NSString*)url
                    params:(NSDictionary*)paramsDict
                  delegate:(id<GDHNetworkDelegate>)delegate
                  progress:(GDHGetProgress)progress
              refreshCache:(BOOL)refreshCache
                   showHUD:(BOOL)showHUD;
/**
 *   post 请求通过 target 回调结果
 *
 *   @param url         url
 *   @param paramsDict  请求参数的字典
 *   @param target      target
 *   @param progress      进度回调
 *   @param refreshCache 是否刷新缓存。由于请求成功也可能没有数据，对于业务失败，只能通过人为手动判断
 *   @param showHUD     是否显示圈圈
 */
+ (void)postReqeustWithURL:(NSString*)url
                    params:(NSDictionary*)paramsDict
                    target:(id)target
                    action:(SEL)action
                  progress:(GDHGetProgress)progress
              refreshCache:(BOOL)refreshCache
                   showHUD:(BOOL)showHUD;

@end




#pragma mark ============ 网络请求的基类 =================

//网络请求的基类
@interface GDHNetworkingObject : NSObject

/**
 *  单例
 *
 *  @return GDHNetworkObject的单例对象
 */
+ (GDHNetworkingObject *)sharedInstance;

/**
 *  网络请求的委托
 */
@property (nonatomic, assign) id <GDHNetworkDelegate> delegate;

/**
 *   target
 */
@property (nonatomic, assign) id tagrget;

/**
 *   action
 */
@property (nonatomic, assign) SEL select;


#pragma mark - 创建一个网络请求项
/**
 *  创建一个网络请求项，开始请求网络
 *
 *  @param networkType  网络请求方式
 *  @param url          网络请求URL
 *  @param params       网络请求参数
 *  @param refreshCache 是否获取缓存。无网络或者获取数据失败则获取本地缓存数据
 *  @param delegate     网络请求的委托，如果没有取消网络请求的需求，可传nil
 *  @param hashValue    网络请求的委托delegate的唯一标示
 *  @param showHUD      是否显示HUD
 *  @param progress     请求成功后的progress进度
 *  @param successBlock 请求成功后的block
 *  @param failureBlock 请求失败后的block
 *
 *  @return MHAsiNetworkItem对象
 */
+ (GDHURLSessionTask *)initWithtype:(GDHNetWorkType)networkType
                                url:(NSString *)url
                             params:(NSDictionary *)params
                       refreshCache:(BOOL)refreshCache
                           delegate:(id)delegate
                             target:(id)target
                             action:(SEL)action
                          hashValue:(NSUInteger)hashValue
                            showHUD:(BOOL)showHUD
                           progress:(GDHDownloadProgress)progress
                       successBlock:(GDHResponseSuccess)successBlock
                       failureBlock:(GDHResponseFail)failureBlock;

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
 *	@param showHUD		菊花旋转
 *	@param success		上传成功回调
 *	@param fail		    上传失败回调
 *
 */
+ (GDHURLSessionTask *)uploadWithImage:(UIImage *)image
                                   url:(NSString *)url
                              filename:(NSString *)filename
                                  name:(NSString *)name
                              mimeType:(NSString *)mimeType
                            parameters:(NSDictionary *)parameters
                               showHUD:(BOOL)showHUD
                              progress:(GDHUploadProgress)progress
                               success:(GDHResponseSuccess)success
                                  fail:(GDHResponseFail)fail;

/**
 *
 *	上传文件操作
 *
 *	@param url						上传路径
 *	@param uploadingFile	待上传文件的路径
 *	@param showHUD		    菊花旋转
 *	@param progress			上传进度
 *	@param success				上传成功回调
 *	@param fail					上传失败回调
 *
 */
+ (GDHURLSessionTask *)uploadFileWithUrl:(NSString *)url
                           uploadingFile:(NSString *)uploadingFile
                                 showHUD:(BOOL)showHUD
                                progress:(GDHUploadProgress)progress
                                 success:(GDHResponseSuccess)success
                                    fail:(GDHResponseFail)fail;

/*!
 *  @author 黄仪标, 16-01-08 15:01:11
 *
 *  下载文件
 *
 *  @param url           下载URL
 *  @param saveToPath    下载到哪个路径下
 *	@param showHUD		 菊花旋转
 *  @param progressBlock 下载进度
 *  @param success       下载成功后的回调
 *  @param failure       下载失败后的回调
 */
+ (GDHURLSessionTask *)downloadWithUrl:(NSString *)url
                            saveToPath:(NSString *)saveToPath
                               showHUD:(BOOL)showHUD
                              progress:(GDHDownloadProgress)progressBlock
                               success:(GDHResponseSuccess)success
                               failure:(GDHResponseFail)failure;

/**
 监听网络状态的变化
 
 @param statusBlock 返回网络枚举类型:GDHNetworkStatus
 */
+ (void)StartMonitoringNetworkStatus:(GDHNetworkStatusBlock)statusBlock;


/*!
 *
 *  用于指定网络请求接口的基础url，如：
 *  http://henishuo.com或者http://101.200.209.244
 *  通常在AppDelegate中启动时就设置一次就可以了。如果接口有来源
 *  于多个服务器，可以调用更新
 *
 *  @param baseUrl 网络接口的基础url
 */
+ (void)updateBaseUrl:(NSString *)baseUrl;
+ (NSString *)baseUrl;

/**!
 项目中默认的网络缓存路径,也可以当做项目中的缓存路线,根据需求自行设置
 默认路径是(GDHNetworkCaches)
 格式是:@"Documents/GDHNetworkCaches",只需要字符串即可。
 
 @param baseCache 默认路径是(GDHNetworkCaches)
 */
+ (void)updateBaseCacheDocuments:(NSString *)baseCache;

/**!
 项目中默认的网络缓存路径,也可以当做项目中的缓存路线,根据需求自行设置
 
 @return 格式是:@"Documents/GDHNetworkCaches"
 */
+ (NSString *)baseCache;

/**
 *	设置请求超时时间，默认为60秒
 *
 *	@param timeout 超时时间
 */
+ (void)setTimeout:(NSTimeInterval)timeout;

/**
 *	当检查到网络异常时，是否从从本地提取数据。默认为NO。一旦设置为YES,当设置刷新缓存时，
 *  若网络异常也会从缓存中读取数据。同样，如果设置超时不回调，同样也会在网络异常时回调，除非
 *  本地没有数据！
 *
 *	@param shouldObtain	YES/NO
 */
+ (void)obtainDataFromLocalWhenNetworkUnconnected:(BOOL)shouldObtain;

/**
 *
 *	默认只缓存GET请求的数据，对于POST请求是不缓存的。如果要缓存POST获取的数据，需要手动调用设置
 *  对JSON类型数据有效，对于PLIST、XML不确定！
 *
 *	@param isCacheGet		默认为YES
 *	@param shouldCachePost	默认为NO
 */
+ (void)cacheGetRequest:(BOOL)isCacheGet shoulCachePost:(BOOL)shouldCachePost;

/**
 *
 *	获取缓存总大小/bytes
 *
 *	@return 缓存大小
 */
+ (unsigned long long)totalCacheSize;

/**
 *	默认不会自动清除缓存，如果需要，可以设置自动清除缓存，并且需要指定上限。当指定上限>0M时，
 *  若缓存达到了上限值，则每次启动应用则尝试自动去清理缓存。
 *
 *	@param mSize				缓存上限大小，单位为M（兆），默认为0，表示不清理
 */
+ (void)autoToClearCacheWithLimitedToSize:(NSUInteger)mSize;

/**
 *
 *	清除缓存
 */
- (BOOL)clearCaches;

/*!
 *
 *  开启或关闭接口打印信息
 *
 *  @param isDebug 开发期，最好打开，默认是NO
 */
+ (void)enableInterfaceDebug:(BOOL)isDebug;

/*!
 *
 *  配置请求格式，默认为JSON。如果要求传XML或者PLIST，请在全局配置一下
 *
 *  @param requestType 请求格式，默认为JSON
 *  @param responseType 响应格式，默认为JSO，
 *  @param shouldAutoEncode YES or NO,默认为NO，是否自动encode url
 *  @param shouldCallbackOnCancelRequest 当取消请求时，是否要回调，默认为YES
 */
+ (void)configRequestType:(GDHRequestType)requestType
             responseType:(GDHResponseType)responseType
      shouldAutoEncodeUrl:(BOOL)shouldAutoEncode
  callbackOnCancelRequest:(BOOL)shouldCallbackOnCancelRequest;

/*!
 *
 *  配置公共的请求头，只调用一次即可，通常放在应用启动的时候配置就可以了
 *
 *  @param httpHeaders 只需要将与服务器商定的固定参数设置即可
 */
+ (void)configCommonHttpHeaders:(NSDictionary *)httpHeaders;

/**
 *
 *	取消所有请求
 */
+ (void)cancelAllRequest;
/**
 *
 *	取消某个请求。如果是要取消某个请求，最好是引用接口所返回来的HYBURLSessionTask对象，
 *  然后调用对象的cancel方法。如果不想引用对象，这里额外提供了一种方法来实现取消某个请求
 *
 *	@param url				URL，可以是绝对URL，也可以是path（也就是不包括baseurl）
 */
+ (void)cancelRequestWithURL:(NSString *)url;


@end
