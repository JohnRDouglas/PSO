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

@property (nonatomic, retain) NSArray *upperBounds, *lowerBounds;
@property (nonatomic, retain) Particle *globalBest;
@property (nonatomic, retain) NSArray *neighbors;

-(id) initWithDimension: (int)DimCount lowerBounds: (NSArray *)newLowerBounds upperBounds: (NSArray *)newUpperBounds;
-(void) setVelocityFactor: (double)MaxVelocity;


-(NSArray *) Posits;
-(NSArray *) BestPosits;

-(void) iterate: (NSNumber *) Score;
-(BOOL) setFitness: (NSNumber *) Score;

-(NSNumber *) Fitness;
-(void) reset;

@end

