//
//  FaceView.m
//  HappinessFace
//
//  Created by admin on 11/25/13.
//  Copyright (c) 2013 admin. All rights reserved.
//
#import "FaceView.h"

#define DEFAULT_SCALE 0.90
#define EYE_H 0.35
#define EYE_V 0.35
#define EYE_RADIUS 0.10
#define MOUNTH_H 0.45
#define MOUNTH_V 0.4
#define MOUNT_SMILE 0.25

@implementation FaceView

@synthesize scaleFace = _scaleFace;

- (void)setScaleFace:(CGFloat)scaleFace{
    if(scaleFace != _scaleFace){
        _scaleFace = scaleFace;
        [self setNeedsDisplay];
    }
}

- (CGFloat)scaleFace{
    if (!_scaleFace) {
        return DEFAULT_SCALE;
    }
    return _scaleFace;
}

- (void)pinch:(UIPinchGestureRecognizer *)gesture{
    if((gesture.state == UIGestureRecognizerStateChanged) || (gesture.state == UIGestureRecognizerStateEnded)) {
        self.scaleFace = gesture.scale;
    }
}

- (void)setup{
    self.contentMode = UIViewContentModeRedraw;
}

- (void)awakeFromNib{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)drawCircleAtPoint:(CGPoint)p withRadius:(CGFloat)radius inContext:(CGContextRef)context{
    UIGraphicsPushContext(context);
    CGContextBeginPath(context);
    CGContextAddArc(context, p.x, p.y, radius, 0, 2*M_PI, YES);
    CGContextStrokePath(context);
    UIGraphicsPopContext();
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGPoint midPoint;
    midPoint.x = self.bounds.origin.x + self.bounds.size.width/2;
    midPoint.y = self.bounds.origin.y + self.bounds.size.height/2;
    
    CGFloat size = self.bounds.size.width/2;
    if (self.bounds.size.height < self.bounds.size.width) {
        size = self.bounds.size.height/2;
    }
    size *= self.scaleFace;
    
    CGContextSetLineWidth(context, 5.0);
    [[UIColor blueColor] setStroke];
    
    [self drawCircleAtPoint:midPoint withRadius:size inContext:context];
    
    CGPoint eyePoint;
    eyePoint.x = midPoint.x - size * EYE_H;
    eyePoint.y = midPoint.y - size * EYE_V;
    
    [self drawCircleAtPoint:eyePoint withRadius:size*EYE_RADIUS inContext:context];
    eyePoint.x += size * EYE_H * 2;
    [self drawCircleAtPoint:eyePoint withRadius:size*EYE_RADIUS inContext:context];
    
    CGPoint mounthStart;
    mounthStart.x = midPoint.x - size * MOUNTH_H;
    mounthStart.y = midPoint.y + size * MOUNTH_V;
    
    CGPoint mounthEnd = mounthStart;
    mounthEnd.x += size * MOUNTH_H * 2;
    CGPoint mounthCP1 = mounthStart;
    mounthCP1.x += size * MOUNTH_H * 2/3;
    CGPoint mounthCP2 = mounthEnd;
    mounthCP2.x -= size * MOUNTH_H * 2/3;
    
    float smile = 0.5;
    
    CGFloat smileOffSet = MOUNT_SMILE * size * smile;
    mounthCP1.y += smileOffSet;
    mounthCP2.y += smileOffSet;
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, mounthStart.x, mounthStart.y);
    CGContextAddCurveToPoint(context, mounthCP1.x, mounthCP1.y, mounthCP2.x, mounthCP2.y, mounthEnd.x, mounthEnd.y);
    
    CGContextStrokePath(context);
}

@end
