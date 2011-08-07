//
//  Particle.h
//  PSO
//
//  Created by John Douglas on 7/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Particle : NSObject {
    int dimensions;
    double *myPosits;
    double *myVelocities;
    double *myBestPosits;
    double myFitness;
    double myBestFitness;
    double velocityFactor;

}

@property double *upperBounds, *lowerBounds;
@property (nonatomic, retain) Particle *globalBest;
@property (nonatomic, retain) NSArray *neighbors;

-(id) initWithDimension: (int)DimCount lowerBounds: (double *)newLowerBounds upperBounds: (double *)newUpperBounds;
-(void) setVelocityFactor: (double)MaxVelocity;

-(double *)Posits;
-(double *)BestPosits;
-(int) Dimension;

-(void) iterate: (double) Score;
-(BOOL) setFitness: (double) Score;

-(double) Fitness;
-(void) reset: (BOOL) ResetPosits;

@end

