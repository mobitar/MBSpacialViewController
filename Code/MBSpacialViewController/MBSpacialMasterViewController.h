//
//  MasterViewController.h
//  TwoTask
//
//  Created by M B. Bitar on 12/18/12.
//  Copyright (c) 2012 progenius, inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBMapUI.h"

typedef enum {
    MBSpacialTransitionTypePan,
    MBSpacialTransitionTypeProgrammatic
}MBSpacialTransitionType;

@class MBQueue, MBSpacialChildViewController, MBSpacialMap;
@interface MBSpacialMasterViewController : UIViewController

@property (nonatomic, assign) BOOL hasMap;
@property (nonatomic, strong) MBSpacialMap *map;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, weak) MBSpacialChildViewController *root;
//-(void)goToRootAnimated:(BOOL)animated;
//-(void)goToViewController:(MBSpacialChildViewController*)controller animated:(BOOL)animated;
-(void)didTransitionFromViewController:(MBSpacialChildViewController*)from toViewController:(MBSpacialChildViewController*)to inDirection:(MBDirection)direction transitionType:(MBSpacialTransitionType)type;
@end
