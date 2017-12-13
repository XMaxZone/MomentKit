//
//  CommentView.m
//  MomentKit
//
//  Created by LEA on 2017/12/12.
//  Copyright © 2017年 LEA. All rights reserved.
//

#define Arror_height 5
#import "CommentView.h"

@interface CommentView () <UITableViewDelegate,UITableViewDataSource,MLLinkLabelDelegate>

@property (nonatomic,strong) UIImageView *bgImageView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *tableHeadView;
@property (nonatomic,strong) MLLinkLabel *likeLabel;
@property (nonatomic,strong) UIView *line;

@end

@implementation CommentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.bgImageView];
        [self addSubview:self.tableView];
    }
    return self;
}

- (void)setMoment:(Moment *)moment
{
    _moment = moment;
    // 处理赞
    if (moment.praiseNameList.length) {
        self.likeLabel.attributedText = kMLLinkLabelAttributedText(moment.praiseNameList);
        CGSize attrStrSize = [self.likeLabel preferredSizeWithMaxWidth:kTextWidth];
        self.tableHeadView.frame = CGRectMake(0, 0, self.width, attrStrSize.height + 15);
        self.likeLabel.frame = CGRectMake(5, 8, attrStrSize.width, attrStrSize.height);
        self.line.top = self.likeLabel.bottom + 7;
        self.tableView.tableHeaderView = self.tableHeadView;
    }
    // 处理评论
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            // 更新Frame
            self.height = self.tableView.contentSize.height + 5;
            self.tableView.frame = CGRectMake(0, 5, self.width, self.height - 5);
            self.bgImageView.frame = self.bounds;
            self.bgImageView.image = [[UIImage imageNamed:@"comment_bg"] stretchableImageWithLeftCapWidth:40 topCapHeight:30];
        });
    });
}

#pragma mark - Getter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.scrollEnabled = NO;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (UIView *)tableHeadView
{
    if (!_tableHeadView) {
        _tableHeadView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableHeadView.backgroundColor = [UIColor clearColor];
        [_tableHeadView addSubview:self.likeLabel];
        [_tableHeadView addSubview:self.line];
    }
    return _tableHeadView;
}

- (MLLinkLabel *)likeLabel
{
    if (!_likeLabel) {
        _likeLabel = kMLLinkLabel();
        _likeLabel.delegate = self;
    }
    return _likeLabel;
}

- (UIView *)line
{
    if (!_line) {
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0.5)];
        _line.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
    }
    return _line;
}

- (UIImageView *)bgImageView
{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _bgImageView;
}

#pragma mark - 获取整体高度
+ (CGFloat)commentViewHeightForMoment:(Moment *)moment
{
    CGFloat height = 0;
    // 赞的高度
    if (moment.praiseNameList.length) {
        MLLinkLabel *linkLab = kMLLinkLabel();
        linkLab.attributedText = kMLLinkLabelAttributedText(moment.praiseNameList);;
        height = [linkLab preferredSizeWithMaxWidth:kTextWidth].height + 15;
    }
    // 评论高度
    for (Comment *com in moment.commentList) {
        height += [CommentCell commentCellHeightForMoment:com];
    }
    return height + 10;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.moment.commentList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CommentCell";
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.comment = [self.moment.commentList objectAtIndex:indexPath.row];;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Comment *comment = [self.moment.commentList objectAtIndex:indexPath.row];
    return [CommentCell commentCellHeightForMoment:comment];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 未处理
}

#pragma mark - MLLinkLabelDelegate
- (void)didClickLink:(MLLink *)link linkText:(NSString *)linkText linkLabel:(MLLinkLabel *)linkLabel
{
    NSLog(@"点击：%@",linkText);
}

@end
