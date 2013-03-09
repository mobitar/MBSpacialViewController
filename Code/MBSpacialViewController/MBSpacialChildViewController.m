//
//  MBSpacialChildViewController.m
//  TwoTask
//
//  Created by M B. Bitar on 12/18/12.
//  Copyright (c) 2012 progenius, inc. All rights reserved.
//

#import "MBSpacialChildViewController.h"
#import "MBSpacialMasterViewController.h"
#import "MBSpacialMap.h"
#import "MBMapNode.h"
#import <QuartzCore/QuartzCore.h>

@interface MBSpacialChildViewController ()
@property (nonatomic, weak) UIScrollView *scrollView;
// for map
@property (nonatomic, assign) BOOL hasLeftViewController;
@property (nonatomic, assign) BOOL hasRightViewController;
@property (nonatomic, assign) BOOL hasLowerViewController;
@property (nonatomic, assign) BOOL hasUpperViewController;

@end

@implementation MBSpacialChildViewController
{
    BOOL didTransitionViaPan;
}
@synthesize panGesture = _panGesture;

-(id)init
{
    if(self = [super init]) {
        _snappingThreshold = 50;
    }
    return self;
}

-(void)loadView
{
    assert(self.masterController.view);
    self.view = [[UIView alloc] initWithFrame:self.masterController.view.bounds];
}

-(void)spacialViewDidLoad
{
    // optionally overriden by subclasses
}

-(void)spacialViewWillAppear
{
    // optionally overriden by subclasses
}

-(void)spacialViewDidAppear
{
    // optionally overriden by subclasses
    if(self.leftViewController && self.leftViewController.isModal && [self.leftViewController.modalPresentingViewController isEqual:self])
    {
        [self unregisterAdjacentViewController:self.leftViewController inDirection:MBDirectionLeft];
        self.leftViewController = nil;
    }
    else if(self.rightViewController && self.rightViewController.isModal && [self.rightViewController.modalPresentingViewController isEqual:self])
    {
        [self unregisterAdjacentViewController:self.rightViewController inDirection:MBDirectionRight];
        self.rightViewController = nil;
    }
    else if(self.upperViewController && self.upperViewController.isModal && [self.upperViewController.modalPresentingViewController isEqual:self])
    {
        [self unregisterAdjacentViewController:self.upperViewController inDirection:MBDirectionUp];
        self.upperViewController = nil;
    }
    else if(self.lowerViewController && self.lowerViewController.isModal && [self.lowerViewController.modalPresentingViewController isEqual:self])
    {
        [self unregisterAdjacentViewController:self.lowerViewController inDirection:MBDirectionDown];
        self.lowerViewController = nil;
    }
}

-(void)unregisterAdjacentViewController:(MBSpacialChildViewController*)controller inDirection:(MBDirection)direction
{
    controller.hasLowerViewController = NO;
    controller.hasLeftViewController = NO;
    controller.hasUpperViewController = NO;
    controller.hasRightViewController = NO;
    
    if(direction == MBDirectionUp)
        self.hasUpperViewController = NO;
    else if(direction == MBDirectionRight)
        self.hasRightViewController = NO;
    else if(direction == MBDirectionLeft)
        self.hasLeftViewController = NO;
    else if(direction == MBDirectionDown)
        self.hasLowerViewController = NO;
    
    
    [controller willMoveToParentViewController:nil];
    [controller.view removeFromSuperview];
    [controller removeFromParentViewController];
    [controller didMoveToParentViewController:nil];
}

-(void)spacialViewWillDisappear {
    // optionally overriden by subclasses
}

-(void)spacialViewDidDisappear {
    // optionally overriden by subclasses
}

#pragma mark -
#pragma mark Getters

-(UITableView*)tableView {
    if(_tableView)
        return _tableView;
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.autoresizingMask = YES;
    [_tableView setBackgroundColor:[UIColor blackColor]];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _tableView.showsVerticalScrollIndicator = NO;
    [_tableView setRowHeight:55];
    [self registerScrollView:_tableView];
    return _tableView;
}

-(UIPanGestureRecognizer*)panGesture {
    if(_panGesture)
        return _panGesture;
    _panGesture = [[MBPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureDidChange:)];
    _panGesture.customDelegate = self;
    _panGesture.delegate = self;
    return _panGesture;
}

#pragma mark --
#pragma mark Setters

-(void)setHasLeftViewController:(BOOL)hasLeftViewController {
    [self setHasViewController:hasLeftViewController inDirection:MBDirectionLeft];
}

-(void)setHasRightViewController:(BOOL)hasRightViewController {
    [self setHasViewController:hasRightViewController inDirection:MBDirectionRight];
}

-(void)setHasLowerViewController:(BOOL)hasLowerViewController {
    [self setHasViewController:hasLowerViewController inDirection:MBDirectionDown];
}

-(void)setHasUpperViewController:(BOOL)hasUpperViewController {
    [self setHasViewController:hasUpperViewController inDirection:MBDirectionUp];
}

-(void)setHasViewController:(BOOL)hasViewController inDirection:(MBDirection)direction {
    if([self hasViewControllerInDirection:direction] != direction) {
        if(direction == MBDirectionLeft) _hasLeftViewController = hasViewController;
        else if(direction == MBDirectionRight) _hasRightViewController = hasViewController;
        else if(direction == MBDirectionUp) _hasUpperViewController = hasViewController;
        else if(direction == MBDirectionDown) _hasLowerViewController = hasViewController;
        [self.masterController.map setHasNode:hasViewController inDirection:direction fromViewController:self];
    }
}

-(BOOL)hasViewControllerInDirection:(MBDirection)direction {
    if(direction == MBDirectionLeft) return self.hasLeftViewController;
    else if(direction == MBDirectionRight) return self.hasRightViewController;
    else if(direction == MBDirectionUp) return self.hasUpperViewController;
    else return self.hasLowerViewController;
}

-(void)setLeftViewController:(MBSpacialChildViewController *)leftViewController {
    [self setViewController:leftViewController forDirection:MBDirectionLeft];
}

-(void)setRightViewController:(MBSpacialChildViewController *)rightViewController {
    [self setViewController:rightViewController forDirection:MBDirectionRight];
}

-(void)setUpperViewController:(MBSpacialChildViewController *)upperViewController {
    [self setViewController:upperViewController forDirection:MBDirectionUp];
}

-(void)setLowerViewController:(MBSpacialChildViewController *)lowerViewController {
    [self setViewController:lowerViewController forDirection:MBDirectionDown];
}

-(void)setViewController:(MBSpacialChildViewController*)controller forDirection:(MBDirection)direction {
    MBSpacialChildViewController *currentController = [self viewControllerInDirection:direction];
    if([currentController isEqual:controller] || !controller)
        return;
    
    if(direction == MBDirectionLeft) _leftViewController = controller;
    else if(direction == MBDirectionRight) _rightViewController = controller;
    else if(direction == MBDirectionUp) _upperViewController = controller;
    else if(direction == MBDirectionDown) _lowerViewController = controller;
    
    [self setInverseRelationshipForController:controller direction:direction];
    controller.masterController = self.masterController;
    [self addController:controller setOrigin:[self originForNewController:controller inDirection:direction]];
    [self.masterController.map setViewController:controller fromViewController:self inDirection:direction];
    [controller spacialViewDidLoad];
}

-(void)setInverseRelationshipForController:(MBSpacialChildViewController*)controller direction:(MBDirection)direction {
    if(direction == MBDirectionLeft) {
        controller->_rightViewController = self;
        self.hasLeftViewController = YES;
    }
    else if(direction == MBDirectionRight) {
        controller->_leftViewController = self;
        self.hasRightViewController = YES;
    }
    else if(direction == MBDirectionUp) {
        controller->_lowerViewController = self;
        self.hasUpperViewController = YES;
    }
    else if(direction == MBDirectionDown) {
        controller->_upperViewController = self;
        self.hasLowerViewController = YES;
    }
}

-(CGPoint)originForNewController:(MBSpacialChildViewController*)controller inDirection:(MBDirection)direction {
    CGRect currentFrame = self.view.frame;
    if(direction == MBDirectionLeft) return CGPointMake(currentFrame.origin.x - controller.view.frame.size.width, currentFrame.origin.y);
    else if(direction == MBDirectionRight) return CGPointMake(currentFrame.origin.x + currentFrame.size.width, currentFrame.origin.y);
    else if(direction == MBDirectionUp) return CGPointMake(currentFrame.origin.x, currentFrame.origin.y - controller.view.frame.size.height);
    else if(direction == MBDirectionDown) return CGPointMake(currentFrame.origin.x, currentFrame.origin.y + controller.view.frame.size.height);
    return CGPointZero;
}

-(void)addController:(MBSpacialChildViewController*)child setOrigin:(CGPoint)origin
{
    [self.masterController addChildViewController:child];
    if(self.masterController.map)
        [self.masterController.view insertSubview:child.view belowSubview:self.masterController.map.view];
    else [self.masterController.view addSubview:child.view];
    [child didMoveToParentViewController:self];
    
    CGRect rect = child.view.frame;
    rect.size = self.masterController.view.frame.size;
    rect.origin = origin;
    child.view.frame = rect;
}

#pragma mark --
#pragma mark UIScrollView Interaction

-(void)registerScrollView:(UIScrollView*)scrollView {
    self.scrollView = scrollView;
    [scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.panGesture];
}


-(BOOL)gestureRecognizerShouldBegin:(MBPanGestureRecognizer *)gestureRecognizer {
    if(!_scrollView)
        return YES;
    
    if(self.lowerViewController && gestureRecognizer.direction == MBDirectionDown) {
        if(_scrollView.contentOffset.y == _scrollView.contentSize.height - _scrollView.bounds.size.height)
            return YES;
        if(_scrollView.contentSize.height < _scrollView.bounds.size.height)
            return YES;
    }
    else if(self.upperViewController && gestureRecognizer.direction == MBDirectionUp) {
        if(_scrollView.contentOffset.y == 0 && gestureRecognizer.direction == MBDirectionUp)
            return YES;
        if(_scrollView.contentSize.height < _scrollView.bounds.size.height)
            return YES;
    }
    else if(self.leftViewController && gestureRecognizer.direction == MBDirectionLeft)
        return YES;
    else if(self.rightViewController && gestureRecognizer.direction == MBDirectionRight)
        return YES;

    return NO;
}

#pragma mark --
#pragma mark Navigation

-(void)goToRootWithAnimation:(BOOL)animated {
    assert(self.masterController);
    assert(self.masterController.root);
    NSArray *steps = [self.masterController.map stepsFromViewController:self toViewController:self.masterController.root];
    MBSpacialChildViewController *currentController = self;
    for(NSNumber *step in steps) {
        MBDirection direction = step.integerValue;
        [currentController moveInDirection:direction animated:animated];
        currentController = [currentController viewControllerInDirection:direction];
    }
}

-(MBSpacialChildViewController*)viewControllerInDirection:(MBDirection)direction {
    if(direction == MBDirectionDown)
        return self.lowerViewController;
    else if(direction == MBDirectionLeft)
        return self.leftViewController;
    else if(direction == MBDirectionRight)
        return self.rightViewController;
    else if(direction == MBDirectionUp)
        return self.upperViewController;
    
    return nil;
}

-(MBSpacialChildViewController*)viewControllerForOppositeDirectionOf:(MBDirection)direction {
    return [self viewControllerInDirection:[MBSpacialMap oppositeForDirection:direction]];
}

-(void)moveInDirectionViaPan:(MBDirection)direction {
    didTransitionViaPan = YES;
    [self moveInDirection:direction animated:YES];
    didTransitionViaPan = NO;
}
#define ANIMATION_DURATION 0.25

-(void)moveInDirection:(MBDirection)direction animated:(BOOL)animated {
    MBSpacialChildViewController *controller = [self viewControllerInDirection:direction];
    if(controller == nil)
        return;
    
    [self spacialViewWillDisappear];
    [controller spacialViewWillAppear];
    
    if(animated) {
        [UIView animateWithDuration:ANIMATION_DURATION animations:^{
            self.view.alpha = 0.0;
            [self executeMoveForViewController:controller inDirection:direction];
        } completion:^(BOOL finished) {
            self.view.alpha = 1.0;
            [self spacialViewDidDisappear];
            [controller spacialViewWillAppear];
        }];
    } else {
        [self executeMoveForViewController:controller inDirection:direction];
        [self spacialViewDidDisappear];
        [controller spacialViewDidAppear];
    }
    
     [self.masterController didTransitionFromViewController:self toViewController:[self viewControllerInDirection:direction] inDirection:direction transitionType:didTransitionViaPan ? MBSpacialTransitionTypePan : MBSpacialTransitionTypeProgrammatic];
}

-(void)executeMoveForViewController:(MBSpacialChildViewController*)controller inDirection:(MBDirection)direction {
    CGRect currentFrame = self.view.frame;
    CGRect newFrame = controller.view.frame;
    
    if(direction == MBDirectionLeft) currentFrame.origin = CGPointMake(newFrame.size.width, currentFrame.origin.y);
    else if(direction == MBDirectionRight) currentFrame.origin = CGPointMake(-newFrame.size.width, currentFrame.origin.y);
    else if(direction == MBDirectionUp) currentFrame.origin = CGPointMake(currentFrame.origin.x, newFrame.size.height);
    else if(direction == MBDirectionDown) currentFrame.origin = CGPointMake(currentFrame.origin.x, - newFrame.size.height);
    self.view.frame = currentFrame;
    
    controller.view.alpha = 1.0;
    [self updatePositionsForAdjacentControllersFromController:self];
    [self.masterController.map setControllerAsCurrent:controller]; 
}

#define VELOCITY_THRESHOLD 650

-(void)panGestureDidChange:(MBPanGestureRecognizer*)recognizer {
    static CGPoint initialTouch;
    static BOOL isVertical;
    static CGRect originalRect;
    static MBSpacialChildViewController *controller;
    
    UIWindow *window = self.view.window;
    CGPoint currentTouch = [recognizer locationInView:window];
    CGFloat panAmountX = initialTouch.x - currentTouch.x;
    CGFloat panAmountY = initialTouch.y - currentTouch.y;
    
    if(recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint velocity = [recognizer velocityInView:window];
        if(fabs(velocity.x) > fabs(velocity.y))
            isVertical = NO;
        else isVertical = YES;
        if(isVertical && fabs(velocity.y) > VELOCITY_THRESHOLD) {
            [self moveInDirectionViaPan:recognizer.direction];
            [recognizer setState:UIGestureRecognizerStateFailed];
        }
        else if(fabs(velocity.x) > VELOCITY_THRESHOLD) {
            [self moveInDirectionViaPan:recognizer.direction];
            [recognizer setState:UIGestureRecognizerStateFailed];
        }
        initialTouch = currentTouch;
        originalRect = self.view.frame;
    }
    else if(recognizer.state == UIGestureRecognizerStateChanged) {
        CGRect currentRect = self.view.frame;
        if(isVertical)
            currentRect.origin.y = originalRect.origin.y - panAmountY;
        else currentRect.origin.x = originalRect.origin.x - panAmountX;
        self.view.frame = currentRect;
        CGFloat fraction = (isVertical ? panAmountY : panAmountX)  / (isVertical ? originalRect.size.height : originalRect.size.width);
       
        controller = [self viewControllerInDirection:[self directionForPanAmount:isVertical ? panAmountY : panAmountX isVerticalPan:isVertical]];
        self.view.alpha = 1 - fabs(fraction);
        controller.view.alpha = fabs(fraction);

        [self updatePositionsForAdjacentControllersFromController:self];
    }
    else if(recognizer.state == UIGestureRecognizerStateEnded) {
        CGFloat panAmount = isVertical ? panAmountY : panAmountX;
        MBDirection direction = [self directionForPanAmount:panAmount isVerticalPan:isVertical];
        if(controller && fabs(panAmount) > controller.snappingThreshold) {
            [self moveInDirectionViaPan:direction];
        } else {
            [self setOrigin:originalRect.origin withAnimation:YES];
        }        
    }
}

-(MBDirection)directionForPanAmount:(CGFloat)panAmount isVerticalPan:(BOOL)isVertical {
    if(isVertical) {
        if(panAmount > 0)
            return MBDirectionDown;
        else return MBDirectionUp;
    } else {
        if(panAmount > 0)
            return MBDirectionRight;
        else return MBDirectionLeft;
    }
}

-(void)setOrigin:(CGPoint)origin withAnimation:(BOOL)animate {
    CGRect frame = self.view.frame;
    frame.origin = origin;
    if(animate) {
        [UIView animateWithDuration:ANIMATION_DURATION animations:^{
            self.view.frame = frame;
            [self updatePositionsForAdjacentControllersFromController:self];
            self.view.alpha = 1.0;
        } completion:^(BOOL finished) {
        }];
    }
    else {
        self.view.alpha = 1.0;
        self.view.frame = frame;
        [self updatePositionsForAdjacentControllersFromController:self];
    }
}


-(void)updatePositionsForAdjacentControllersFromController:(MBSpacialChildViewController*)controller {
    if(self.rightViewController && [self.rightViewController isEqual:controller] == NO) {
        [self updatePositionForController:self.rightViewController inDirection:MBDirectionRight];
    }
    if(self.leftViewController && [self.leftViewController isEqual:controller] == NO) {
        [self updatePositionForController:self.leftViewController inDirection:MBDirectionLeft];
    }
    if(self.upperViewController && [self.upperViewController isEqual:controller] == NO) {
        [self updatePositionForController:self.upperViewController inDirection:MBDirectionUp];
    }
    if(self.lowerViewController && [self.lowerViewController isEqual:controller] == NO) {
        [self updatePositionForController:self.lowerViewController inDirection:MBDirectionDown];
    }
}

-(void)updatePositionForController:(MBSpacialChildViewController*)controller inDirection:(MBDirection)direction {
    CGRect rect = controller.view.frame;
    rect.origin = [self originForNewController:controller inDirection:direction];
    controller.view.frame = rect;
    [controller updatePositionsForAdjacentControllersFromController:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addGestureRecognizer:self.panGesture];
}

-(void)setTableViewOrigin:(CGPoint)origin {
    CGRect frame = self.tableView.frame;
    frame.origin = origin;
    self.tableView.frame = frame;
}

#pragma mark --
#pragma mark MBPanGesture Custom Delegate

-(void)didSetMinNumberOfTouches:(NSUInteger)touches inDirection:(MBDirection)direction {
    [self.masterController.map setMinNumberOfTouches:touches forViewController:self inDirection:direction];
    if(direction == MBDirectionDown)
        self.lowerViewController.panGesture.minNumberTouchesUp = touches;
    else if(direction == MBDirectionLeft)
        self.leftViewController.panGesture.minNumberTouchesRight = touches;
    else if(direction == MBDirectionRight)
       self.rightViewController.panGesture.minNumberTouchesLeft = touches;
    else if(direction == MBDirectionUp)
        self.upperViewController.panGesture.minNumberTouchesDown = touches;
}

@end
