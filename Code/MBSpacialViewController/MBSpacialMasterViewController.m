//
//  MasterViewController.m
//  TwoTask
//
//  Created by M B. Bitar on 12/18/12.
//  Copyright (c) 2012 progenius, inc. All rights reserved.
//

#import "MBSpacialMasterViewController.h"
#import "MBSpacialChildViewController.h"
#import "MBSpacialMap.h"
#import "MBMapNode.h"

@interface MBSpacialMasterViewController ()
@end

@implementation MBSpacialMasterViewController

-(void)setRoot:(MBSpacialChildViewController *)root {
    [self addChildViewController:root];
    _root = root;
    _root.masterController = self;
    if(_map)
        [self.view insertSubview:root.view belowSubview:self.map.view];
    else [self.view addSubview:root.view];
    [root didMoveToParentViewController:self];
    
    [self.map setHasNode:YES inDirection:MBDirectionRoot fromViewController:root];
    [self.map setControllerAsCurrent:root];
    self.map.titleLabel.text = root.title;
    [self.map.titleLabel sizeToFit];
}

-(MBSpacialMap*)map {
    if(_map)
        return _map;
    if(!_hasMap)
        return nil;
    self.map = [[MBSpacialMap alloc] init];
    return _map;
}

-(void)setHasMap:(BOOL)hasMap
{
    if(hasMap && !_hasMap) {
        // add map
        _hasMap = hasMap;
        [self.view addSubview:self.map.view];
        self.map.position = MBMapPositionBottomLeft;
    }
    else if(!hasMap && _hasMap) {
        // remove map
        [self.map.view removeFromSuperview];
        self.map = nil;
        _hasMap = hasMap;
    }
    
}

-(void)loadView {
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    self.view = [[UIView alloc] initWithFrame:window.bounds];
    [self.view setBackgroundColor:[UIColor blackColor]];
}

-(void)goToRootAnimated:(BOOL)animated {
    // TODO
}

-(void)goToViewController:(MBSpacialChildViewController*)controller animated:(BOOL)animated {
    // TODO
}

-(void)didTransitionFromViewController:(MBSpacialChildViewController*)from toViewController:(MBSpacialChildViewController*)to inDirection:(MBDirection)direction transitionType:(MBSpacialTransitionType)type {
    // optionally overriden by subclasses
}

@end
