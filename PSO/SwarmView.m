//
//  SwarmView.m
//  PSO
//
//  Created by John Douglas on 7/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SwarmView.h"

@implementation SwarmView
@synthesize PSO, touchPoint;


-(CGRect *)getRectsFromPosits: (NSArray *)Posits
{
    int pointCount = [Posits count] / 2;
    CGRect *rects = malloc(sizeof(CGRect) * pointCount);
    int x, y;
    
    for(int i = 0; i < pointCount; i+=2) {
        x = [[Posits objectAtIndex:i] intValue] - 1;
        y = [[Posits objectAtIndex:i] intValue] - 2;
        rects[i] = CGRectMake(x, y, 2, 2);
    }
    
    return rects;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _notFirstRun = NO;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if(PSO == NULL)
        return;
 
    static double **posits;
    static int dimCount;
    
    // Drawing code
    if(_notFirstRun == NO) {
		context = UIGraphicsGetCurrentContext();
        _notFirstRun = YES;
        dimCount = [[PSO Dimension] intValue];
        posits = malloc(sizeof(double*) * [[PSO Particles] count]);
        for(int i = 0; i < [[PSO Particles] count]; i++) {
            posits[i] = malloc(sizeof(double) * dimCount);
        }

	}

    CGMutablePathRef path;
    
    context = UIGraphicsGetCurrentContext();
	path = CGPathCreateMutable();

    CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);
    CGContextAddEllipseInRect(context, CGRectMake(touchPoint.x - 2, touchPoint.y - 2, 4, 4));
    CGContextStrokePath(context);
    
    path = CGPathCreateMutable();
	
    //CGContextSetStrokeColorWithColor(context, [[UIColor greenColor] CGColor]);
    CGContextSetRGBStrokeColor(context, 0.0, 0.0, 1.0, 1.0);		
    double x, y;
    
    for(int i = 0; i < [[PSO Particles] count]; i++) {
        Particle *p = [[PSO Particles] objectAtIndex:i];
        for(int j = 0; j < dimCount; j+=2) {
            x = [[[p Posits] objectAtIndex:j] doubleValue];
            y = [[[p Posits] objectAtIndex:j+1] doubleValue];
            CGContextAddEllipseInRect(context, CGRectMake(x - 2, y - 2, 4, 4));
        }
    }
    CGContextStrokePath(context);
    
    CGContextSetRGBStrokeColor(context, 0.0, 1.0, 0.0, 1.0);		
    for(int i = 0; i < [[PSO Particles] count]; i++) {
        Particle *p = [[PSO Particles] objectAtIndex:i];
        for(int j = 0; j < dimCount; j+=2) {
            x = [[[p BestPosits] objectAtIndex:j] doubleValue];
            y = [[[p BestPosits] objectAtIndex:j+1] doubleValue];
            CGContextAddEllipseInRect(context, CGRectMake(x - 2, y - 2, 4, 4));
        }
    }
 
    CGContextStrokePath(context);
    
}



- (void)dealloc
{
    [super dealloc];
}

@end
