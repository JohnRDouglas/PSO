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

@property (nonatomic, retain) NSArray *upperBounds, *lowerBounds;


-(id) initWithPopulation: (int)PopSize dimension: (int)DimCount lowerBounds: (NSArray *)newLowerBounds upperBounds: (NSArray *)newUpperBounds;;
-(void) setVelocityFactor: (double)MaxVelocity;
-(void) setNeighborhoodSize: (int)NeighborCount;
-(void) setParticleCount: (int) popSize;

-(NSArray *) Particles;
-(NSNumber *) Dimension;
-(double) velocityFactor;

-(void) iterate: (NSArray *)Scores;

-(Particle *)globalBest;

-(void)resetParticles: (BOOL)ResetPosits;

@end
