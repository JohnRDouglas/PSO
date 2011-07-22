//
//  PSOViewController.m
//  PSO
//
//  Created by John Douglas on 7/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PSOViewController.h"

@implementation PSOViewController
@synthesize mySwarmView, myPSO, popSizeSlider, maxVelSlider;


- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    int pointCount = (int)popSizeSlider.value;
    int dimCount = 2;
    double maxVelocity = maxVelSlider.value;
    
    touchPoint = CGPointMake(mySwarmView.frame.size.width / 2, mySwarmView.frame.size.height / 2 );
    mySwarmView.touchPoint = touchPoint;
    
    scores = [[NSMutableArray alloc] initWithCapacity:pointCount];
    for(int i = 0; i < pointCount; i++) {
        [scores addObject:[NSNumber numberWithDouble:DBL_MAX]];
    }
    
    NSMutableArray *lb = [[NSMutableArray alloc] init];
    NSMutableArray *ub = [[NSMutableArray alloc] init];
    for(int i = 0; i < dimCount; i++) {
        [lb addObject:[NSNumber numberWithFloat:0.0]];
        if(i % 2 == 0) {
            [ub addObject:[NSNumber numberWithFloat:mySwarmView.frame.size.width]];
        } else {
            [ub addObject:[NSNumber numberWithFloat:mySwarmView.frame.size.height]];
        }
    }
    
    myPSO = [[PSOContext alloc] initWithPopulation:pointCount dimension:dimCount lowerBounds:lb upperBounds:ub];
    [myPSO setVelocityFactor: maxVelocity];
    //[myPSO setNeighborhoodSize:2];
    
    mySwarmView.PSO = myPSO;
    
    CADisplayLink *frameLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
    
    // Notify the application at the refresh rate of the display (60 Hz)
    frameLink.frameInterval = 1;
    
    [frameLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
}

-(void) update 
{
    
    [self evaluateFitness];
    [myPSO iterate:scores];
    
    [mySwarmView setNeedsDisplay];
    
}

-(void) evaluateFitness
{
    double x, y, dist;
    int dimension = [[myPSO Dimension] intValue];
    
    for(int j = 0; j < [[myPSO Particles] count]; j++) {
        dist = 0;
        Particle *p = [[myPSO Particles] objectAtIndex:j];
        
        for(int i = 0; i < dimension; i+=2) {
            x = [[[p Posits] objectAtIndex:i] doubleValue];
            y = [[[p Posits] objectAtIndex:i+1] doubleValue];
            dist += sqrt(pow(x - touchPoint.x, 2) + pow(y - touchPoint.y, 2));
        }
        
        [scores replaceObjectAtIndex:j withObject:[NSNumber numberWithDouble:dist]];
    }   
}

-(IBAction) resetContext
{
    [myPSO resetParticles:YES];
    
}

-(IBAction) updatePSO
{
    //int dimCount = 2;
    
    if([[myPSO Particles] count] != (int)popSizeSlider.value) {
        if((int)popSizeSlider.value > [[myPSO Particles] count]) {
            for(int i = [[myPSO Particles] count]; i < (int)popSizeSlider.value; i++) {
                [scores addObject:[NSNumber numberWithDouble:DBL_MAX]];
            }
        } else {
            for(int i = [[myPSO Particles]count] - 1; i >= (int)popSizeSlider.value; i--) {
                [scores removeObjectAtIndex:i];
            }
        }
        [myPSO setParticleCount:(int)popSizeSlider.value];
        [myPSO resetParticles:NO];   
    }
    
    if(maxVelSlider.value != [myPSO velocityFactor]) {
        [myPSO setVelocityFactor:maxVelSlider.value];
    }
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *theTouch = [[touches allObjects] objectAtIndex:0];
        touchPoint = [theTouch locationInView:mySwarmView];
        mySwarmView.touchPoint = touchPoint;
        [myPSO resetParticles:NO];
}

@end
