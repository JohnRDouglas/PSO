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

-(id) initWithPopulation: (int)PopSize dimension: (int)DimCount lowerBounds: (NSArray *)newLowerBounds upperBounds: (NSArray *)newUpperBounds
{
    self = [super init];

    if(self) {
        myParticles = [[NSMutableArray alloc] initWithCapacity:PopSize];
        myDimension = DimCount;
        self.lowerBounds = newLowerBounds;
        self.upperBounds = newUpperBounds;
    
        for(int i = 0; i < PopSize; i++) {
            Particle *p = [[[Particle alloc] initWithDimension: DimCount 
                                                  lowerBounds:newLowerBounds upperBounds:newUpperBounds] autorelease];
            [myParticles addObject:p];
        }
        
        myGlobalBest = [myParticles objectAtIndex:0];
    }
    return self;
}

-(void) setVelocityFactor: (double)MaxVelocity
{
    for(int i = 0; i < [myParticles count]; i++) {
        [[myParticles objectAtIndex:i] setVelocityFactor:MaxVelocity];
    }
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

-(NSArray *) Particles 
{

    return myParticles;
}

-(NSNumber *)Dimension
{
    return [NSNumber numberWithInt: myDimension];
}

-(void) iterate: (NSArray *)Scores
{
    int popSize = [myParticles count];
    
    if([Scores count] != popSize)
        return;
    
    // Have scores, determine if new globalBest has emerged and set it
    Particle *p;
    for(int i = 0; i < popSize; i++) {
        p = [myParticles objectAtIndex:i];
        double s = [[Scores objectAtIndex:i] doubleValue];
        if(s < myGlobalBestFitness) {
            myGlobalBestFitness = s;
            myGlobalBest = p;
        }
    }
    
    
    for(int i = 0; i < popSize; i++) {
        p = [myParticles objectAtIndex:i];
        p.globalBest = myGlobalBest;
        
        [p iterate: [Scores objectAtIndex:i]];
    }
}


-(Particle *) globalBest
{
    return myGlobalBest;
}

-(void)resetParticles
{
    for(int i = 0; i < [myParticles count]; i++) {
        [[myParticles objectAtIndex:i] reset];
    }
}

@end
