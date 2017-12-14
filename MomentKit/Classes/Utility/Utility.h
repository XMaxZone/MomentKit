//
//  Utility.h
//  MomentKit
//
//  Created by LEA on 2017/12/12.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject

/**
 时间戳转日期

 @param timestamp 时间戳
 @return 日期
 */
+ (NSString *)getDateFormatByTimestamp:(long long)timestamp;

/**
 获取单张图片的实际size

 @param singleSize 原始
 @return 结果
 */
+ (CGSize)getSingleSize:(CGSize)singleSize;

@end
