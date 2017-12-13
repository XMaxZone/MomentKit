//
//  MomentCell.h
//  MomentKit
//
//  Created by LEA on 2017/12/12.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentView.h"
#import "MomentView.h"
#import "Moment.h"

@protocol MomentCellDelegate;
@interface MomentCell : UITableViewCell <MomentViewDelgate>

//头像
@property (nonatomic, strong) UIImageView *headImageView;
//名称
@property (nonatomic, strong) UILabel *nameLab;
//内容
@property (nonatomic, strong) MLLinkLabel *textLab;
//时间
@property (nonatomic, strong) UILabel *timeLab;
//位置
@property (nonatomic, strong) UILabel *locationLab;
//时间
@property (nonatomic, strong) UIButton *deleteBtn;
//赞/评论
@property (nonatomic, strong) UIButton *arrowBtn;
//显示赞和评论的视图
@property (nonatomic, strong) UITableView *tableView;
//正文
@property (nonatomic, strong) MomentView *momentView;
//赞和评论
@property (nonatomic, strong) CommentView *commentView;

//动态
@property (nonatomic, strong) Moment *moment;
//代理
@property (nonatomic, assign) id<MomentCellDelegate> delegate;

//获取行高
+ (CGFloat)momentCellHeightForMoment:(Moment *)moment;

@end

@protocol MomentCellDelegate <NSObject>

@optional

//赞
- (void)didPraiseMoment:(MomentCell *)cell;
//评论
- (void)didRemarkMoment:(MomentCell *)cell;
//查看全文/收起
- (void)didSelectFullText:(MomentCell *)cell;
//删除
- (void)didDeleteMoment:(MomentCell *)cell;
//点击高亮文字
- (void)cell:(MomentCell *)cell didClickLinkText:(NSString *)linkText withType:(MLLinkType)type;

@end
