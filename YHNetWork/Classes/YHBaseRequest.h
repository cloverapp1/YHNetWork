//
//  YHBaseRequest.h
//  YHNetWork_Example
//
//  Created by Yangli on 2018/4/19.
//  Copyright © 2018年 2510479687@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

typedef NS_ENUM(NSInteger,YHNetworkStatus) {
    YHNetWorkStatusUnknown          = -1,
    YHNetWorkStatusNotReachable     = 0,
    YHNetWorkStatusReachableViaWWAN = 1,
    YHNetWorkStatusReachableViaWiFi = 2
};

typedef NS_ENUM(NSInteger,YHRequestMethod) {
    YHRequestGet,
    YHRequestPost,
    YHRequestPut,
    YHRequestDelete
};

typedef void(^YHRequestBack)(BOOL requestSuccess, id _Nullable response, NSString* _Nullable responseJson, NSDictionary * _Nullable requestDic);

@interface YHBaseRequest : NSObject

+ (AFHTTPSessionManager *_Nullable)afnManager;


/**
 字典转json字符串
 
 @param data <#data description#>
 @return <#return value description#>
 */
+ (NSString *_Nullable)getJsonStringWithDic:(NSDictionary *_Nullable)data;


/**
 检查网络状态
 
 @param ret <#ret description#>
 */
+ (void)netWorkStatus:(void(^_Nullable)(YHNetworkStatus))ret;


/**
 显示加载图
 
 @param view <#view description#>
 */
+ (void)showGifImageWhenRequestInView:(UIView*_Nullable)view;


/**
 隐藏加载图
 
 @param view <#view description#>
 */
+ (void)hideGifImageWhenRequest:(UIView*_Nullable)view;


/**
 上传数据
 
 @param url <#url description#>
 @param params <#params description#>
 @param formDataRet <#formDataRet description#>
 @param progress <#progress description#>
 @param success <#success description#>
 @param failed <#failed description#>
 */
+ (void)upLoadWithUrl:(NSString*_Nonnull)url
               Params:(NSDictionary*_Nonnull)params
               inView:(UIView*_Nullable)view
             FormData:(void (^)(id<AFMultipartFormData> formData))formDataRet
             Progress:(void(^)(NSProgress* _Nullable progress))progress
              Success:(void(^)(id _Nullable response))success
               Failed:(void(^)(NSError *error))failed;


/**
 post
 
 @param url <#url description#>
 @param params <#params description#>
 @param needHandle <#needHandle description#>
 @param requestBack <#requestBack description#>
 */
+ (void)postRequestWithUrl:(NSString*_Nullable)url
                    Params:(NSDictionary*_Nullable)params
                    inView:(UIView*_Nullable)view
                needHandle:(BOOL)needHandle
               requestBack:(YHRequestBack _Nullable )requestBack;


/**
 允许自定义请求和相应的post
 
 @param url <#url description#>
 @param params <#params description#>
 @param requestSerializer <#requestSerializer description#>
 @param responseSerializer <#responseSerializer description#>
 @param requestBack <#requestBack description#>
 */
+ (void)postRequestWithUrl:(NSString*_Nonnull)url
                    Params:(NSDictionary*_Nonnull)params
                    inView:(UIView*_Nullable)view
         requestSerializer:(AFHTTPRequestSerializer *_Nullable)requestSerializer
        responseSerializer:(AFHTTPResponseSerializer *_Nullable)responseSerializer
               requestBack:(YHRequestBack _Nullable )requestBack;


/**
 get
 
 @param url <#url description#>
 @param params <#params description#>
 @param needHandle <#needHandle description#>
 @param requestBack <#requestBack description#>
 */
+ (void)getRequestWithUrl:(NSString*_Nullable)url
                   Params:(NSDictionary*_Nullable)params
                   inView:(UIView*_Nullable)view
               needHandle:(BOOL)needHandle
              requestBack:(YHRequestBack _Nullable )requestBack;


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
 @return <#return value description#>
 */
+ (void)uploadImageWithURL:(NSString *_Nonnull)url
                                    headers:(NSDictionary*_Nullable)headers
                                 postParams:(NSDictionary*_Nullable)params
                          requestSerializer:(AFHTTPRequestSerializer *_Nullable)requestSerializer
                         responseSerializer:(AFHTTPResponseSerializer *_Nullable)responseSerializer
                                      files:(NSArray *_Nonnull)files
                                 filesNames:(NSArray *_Nonnull)filesNames
                                  mimeTypes:(NSArray *_Nonnull)mimeTypes
                                   progress:(void (^_Nullable)(NSProgress * _Nonnull))uploadProgress
                                     inView:(UIView *_Nullable)view
                                requestBack:(YHRequestBack _Nullable )requestBack;

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
         requestSerializer:(AFHTTPRequestSerializer *_Nullable)requestSerializer
        responseSerializer:(AFHTTPResponseSerializer *_Nullable)responseSerializer
               requestBack:(YHRequestBack _Nullable )requestBack;



@end
