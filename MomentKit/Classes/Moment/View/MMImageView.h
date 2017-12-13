//
//  MMImageView.h
//  MomentKit
//
//  Created by LEA on 2017/12/12.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MMImageViewDelegate;
@interface MMImageView : UIImageView

@property (nonatomic, assign) id <MMImageViewDelegate> delegate;

@end

@protocol MMImageViewDelegate <NSObject>

- (void)didClickImageView:(MMImageView *)imageView;

@end
