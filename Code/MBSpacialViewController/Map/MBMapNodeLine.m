//
//  MBMapNodeLine.m
//  TwoTask
//
//  Created by M B. Bitar on 12/19/12.
//  Copyright (c) 2012 progenius, inc. All rights reserved.
//

#import "MBMapNodeLine.h"
#import "MBMapUI.h"
#import <QuartzCore/QuartzCore.h>

@implementation MBMapNodeLine

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _lineColor = POSSIBILITY_SHAFT_COLOR;
        self.opaque = NO;
    }
    return self;
}

-(id)init {
    if(self = [super init]) {
        _lineColor = POSSIBILITY_SHAFT_COLOR;
    }
    return self;
}

-(void)setIsDoubleTouch:(BOOL)isDoubleTouch {
    if(_isDoubleTouch == isDoubleTouch)
        return;
    
    _isDoubleTouch = isDoubleTouch;
    CGRect frame = self.frame;
    BOOL isVertical = frame.size.height > frame.size.width;
    if(_isDoubleTouch) {
        if(isVertical) {
            frame.size.width = LINE_THICKNESS * 2;
            frame.origin.x -= LINE_THICKNESS / 2.0;
            frame.size.height += 1;
            frame.origin.y -= 0.5;
        }
        else {
            frame.size.height = LINE_THICKNESS * 2;
            frame.origin.y -= LINE_THICKNESS / 2.0;
            frame.size.width += 1;
            frame.origin.x -= 0.5;
        }
    }
    else {
        if(isVertical) {
            frame.size.width = LINE_THICKNESS;
            frame.origin.x += LINE_THICKNESS / 2.0;
        }
        else {
            frame.size.height = LINE_THICKNESS;
        }
    }
    self.frame = frame;
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect {
    [_lineColor setFill];
    if(_isDoubleTouch) {
        // break line into two
        CGFloat spaceBetweenLines = 1.0;
        UIBezierPath *first, *second;
        if(rect.size.height > rect.size.width) {
            // vertical line
            CGRect firstRect = CGRectMake(0, 0, rect.size.width/2.0 - spaceBetweenLines/2.0, rect.size.height);
            first = [UIBezierPath bezierPathWithRect:firstRect];
            second = [UIBezierPath bezierPathWithRect:CGRectMake(firstRect.origin.x + firstRect.size.width + spaceBetweenLines, 0, rect.size.width/2.0 - spaceBetweenLines/2.0, rect.size.height)];
        }
        else {
            // horizontal line
            CGRect firstRect = CGRectMake(0, 0, rect.size.width, rect.size.height/2.0 - spaceBetweenLines/2.0);
            first = [UIBezierPath bezierPathWithRect:firstRect];
            second = [UIBezierPath bezierPathWithRect:CGRectMake(0, firstRect.origin.y + firstRect.size.height + spaceBetweenLines, rect.size.width, rect.size.height/2.0 - spaceBetweenLines/2.0)];
        }
        [first fill];
        [second fill];
    }
    else {
        UIBezierPath *line = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, rect.size.width, rect.size.height)];
        [line fill];
    }
}

@end
