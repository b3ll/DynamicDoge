//
//  DDGameView.h
//  DynamicDoge
//
//  Created by Adam Bell on 2/12/2014.
//  Copyright (c) 2014 Adam Bell. All rights reserved.
//

@import UIKit;

#import "DDPillarView.h"

@class DDGameView;

@protocol DDGameViewDelegate <NSObject>

- (void)gameDidFail:(DDGameView *)gameView;

@end

@interface DDGameView : UIView

- (void)reset;

@property (nonatomic, weak) id<DDGameViewDelegate> delegate;

@property (nonatomic, strong) UIView *dogeView;
@property (nonatomic, strong) UIView *boundsView;
@property (nonatomic, strong) DDPillarView *pillarView;

@end
