//
//  MasterViewController.m
//  SpacialDemo
//
//  Created by Mo Bitar on 2/17/13.
//  Copyright (c) 2013 progenius. All rights reserved.
//

#import "MasterViewController.h"
#import "ChildViewController.h"
#import "UIViewController+Utilities.h"

@interface MasterViewController ()
@property (nonatomic, strong) ChildViewController *child;
@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hasMap = YES;
    self.child = [[ChildViewController alloc] init];
    self.child.title = @"Hello world, we once said cheerfully";
    self.root = self.child; 
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    ChildViewController *left = [[ChildViewController alloc] initWithTitle:@"But now, the deeper you go"];
    self.child.leftViewController = left;
    
    ChildViewController *leftDown = [[ChildViewController alloc] initWithTitle:@"The less you know"];
    left.lowerViewController = leftDown;
    
    ChildViewController *leftDownDown = [[ChildViewController alloc] initWithTitle:@"Lower and lower"];
    leftDown.lowerViewController = leftDownDown;
    
    ChildViewController *leftDownDownDown = [[ChildViewController alloc] initWithTitle:@"Time can't get any slower"];
    leftDownDown.lowerViewController = leftDownDownDown;
    
    ChildViewController *right = [[ChildViewController alloc] initWithTitle:@"Till presently comes a day"];
    leftDownDownDown.rightViewController = right;
    
    ChildViewController *rightRight = [[ChildViewController alloc] initWithTitle:@"That sways you the other way"];
    right.rightViewController = rightRight;
    
    ChildViewController *up = [[ChildViewController alloc] initWithTitle:@"You flow with the river upstream"];
    rightRight.upperViewController = up;
    
    ChildViewController *upUp = [[ChildViewController alloc] initWithTitle:@"And catch sight of a tiny gleam"];
    up.upperViewController = upUp;
    
    ChildViewController *upUpUp = [[ChildViewController alloc] initWithTitle:@"Faster and faster"];
    upUp.upperViewController = upUpUp;
    
    ChildViewController *up4 = [[ChildViewController alloc] initWithTitle:@"Consciousness you try to master"];
    upUpUp.upperViewController = up4;
    
    ChildViewController *up5 = [[ChildViewController alloc] initWithTitle:@"You think you've got it all figured out"];
    up4.upperViewController = up5;
    
    ChildViewController *right3 = [[ChildViewController alloc] initWithTitle:@"Till comes a day that fills you with doubt"];
    up5.rightViewController = right3;
    
    ChildViewController *down = [[ChildViewController alloc] initWithTitle:@"Down again into the pits of emptiness"];
    right3.lowerViewController = down;
    
    ChildViewController *down2 = [[ChildViewController alloc] initWithTitle:@"This is life"];
    down.lowerViewController = down2;
    
    ChildViewController *right4 = [[ChildViewController alloc] initWithTitle:@"Up down left right"];
    down2.rightViewController = right4;
    
    ChildViewController *right5 = [[ChildViewController alloc] initWithTitle:@"And it's all we'll ever know"];
    right4.rightViewController = right5;
}

@end
