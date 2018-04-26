//
//  YLJastor.h
//  Pods
//
//  Created by Yangli on 2018/3/29.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"

@interface YLJastor : NSObject<YYModel>


/**
 使用json初始化实例对象

 @param json json对象
 @return 实例对象
 */
+ (nullable instancetype)modelWithJSON:(id _Nullable)json;


/**
 使用dic初始化实例对象

 @param dictionary 字典对象
 @return 实例对象
 */
+ (nullable instancetype)modelWithDictionary:(NSDictionary *_Nullable)dictionary;


/**
 将实例对象转化成json字符串

 @return json字符串
 */
- (NSString *_Nullable)toJsonString;


/**
 description

 @return description字符串
 */
- (NSString *_Nullable)toDescription;


@end
