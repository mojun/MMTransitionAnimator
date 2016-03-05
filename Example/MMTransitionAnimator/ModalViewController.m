//
//  ModalViewController.m
//  MusicPlaybackTransition
//
//  Created by mo jun on 3/3/16.
//  Copyright © 2016 kimoworks. All rights reserved.
//

#import "ModalViewController.h"

@interface ModalViewController (){
    
}

@end

@implementation ModalViewController {
    UIImageView *_bgView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:[self bgView]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _bgView.frame = self.view.bounds;
}

#pragma mark - getters
- (UIImageView *)bgView {
    if (_bgView == nil) {
        _bgView = [[UIImageView alloc]init];
        _bgView.image = [UIImage imageNamed:@"modal_bg"];
        _bgView.contentMode = UIViewContentModeScaleToFill;
        _bgView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    }
    return _bgView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
