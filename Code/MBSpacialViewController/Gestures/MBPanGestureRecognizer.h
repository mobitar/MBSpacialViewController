//
//  MBPanGestureRecognizer.h
//  TwoTask
//
//  Created by M B. Bitar on 12/22/12.
//  Copyright (c) 2012 progenius, inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIGestureRecognizerSubclass.h>
#import "MBMapUI.h"

@protocol MBPanGestureRecognizerDelegate <NSObject>
@optional
-(void)didSetMinNumberOfTouches:(NSUInteger)touches inDirection:(MBDirection)direction;
@end

@interface MBPanGestureRecognizer : UIPanGestureRecognizer <UIGestureRecognizerDelegate>
// must be set in viewDidAppear methods, or else maps would not have had the chance to set up yet
@property (nonatomic, assign) NSUInteger minNumberTouchesLeft;
@property (nonatomic, assign) NSUInteger minNumberTouchesRight;
@property (nonatomic, assign) NSUInteger minNumberTouchesUp;
@property (nonatomic, assign) NSUInteger minNumberTouchesDown;
@property (nonatomic, assign) id<MBPanGestureRecognizerDelegate> customDelegate;

-(void)setRecognizerState:(UIGestureRecognizerState)state;
-(MBDirection)direction;
@end
