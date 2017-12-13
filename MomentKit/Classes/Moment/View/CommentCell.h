//
//  CommentCell.h
//  MomentKit
//
//  Created by LEA on 2017/12/12.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"

@interface CommentCell : UITableViewCell <MLLinkLabelDelegate>

// 内容Label
@property (nonatomic,strong) MLLinkLabel *linkLabel;
// 评论
@property (nonatomic,strong) Comment *comment;

// 获取行高
+ (CGFloat)commentCellHeightForMoment:(Comment *)comment;

@end
