//
//  MMPreviewView.h
//  MomentKit
//
//  Created by LEA on 2017/12/12.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MMPreviewViewDelegate;
@interface MMPreviewView : UIView <UIScrollViewDelegate>

//横向滚动视图
@property (nonatomic,strong) UIScrollView *scrollView;
//预览时的黑色背景
@property (nonatomic,strong) UIView *markView;
//页码指示
@property (nonatomic,strong) UIPageControl *pageControl;
//页码数目
@property (nonatomic,assign) NSInteger pageNum;
//页码索引
@property (nonatomic,assign) NSInteger pageIndex;

@property (nonatomic,assign) id<MMPreviewViewDelegate> delegate;

@end

@protocol MMPreviewViewDelegate <NSObject>

@optional
- (void)didEndDecelerating:(MMPreviewView *)previewView;

@end
