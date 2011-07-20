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
    float ret = (arc4random() % 10000) / 10000.0f;
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

            myVelocities[i] = rnd()  * (ub - lb);
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


-(void) iterate: (NSNumber *) Score
{
    [self setFitness:Score];
    
    double ub, lb;
    for(int i = 0; i < dimensions; i++) {
        myVelocities[i] = .5 + (1.5 * rnd()) * myVelocities[i] + 
        1.49 * rnd() * (myBestPosits[i] - myPosits[i]) + 
        1.49 * rnd() * ([[[globalBest BestPosits] objectAtIndex:i] doubleValue] - myPosits[i]);
        myPosits[i] += myVelocities[i];

        ub = [[upperBounds objectAtIndex:i] doubleValue];
        lb = [[lowerBounds objectAtIndex:i] doubleValue];
                
        if(myPosits[i] > ub) {
            myPosits[i] = ub;
            myVelocities[i] *= -1;
        }
        
        if(myPosits[i] < lb) {
            myPosits[i] = lb;
            myVelocities[i] *= -1;
        }
        
        if(fabs(myVelocities[i]) > velocityFactor * (ub - lb)) {
            myVelocities[i] = velocityFactor * (ub - lb);
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

-(void) reset
{
    myFitness = DBL_MAX;
    myBestFitness = DBL_MAX;
    for(int i = 0; i < dimensions; i++) {
        myBestPosits[i] = myPosits[i];
    }
}

@end
