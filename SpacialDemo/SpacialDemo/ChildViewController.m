//
//  ChildViewController.m
//  SpacialDemo
//
//  Created by Mo Bitar on 2/17/13.
//  Copyright (c) 2013 progenius. All rights reserved.
//

#import "ChildViewController.h"

@interface ChildViewController ()

@end

@implementation ChildViewController

-(UIColor*)randomColor {
    return [UIColor colorWithRed:(float)(arc4random() % 255)/255.0 green:(float)(arc4random() % 255)/255.0 blue:(float)(arc4random() % 255)/255.0 alpha:1.0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[self randomColor]];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width - 40, 200)];
    label.font = [UIFont boldSystemFontOfSize:20];
    label.numberOfLines = 0;
    label.userInteractionEnabled = NO;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.text = self.title;
    [label sizeToFit];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.shadowOffset = CGSizeMake(0, 1);
    [self.view addSubview:label];
    
    CGRect rect = label.frame;
    rect.origin = CGPointMake(self.view.bounds.size.width/2.0 - rect.size.width/2.0, self.view.bounds.size.height/2.0 - rect.size.height/2.0);
    label.frame = rect;
    
    UINavigationBar *bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
    [self.view addSubview:bar];

    CGFloat const barWidth = 100;
    CGRect frame = CGRectMake(bar.bounds.size.width/2.0 - barWidth/2.0, 0, barWidth, 50);
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:frame];

    titleLabel.text = self.title;
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.shadowColor = [UIColor blackColor];
    titleLabel.shadowOffset = CGSizeMake(0, 1);
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [bar addSubview:titleLabel];
}

@end
