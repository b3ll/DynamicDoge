//
//  DDPillarView.h
//  DynamicDoge
//
//  Created by Adam Bell on 2/12/2014.
//  Copyright (c) 2014 Adam Bell. All rights reserved.
//

@import UIKit;

@interface DDPillarView : UIView

- (void)regenerateTopWall;

- (BOOL)viewIntersectsBounds:(UIView *)view;
- (BOOL)pointScored:(UIView *)view;

@property (nonatomic, assign) CGFloat minWallHeight;
@property (nonatomic, assign) CGFloat minWallGap;

@property (nonatomic, strong) UIView *topWall;
@property (nonatomic, strong) UIView *bottomWall;

@end
