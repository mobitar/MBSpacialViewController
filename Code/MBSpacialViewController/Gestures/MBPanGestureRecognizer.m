//
//  MBPanGestureRecognizer.m
//  TwoTask
//
//  Created by M B. Bitar on 12/22/12.
//  Copyright (c) 2012 progenius, inc. All rights reserved.
//

#import "MBPanGestureRecognizer.h"

@implementation MBPanGestureRecognizer
-(id)initWithTarget:(id)target action:(SEL)action {
    if(self = [super initWithTarget:target action:action]) {
        self.delegate = self;
        _minNumberTouchesUp = 1;
        _minNumberTouchesRight = 1;
        _minNumberTouchesLeft = 1;
        _minNumberTouchesDown = 1;
    }
    return self;
}

-(void)setMinNumberTouchesDown:(NSUInteger)minNumberTouchesDown {
    if(_minNumberTouchesDown != minNumberTouchesDown) {
        _minNumberTouchesDown = minNumberTouchesDown;
        [self didChangeMinNumberTouches:minNumberTouchesDown inDirection:MBDirectionDown];
    }
}

-(void)setMinNumberTouchesUp:(NSUInteger)minNumberTouchesUp {
    if(_minNumberTouchesUp != minNumberTouchesUp) {
        _minNumberTouchesUp = minNumberTouchesUp;
        [self didChangeMinNumberTouches:minNumberTouchesUp inDirection:MBDirectionUp];
    }
}

-(void)setMinNumberTouchesLeft:(NSUInteger)minNumberTouchesLeft {
    if(_minNumberTouchesLeft != minNumberTouchesLeft) {
        _minNumberTouchesLeft = minNumberTouchesLeft;
        [self didChangeMinNumberTouches:minNumberTouchesLeft inDirection:MBDirectionLeft];
    }
}

-(void)setMinNumberTouchesRight:(NSUInteger)minNumberTouchesRight {
    if(_minNumberTouchesRight != minNumberTouchesRight) {
        _minNumberTouchesRight = minNumberTouchesRight;
        [self didChangeMinNumberTouches:minNumberTouchesRight inDirection:MBDirectionRight];
    }
}

-(void)didChangeMinNumberTouches:(NSUInteger)touches inDirection:(MBDirection)direction {
    if([_customDelegate respondsToSelector:@selector(didSetMinNumberOfTouches:inDirection:)])
        [_customDelegate didSetMinNumberOfTouches:touches inDirection:direction];
}

-(BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint velocity = [gestureRecognizer velocityInView:self.view];
    BOOL isVertical = fabs(velocity.y) > fabs(velocity.x);
    if(isVertical) {
        if(velocity.y < 0) {
            if(gestureRecognizer.numberOfTouches < _minNumberTouchesDown)
                return NO;
        }
        else {
            if(gestureRecognizer.numberOfTouches < _minNumberTouchesUp)
                return NO;
        }
    }
    else {
        if(velocity.x > 0) {
            if(gestureRecognizer.numberOfTouches < _minNumberTouchesLeft)
                return NO;
        }
        else {
            if(gestureRecognizer.numberOfTouches < _minNumberTouchesRight)
                return NO;
        }
    }

    return YES;
}

-(MBDirection)direction {
    CGPoint velocity = [self velocityInView:self.view.window];
    if(fabs(velocity.y) > fabs(velocity.x)) {
        if(velocity.y > 0) return MBDirectionUp;
        else return MBDirectionDown;
    }
    else {
        if(velocity.x > 0) return MBDirectionLeft;
        else return MBDirectionRight;
    }

}

-(void)setRecognizerState:(UIGestureRecognizerState)state {
    self.state = state;
}

@end
