//
//  YHBaseRequest.m
//  YHNetWork_Example
//
//  Created by Yangli on 2018/4/19.
//  Copyright © 2018年 2510479687@qq.com. All rights reserved.
//

#import "YHBaseRequest.h"
#import <MJExtension/MJExtension.h>
#import <MBProgressHUD/MBProgressHUD.h>

#define CurAfnManager_YH [YHBaseRequest afnManager]
#define HudTag 123456
#define ImageTag 654321
#define SCREEN_WIDTH_YH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT_YH ([[UIScreen mainScreen] bounds].size.height)

#define IOS_9_OR_LATER (([[[UIDevice currentDevice] systemVersion] floatValue] >=9.0)? (YES):(NO))

#define YHSetEmptyIfNil(obj) (obj==nil?@"":obj)
#define YHUSER_TOKEN_KEY  @"X-AUTH-TOKEN"

#ifdef DEBUG
#define YHLog(format, ...) printf("\n[%s] %s [第%d行] %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
#else
#define YHLog(format, ...)
#endif

@interface YHBaseRequest ()<MBProgressHUDDelegate>

@property (nonatomic, strong) NSMutableArray *requestUArr;
@property (nonatomic, strong) NSMutableArray<UIImage*>* gifImageArray;
@property (nonatomic, strong) UIImageView* gifImageView;
@property (nonatomic, strong) UIView* hudView;

@end

@implementation YHBaseRequest


- (NSMutableArray *)gifImageArray{
    if (!_gifImageArray) {
        _gifImageArray = [[NSMutableArray alloc] init];
        for (int i = 0; i<51; i++) {
            UIImage *image;
            if (i<10) {
                image = [UIImage imageNamed:[NSString stringWithFormat:@"frame_0%d",i]];
            }else{
                image = [UIImage imageNamed:[NSString stringWithFormat:@"frame_%d",i]];
            }
            [_gifImageArray addObject:image];
        }
    }
    return _gifImageArray;
};

- (UIImageView *)gifImageView{
    if (!_gifImageView) {
        _gifImageView = [[UIImageView alloc] init];
    }
    _gifImageView.animationImages = [[YHBaseRequest shareInstance] gifImageArray];
    _gifImageView.animationDuration = 1.0;
    _gifImageView.animationRepeatCount = 999;
    [_gifImageView startAnimating];
    return _gifImageView;
}

- (UIView *)hudView{
    if (!_hudView) {
        _hudView = [[UIView alloc] init];
    }
    _hudView.alpha = 0.4;
    _hudView.backgroundColor = [UIColor darkGrayColor];
    return _hudView;
}

- (NSMutableArray *)requestUArr{
    if (_requestUArr == nil) {
        _requestUArr = [NSMutableArray array];
    }
    return _requestUArr;
}

+ (instancetype)shareInstance{
    static YHBaseRequest *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YHBaseRequest alloc] init];
    });
    return manager;
}

/**
 字典转json字符串
 
 @param data <#data description#>
 @return <#return value description#>
 */
+ (NSString *)getJsonStringWithDic:(NSDictionary *)data{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

+ (AFHTTPSessionManager *)afnManager{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [self setAFNManagerDefalutSetting:manager];
    return manager;
}

+ (void)showGifImageWhenRequestInView:(UIView*)view{
    if (view) {
        view.userInteractionEnabled = 0;
        CGRect rect = CGRectMake(SCREEN_WIDTH_YH/2.0-25, SCREEN_HEIGHT_YH/2.0, 50, 50);
        CGRect curRect = [[UIApplication sharedApplication].delegate.window convertRect:rect toView:view];
        
        YHBaseRequest *request = [YHBaseRequest new];
        UIView *hudView = request.hudView;
        hudView.tag = HudTag;
        UIImageView *gifImageView = request.gifImageView;
        gifImageView.tag = ImageTag;
        
        [view addSubview:hudView];
        [view addSubview:gifImageView];
        hudView.frame = curRect;
        gifImageView.frame = curRect;
    }
}

+ (void)hideGifImageWhenRequest:(UIView*)view{
    if (view) {
        view.userInteractionEnabled = 1;
        UIView *hud = [view viewWithTag:HudTag];
        UIView *imageView = [view viewWithTag:ImageTag];
        [hud removeFromSuperview];
        [imageView removeFromSuperview];
    }
}

+ (NSDictionary*)getGeneralHeaders {
    NSString *version=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    return @{@"Content-Type":@"application/json",@"X-VERSION":YHSetEmptyIfNil(version),@"X-DEVICE":@"IOS"};
}

+ (void)setHeaders:(NSDictionary*)headers toManager:(AFHTTPSessionManager*)manager {
    if (headers) {
        NSArray *keys = headers.allKeys;
        for (NSInteger i=0; i<keys.count; i++) {
            id obj = [headers objectForKey:keys[i]];
            if ([obj isKindOfClass:[NSString class]]) {
                [manager.requestSerializer setValue:obj forHTTPHeaderField:keys[i]];
            }
        }
    }
}

+ (void)setAFNManagerDefalutSetting:(AFHTTPSessionManager *)manager{
    manager.responseSerializer.acceptableContentTypes
    = [NSSet setWithObjects:@"text/javascript",@"application/json",@"text/json",@"text/plain",@"multipart/form-data",@"text/html",nil];
    
    //    {
    //        NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"wuyouwei" ofType:@"cer"];
    //        NSData * certData =[NSData dataWithContentsOfFile:cerPath];
    //        NSSet * certSet = [[NSSet alloc] initWithObjects:certData, nil];
    //        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    //        // 是否允许,NO-- 不允许无效的证书
    //        [securityPolicy setAllowInvalidCertificates:YES];
    //        // 设置证书
    //        [securityPolicy setPinnedCertificates:certSet];
    //        manager.securityPolicy = securityPolicy;
    //
    //    }
    
}

+ (void)netWorkStatus:(void (^)(YHNetworkStatus))ret{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                ret(YHNetWorkStatusUnknown);
                break;
            case AFNetworkReachabilityStatusNotReachable:
                ret(YHNetWorkStatusNotReachable);
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                ret(YHNetWorkStatusReachableViaWWAN);
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                ret(YHNetWorkStatusReachableViaWiFi);
                break;
            default:
                break;
        }
    }];
    
}

+ (void)postRequestWithUrl:(NSString *)url
                    Params:(NSDictionary *)params
                    inView:(UIView*)view
                needHandle:(BOOL)needHandle
               requestBack:(YHRequestBack)requestBack{
    [self postRequestWithUrl:url
                      Params:params
                      inView:(UIView*)view
           requestSerializer:[AFJSONRequestSerializer serializer]
          responseSerializer:[AFJSONResponseSerializer serializer]
                 requestBack:requestBack];
}

+ (void)postRequestWithUrl:(NSString *)url
                    Params:(NSDictionary *)params
                    inView:(UIView*)view
         requestSerializer:(AFHTTPRequestSerializer *)requestSerializer
        responseSerializer:(AFHTTPResponseSerializer *)responseSerializer
               requestBack:(YHRequestBack)requestBack{
    YHLog(@"\nPOST请求url*****************************************\n%@\n请求参数*************************************\n%@",url,params);
    [YHBaseRequest showGifImageWhenRequestInView:view];
    AFHTTPSessionManager *httpManager = CurAfnManager_YH;
    httpManager.requestSerializer = requestSerializer;
    httpManager.responseSerializer = responseSerializer;
    [self setAFNManagerDefalutSetting:httpManager];
    [self setHeaders:[self getGeneralHeaders] toManager:httpManager];
    [httpManager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonStr = nil;
        if (responseObject) {
            jsonStr = ((NSDictionary*)responseObject).mj_JSONString;
        }
        YHLog(@"\n url = %@ \n请求结果******************************************\n%@",url,jsonStr);
        [YHBaseRequest hideGifImageWhenRequest:view];
        requestBack(YES, responseObject, jsonStr, params);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        YHLog(@"\n请求失败************************************************\n%@",error);
        [YHBaseRequest hideGifImageWhenRequest:view];
        requestBack(NO, nil, nil, params);
    }];
}

/**
 <#Description#>

 @param url <#url description#>
 @param params <#params description#>
 @param view <#view description#>
 @param needHandle <#needHandle description#>
 @param requestBack <#requestBack description#>
 */
+ (void)getRequestWithUrl:(NSString *)url Params:(NSDictionary *)params inView:(UIView*)view needHandle:(BOOL)needHandle requestBack:(YHRequestBack)requestBack{
    YHLog(@"\nGET请求url*****************************************\n%@\n请求参数*************************************\n%@",url,params);
    
    [YHBaseRequest showGifImageWhenRequestInView:view];
    AFHTTPSessionManager *httpManager = CurAfnManager_YH;
    [self setHeaders:[self getGeneralHeaders] toManager:httpManager];
    [httpManager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        YHLog(@"\n请求url\n%@#######################################",url);
        YHLog(@"\n请求结果******************************************\n%@",responseObject);
        NSString *jsonStr = nil;
        if (responseObject) {
            jsonStr = ((NSDictionary*)responseObject).mj_JSONString;
        }
        [YHBaseRequest hideGifImageWhenRequest:view];
        requestBack(YES, responseObject, jsonStr, params);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        YHLog(@"\n请求失败************************************************\n%@",error);
        [YHBaseRequest hideGifImageWhenRequest:view];
        requestBack(NO, nil, nil, params);
    }];
}

/**
 上传图片

 @param url <#url description#>
 @param params <#params description#>
 @param view <#view description#>
 @param formDataRet <#formDataRet description#>
 @param progress <#progress description#>
 @param success <#success description#>
 @param failed <#failed description#>
 */
+ (void)upLoadWithUrl:(NSString *)url Params:(NSDictionary *)params inView:(UIView*)view FormData:(void (^)(id<AFMultipartFormData>))formDataRet Progress:(void (^)(NSProgress *))progress Success:(void (^)(id))success Failed:(void (^)(NSError *))failed{
    [YHBaseRequest showGifImageWhenRequestInView:view];
    YHLog(@"\nPOST请求url*****************************************\n%@\n请求参数*************************************\n%@",url,params);
    AFHTTPSessionManager *httpManager = CurAfnManager_YH;
    [self setHeaders:[self getGeneralHeaders] toManager:httpManager];
    [httpManager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (formDataRet) {
            formDataRet(formData);
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        YHLog(@"\n请求进度%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        YHLog(@"\n请求结果******************************************\n%@",responseObject);
        [YHBaseRequest hideGifImageWhenRequest:view];
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        YHLog(@"\n请求失败******************************************%@",error);
        [YHBaseRequest hideGifImageWhenRequest:view];
        if (failed) {
            failed(error);
        }
    }];
}

/**
 <#Description#>

 @param url <#url description#>
 @param method <#method description#>
 @param headers <#headers description#>
 @param params <#params description#>
 @param requestSerializer <#requestSerializer description#>
 @param responseSerializer <#responseSerializer description#>
 @param files <#files description#>
 @param filesNames <#filesNames description#>
 @param mimeTypes <#mimeTypes description#>
 @param progress <#progress description#>
 @param view <#view description#>
 @param requestBack <#requestBack description#>
 @return <#return value description#>
 */
+ (NSURLSessionDataTask*)requestWithUrl:(NSString*_Nonnull)url
                                method:(YHRequestMethod)method
                               headers:(NSDictionary*_Nullable) headers
                                params:(NSDictionary*_Nullable)params
                     requestSerializer:(AFHTTPRequestSerializer *)requestSerializer
                    responseSerializer:(AFHTTPResponseSerializer *)responseSerializer
                                 files:(NSArray *_Nullable)files
                            filesNames:(NSArray *_Nullable)filesNames
                             mimeTypes:(NSArray *_Nullable)mimeTypes
                              progress:(void (^_Nullable)(NSProgress * _Nonnull))progress
                                inView:(UIView *_Nullable)view
                           requestBack:(YHRequestBack)requestBack{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    MBProgressHUD *hud=nil;;
    if (view) {
        hud=[MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    AFHTTPSessionManager * manager = CurAfnManager_YH;
    manager.requestSerializer = requestSerializer ? requestSerializer : [AFJSONRequestSerializer serializer];
    manager.responseSerializer = responseSerializer ? responseSerializer : [AFJSONResponseSerializer serializer];
    [self setHeaders:headers ? headers : [self getGeneralHeaders] toManager:manager];
    
    YHLog(@"\n请求类型👉👉%@\t%@\n%@",@[@"get",@"post",@"put",@"delete",@"",@""][method],url,params);
    
    __block id success =^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hud hideAnimated:YES];
        // 隐藏系统风火轮
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSString *jsonStr = nil;
        if (responseObject) {
            jsonStr = ((NSDictionary*)responseObject).mj_JSONString;
        }
        YHLog(@"\n************************************\n请求url==>%@\n参数==>\n%@\n请求结果\n%@\n************************************",url,params,jsonStr);
        requestBack(YES, responseObject, jsonStr, params);

    };
    
    __block id failure =^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 隐藏系统风火轮
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [hud hideAnimated:YES];
        YHLog(@"\n------------------------------------\n请求失败==>\n请求url ==> %@\ncode = %ld\n详情 = %@\n------------------------------------",url,[error code],[error localizedDescription]);
        requestBack(NO, nil, nil, params);
    };
    
    url = IOS_9_OR_LATER ? [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]] : [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    switch (method) {
        case YHRequestGet:
            return [manager GET:url parameters:params progress:progress success:success failure:failure];
            
        case YHRequestPost:
            if (files == nil || files.count ==0) {
                return [manager POST:url parameters:params progress:progress success:success failure:failure];
            }
            else {
                return [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                    for (id file in files) {
                        if ([file isKindOfClass:[UIImage class]]) {
                            NSData *imageData = UIImageJPEGRepresentation(file, 0.8);
                            //上传的参数(上传图片，以文件流的格式)
                            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                            formatter.dateFormat =@"yyyyMMddHHmmss";
                            NSString *str = [formatter stringFromDate:[NSDate date]];
                            NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
                            [formData appendPartWithFileData:imageData
                                                        name:@"file"
                                                    fileName:fileName
                                                    mimeType:@"image/jpeg"];
                            
                        }
                    }
                } progress:^(NSProgress * _Nonnull uploadProgress) {
                    if (files.count) {
                        CGFloat pres=   0.99*uploadProgress.completedUnitCount/uploadProgress.totalUnitCount;
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            hud.label.text = [NSString stringWithFormat:@"上传中（%.2f%%）",pres*100];
                            YHLog(@"2press=%.2f",pres);
                            
                        });
                        
                    }
                    
                } success:success failure:failure];
            }
            
        case YHRequestPut:
            return [manager PUT:url parameters:params success:success failure:failure];
            
        case YHRequestDelete:
            return [manager DELETE:url parameters:params success:success failure:failure];
            
        default:
            break;
    }
    return NULL;
}


/**
 上传图片，支持多图上传

 @param url <#url description#>
 @param headers <#headers description#>
 @param params <#params description#>
 @param requestSerializer <#requestSerializer description#>
 @param responseSerializer <#responseSerializer description#>
 @param files <#files description#>
 @param filesNames <#filesNames description#>
 @param mimeTypes <#mimeTypes description#>
 @param uploadProgress <#uploadProgress description#>
 @param view <#view description#>
 @param requestBack <#requestBack description#>
 */
+ (void)uploadImageWithURL:(NSString *_Nonnull)url
                            headers:(NSDictionary*_Nullable)headers
                         postParams:(NSDictionary*_Nullable)params
                   requestSerializer:(AFHTTPRequestSerializer *)requestSerializer
                  responseSerializer:(AFHTTPResponseSerializer *)responseSerializer
                              files:(NSArray *_Nonnull)files
                         filesNames:(NSArray *_Nonnull)filesNames
                          mimeTypes:(NSArray *_Nonnull)mimeTypes
                           progress:(void (^_Nullable)(NSProgress * _Nonnull))uploadProgress
                             inView:(UIView *_Nullable)view
                             requestBack:(YHRequestBack)requestBack{
    [self requestWithUrl:url
                         method:YHRequestPost
                        headers:headers
                         params:params
              requestSerializer:requestSerializer
             responseSerializer:responseSerializer
                          files:files
                     filesNames:filesNames
                      mimeTypes:mimeTypes
                       progress:uploadProgress
                         inView:view
                    requestBack:requestBack];
}

/**
 允许自定义请求
 
 @param url <#url description#>
 @param params <#params description#>
 @param requestSerializer <#requestSerializer description#>
 @param responseSerializer <#responseSerializer description#>
 @param requestBack <#requestBack description#>
 */
+ (NSURLSessionDataTask*_Nullable)requestWithUrl:(NSString*_Nonnull)url
                                             method:(YHRequestMethod)method
                                            headers:(NSDictionary*_Nullable)headers
                                             Params:(NSDictionary*_Nonnull)params
                                             inView:(UIView*_Nullable)view
                                  requestSerializer:(AFHTTPRequestSerializer *)requestSerializer
                                 responseSerializer:(AFHTTPResponseSerializer *)responseSerializer
                                        requestBack:(YHRequestBack _Nullable )requestBack{
    return [self requestWithUrl:url
                         method:method
                        headers:headers
                         params:params
              requestSerializer:requestSerializer
             responseSerializer:responseSerializer
                          files:nil
                     filesNames:nil
                      mimeTypes:nil
                       progress:nil
                         inView:view
                    requestBack:requestBack];
}


@end
