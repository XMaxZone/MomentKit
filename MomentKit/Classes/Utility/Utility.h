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

@end
