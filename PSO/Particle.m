//
//  Particle.m
//  PSO
//
//  Created by John Douglas on 7/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Particle.h"

float rnd()
{
    
    float ret = (arc4random() % (LONG_MAX - 1)) / ((float)LONG_MAX);
    return ret;
}

@implementation Particle
@synthesize upperBounds, lowerBounds, globalBest, neighbors;

-(id) initWithDimension: (int)DimCount lowerBounds: (double *)newLowerBounds upperBounds: (double *)newUpperBounds
{
    self = [Particle alloc];
    
    if(self) {
        dimensions = DimCount;
        myPosits = malloc(sizeof(double) * dimensions);
        myVelocities = malloc(sizeof(double) * dimensions);
        myBestPosits = malloc(sizeof(double) * dimensions);
        
        self.lowerBounds = newLowerBounds;
        self.upperBounds = newUpperBounds;
    
        double lb, ub;
        for(int i = 0; i < dimensions; i++) {
            lb = lowerBounds[i];
            ub = upperBounds[i];
            myPosits[i] = lb + rnd() * (ub - lb);

            myVelocities[i] = (1 - 2 *rnd()) * (ub - lb);
            myBestPosits[i] = myPosits[i];

        }
    }
    
    myFitness = DBL_MAX;
    myBestFitness = myFitness;
    
    return self;
}

-(void) setVelocityFactor: (double)MaxVelocity 
{
    velocityFactor = MaxVelocity;
    
    double lb, ub;
    for (int i = 0; i < dimensions; i++) {
        lb = lowerBounds[i];
        ub = upperBounds[i];
        myVelocities[i] = (1 - 2 *rnd()) * velocityFactor * (ub - lb);
    }
}

-(double *) Posits
{
    return myPosits;
}

-(double *)BestPosits
{
    return  myBestPosits;   
}


-(int) Dimension
{
    return dimensions;
}

-(void) iterate: (double) Score
{
    [self setFitness:Score];
    
    double ub, lb;
    for(int i = 0; i < dimensions; i++) {
        ub = upperBounds[i];
        lb = lowerBounds[i];
        
        myVelocities[i] = .5 * (1 + 1.0 * rnd()) * myVelocities[i] + 
            1.4945 * rnd() * ([globalBest BestPosits][i] - myPosits[i]) + 
            1.4945 * rnd() * (myBestPosits[i] - myPosits[i]);
        
        if(fabs(myVelocities[i]) > velocityFactor * (ub - lb)) {
            myVelocities[i]= velocityFactor * (ub - lb) * myVelocities[i] / fabs(myVelocities[i]);
        }
        
        myPosits[i] += myVelocities[i];

        if(myPosits[i] > ub) {
            myPosits[i] = (ub - fabs(ub - myPosits[i]));
            myVelocities[i] *= -1;
        }
        
        if(myPosits[i] < lb) {
            myPosits[i] = lb + (lb - myPosits[i]);
            myVelocities[i] *= -1;
        }
    }
}

-(BOOL) setFitness: (double)Score
{
    myFitness = Score;
    
    if(myFitness < myBestFitness) {
        myBestFitness = myFitness;
        for(int i = 0; i < dimensions; i++) {
            myBestPosits[i] = myPosits[i];
        }
        return YES;
    }
    return NO;
}


-(double)Fitness 
{
    return myFitness;
}

-(void) reset: (BOOL) ResetPosits
{
    myFitness = DBL_MAX;
    myBestFitness = DBL_MAX;
    double lb, ub;
    
    for(int i = 0; i < dimensions; i++) {
        if(ResetPosits) {
            lb = lowerBounds[i];
            ub = upperBounds[i];
            myPosits[i] = lb + rnd() * (ub - lb);
        }
        myBestPosits[i] = myPosits[i];
    }
}

@end
