//
//  MMRefreshHeadView.m
//  MomentKit
//
//  Created by LEA on 2017/12/12.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import "MMRefreshHeadView.h"

static const CGFloat LIMITY = -50.f;
NSString *const MMAnimationForKey = @"RotateAnimationKey";

@interface MMRefreshHeadView ()
{
    CABasicAnimation *rotateAnimation;
}
@end

@implementation MMRefreshHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default_moment"]];
        self.bounds = imageView.bounds;
        [self addSubview:imageView];
        
        rotateAnimation = [[CABasicAnimation alloc] init];
        rotateAnimation.keyPath = @"transform.rotation.z";
        rotateAnimation.fromValue = @0;
        rotateAnimation.toValue = @(M_PI * 2);
        rotateAnimation.duration = 1.0;
        rotateAnimation.repeatCount = MAXFLOAT;
    }
    return self;
}

- (void)setRefreshState:(MMRefreshHeadViewState)refreshState
{
    [super setRefreshState:refreshState];
    if (refreshState == MMRefreshHeadViewStateRefreshing) {
        if (self.refreshingBlock) {
            self.refreshingBlock();
        }
        [self.layer addAnimation:rotateAnimation forKey:MMAnimationForKey];
    }
    else if (refreshState == MMRefreshHeadViewStateNormal) {
        [self.layer removeAnimationForKey:MMAnimationForKey];
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.transform = CGAffineTransformIdentity;
                         }];
    }
}

- (void)updateRefreshHead:(CGFloat)offsetY
{
    CGFloat rotateValue = offsetY / 50.0 * M_PI;
    
    if (offsetY < LIMITY) {
        offsetY = LIMITY;
        
        if (self.scrollView.isDragging && self.refreshState != MMRefreshHeadViewStateWillRefresh) {
            self.refreshState = MMRefreshHeadViewStateWillRefresh;
        } else if (!self.scrollView.isDragging && self.refreshState == MMRefreshHeadViewStateWillRefresh) {
            self.refreshState = MMRefreshHeadViewStateRefreshing;
        }
    }
    
    if (self.refreshState == MMRefreshHeadViewStateRefreshing)
        return;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformTranslate(transform, 0, -offsetY);
    transform = CGAffineTransformRotate(transform, rotateValue);
    self.transform = transform;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (![keyPath isEqualToString:MMRefreshObserveKeyPath]) {
        return;
    }
    [self updateRefreshHead:self.scrollView.contentOffset.y];
}

@end
