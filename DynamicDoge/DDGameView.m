//
//  DDGameView.m
//  DynamicDoge
//
//  Created by Adam Bell on 2/12/2014.
//  Copyright (c) 2014 Adam Bell. All rights reserved.
//

#import "DDGameView.h"

#define DOGE_SIZE 44.0
#define WALL_GAP 140.0
#define MIN_WALL_HEIGHT 160.0

#define PILLAR_PADDING 156.0

#define PILLAR_WIDTH 44.0

#define NUM_PILLARS 3

@implementation DDGameView {
    NSMutableArray *_pillars;
    NSUInteger _pillarIndex;
    
    NSUInteger _score;
    UILabel *_currentScore;
    
    UIImageView *_background;
    
    BOOL gottaGoFast;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        gottaGoFast = [[NSUserDefaults standardUserDefaults] boolForKey:@"GOTTAGOFAST"];

        _background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:(gottaGoFast ? @"Background.png" : @"Linen.png")]];
        [self addSubview:_background];
        
        UIImageView *dogeView = [[UIImageView alloc] initWithFrame:CGRectMake(100.0, 100.0, DOGE_SIZE, DOGE_SIZE)];
        dogeView.backgroundColor = [UIColor clearColor];
        dogeView.image = [UIImage imageNamed:(gottaGoFast ? @"Tails.png" : @"Button.png")];
        
        self.dogeView = dogeView;
        
        self.backgroundColor = [UIColor blackColor];
        
        _pillars = [NSMutableArray array];
        for (int i = 0; i < NUM_PILLARS; i++) {
            DDPillarView *pillarView = [[DDPillarView alloc] initWithFrame:CGRectMake(frame.size.width + (i * (PILLAR_WIDTH + PILLAR_PADDING)), 0.0, PILLAR_WIDTH, frame.size.height)];
            [_pillars addObject:pillarView];
            [self addSubview:pillarView];
        }
        
        UIImageView *bottom = [[UIImageView alloc] initWithImage:[UIImage imageNamed:(gottaGoFast ? @"Bottom.png" : @"UIToolbar.png")]];
        bottom.frame = CGRectMake(0, frame.size.height - bottom.bounds.size.height, bottom.bounds.size.width, bottom.bounds.size.height);
        [self addSubview:bottom];
        
        _currentScore = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height - 72, frame.size.width, 100)];
        _currentScore.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        _currentScore.textColor = [UIColor whiteColor];
        _currentScore.text = @"0";
        _currentScore.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_currentScore];
        
        UIView *boundsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - bottom.bounds.size.height)];
        boundsView.backgroundColor = [UIColor clearColor];
        [self addSubview:boundsView];
        [boundsView addSubview:self.dogeView];
        self.boundsView = boundsView;

        CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(moveWalls)];
        [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    return self;
}

- (void)makeNewWalls {
    DDPillarView *pillarView = _pillars[_pillarIndex];
   
    NSUInteger lastIndex = (_pillarIndex + (_pillars.count - 1)) % _pillars.count;
    DDPillarView *lastPillar = _pillars[lastIndex];
    
    pillarView.frame = CGRectOffset(lastPillar.frame, PILLAR_WIDTH + PILLAR_PADDING, 0.0);
    
    _pillarIndex = ((_pillarIndex + 1) % _pillars.count);
    
    [pillarView regenerateTopWall];
}

- (void)updateScore {
    _currentScore.text = [NSString stringWithFormat:@"%lu", (unsigned long)_score];
}

- (void)moveWalls {
    BOOL gameOver = NO;
    for (DDPillarView *pillar in _pillars) {
        if (!gameOver) {
            gameOver = [pillar viewIntersectsBounds:self.dogeView];
            
            if ([pillar pointScored:self.dogeView]) {
                _score++;
                [self updateScore];
            }
        }
    }
    
    if (!gameOver) {
        for (DDPillarView *pillar in _pillars) {
            pillar.frame = CGRectOffset(pillar.frame, -2.0, 0.0);
        
            if (pillar.frame.origin.x < -PILLAR_WIDTH) {
                [self makeNewWalls];
            }
        }
    }
    else {
        [self.delegate gameDidFail:self];
    }
}


- (void)reset {
    _pillarIndex = 0;
    
    NSUInteger pillarCount = _pillars.count;
    
    CGRect bounds = self.bounds;
    
    for (int i = 0; i < pillarCount; i++) {
        DDPillarView *pillarView = _pillars[i];
        pillarView.frame = CGRectMake(bounds.size.width + (i * (PILLAR_WIDTH + PILLAR_PADDING)), 0.0, PILLAR_WIDTH, bounds.size.height);
        [pillarView regenerateTopWall];
    }
    
    _score = 0;
    [self updateScore];
    
    _dogeView.frame = CGRectMake(100.0, 100.0, DOGE_SIZE, DOGE_SIZE);
}

@end
