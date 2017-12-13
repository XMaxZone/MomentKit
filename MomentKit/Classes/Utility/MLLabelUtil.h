//
//  MLLabelUtil.h
//  MomentKit
//
//  Created by LEA on 2017/12/13.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MLLabel/MLLinkLabel.h>
#import "Moment.h"
#import "Comment.h"

@interface MLLabelUtil : NSObject

// 获取linkLabel
MLLinkLabel *kMLLinkLabel();
// 获取富文本
NSMutableAttributedString *kMLLinkLabelAttributedText(id object);

@end
