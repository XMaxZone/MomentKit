//
//  MMRefreshHeadView.h
//  MomentKit
//
//  Created by LEA on 2017/12/12.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMRefreshBaseView.h"

@interface MMRefreshHeadView : MMRefreshBaseView

@property (nonatomic, copy) void(^refreshingBlock)();

@end
