//
//  MBMapNode.h
//  TwoTask
//
//  Created by M B. Bitar on 12/19/12.
//  Copyright (c) 2012 progenius, inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBMapUI.h"

@class MBMapNodeLine, MBSpacialChildViewController;
@interface MBMapNode : UIView
@property (nonatomic, weak) MBMapNode *leftNode;
@property (nonatomic, weak) MBMapNode *rightNode;
@property (nonatomic, weak) MBMapNode *upperNode;
@property (nonatomic, weak) MBMapNode *lowerNode;

@property (nonatomic, weak) MBMapNodeLine *leftLine;
@property (nonatomic, weak) MBMapNodeLine *rightLine;
@property (nonatomic, weak) MBMapNodeLine *upperLine;
@property (nonatomic, weak) MBMapNodeLine *lowerLine;

@property (nonatomic, readonly) MBDirection direction;
@property (nonatomic, weak) MBSpacialChildViewController *viewController;

@property (nonatomic, strong) UIColor *currentCircleColor;
@property (nonatomic, strong) UIColor *possibleCircleColor;

@property (nonatomic, assign) BOOL isCurrent;

-(void)setMapNode:(MBMapNode*)node forDirection:(MBDirection)direction;
-(MBMapNode*)mapNodeForDirection:(MBDirection)direction;
+(MBMapNode*)mapNodeWithCircleRadius:(float)radius rectangleSize:(CGSize)size direction:(MBDirection)direction;
@end
