//
//  MBSpacialMap.m
//  TwoTask
//
//  Created by M B. Bitar on 12/19/12.
//  Copyright (c) 2012 progenius, inc. All rights reserved.
//

#import "MBSpacialMap.h"
#import "MBMapNode.h"
#import "MBMapUI.h"
#import "MBSpacialChildViewController.h"
#import "MBMapNodeLine.h"

@interface MBSpacialMap ()
@property (nonatomic, strong) NSMutableArray *nodes;
@property (nonatomic, strong) NSMutableArray *shifts;
@property (nonatomic, strong) NSMutableArray *expansions;
@end

@implementation MBSpacialMap {
    MBMapNode *_currentNode;
}
@synthesize titleLabel = _titleLabel;

-(void)loadView {
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CIRCLE_RADIUS, CIRCLE_RADIUS)];
    self.view.userInteractionEnabled = NO;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view addSubview:_titleLabel];
    if(_position == MBMapPositionBottomLeft)
        [self shiftSubviewsBy:CGSizeMake(0, -20)];
}

#pragma mark --
#pragma mark Getters

-(NSMutableArray*)nodes {
    if(_nodes)
        return _nodes;
    _nodes = [NSMutableArray new];
    return _nodes;
}

-(NSMutableArray*)shifts {
    if(!_shifts)
        _shifts = [NSMutableArray new];
    return _shifts;
}

-(NSMutableArray*)expansions {
    if(!_expansions)
        _expansions = [NSMutableArray new];
    return _expansions;
}

-(UILabel*)titleLabel {
    if(_titleLabel)
        return _titleLabel;
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(MAP_MARGIN_X, 0, MAP_LABEL_MAX_WIDTH, 50)];
    _titleLabel.textColor = MAP_LABEL_TEXT_COLOR;
    _titleLabel.font = MAP_LABEL_FONT;
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.text = @"Home";
    [_titleLabel sizeToFit];

    return _titleLabel;
}

#pragma mark --
#pragma mark Setters

-(void)setPosition:(MBMapPosition)position {
    if(position != _position) {
        _position = position;
        [self positionMap];
    }
}

-(NSArray*)stepsFromViewController:(MBSpacialChildViewController*)from toViewController:(MBSpacialChildViewController*)to {
    assert(to && from);
    NSMutableArray *steps = [NSMutableArray new];
    NSMutableSet *exploredControllers = [NSMutableSet new];
    [self traverseMapFromViewController:from toViewController:to steps:&steps explored:&exploredControllers];
    return steps;
}

-(void)traverseMapFromViewController:(MBSpacialChildViewController*)from toViewController:(MBSpacialChildViewController*)to steps:(NSMutableArray **)steps explored:(NSMutableSet**)explored {
    if([from isEqual:to])
        return;
    
    [*explored addObject:from];
    
    // we'll do a depth-first search in the following order: up, left, down, right
    if(from.upperViewController && [*explored containsObject:from.upperViewController] == NO) {
        [*steps addObject:@(MBDirectionUp)];
        [self traverseMapFromViewController:from.upperViewController toViewController:to steps:steps explored:explored];
    }
    else if(from.leftViewController && [*explored containsObject:from.leftViewController] == NO) {
        [*steps addObject:@(MBDirectionLeft)];
        [self traverseMapFromViewController:from.leftViewController toViewController:to steps:steps explored:explored];
    }
    else if(from.lowerViewController && [*explored containsObject:from.lowerViewController] == NO) {
        [*steps addObject:@(MBDirectionDown)];
        [self traverseMapFromViewController:from.lowerViewController toViewController:to steps:steps explored:explored];
    }
    else if(from.rightViewController && [*explored containsObject:from.rightViewController] == NO) {
        [*steps addObject:@(MBDirectionRight)];
        [self traverseMapFromViewController:from.rightViewController toViewController:to steps:steps explored:explored];
    }
    else {
        MBDirection direction = [(*steps).lastObject intValue];
        [*steps removeLastObject];
        if(direction == MBDirectionUp)
            [self traverseMapFromViewController:from.lowerViewController toViewController:to steps:steps explored:explored];
        else if(direction == MBDirectionDown)
            [self traverseMapFromViewController:from.upperViewController toViewController:to steps:steps explored:explored];
        else if(direction == MBDirectionRight)
            [self traverseMapFromViewController:from.leftViewController toViewController:to steps:steps explored:explored];
        else if(direction == MBDirectionLeft)
            [self traverseMapFromViewController:from.rightViewController toViewController:to steps:steps explored:explored];
    }
}

-(void)setControllerAsCurrent:(MBSpacialChildViewController*)controller {
    _currentNode.isCurrent = NO;
    _currentNode = [self nodeForViewController:controller];
    _currentNode.isCurrent = YES;
    _titleLabel.text = controller.title;
    [_titleLabel sizeToFit];
}

-(MBMapNode*)nodeForViewController:(MBSpacialChildViewController*)controller {
    for(MBMapNode *node in self.nodes) {
        if([node.viewController isEqual:controller])
            return node;
    }
    
    return nil;
}

-(void)setHasNode:(BOOL)hasNode inDirection:(MBDirection)direction fromViewController:(MBSpacialChildViewController*)from {
    // get node for from
    MBMapNode *fromNode = [self nodeForViewController:from];
    if(direction != MBDirectionRoot)
        assert(fromNode);
    
    if(hasNode) {
        // create new node
        MBMapNode *newNode = [MBMapNode mapNodeWithCircleRadius:CIRCLE_RADIUS rectangleSize:CGSizeZero direction:MBDirectionRoot];
        [self.nodes addObject:newNode];
        [fromNode setMapNode:newNode forDirection:direction];
        [newNode setMapNode:fromNode forDirection:[MBSpacialMap oppositeForDirection:direction]];
        [self.view addSubview:newNode];
        [self drawPathFromNode:fromNode toNode:newNode inDirection:direction];
        
        if(direction == MBDirectionRoot)
            newNode.viewController = from;
    }
    else {
        MBMapNode *toNode = [fromNode mapNodeForDirection:direction];
        assert(toNode);
        [self removeNodeFromView:toNode];
        [fromNode setMapNode:nil forDirection:direction];
        [self.nodes removeObject:toNode];
        
        CGSize popSize = [[self.expansions lastObject] CGSizeValue];
        [self.expansions removeLastObject];
        CGSize oppositeSize = CGSizeMake(-popSize.width, -popSize.height);
        [self expandMapBySize:oppositeSize];
        
        MBDirection popShiftDirection = [[self.shifts lastObject] intValue];
        [self.shifts removeLastObject];
        [self shiftSubviewsInDirection:[MBSpacialMap oppositeForDirection:popShiftDirection]];
    }
}

-(void)setViewController:(MBSpacialChildViewController*)controller fromViewController:(MBSpacialChildViewController*)from inDirection:(MBDirection)direction {
    // this method should only be called when setting a non-nil controller. it is not neccessary to clear a view controller manually. setHasNode will take care of that
    assert(controller);
    
    MBMapNode *fromNode = [self nodeForViewController:from];
    assert(fromNode);
    MBMapNode *toNode = [fromNode mapNodeForDirection:direction];
    assert(toNode);
    toNode.viewController = controller;
}

-(void)removeNodeFromView:(MBMapNode*)node {
    [UIView animateWithDuration:0.25 animations:^{
        node.alpha = 0.0;
        node.leftLine.alpha = 0.0;
        node.rightLine.alpha = 0.0;
        node.upperLine.alpha = 0.0;
        node.lowerLine.alpha = 0.0;
    } completion:^(BOOL finished) {
        if(finished) {
            [node removeFromSuperview];
            [node.leftLine removeFromSuperview];
            [node.rightLine removeFromSuperview];
            [node.upperLine removeFromSuperview];
            [node.lowerLine removeFromSuperview];            
        }
    }];
}

-(void)drawPathFromNode:(MBMapNode*)fromNode toNode:(MBMapNode*)toNode inDirection:(MBDirection)direction {
    if(direction == MBDirectionRoot)
        return;
    
    CGSize expandSize = CGSizeZero;
    
    CGRect frame = toNode.frame;
    MBDirection shiftDirection = MBDirectionNone;
    
    if(direction == MBDirectionLeft) {
        frame.origin = CGPointMake(fromNode.frame.origin.x - LINE_LENGTH - CIRCLE_RADIUS, fromNode.frame.origin.y);
        if(frame.origin.x < 0)
        {
            expandSize = CGSizeMake(CIRCLE_RADIUS + LINE_LENGTH, 0);
            shiftDirection = MBDirectionRight;
        }
    }
    else if(direction == MBDirectionRight) {
        frame.origin = CGPointMake(fromNode.frame.origin.x + LINE_LENGTH + CIRCLE_RADIUS, fromNode.frame.origin.y);
    }
    else if(direction == MBDirectionUp) {
        frame.origin = CGPointMake(fromNode.frame.origin.x, fromNode.frame.origin.y - LINE_LENGTH - CIRCLE_RADIUS);
        if(frame.origin.y < 0) {
            expandSize = CGSizeMake(0, CIRCLE_RADIUS + LINE_LENGTH);
            shiftDirection = MBDirectionDown;
        }
    }
    else if(direction == MBDirectionDown) {
        frame.origin = CGPointMake(fromNode.frame.origin.x, fromNode.frame.origin.y + LINE_LENGTH + CIRCLE_RADIUS);
        if(frame.origin.y + frame.size.height > self.view.frame.size.height) {
            expandSize = CGSizeMake(0, CIRCLE_RADIUS + LINE_LENGTH);
        }
    }
    
    [self expandMapBySize:expandSize];
    
    toNode.frame = frame;
    [self drawLineFromNode:fromNode toAdjacentNode:toNode inDirection:direction];
    if(shiftDirection != MBDirectionNone) {
        [self shiftSubviewsInDirection:shiftDirection];
    }
    else {
        [self positionMap];
    }
    
    [self.shifts addObject:@(shiftDirection)];
    [self.expansions addObject:[NSValue valueWithCGSize:expandSize]];
}

-(void)drawLineFromNode:(MBMapNode*)fromNode toAdjacentNode:(MBMapNode*)toNode inDirection:(MBDirection)direction
{
    MBMapNodeLine *line = [[MBMapNodeLine alloc] init];
    if(direction == MBDirectionLeft) {
        line.frame = CGRectMake(toNode.frame.origin.x + toNode.frame.size.width , fromNode.frame.origin.y + fromNode.frame.size.height/2.0 - LINE_THICKNESS/2.0, LINE_LENGTH, LINE_THICKNESS);
        toNode.rightLine = line;
        fromNode.leftLine = line;
    }
    else if(direction == MBDirectionUp) {
        line.frame = CGRectMake(fromNode.frame.origin.x + fromNode.frame.size.width/2.0 - LINE_THICKNESS/2.0, fromNode.frame.origin.y - LINE_LENGTH, LINE_THICKNESS, LINE_LENGTH);
        toNode.lowerLine = line;
        fromNode.upperLine = line;
    }
    else if(direction == MBDirectionRight) {
        line.frame = CGRectMake(fromNode.frame.origin.x + fromNode.frame.size.width, fromNode.frame.origin.y + fromNode.frame.size.height/2.0 - LINE_THICKNESS/2.0, LINE_LENGTH, LINE_THICKNESS);
        toNode.leftLine = line;
        fromNode.rightLine = line;
    }
    else if(direction == MBDirectionDown) {
        line.frame = CGRectMake(fromNode.frame.origin.x + fromNode.frame.size.width/2.0 - LINE_THICKNESS/2.0, fromNode.frame.origin.y + fromNode.frame.size.height, LINE_THICKNESS, LINE_LENGTH);
        toNode.upperLine = line;
        fromNode.lowerLine = line;
    }

    [self.view addSubview:line];
}

-(void)setMinNumberOfTouches:(NSUInteger)touches forViewController:(MBSpacialChildViewController*)controller inDirection:(MBDirection)direction {
    if(touches <= 0)
        return;
    
    MBMapNode *node = [self nodeForViewController:controller];
    if(direction == MBDirectionLeft) {
        node.leftLine.isDoubleTouch = touches > 1 ? YES : NO;
    }
    else if(direction == MBDirectionUp) {
        node.upperLine.isDoubleTouch = touches > 1 ? YES : NO;
    }
    else if(direction == MBDirectionRight) {
        node.rightLine.isDoubleTouch = touches > 1 ? YES : NO;
    }
    else if(direction == MBDirectionDown) {
        node.lowerLine.isDoubleTouch = touches > 1 ? YES : NO;
    }
}

-(void)shiftSubviewsInDirection:(MBDirection)direction {
    if(direction == MBDirectionNone || direction == MBDirectionRoot)
        return;
    
    CGFloat offset = LINE_LENGTH + CIRCLE_RADIUS;
    CGSize shift = CGSizeZero;
    
    if(direction == MBDirectionRight) {
        shift.width = offset;
    }
    else if(direction == MBDirectionLeft) {
        shift.width = -offset;
    }
    else if(direction == MBDirectionUp) {
        shift.height = -offset;
    }
    else if(direction == MBDirectionDown) {
        shift.height = offset;
    }
    [self shiftSubviewsBy:shift];
}

-(void)shiftSubviewsBy:(CGSize)size {
    for(UIView *view in self.view.subviews) {
        CGRect frame = view.frame;
        frame.origin = CGPointMake(frame.origin.x + size.width, frame.origin.y + size.height);
        view.frame = frame;
    }
    [self positionMap];
}

-(void)expandMapBySize:(CGSize)size {
    CGRect frame = self.view.frame;
    frame.size = CGSizeMake(frame.size.width + size.width, frame.size.height + size.height);
    self.view.frame = frame;
}

-(void)positionMap {
    CGRect frame = self.view.frame;
    if(_position == MBMapPositionBottomLeft) {
        frame.origin = CGPointMake(MAP_MARGIN_X, self.view.superview.bounds.size.height - frame.size.height - MAP_MARGIN_Y_BOTTOM);
    }
    else if(_position == MBMapPositionTopLeft) {
        frame.origin = CGPointMake(MAP_MARGIN_X, MAP_MARGIN_Y_TOP);
    }
    self.view.frame = frame;
    
    CGRect labelRect = _titleLabel.frame;
    labelRect.origin = CGPointMake(0, frame.size.height - labelRect.size.height );
    _titleLabel.frame = labelRect;
}

+(MBDirection)oppositeForDirection:(MBDirection)direction {
    if(direction == MBDirectionDown)
        return MBDirectionUp;
    else if(direction == MBDirectionUp)
        return MBDirectionDown;
    else if(direction == MBDirectionLeft)
        return MBDirectionRight;
    else if(direction == MBDirectionRight)
        return MBDirectionLeft;
    
    return MBDirectionNone;
}

@end
