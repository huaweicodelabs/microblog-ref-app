/**
 * Copyright (c) Huawei Technologies Co., Ltd. 2019-2020. All rights reserved.
 * Generated by the CloudDB ObjectType compiler.  DO NOT EDIT!
 */

#import "Post.h"

@implementation Post

+ (NSArray<NSString *> *)primaryKeyProperties {
    return @[@"id"];
}

+ (NSDictionary<NSString *, NSArray *> *)indexProperties { 
    return @{@"timeStamp" : @[@"timeStamp"],
              @"userUid" : @[@"userUid"]};
}

+ (NSArray<NSString *> *)notNullProperties {
    return @[@"id"];
}

@end
