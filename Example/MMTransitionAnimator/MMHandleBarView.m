//
//  MMHandleBarView.m
//  MMTransitionAnimator
//
//  Created by mo jun on 3/5/16.
//  Copyright © 2016 mojun. All rights reserved.
//

#import "MMHandleBarView.h"

@implementation MMHandleBarView {
    UIImageView *_bgView;
}

- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:[self bgView]];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _bgView.frame = self.bounds;
}

#pragma mark - getters
- (UIImageView *)bgView {
    if (_bgView == nil) {
        _bgView = [[UIImageView alloc]init];
        _bgView.image = [UIImage imageNamed:@"pan_bg"];
        _bgView.contentMode = UIViewContentModeScaleToFill;
        _bgView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        _bgView.userInteractionEnabled = NO;
    }
    return _bgView;
}

@end
