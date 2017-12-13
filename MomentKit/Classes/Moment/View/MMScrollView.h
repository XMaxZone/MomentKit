//
//  MMScrollView.h
//  MomentKit
//
//  Created by LEA on 2017/12/12.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MMScrollViewDelegate;
@interface MMScrollView : UIScrollView

@property (nonatomic,assign) id <MMScrollViewDelegate> pDelegate;
@property (nonatomic,assign) CGRect contentRect;
@property (nonatomic,strong) UIImage *image;

- (void)updateOriginRect;

@end


@protocol MMScrollViewDelegate <NSObject>

//点击图片
- (void)didClickPicture:(MMScrollView *)scrollView;
//关闭预览
- (void)didClosePreview;

@end
