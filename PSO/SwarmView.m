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
 
    static int dimCount;
    
    // Drawing code
    if(_notFirstRun == NO) {
        _notFirstRun = YES;
        context = UIGraphicsGetCurrentContext();
    
        dimCount = [PSO Dimension];
    }

    
    //CGMutablePathRef path;
    double x, y;   
    
    

    // Draw current posit circles in light blue
    //path = CGPathCreateMutable();
    CGContextSetRGBStrokeColor(context, 0.0, 0.5, 1.0, 1.0);		
    for(int i = 0; i < [[PSO Particles] count]; i++) {
        Particle *p = [[PSO Particles] objectAtIndex:i];
        x = [p Posits][0];
        y = [p Posits][1];
        CGContextAddEllipseInRect(context, CGRectMake(x - 2, y - 2, 4, 4));
    }
    CGContextStrokePath(context);
    
    // Draw pBest posits in green
    //path = CGPathCreateMutable();
    double xb, yb;
    CGContextSetRGBStrokeColor(context, 0.0, 1.0, 0.0, 1.0);		
    for(int i = 0; i < [[PSO Particles] count]; i++) {
        Particle *p = [[PSO Particles] objectAtIndex:i];
        xb = [p BestPosits][0];
        yb = [p BestPosits][1];
        CGContextAddEllipseInRect(context, CGRectMake(xb - 2, yb - 2, 4, 4));
    }
    CGContextStrokePath(context);
    
    
    // Draw touchPoint circle in Red
    //path = CGPathCreateMutable();
    CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);
    CGContextAddEllipseInRect(context, CGRectMake(touchPoint.x - 2, touchPoint.y - 2, 4, 4));
    CGContextStrokePath(context);

}



- (void)dealloc
{
    [super dealloc];
}

@end
