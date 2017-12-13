//
//  MMScrollView.m
//  MomentKit
//
//  Created by LEA on 2017/12/12.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import "MMScrollView.h"

@interface MMScrollView () <UIScrollViewDelegate>

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,assign) CGRect originRect;

@end

@implementation MMScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.bouncesZoom = YES;
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        self.minimumZoomScale = 1.0;
        self.userInteractionEnabled = YES;
        //显示的图片
        [self addSubview:self.imageView];
        //双击
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGestureCallback:)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
        //单击
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCallback:)];
        [singleTap requireGestureRecognizerToFail:doubleTap];
        [self addGestureRecognizer:singleTap];
        //长按
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureCallback:)];
        [self addGestureRecognizer:longPress];
    }
    return self;
}

#pragma mark - getter
- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.contentScaleFactor = [[UIScreen mainScreen] scale];
        _imageView.backgroundColor = [UIColor redColor];
    }
    return _imageView;
}

#pragma mark - setter
- (void)setImage:(UIImage *)image
{
    self.imageView.image = image;
}

- (void)setContentRect:(CGRect)contentRect
{
    _contentRect = contentRect;
    self.imageView.frame = contentRect;
}

#pragma mark - 图片展开
- (void)updateOriginRect
{
    CGSize picSize = self.imageView.image.size;
    if (picSize.width == 0 || picSize.height == 0) {
        return;
    }
    float scaleX = self.frame.size.width/picSize.width;
    float scaleY = self.frame.size.height/picSize.height;
    if (scaleX > scaleY)
    {
        float imgViewWidth = picSize.width*scaleY;
        self.maximumZoomScale = self.frame.size.width/imgViewWidth;
        _originRect = (CGRect){self.frame.size.width/2-imgViewWidth/2,0,imgViewWidth,self.frame.size.height};
    }
    else
    {
        float imgViewHeight = picSize.height*scaleX;
        self.maximumZoomScale = self.frame.size.height/imgViewHeight;
        _originRect = (CGRect){0,self.frame.size.height/2-imgViewHeight/2,self.frame.size.width,imgViewHeight};
        self.zoomScale = 1.0;
    }
    [UIView animateWithDuration:0.4
                     animations:^{
                         self.imageView.frame = _originRect;
                     }];
}

#pragma mark - 手势处理
- (void)doubleTapGestureCallback:(UITapGestureRecognizer *)gesture
{
    CGFloat zoomScale = self.zoomScale;
    if (zoomScale == self.maximumZoomScale) {
        zoomScale = 0;
    } else {
        zoomScale = self.maximumZoomScale;
    }
    [UIView animateWithDuration:0.35
                     animations:^{
                         self.zoomScale = zoomScale;
                     }];
}

- (void)singleTapGestureCallback:(UITapGestureRecognizer *)gesture
{
    if ([self.pDelegate respondsToSelector:@selector(didClickPicture:)]) {
        [self.pDelegate didClickPicture:self];
    }
}

- (void)longPressGestureCallback:(UILongPressGestureRecognizer *)gesture
{
    
}

#pragma mark - scroll delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGSize boundsSize = scrollView.bounds.size;
    CGRect imgFrame = self.imageView.frame;
    CGSize contentSize = scrollView.contentSize;
    CGPoint centerPoint = CGPointMake(contentSize.width/2, contentSize.height/2);
    
    if (imgFrame.size.width <= boundsSize.width) {
        centerPoint.x = boundsSize.width/2;
    }
    if (imgFrame.size.height <= boundsSize.height) {
        centerPoint.y = boundsSize.height/2;
    }
    self.imageView.center = centerPoint;
}

@end
