//
//  LNKCircleBackgroundView.m
//  Link
//
//  Created by David Zilli on 8/21/14.
//  Copyright (c) 2014 Link. All rights reserved.
//

#import "LNKCircleBackgroundView.h"

@interface LNKCircleBackgroundView()

@property (strong, nonatomic) UIColor *circleColor;

@end

@implementation LNKCircleBackgroundView

-(id)initWithCoder:(NSCoder*)coder
{
    self = [super initWithCoder:coder];
    
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:0.941 green:0.945 blue:0.945 alpha:1]; /*#f0f1f1*/
        self.circleColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1]; /*#ffffff*/
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:0.941 green:0.945 blue:0.945 alpha:1]; /*#f0f1f1*/
        self.circleColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1]; /*#ffffff*/
    }
    return self;

}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGRect bounds = self.bounds;
    
    CGPoint center;
    center.x = bounds.origin.x + bounds.size.width / 2.0;
    center.y = bounds.origin.y + bounds.size.height + (bounds.size.height * .2);
    
    float maxRadius = bounds.size.height * 1.5;
    
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    path.lineWidth = 1.0;
    
    [self.circleColor setStroke];
    
    for (float currentRadius = maxRadius; currentRadius > 0; currentRadius -= 4.0) {
        
        [path moveToPoint:CGPointMake(center.x + currentRadius, center.y)];
        
        [path addArcWithCenter:center
                        radius:currentRadius
                    startAngle:0
                      endAngle:M_PI * 2
                     clockwise:YES];
    }
    
    [path stroke];
}

@end
