//
//  MMPreviewView.m
//  MomentKit
//
//  Created by LEA on 2017/12/12.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import "MMPreviewView.h"

@implementation MMPreviewView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        
        //添加子视图
        _markView = [[UIView alloc] initWithFrame:self.bounds];
        _markView.backgroundColor = [UIColor blackColor];
        _markView.hidden = YES;
        [self addSubview:_markView];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.scrollEnabled = YES;
        _scrollView.userInteractionEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:_scrollView];
        
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.height-40, kWidth, 20)];
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        [self addSubview:_pageControl];
    }
    return self;
}

#pragma mark - setter
- (void)setPageNum:(NSInteger)pageNum
{
    _pageNum = pageNum;
    _pageControl.numberOfPages = pageNum;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _pageIndex = scrollView.contentOffset.x / self.width;
    _pageControl.currentPage = _pageIndex;
}

@end
