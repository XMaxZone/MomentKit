//
//  MomentCell.m
//  MomentKit
//
//  Created by LEA on 2017/12/14.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import "MomentCell.h"

#pragma mark - ------------------ 动态 ------------------

// 最大高度限制
CGFloat maxLimitHeight = 0;

@implementation MomentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
    // 头像视图
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, kBlank, kFaceWidth, kFaceWidth)];
    _headImageView.contentMode = UIViewContentModeScaleAspectFill;
    _headImageView.userInteractionEnabled = YES;
    _headImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:_headImageView];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHead:)];
    [_headImageView addGestureRecognizer:tapGesture];
    // 名字视图
    _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(_headImageView.right+10, _headImageView.top, kTextWidth, 20)];
    _nameLab.font = [UIFont boldSystemFontOfSize:17.0];
    _nameLab.textColor = kHLTextColor;
    _nameLab.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_nameLab];
    // 正文视图
    _linkLabel = kMLLinkLabel();
    _linkLabel.font = kTextFont;
    _linkLabel.delegate = self;
    _linkLabel.linkTextAttributes = @{NSForegroundColorAttributeName:kLinkTextColor};
    _linkLabel.activeLinkTextAttributes = @{NSForegroundColorAttributeName:kLinkTextColor,NSBackgroundColorAttributeName:kHLBgColor};
    [self.contentView addSubview:_linkLabel];
    // 查看'全文'按钮
    _showAllBtn = [[UIButton alloc]init];
    _showAllBtn.titleLabel.font = kTextFont;
    _showAllBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _showAllBtn.backgroundColor = [UIColor clearColor];
    [_showAllBtn setTitle:@"全文" forState:UIControlStateNormal];
    [_showAllBtn setTitleColor:kHLTextColor forState:UIControlStateNormal];
    [_showAllBtn addTarget:self action:@selector(fullTextClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_showAllBtn];
    // 图片区
    _imageListView = [[MMImageListView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_imageListView];
    // 位置视图
    _locationLab = [[UILabel alloc] init];
    _locationLab.textColor = [UIColor colorWithRed:0.43 green:0.43 blue:0.43 alpha:1.0];
    _locationLab.font = [UIFont systemFontOfSize:13.0f];
    [self.contentView addSubview:_locationLab];
    // 时间视图
    _timeLab = [[UILabel alloc] init];
    _timeLab.textColor = [UIColor colorWithRed:0.43 green:0.43 blue:0.43 alpha:1.0];
    _timeLab.font = [UIFont systemFontOfSize:13.0f];
    [self.contentView addSubview:_timeLab];
    // 删除视图
    _deleteBtn = [[UIButton alloc] init];
    _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    _deleteBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _deleteBtn.backgroundColor = [UIColor clearColor];
    [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [_deleteBtn setTitleColor:kHLTextColor forState:UIControlStateNormal];
    [_deleteBtn addTarget:self action:@selector(deleteMoment:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_deleteBtn];
    // 评论
    [self.contentView addSubview:self.bgImageView];
    [self.contentView addSubview:self.tableView];
    // 最大高度限制
    maxLimitHeight = _linkLabel.font.lineHeight * 6;
}

#pragma mark - Getter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.separatorInset = UIEdgeInsetsZero;
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

#pragma mark - setter
- (void)setMoment:(Moment *)moment
{
    _moment = moment;
    // 头像
    _headImageView.image = [UIImage imageNamed:@"moment_head"];
    // 昵称
    _nameLab.text = moment.userName;
    // 正文
    _showAllBtn.hidden = YES;
    _linkLabel.hidden = YES;
    CGFloat bottom = _nameLab.bottom + kPaddingValue;
    if ([moment.text length]) {
        _linkLabel.hidden = NO;
        _linkLabel.text = moment.text;
        // 判断显示'全文'/'收起'
        CGSize attrStrSize = [_linkLabel preferredSizeWithMaxWidth:kTextWidth];
        CGFloat labH = attrStrSize.height;
        if (labH > maxLimitHeight) {
            if (!_moment.isFullText) {
                labH = maxLimitHeight;
                [self.showAllBtn setTitle:@"全文" forState:UIControlStateNormal];
            } else {
                [self.showAllBtn setTitle:@"收起" forState:UIControlStateNormal];
            }
            _showAllBtn.hidden = NO;
        }
        _linkLabel.frame = CGRectMake(_nameLab.left, bottom, attrStrSize.width, labH);
        _showAllBtn.frame = CGRectMake(_nameLab.left, _linkLabel.bottom + kArrowHeight, kMoreLabWidth, kMoreLabHeight);
        if (_showAllBtn.hidden) {
            bottom = _linkLabel.bottom + kPaddingValue;
        } else {
            bottom = _showAllBtn.bottom + kPaddingValue;
        }
    }
    // 图片
    _imageListView.moment = moment;
    if (moment.fileCount > 0) {
        _imageListView.origin = CGPointMake(_nameLab.left, bottom);
        bottom = _imageListView.bottom + kPaddingValue;
    }
    // 位置
    _locationLab.frame = CGRectMake(_nameLab.left, bottom, _nameLab.width, kTimeLabelH);
    _timeLab.text = [NSString stringWithFormat:@"%@",[Utility getDateFormatByTimestamp:moment.time]];
    CGFloat textW = [_timeLab.text boundingRectWithSize:CGSizeMake(200, kTimeLabelH)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName:_timeLab.font}
                                                context:nil].size.width;
    if ([moment.location length]) {
        _locationLab.hidden = NO;
        _locationLab.text = moment.location;
        _timeLab.frame = CGRectMake(_nameLab.left, _locationLab.bottom+kPaddingValue, textW, kTimeLabelH);
    } else {
        _locationLab.hidden = YES;
        _timeLab.frame = CGRectMake(_nameLab.left, bottom, textW, kTimeLabelH);
    }
    _deleteBtn.frame = CGRectMake(_timeLab.right + 25, _timeLab.top, 50, kTimeLabelH);
    bottom = _timeLab.bottom + kPaddingValue;
    
    // 处理评论/赞
    self.tableView.frame = CGRectZero;
    self.bgImageView.frame = CGRectZero;
    self.bgImageView.image = nil;
    self.tableView.tableHeaderView = nil;
    // 处理赞
    if (moment.praiseNameList.length) {
        self.likeLabel.attributedText = kMLLinkLabelAttributedText(moment.praiseNameList);
        CGSize attrStrSize = [self.likeLabel preferredSizeWithMaxWidth:kTextWidth];
        self.tableHeadView.frame = CGRectMake(0, 0, kComWidth, attrStrSize.height + 15);
        self.likeLabel.frame = CGRectMake(5, 8, attrStrSize.width, attrStrSize.height);
        self.line.top = self.likeLabel.bottom + 7;
        self.tableView.tableHeaderView = self.tableHeadView;
    }
    // 处理评论
    if ([moment.commentList count]) {
        [self.tableView reloadData];
    }
    // 更新UI
    CGFloat contentHeight = self.tableView.contentSize.height;
    if (contentHeight > 0) {
        self.bgImageView.frame = CGRectMake(_nameLab.left, bottom, kWidth-kRightMargin-_nameLab.left, contentHeight + kArrowHeight);
        self.bgImageView.image = [[UIImage imageNamed:@"comment_bg"] stretchableImageWithLeftCapWidth:40 topCapHeight:30];
        self.tableView.frame = CGRectMake(_nameLab.left, bottom + kArrowHeight, kWidth-kRightMargin-_nameLab.left, contentHeight);
    }
}

#pragma mark - 获取行高
+ (CGFloat)momentCellHeightForMoment:(Moment *)moment;
{
    CGFloat height = kBlank;
    // 名字
    height += kNameLabelH+kPaddingValue;
    // 正文
    if (moment.text.length) {
        MLLinkLabel *linkLab = kMLLinkLabel();
        linkLab.font = kTextFont;
        linkLab.text =  moment.text;
        CGFloat labH = [linkLab preferredSizeWithMaxWidth:kTextWidth].height;
        BOOL isHide = YES;
        if (labH > maxLimitHeight) {
            if (!moment.isFullText) {
                labH = maxLimitHeight;
            }
            isHide = NO;
        }
        if (isHide) {
            height += labH + kPaddingValue;
        } else {
            height += labH + kArrowHeight + kMoreLabHeight + kPaddingValue;
        }
    }
    // 图片
    height += [MMImageListView imageListHeightForMoment:moment]+kPaddingValue;
    // 地理位置
    if ([moment.location length]) {
        height += kTimeLabelH+kPaddingValue;
    }
    // 时间
    height += kTimeLabelH+kPaddingValue;
    // 如果赞或评论不空，加kArrowHeight
    CGFloat addH = 0;
    // 赞
    if (moment.praiseNameList.length) {
        addH = kArrowHeight;
        MLLinkLabel *linkLab = kMLLinkLabel();
        linkLab.attributedText = kMLLinkLabelAttributedText(moment.praiseNameList);;
        height += [linkLab preferredSizeWithMaxWidth:kTextWidth].height + 15;
    }
    // 评论
    for (Comment *com in moment.commentList) {
        addH = kArrowHeight;
        height += [CommentCell commentCellHeightForMoment:com];
    }
    if (addH == 0) {
        height -= kPaddingValue;
    }
    height += kBlank + addH;
    return height;
}

#pragma mark - 点击事件
// 查看全文/收起
- (void)fullTextClicked:(UIButton *)bt
{
    _showAllBtn.titleLabel.backgroundColor = kHLBgColor;
    dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC));
    dispatch_after(when, dispatch_get_main_queue(), ^{
        _showAllBtn.titleLabel.backgroundColor = [UIColor clearColor];
        _moment.isFullText = !_moment.isFullText;
        if ([self.delegate respondsToSelector:@selector(didSelectFullText:)]) {
            [self.delegate didSelectFullText:self];
        }
    });
}

// 点击头像
- (void)clickHead:(UITapGestureRecognizer *)gesture
{
    if ([self.delegate respondsToSelector:@selector(didClickHead:)]) {
        [self.delegate didClickHead:self];
    }
}

// 删除动态
- (void)deleteMoment:(UIButton *)bt
{
    _deleteBtn.titleLabel.backgroundColor = [UIColor lightGrayColor];
    dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC));
    dispatch_after(when, dispatch_get_main_queue(), ^{
        _deleteBtn.titleLabel.backgroundColor = [UIColor clearColor];
        if ([self.delegate respondsToSelector:@selector(didDeleteMoment:)]) {
            [self.delegate didDeleteMoment:self];
        }
    });
}

#pragma mark - MLLinkLabelDelegate
- (void)didClickLink:(MLLink *)link linkText:(NSString *)linkText linkLabel:(MLLinkLabel *)linkLabel
{
    // 点击动态正文或者赞高亮
    if ([self.delegate respondsToSelector:@selector(didClickLink:linkText:momentCell:)]) {
        [self.delegate didClickLink:link linkText:linkText momentCell:self];
    }
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
    cell.comment = [self.moment.commentList objectAtIndex:indexPath.row];
    // 点击评论高亮
    [cell setDidClickLink:^(MLLink *link, NSString *linkText){
        if ([self.delegate respondsToSelector:@selector(didClickLink:linkText:momentCell:)]) {
            [self.delegate didClickLink:link linkText:linkText momentCell:self];
        }
    }];
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
    
    // 选择评论
    Comment *comment = [self.moment.commentList objectAtIndex:indexPath.row];
    if ([self.delegate respondsToSelector:@selector(didSelectComment:)]) {
        [self.delegate didSelectComment:comment];
    }
}

@end

#pragma mark - ------------------ 评论 ------------------
@implementation CommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _linkLabel = kMLLinkLabel();
        _linkLabel.delegate = self;
        [self.contentView addSubview:_linkLabel];
    }
    return self;
}

#pragma mark - Setter
- (void)setComment:(Comment *)comment
{
    _comment = comment;
    _linkLabel.attributedText = kMLLinkLabelAttributedText(comment);
    CGSize attrStrSize = [_linkLabel preferredSizeWithMaxWidth:kTextWidth];
    _linkLabel.frame = CGRectMake(5, 3, attrStrSize.width, attrStrSize.height);
}

#pragma mark - MLLinkLabelDelegate
- (void)didClickLink:(MLLink *)link linkText:(NSString *)linkText linkLabel:(MLLinkLabel *)linkLabel
{
    if (self.didClickLink) {
        self.didClickLink(link,linkText);
    }
}

#pragma mark - 获取行高
+ (CGFloat)commentCellHeightForMoment:(Comment *)comment
{
    MLLinkLabel *linkLab = kMLLinkLabel();
    linkLab.attributedText = kMLLinkLabelAttributedText(comment);
    CGFloat height = [linkLab preferredSizeWithMaxWidth:kTextWidth].height + 5;
    return height;
}

@end
