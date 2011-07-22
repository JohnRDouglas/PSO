//
//  PSOViewController.h
//  PSO
//
//  Created by John Douglas on 7/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "SwarmView.h"
#import "PSOContext.h"
#import "Particle.h"

@interface PSOViewController : UIViewController {
    IBOutlet SwarmView *mySwarmView;
    PSOContext *myPSO;
    CGPoint touchPoint;
    NSMutableArray *scores;
    IBOutlet UISlider *popSizeSlider, *maxVelSlider;
}
@property (nonatomic, retain) IBOutlet SwarmView *mySwarmView;
@property (nonatomic, retain) PSOContext *myPSO;
@property (nonatomic, retain) IBOutlet UISlider *popSizeSlider, *maxVelSlider;

-(void) update;
-(void) evaluateFitness;

@end
