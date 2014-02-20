//
//  DDPillarView.m
//  DynamicDoge
//
//  Created by Adam Bell on 2/12/2014.
//  Copyright (c) 2014 Adam Bell. All rights reserved.
//

#import "DDPillarView.h"

#define WALL_WIDTH 44.0
#define WALL_GAP_HEIGHT 140.0
#define MIN_WALL_HEIGHT (self.bounds.size.height / 3.0)

@implementation DDPillarView {
    CGFloat _topWallHeight;
    
    BOOL _pointScored;
    BOOL gottaGoFast;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        gottaGoFast = [[NSUserDefaults standardUserDefaults] boolForKey:@"GOTTAGOFAST"];

        UIView *topWall = [[UIView alloc] initWithFrame:CGRectZero];
        topWall.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:gottaGoFast ? @"Texture.png" : @"UINavigationBarRotated.png"]];
        [self addSubview:topWall];
        self.topWall = topWall;
        
        UIView *bottomWall = [[UIView alloc] initWithFrame:CGRectZero];
        bottomWall.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:gottaGoFast ? @"Texture.png" : @"UINavigationBarRotated.png"]];
        [self addSubview:bottomWall];
        self.bottomWall = bottomWall;
        
        self.backgroundColor = [UIColor clearColor];

        [self regenerateTopWall];
        [self setNeedsLayout];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGRect bounds = self.bounds;
    
    self.topWall.frame = CGRectMake(0.0, 0.0, bounds.size.width, _topWallHeight);
    self.bottomWall.frame = CGRectMake(self.topWall.frame.origin.x, self.topWall.bounds.size.height + WALL_GAP_HEIGHT, bounds.size.width, bounds.size.height - self.topWall.bounds.size.height + WALL_GAP_HEIGHT);
}

- (BOOL)viewIntersectsBounds:(UIView *)view {
    BOOL hitBounds = NO;
    
    CGRect localFrame = [self.superview convertRect:view.frame toView:self];
    
    if (CGRectIntersectsRect(localFrame, self.topWall.frame) || CGRectIntersectsRect(localFrame, self.bottomWall.frame))
        hitBounds = YES;
    
    return hitBounds;
}

- (BOOL)pointScored:(UIView *)view {
    if (_pointScored)
        return NO;
    
    CGRect localFrame = [self.superview convertRect:view.frame toView:self];
    if (localFrame.origin.x > self.bounds.size.width) {
        _pointScored = YES;
    }
    
    return _pointScored;
}

- (void)regenerateTopWall {
    CGRect bounds = self.bounds;
    
    CGFloat defaultWallHeight = ((bounds.size.height - WALL_GAP_HEIGHT) / 2.0);
    CGFloat halfWallHeight = defaultWallHeight / 2.0;
    
    _topWallHeight = defaultWallHeight + ((arc4random() % 2 == 0 ? -1.0 : 1.0) * (arc4random() % (int)halfWallHeight));
    _pointScored = NO;
    
    [self setNeedsLayout];
}

@end
