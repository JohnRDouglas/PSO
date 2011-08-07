//
//  PSOContext.h
//  PSO
//
//  Created by John Douglas on 7/17/11.
//  Copyright 2011 SlimeSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Particle.h"

@interface PSOContext : NSObject {
    NSMutableArray *myParticles;
    int myDimension;
    int hoodSize;
    Particle *myGlobalBest;
    double velocityFactor;
}

@property double *upperBounds, *lowerBounds;

-(id) initWithPopulation: (int)PopSize dimension: (int)DimCount lowerBounds: (double *)newLowerBounds upperBounds: (double *)newUpperBounds;
-(void) setVelocityFactor: (double)MaxVelocity;
-(void) setNeighborhoodSize: (int)NeighborCount;
-(void) setParticleCount: (int) popSize;

-(NSArray *) Particles;
-(int) Dimension;
-(double) velocityFactor;

-(void) iterateSwarm: (double *)Scores;

-(Particle *)globalBest;

-(void)resetParticles: (BOOL)ResetPosits;

@end
