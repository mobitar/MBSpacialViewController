//
//  MBMapNode.m
//  TwoTask
//
//  Created by M B. Bitar on 12/19/12.
//  Copyright (c) 2012 progenius, inc. All rights reserved.
//

#import "MBMapNode.h"
#import "MBMapUI.h"

@implementation MBMapNode {
    float radius;
    CGSize size;
    BOOL isPossibleNode;
    MBMapNode *possibleLeft, *possibleRight, *possibleDown, *possibleUp;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
        _currentCircleColor = DEFAULT_CIRCLE_COLOR;
        _possibleCircleColor = POSSIBILITY_CIRCLE_COLOR;
    }
    return self;
}

+(MBMapNode*)mapNodeWithCircleRadius:(float)radius rectangleSize:(CGSize)size direction:(MBDirection)direction {
    float height, width;
    if(direction == MBDirectionRoot)
        width = radius, height = radius;
    else if(direction == MBDirectionLeft || direction == MBDirectionRight)
        height = radius, width = radius + size.width;
    else
        height = radius + size.height, width = radius;
    MBMapNode *node = [[MBMapNode alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    node->radius = radius;
    node->size = size;
    node->_direction = direction;
    return node;
}

-(MBMapNode*)mapNodeForDirection:(MBDirection)direction {
    if(direction == MBDirectionRight)
        return self.rightNode;
    if(direction == MBDirectionLeft)
        return self.leftNode;
    if(direction == MBDirectionUp)
        return self.upperNode;

    return self.lowerNode;
}

-(void)setMapNode:(MBMapNode*)node forDirection:(MBDirection)direction
{
    if(direction == MBDirectionRight)
        self.rightNode = node;
    else if(direction == MBDirectionLeft)
        self.leftNode = node;
    else if(direction == MBDirectionUp)
        self.upperNode = node;
    else if(direction == MBDirectionDown)
        self.lowerNode = node;
}

-(void)setIsCurrent:(BOOL)isCurrent {
    if(isCurrent != _isCurrent) {
        _isCurrent = isCurrent;
        [self setNeedsDisplay];
    }
}

-(void)drawRect:(CGRect)rect {
    UIBezierPath *circle = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, radius, radius)];
    _isCurrent ? [_currentCircleColor setFill] : [_possibleCircleColor setFill];
    [circle fill];
}

@end
