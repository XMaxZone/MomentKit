//
//  MomentView.h
//  MomentKit
//
//  Created by LEA on 2017/12/12.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMPreviewView.h"
#import "MMScrollView.h"
#import "MMImageView.h"
#import "Moment.h"

@protocol MomentViewDelgate;
@interface MomentView : UIView <UIScrollViewDelegate,MLLinkLabelDelegate,MMScrollViewDelegate,MMImageViewDelegate,MMPreviewViewDelegate>

//动态
@property (nonatomic,strong) Moment *moment;
//代理
@property (nonatomic,assign) id<MomentViewDelgate> delegate;

//获取行高
+ (CGFloat)momentViewHeightForMoment:(Moment *)moment;

@end

@protocol MomentViewDelgate <NSObject>

@optional
//点击高亮文字
- (void)didClickLinkText:(NSString *)linkText withType:(MLLinkType)type;
//查看全文/收起
- (void)didSelectFullText:(MomentView *)momentView;

@end
