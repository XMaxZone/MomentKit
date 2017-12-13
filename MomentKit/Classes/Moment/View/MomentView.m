//
//  MomentView.m
//  MomentKit
//
//  Created by LEA on 2017/12/12.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import "MomentView.h"

/** 最大高度限制 */
CGFloat maxLimitHeight = 0;
@interface MomentView ()

/** 正文的文字 */
@property (nonatomic, strong) MLLinkLabel       *linkLabel;
/** 查看全文 */
@property (nonatomic, strong) UIButton          *showAllBtn;
/** 图片视图数组 */
@property (nonatomic, strong) NSMutableArray    *imageViewsArray;
/** 预览视图 */
@property (nonatomic, strong) MMPreviewView     *previewView;

@end

@implementation MomentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}

#pragma mark - 初始化子控件
- (void)setUpUI
{
    //1.添加正文
    _linkLabel = kMLLinkLabel();
    _linkLabel.font = kTextFont;
    _linkLabel.delegate = self;
    [self addSubview:_linkLabel];
    
    //2.查看'更多'按钮
    _showAllBtn = [[UIButton alloc]init];
    _showAllBtn.titleLabel.font = kTextFont;
    _showAllBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _showAllBtn.backgroundColor = [UIColor clearColor];
    [_showAllBtn setTitle:@"全文" forState:UIControlStateNormal];
    [_showAllBtn setTitleColor:kHLTextColor forState:UIControlStateNormal];
    [_showAllBtn addTarget:self action:@selector(fullTextClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_showAllBtn];
    
    //3.图片
    _imageViewsArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 9; i++) {
        MMImageView *imageView = [[MMImageView alloc] initWithFrame:CGRectZero];
        imageView.delegate = self;
        imageView.tag = 1000 + i;
        [_imageViewsArray addObject:imageView];
        [self addSubview:imageView];
    }
    //4.预览视图
    _previewView = [[MMPreviewView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _previewView.delegate = self;
   
    //5.最大高度限制
    maxLimitHeight = _linkLabel.font.lineHeight * 6;
}

#pragma mark - 获取行高
+ (CGFloat)momentViewHeightForMoment:(Moment *)moment
{
    CGFloat height = 0;
    // 文字高度
    if (moment.text.length)
    {
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
            height += labH+kPaddingValue;
        } else {
            height += labH+5+kMoreLabHeight+kPaddingValue;
        }
    }
    // 图片高度
    NSInteger count = moment.fileCount;
    if (count == 0) {
        height -= kPaddingValue;
    } else if (count == 1) {
        height += [MomentView getSinglePicSize:moment].height;
    } else if (count < 4) {
        height += kImageWidth;
    } else if (count < 7) {
        height += (kImageWidth*2 + kImagePadding);
    } else {
        height += (kImageWidth*3 + kImagePadding*2);
    }
    return height;
}

#pragma mark - setter
- (void)setMoment:(Moment *)moment
{    
    _moment = moment;
    
    //1.文字区
    _showAllBtn.hidden = YES;
    _linkLabel.hidden = YES;
    for (MMImageView *imageView in _imageViewsArray) {
        imageView.hidden = YES;
    }
    CGFloat contentHeight = 0;
    if ([moment.text length])
    {
        _linkLabel.hidden = NO;
        _linkLabel.text = moment.text;
        
        //1.1 判断显示'全文'OR'收起'
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
        _linkLabel.frame = CGRectMake(0, 0, attrStrSize.width, labH);
        _showAllBtn.frame = CGRectMake(0, _linkLabel.bottom+5, 65, kMoreLabHeight);
        
        if (_showAllBtn.hidden) {
            contentHeight = _linkLabel.bottom+kPaddingValue;
        } else {
            contentHeight = _showAllBtn.bottom+kPaddingValue;
        }
    }
    
    //2. 图片区
    NSInteger count = moment.fileCount;
    if (count == 0) {
        self.height = contentHeight-kPaddingValue;
        return;
    }
    //2.1 更新视图数据
    _previewView.pageNum = count;
    _previewView.scrollView.contentSize = CGSizeMake(_previewView.width*count, _previewView.height);
    //2.2 添加图片
    MMScrollView *imageView = nil;
    for (NSInteger i = 0; i < count; i++)
    {
        if (i > 8) {
            break;
        }
        NSInteger rowNum = i/3;
        NSInteger colNum = i%3;
        if(count == 4) {
            rowNum = i/2;
            colNum = i%2;
        }
        
        CGFloat imageX = colNum*(kImageWidth+kImagePadding);
        CGFloat imageY = contentHeight + rowNum*(kImageWidth+kImagePadding);
        CGRect frame = CGRectMake(imageX,imageY, kImageWidth, kImageWidth);
  
        //单张图片需计算实际显示size
        if (count == 1) {
            CGSize singleSize = [MomentView getSinglePicSize:moment];
            frame = CGRectMake(0, contentHeight, singleSize.width, singleSize.height);
        }
        imageView = [self viewWithTag:1000+i];
        imageView.hidden = NO;
        imageView.frame = frame;
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"moment_pic_%d",(int)i]];
    }
    self.height = imageView.bottom;
}

#pragma mark - MMImageViewDelegate
- (void)didClickImageView:(MMImageView *)imageView
{
    UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    
    //1.解除隐藏
    [window addSubview:_previewView];
    [window bringSubviewToFront:_previewView];
    //2.添加子视图
    for (UIView *V in _previewView.scrollView.subviews){
        [V removeFromSuperview];
    }
    
    NSInteger index = imageView.tag-1000;
    NSInteger count = _moment.fileCount;
    CGRect convertRect;
    if (count == 1) {
        [_previewView.pageControl removeFromSuperview];
    }
    for (NSInteger i = 0; i < count; i ++)
    {
        MMImageView *pImageView = (MMImageView *)[self viewWithTag:1000+i];
        convertRect = [[pImageView superview] convertRect:pImageView.frame toView:window];

        MMScrollView *scrollView = [[MMScrollView alloc] initWithFrame:CGRectMake(i*_previewView.width, 0, _previewView.width, _previewView.height)];
        scrollView.tag = 100+i;
        scrollView.maximumZoomScale = 2.0;
        scrollView.pDelegate = self;
        scrollView.image = pImageView.image;
        scrollView.contentRect = convertRect;
        [_previewView.scrollView addSubview:scrollView];
       
        if (i == index) {
            [UIView animateWithDuration:0.3 animations:^{
                _previewView.markView.hidden = NO;
                _previewView.pageControl.hidden = NO;
                [scrollView updateOriginRect];
            }];
        } else {
            [scrollView updateOriginRect];
        }
    }

    //3.更新offset
    CGPoint offset = _previewView.scrollView.contentOffset;
    offset.x = index * kWidth;
    _previewView.scrollView.contentOffset = offset;   
}

#pragma mark - MMScrollViewDelegate
- (void)didClickPicture:(MMScrollView *)scrollView
{
    [UIView animateWithDuration:0.3 animations:^{
        _previewView.pageControl.hidden = YES;
        _previewView.markView.hidden = YES;
        scrollView.zoomScale = 1.0;
        scrollView.contentRect = scrollView.contentRect;
    } completion:^(BOOL finished) {
        [_previewView removeFromSuperview];
    }];
}

- (void)didClosePreview
{
    [_previewView removeFromSuperview];
}

#pragma mark - MLLinkLabelDelegate
- (void)didClickLink:(MLLink *)link linkText:(NSString *)linkText linkLabel:(MLLinkLabel *)linkLabel
{
    if ([self.delegate respondsToSelector:@selector(didClickLinkText:withType:)]) {
        [self.delegate didClickLinkText:linkText withType:link.linkType];
    }
}

#pragma mark - 查看全文/收起
- (void)fullTextClicked:(UIButton *)bt
{
    _showAllBtn.titleLabel.backgroundColor = [UIColor lightGrayColor];
    dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC));
    dispatch_after(when, dispatch_get_main_queue(), ^{
        _showAllBtn.titleLabel.backgroundColor = [UIColor clearColor];
        _moment.isFullText = !_moment.isFullText;
        if ([self.delegate respondsToSelector:@selector(didSelectFullText:)]) {
            [self.delegate didSelectFullText:self];
        }
    });
}

#pragma mark - 获取单张图片的实际size
+ (CGSize)getSinglePicSize:(Moment *)moment
{
    CGFloat MAX_WIDTH = kWidth-150;
    CGFloat MAX_HEIGHT = kWidth-130;
    CGFloat imageW = moment.singleWidth;
    CGFloat imageH = moment.singleHeight;
    
    CGFloat resultW = 0;
    CGFloat resultH = 0;
    if (imageH/imageW > 3) {
        resultH = MAX_HEIGHT;
        resultW = resultH/2;
    }  else  {
        resultW = MAX_WIDTH;
        resultH = MAX_WIDTH*imageH/imageW;
        if (resultH > MAX_HEIGHT) {
            resultH = MAX_HEIGHT;
            resultW = MAX_HEIGHT*imageW/imageH;
        }
    }
    return CGSizeMake(resultW, resultH);
}

@end
