//
//  YLJastor.m
//  Pods
//
//  Created by Yangli on 2018/3/29.
//

#import "YLJastor.h"

@interface YLJastor()

@end

@implementation YLJastor

/**
 使用json初始化实例对象
 
 @param json json对象
 @return 实例对象
 */
+ (instancetype)modelWithJSON:(id)json{
    return [super yy_modelWithJSON:json];
}

/**
 使用dic初始化实例对象
 
 @param dictionary 字典对象
 @return 实例对象
 */
+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary{
    return [super yy_modelWithDictionary:dictionary];
}

/**
 将实例对象转化成json字符串
 
 @return json字符串
 */
- (NSString *)toJsonString{
    return [self yy_modelToJSONString];
}

/**
 description
 
 @return description字符串
 */
- (NSString *)toDescription{
    return [self yy_modelDescription];
}


@end
