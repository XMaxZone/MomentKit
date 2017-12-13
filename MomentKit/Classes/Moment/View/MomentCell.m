//
//  MomentCell.m
//  MomentKit
//
//  Created by LEA on 2017/12/12.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import "MomentCell.h"

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
    //头像视图
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, kBlank, kFaceWidth, kFaceWidth)];
    _headImageView.contentMode = UIViewContentModeScaleAspectFill;
    _headImageView.userInteractionEnabled = YES;
    _headImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:_headImageView];

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHead:)];
    [_headImageView addGestureRecognizer:tapGesture];
    
    //名字视图
    _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(_headImageView.right+10, _headImageView.top, kWidth-kFaceWidth-kPaddingValue*3, 20)];
    _nameLab.font = [UIFont boldSystemFontOfSize:17.0];
    _nameLab.textColor = kHLTextColor;
    _nameLab.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_nameLab];
    
    //正文视图
    _momentView = [[MomentView alloc] initWithFrame:CGRectMake(_nameLab.left, _nameLab.bottom+kPaddingValue, kTextWidth, 0)];
    _momentView.delegate = self;
    _momentView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_momentView];

    //位置视图
    _locationLab = [[UILabel alloc] init];
    _locationLab.textColor = [UIColor grayColor];
    _locationLab.font = [UIFont systemFontOfSize:13.0f];
    [self.contentView addSubview:_locationLab];
    
    //时间视图
    _timeLab = [[UILabel alloc] init];
    _timeLab.textColor = [UIColor grayColor];
    _timeLab.font = [UIFont systemFontOfSize:13.0f];
    [self.contentView addSubview:_timeLab];
    
    //删除视图
    _deleteBtn = [[UIButton alloc] init];
    _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    _deleteBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _deleteBtn.backgroundColor = [UIColor clearColor];
    [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [_deleteBtn setTitleColor:kHLTextColor forState:UIControlStateNormal];
    [_deleteBtn addTarget:self action:@selector(deleteMoment:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_deleteBtn];
    
    //评论
    _commentView = [[CommentView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_commentView];
}

#pragma mark - setter
- (void)setMoment:(Moment *)moment
{
    _moment = moment;
    _momentView.moment = moment;

    _nameLab.text = moment.userName;
    _headImageView.image = [UIImage imageNamed:@"moment_head"];
    _locationLab.frame = CGRectMake(_nameLab.left,_momentView.bottom+10, _nameLab.width, kTimeLabelH);
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
        _timeLab.frame = CGRectMake(_nameLab.left, _momentView.bottom+kPaddingValue, textW, kTimeLabelH);
    }
    _deleteBtn.frame = CGRectMake(_timeLab.right+25, _timeLab.top, 50, kTimeLabelH);
    _commentView.frame = CGRectMake(_nameLab.left, _timeLab.bottom+kPaddingValue, kWidth-_nameLab.left-10, 0);
    _commentView.moment = moment;
}

#pragma mark - 获取行高
+ (CGFloat)momentCellHeightForMoment:(Moment *)moment;
{
    CGFloat height = kBlank;
    // 名字
    height += kNameLabelH+kPaddingValue;
    // 正文
    height += [MomentView momentViewHeightForMoment:moment]+kPaddingValue;
    // 地理位置
    if ([moment.location length]) {
        height += kTimeLabelH+kPaddingValue;
    }
    // 时间
    height += kTimeLabelH+kPaddingValue;
    // 评论/赞
    CGFloat h = [CommentView commentViewHeightForMoment:moment];
    if (h == 0) {
        height -= kPaddingValue;
    } else {
        height += h;
    }
    height += kBlank;
    return height;
}

#pragma mark - 点击事件
- (void)clickHead:(UITapGestureRecognizer *)gesture
{
    
}

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

#pragma mark - MomentViewDelgate
- (void)didSelectFullText:(MomentView *)momentView
{
    if ([self.delegate respondsToSelector:@selector(didSelectFullText:)]) {
        [self.delegate didSelectFullText:self];
    }
}

- (void)didClickLinkText:(NSString *)linkText withType:(MLLinkType)type;
{
    if ([self.delegate respondsToSelector:@selector(cell:didClickLinkText:withType:)]) {
        [self.delegate cell:self didClickLinkText:linkText withType:type];
    }
}

@end
