//
//  MMRefreshBaseView.m
//  MomentKit
//
//  Created by LEA on 2017/12/12.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import "MMRefreshBaseView.h"

NSString *const MMRefreshObserveKeyPath = @"contentOffset";
@implementation MMRefreshBaseView

- (void)setScrollView:(UIScrollView *)scrollView
{
    _scrollView = scrollView;
    [_scrollView.superview addSubview:self];
    [scrollView addObserver:self forKeyPath:MMRefreshObserveKeyPath options:NSKeyValueObservingOptionNew context:nil];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (!newSuperview) {
        [_scrollView removeObserver:self forKeyPath:MMRefreshObserveKeyPath];
    }
}

- (void)endRefreshing
{
    [self setRefreshState:MMRefreshHeadViewStateNormal];
}

@end
