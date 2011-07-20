//
//  SwarmView.h
//  PSO
//
//  Created by John Douglas on 7/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSOContext.h"
#import "Particle.h"

@interface SwarmView : UIView {
    BOOL _notFirstRun;
    CGContextRef context;
}

@property (nonatomic, retain) PSOContext *PSO;
@property CGPoint touchPoint;
@end
