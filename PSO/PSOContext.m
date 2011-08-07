//
//  PSOContext.m
//  PSO
//
//  Created by John Douglas on 7/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PSOContext.h"


@implementation PSOContext
@synthesize upperBounds, lowerBounds;

-(id) initWithPopulation: (int)PopSize dimension: (int)DimCount lowerBounds: (double *)newLowerBounds upperBounds: (double *)newUpperBounds
{
    self = [super init];

    if(self) {
        myParticles = [[NSMutableArray alloc] initWithCapacity:PopSize] ;
        myDimension = DimCount;
        self.lowerBounds = newLowerBounds;
        self.upperBounds = newUpperBounds;
    
        for(int i = 0; i < PopSize; i++) {
            Particle *p = [[Particle alloc] initWithDimension: DimCount 
                                                  lowerBounds:newLowerBounds upperBounds:newUpperBounds];
            [myParticles addObject:p];
        }
        
        myGlobalBest = [myParticles objectAtIndex:arc4random() % [myParticles count]];
    }
    return self;
}

-(void) setVelocityFactor: (double)MaxVelocity
{
    for(int i = 0; i < [myParticles count]; i++) {
        [[myParticles objectAtIndex:i] setVelocityFactor:MaxVelocity];
    }
}
 
-(double) velocityFactor
{
    return velocityFactor;
}

-(void) setNeighborhoodSize:(int)NeighborCount
{
    if (NeighborCount >= [myParticles count] / 2)
        return;

    for(int i = 0; i < [myParticles count]; i++) {
        NSMutableArray *n = [[NSMutableArray alloc] initWithCapacity:NeighborCount * 2];
        int startIdx = i - NeighborCount;
        int endIdx = i + NeighborCount;
        if(startIdx < 0)
            startIdx += [myParticles count];
        if(endIdx > [myParticles count] - 1)
            endIdx -= ([myParticles count]);

        int idx = startIdx;
        while([n count] < NeighborCount * 2) {
            if(idx != i) {
                [n addObject:[myParticles objectAtIndex:idx]];
                
            }
            idx++;
            if(idx > [myParticles count] - 1)
                idx -= ([myParticles count]);
        }
        
        [[myParticles objectAtIndex:i] setNeighbors:n];
    }
}

// If a new particle count is in order, remove extraneous ones or add new, randomized ones
-(void) setParticleCount: (int) popSize
{
    if(popSize == [myParticles count])
        return;
    

    if(popSize > [myParticles count]) {
        int dimCount = myDimension;
        for(int i = [myParticles count]; i < popSize; i++) {
            Particle *p = [[[Particle alloc] initWithDimension: dimCount 
                                                   lowerBounds:lowerBounds upperBounds:upperBounds] autorelease];
            [myParticles addObject:p];
        }
    } else {
        for(int i = [myParticles count] - 1; i >= popSize; i--) {
            [myParticles removeObjectAtIndex:i];
        }
    }
        
    
}

-(NSArray *) Particles 
{
    return myParticles;
}

-(int)Dimension
{
    return myDimension;
}

-(void) iterateSwarm: (double *)Scores
{
    
    // Have scores, determine if new globalBest has emerged and set it
    for(int i = 0; i < [myParticles count]; i++) {
        if(Scores[i] < [myGlobalBest Fitness]) {
            myGlobalBest = [myParticles objectAtIndex:i];
        }
    }
    
    // Neighborhood will need to be taken into consideration here
    for(int i = 0; i < [myParticles count]; i++) {
        [[myParticles objectAtIndex:i] setGlobalBest: myGlobalBest];
        [[myParticles objectAtIndex:i] iterate: Scores[i]];
    }
}


-(Particle *) globalBest
{
    return myGlobalBest;
}

-(void)resetParticles: (BOOL)ResetPosits
{
    myGlobalBest = [myParticles objectAtIndex:arc4random() % [myParticles count]];
    for(int i = 0; i < [myParticles count]; i++) {
        [[myParticles objectAtIndex:i] reset: ResetPosits];
        [[myParticles objectAtIndex:i] setGlobalBest:myGlobalBest];
    }
}

@end
