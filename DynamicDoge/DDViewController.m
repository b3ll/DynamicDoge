//
//  DDViewController.m
//  DynamicDoge
//
//  Created by Adam Bell on 2/12/2014.
//  Copyright (c) 2014 Adam Bell. All rights reserved.
//

#import "DDViewController.h"

@interface DDViewController ()

@property (nonatomic, strong) DDGameView *view;

@end

@implementation DDViewController {
    UIDynamicAnimator *_animator;
    UIPushBehavior *_pushBehavior;
    UIGravityBehavior *_dogeBehaviour;
    UICollisionBehavior *_collisionBehavior;
    
    BOOL _paused;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)loadView {
    DDGameView *gameView = [[DDGameView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    gameView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    self.view = gameView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.delegate = self;

    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view.boundsView];
    
    _collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.view.dogeView]];
    [_collisionBehavior setTranslatesReferenceBoundsIntoBoundary:YES];
    
    _dogeBehaviour = [[UIGravityBehavior alloc] initWithItems:@[self.view.dogeView]];
    _dogeBehaviour.gravityDirection = CGVectorMake(0.0, 1.5);
    
    _pushBehavior = [[UIPushBehavior alloc] initWithItems:@[self.view.dogeView] mode:UIPushBehaviorModeInstantaneous];
    _pushBehavior.pushDirection = CGVectorMake(0.0, 0.0);
    _pushBehavior.angle = M_PI / 2;
    
    _paused = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self run];
}

#pragma mark -
#pragma mark Game Controls

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    if (!_paused) {
        _pushBehavior.pushDirection = CGVectorMake(0.0, -1.0);
        _pushBehavior.active = YES;
    }
    else {
        [self resetGame];
    }
}

- (void)resetGame {
    [self.view reset];
    [self run];
}

- (void)run {
    if (!_paused)
        return;
    
    [_animator addBehavior:_collisionBehavior];
    [_animator addBehavior:_dogeBehaviour];
    [_animator addBehavior:_pushBehavior];
    
    _paused = NO;
}

- (void)pause {
    if (_paused)
        return;
    
    [_animator removeAllBehaviors];
    _paused = YES;
}

#pragma mark -
#pragma mark Game Handling

- (void)gameDidFail:(DDGameView *)gameView {
    [self pause];
}

@end
