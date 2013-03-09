//
//  MBSpacialMap.h
//  TwoTask
//
//  Created by M B. Bitar on 12/19/12.
//  Copyright (c) 2012 progenius, inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBMapUI.h"

@class MBSpacialChildViewController;
@interface MBSpacialMap : UIViewController
@property (nonatomic, assign) MBMapPosition position;
@property (nonatomic, strong, readonly) UILabel *titleLabel;

-(void)setHasNode:(BOOL)hasNode inDirection:(MBDirection)direction fromViewController:(MBSpacialChildViewController*)from;
-(void)setViewController:(MBSpacialChildViewController*)controller fromViewController:(MBSpacialChildViewController*)from inDirection:(MBDirection)direction;

-(void)setControllerAsCurrent:(MBSpacialChildViewController*)controller;
-(NSArray*)stepsFromViewController:(MBSpacialChildViewController*)from toViewController:(MBSpacialChildViewController*)to;
// draws single or double stroked line depending on touches
-(void)setMinNumberOfTouches:(NSUInteger)touches forViewController:(MBSpacialChildViewController*)controller inDirection:(MBDirection)direction;

// class method
+(MBDirection)oppositeForDirection:(MBDirection)direction;
@end
