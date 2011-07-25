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
@synthesize upperBounds, lowerBounds, globalBest;

-(id) initWithDimension: (int)DimCount lowerBounds: (NSArray *)newLowerBounds upperBounds: (NSArray *)newUpperBounds
{
    self = [Particle alloc];
    
    if(self) {
        dimensions = DimCount;
        myPosits = malloc(sizeof(double) * dimensions);
        myVelocities = malloc(sizeof(double) * dimensions);
        myBestPosits = malloc(sizeof(double) * dimensions);
        
        self.lowerBounds = newLowerBounds;
        self.upperBounds = newUpperBounds;
    
        // If min value >= 0.0 && max value <= 1.0,
        double lb, ub;
        for(int i = 0; i < dimensions; i++) {
            lb = [[lowerBounds objectAtIndex:i] doubleValue];
            ub = [[upperBounds objectAtIndex:i] doubleValue];
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
        lb = [[lowerBounds objectAtIndex:i] doubleValue];
        ub = [[upperBounds objectAtIndex:i] doubleValue];

        myVelocities[i] = (1 - 2 *rnd()) * velocityFactor * (ub - lb);
    }
}


-(NSArray *) Posits
{
    // Wrap double* into NSArray of NSNumbers
    NSMutableArray *p = [[NSMutableArray alloc] initWithCapacity:dimensions];
    for(int i = 0; i < dimensions; i++) {
        [p addObject:[NSNumber numberWithFloat:myPosits[i]]];
    }
    
    return p;
    
}

-(NSArray *) BestPosits
{
    // Wrap double* into NSArray of NSNumbers
    NSMutableArray *bp = [[NSMutableArray alloc] initWithCapacity:dimensions];
    for(int i = 0; i < dimensions; i++) {
        [bp addObject:[NSNumber numberWithFloat:myBestPosits[i]]];
    }
    
    return bp;
}

-(NSInteger) Dimension
{
    return dimensions;
}

-(void) iterate: (NSNumber *) Score
{
    [self setFitness:Score];
    
    double ub, lb;
    for(int i = 0; i < dimensions; i++) {
        ub = [[upperBounds objectAtIndex:i] doubleValue];
        lb = [[lowerBounds objectAtIndex:i] doubleValue];

        myVelocities[i] = .5 * (1 + 1.0 * rnd()) * myVelocities[i] + 
        1.4945 * rnd() * (myBestPosits[i] - myPosits[i]) + 
        1.4945 * rnd() * ([[[globalBest BestPosits] objectAtIndex:i] doubleValue] - myPosits[i]);
        
        if(fabs(myVelocities[i]) > velocityFactor * (ub - lb)) {
            //myVelocities[i] = (1 - rnd() * 2) * velocityFactor * (ub - lb);
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

-(BOOL) setFitness: (NSNumber *)Score
{
    myFitness = [Score doubleValue];
    if(myFitness < myBestFitness) {
        myBestFitness = myFitness;
        for(int i = 0; i < dimensions; i++) {
            myBestPosits[i] = myPosits[i];
        }
        return YES;
    }
    return NO;
}


-(NSNumber *)Fitness 
{
    return [NSNumber numberWithDouble:myFitness];
}

-(void) reset: (BOOL) ResetPosits
{
    myFitness = DBL_MAX;
    myBestFitness = DBL_MAX;
    for(int i = 0; i < dimensions; i++) {
        if(ResetPosits) {
            double lb, ub;
            lb = [[lowerBounds objectAtIndex:i] doubleValue];
            ub = [[upperBounds objectAtIndex:i] doubleValue];
            myPosits[i] = lb + rnd() * (ub - lb);
        }
        myBestPosits[i] = myPosits[i];
    }
}

@end
