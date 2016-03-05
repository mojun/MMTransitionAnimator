//
//  MMViewController.m
//  MMTransitionAnimator
//
//  Created by mojun on 03/05/2016.
//  Copyright (c) 2016 mojun. All rights reserved.
//

#import "ViewController.h"
#import "ModalViewController.h"
#import "PlaylistViewController.h"
#import "UIView+LayoutMethods.h"
#import "MMHandleBarView.h"

#define kHandleBarHeight 55

@interface ViewController ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) MMHandleBarView *handleBarView;
@property (nonatomic, strong) MMTransitionAnimator *animator;
@property (nonatomic, strong) ModalViewController *modalVC;
@property (nonatomic, strong) PlaylistViewController *playlistVC;

@end

@implementation ViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:[self containerView]];
    
    [self.view addSubview:[self handleBarView]];
    
    [self setupVC];
    
    [self setupAnimator];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    CGRect containerRect = self.view.bounds;
    containerRect.size.height -= kHandleBarHeight;
    _containerView.frame = containerRect;
    _playlistVC.view.frame = _containerView.bounds;
    
    if (CGRectEqualToRect(_handleBarView.frame, CGRectZero)) {
        containerRect.origin.y = containerRect.size.height;
        containerRect.size.height = kHandleBarHeight;
        _handleBarView.frame = containerRect;
    }
    
}

#pragma mark - private methods
- (void)setupVC {
    [[self playlistVC] willMoveToParentViewController:self];
    [self addChildViewController:[self playlistVC]];
    [_containerView addSubview:_playlistVC.view];
    [_playlistVC didMoveToParentViewController:self];
    
    [self modelVC];
}

- (void)setupAnimator {
    _animator = [[MMTransitionAnimator alloc]initWithOperationType:MMTransitionAnimatorOperationPresent fromVC:self toVC:_modalVC];
    _animator.usingSpringWithDamping = 0.8f;
    _animator.gestureTargetView = self.handleBarView;
    _animator.interactiveType = MMTransitionAnimatorOperationPresent;
    
    /// 在block中的成员变量也会引起retain cycle
    __weak __typeof(*&self) weakSelf = self;
    [_animator setPresentationBeforeHandler:^(UIView *containerView, id<UIViewControllerContextTransitioning> transitionContext) {
        [weakSelf beginAppearanceTransition:NO animated:NO];
        weakSelf.animator.direction = MMTransitionAnimatorDirectionTop;
        weakSelf.modalVC.view.y = weakSelf.handleBarView.bottom;
        
        [containerView addSubview:weakSelf.modalVC.view];
        [weakSelf.view layoutIfNeeded];
        [weakSelf.modalVC.view layoutIfNeeded];
        
        // handle pan
        CGFloat startOriginY = weakSelf.handleBarView.y;
        CGFloat endOriginY = -weakSelf.handleBarView.height;
        CGFloat diff = startOriginY - endOriginY;
        
        [weakSelf.animator setPresentationAnimationHandler:^(UIView *containerView, CGFloat percentComplete) {
            percentComplete = percentComplete >= 0 ? percentComplete : 0;
            CGFloat expectY = startOriginY - diff * percentComplete;
            if (expectY < endOriginY) {
                expectY = endOriginY;
            }
            weakSelf.handleBarView.y = expectY;
            
            weakSelf.modalVC.view.y = weakSelf.handleBarView.bottom;
            
            CGFloat alpha = 1.0 - (1.0 * percentComplete);
            weakSelf.containerView.alpha = alpha + 0.5f;
            for (UIView *s in weakSelf.handleBarView.subviews) {
                s.alpha = alpha;
            }
            
        }];
        
        [weakSelf.animator setPresentationCancelAnimationHandler:^(UIView *containerView) {
            weakSelf.handleBarView.y = startOriginY;
            weakSelf.modalVC.view.y = weakSelf.handleBarView.height + startOriginY;
            weakSelf.containerView.alpha = 1.0;
            for (UIView *s in weakSelf.handleBarView.subviews) {
                s.alpha = 1.0;
            }
        }];
        
        [weakSelf.animator setPresentationCompletionHandler:^(UIView *containerView, BOOL completeTransition) {
            if (completeTransition) {
                weakSelf.animator.interactiveType = MMTransitionAnimatorOperationDismiss;
                weakSelf.animator.gestureTargetView = weakSelf.modalVC.view;
                weakSelf.animator.direction = MMTransitionAnimatorDirectionBottom;
            } else {
                [weakSelf beginAppearanceTransition:YES animated:NO];
                [weakSelf endAppearanceTransition];
            }
        }];
        
    }];
    
    [_animator setDismissalBeforeHandler:^(UIView *containerView, id<UIViewControllerContextTransitioning> transitionContext) {
        [weakSelf beginAppearanceTransition:YES animated:NO];
        [weakSelf.view addSubview:weakSelf.modalVC.view];
        [weakSelf.view layoutIfNeeded];
        [weakSelf.modalVC.view layoutIfNeeded];
        
        CGFloat startOriginY = 0 - weakSelf.handleBarView.height;
        CGFloat endOriginY = weakSelf.view.height - weakSelf.handleBarView.height;
        CGFloat diff = endOriginY - startOriginY;
        
        weakSelf.containerView.alpha = 0.5f;
        [weakSelf.animator setDismissalAnimationHandler:^(UIView *containerView, CGFloat percentComplete) {
            percentComplete = percentComplete >= -0.05 ? percentComplete : -0.05;
            weakSelf.handleBarView.y = startOriginY + (diff * percentComplete);
            weakSelf.modalVC.view.y = weakSelf.handleBarView.y + weakSelf.handleBarView.height;
            
            CGFloat alpha = 1.0 * percentComplete;
            weakSelf.containerView.alpha = alpha + 0.5f;
            weakSelf.handleBarView.alpha = 1;
            for (UIView *s in weakSelf.handleBarView.subviews) {
                s.alpha = alpha;
            }
        }];
        
        [weakSelf.animator setDismissalCancelAnimationHandler:^(UIView *containerView) {
            weakSelf.handleBarView.y = startOriginY;
            weakSelf.modalVC.view.y = startOriginY + weakSelf.handleBarView.height;
            weakSelf.handleBarView.alpha = 0;
            weakSelf.containerView.alpha = 0.5f;
            for (UIView *s in weakSelf.handleBarView.subviews) {
                s.alpha = 0;
            }
        }];
        
        [weakSelf.animator setDismissalCompletionHandler:^(UIView *containerView, BOOL completeTransition) {
            if (completeTransition) {
                [weakSelf.modalVC.view removeFromSuperview];
                weakSelf.animator.gestureTargetView = weakSelf.handleBarView;
                weakSelf.animator.interactiveType = MMTransitionAnimatorOperationPresent;
            } else {
                [weakSelf.modalVC.view removeFromSuperview];
                [containerView addSubview:weakSelf.modalVC.view];
                [weakSelf beginAppearanceTransition:NO animated:NO];
                [weakSelf endAppearanceTransition];
            }
        }];
        
    }];
    
    self.modalVC.transitioningDelegate = self.animator;
}

- (void)handleTap:(UIGestureRecognizer *)gesture {
    self.animator.interactiveType = MMTransitionAnimatorOperationNone;
    [self presentViewController:self.modalVC animated:YES completion:nil];
}

#pragma mark - getters
- (UIView *)containerView {
    if (_containerView == nil) {
        _containerView = [[UIView alloc]init];
        _containerView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        _containerView.clipsToBounds = YES;
        
    }
    return _containerView;
}

- (UIView *)handleBarView {
    if (_handleBarView == nil) {
        _handleBarView = [[MMHandleBarView alloc]init];
        _handleBarView.clipsToBounds = YES;
        _handleBarView.backgroundColor = [UIColor whiteColor];
        _handleBarView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
        [_handleBarView addGestureRecognizer:tap];
    }
    return _handleBarView;
}

- (ModalViewController *)modelVC {
    if (!_modalVC) {
        _modalVC = [[ModalViewController alloc]init];
        _modalVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    }
    return _modalVC;
}

- (PlaylistViewController *)playlistVC {
    if (!_playlistVC) {
        _playlistVC = [PlaylistViewController new];
    }
    return _playlistVC;
}


@end
