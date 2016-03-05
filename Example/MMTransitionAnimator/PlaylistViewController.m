//
//  PlaylistViewController.m
//  MusicPlaybackTransition
//
//  Created by mo jun on 3/3/16.
//  Copyright © 2016 kimoworks. All rights reserved.
//

#import "PlaylistViewController.h"

@interface PlaylistViewController ()

@end

@implementation PlaylistViewController {
    UIImageView *_bgView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:[self bgView]];
    
    UILabel *l = [UILabel new];
    l.text = @"ABC 莫";
    l.frame = CGRectMake(100, 100, 200, 30);
    [self.view addSubview:l];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _bgView.frame = self.view.bounds;
    NSLog(@"frame___ :  %@", NSStringFromCGRect(_bgView.frame));
    _bgView.image = [UIImage imageNamed:@"home_bg"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getters 
- (UIImageView *)bgView {
    if (_bgView == nil) {
        _bgView = [[UIImageView alloc]init];
        _bgView.contentMode = UIViewContentModeScaleToFill;
        _bgView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    }
    return _bgView;
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
