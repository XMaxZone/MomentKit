//
//  CommentView.h
//  MomentKit
//
//  Created by LEA on 2017/12/12.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentCell.h"
#import "Comment.h"
#import "Moment.h"

@interface CommentView : UIView 

@property (nonatomic,strong) Moment *moment;

//获取行高
+ (CGFloat)commentViewHeightForMoment:(Moment *)moment;

@end
