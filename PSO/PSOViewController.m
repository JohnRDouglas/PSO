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
    
    
    touchPoint = CGPointMake(mySwarmView.frame.size.width / 2, mySwarmView.frame.size.height / 2 );
    mySwarmView.touchPoint = touchPoint;
    
    [self initSwarm];
        
    mySwarmView.PSO = myPSO;
    
    CADisplayLink *frameLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
    
    // Notify the application at the refresh rate of the display (60 Hz)
    frameLink.frameInterval = 1;
    
    [frameLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
}

-(void) initSwarm
{
    int pointCount = (int)popSizeSlider.value;
    int dimCount = 2;
    double maxVelocity = maxVelSlider.value;
    
    scores = malloc(sizeof(double) * pointCount);
    
    for(int i = 0; i < pointCount; i++) {
        scores[i] = DBL_MAX;
    }
    
    double *lb = malloc(sizeof(double) * dimCount);
    double *ub = malloc(sizeof(double) * dimCount);
    
    for(int i = 0; i < dimCount; i++) {
        lb[i] = 0;
        if(i % 2 == 0) {
            ub[i] = mySwarmView.frame.size.width;
        } else {
            ub[i] = mySwarmView.frame.size.height;
        }
    }
    
    myPSO = [[[PSOContext alloc] initWithPopulation:pointCount dimension:dimCount lowerBounds:lb upperBounds:ub] autorelease];
    [myPSO setVelocityFactor: maxVelocity];
    //[myPSO setNeighborhoodSize:2];
    
}


-(void) update 
{
    
    [self evaluateFitness];
    [myPSO iterateSwarm:scores];
    
    [mySwarmView setNeedsDisplay];
    
}


-(void) evaluateFitness
{
    double x, y, dist;
    int dimension = [myPSO Dimension];
    Particle *p;
    
    for(int i = 0; i < [[myPSO Particles] count]; i++) {
        dist = 0;
        p = [[myPSO Particles] objectAtIndex:i];
        
        for(int j = 0; j < dimension; j+=2) {
            x = [p Posits][j];
            y = [p Posits][j+1];
            dist += sqrt(pow(x - touchPoint.x, 2) + pow(y - touchPoint.y, 2));
        }
        
        scores[i] = dist;
    }   
}

-(IBAction) resetContext
{
    [myPSO resetParticles:YES];
    
}


// If any of the parameters need to change, do so
-(IBAction) updatePSO
{
    int newPopCount = (int)popSizeSlider.value;
    
    if([[myPSO Particles] count] != newPopCount) {
        double *newScores = malloc(sizeof(double) * newPopCount);

        for(int i = 0; i < newPopCount; i++) {
            if(i < [[myPSO Particles] count])
                newScores[i] = scores[i];
            else
                newScores[i] = DBL_MAX;
        }

        scores = newScores;
        [myPSO setParticleCount:newPopCount];
        [myPSO resetParticles:NO];   
    }
    
    if(maxVelSlider.value != [myPSO velocityFactor]) {
        [myPSO setVelocityFactor:maxVelSlider.value];
    }
    
}

-(void) resetTimer
{
    startTime = time(0);
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
