//
//  UIViewController+Utilities.m
//  SpacialDemo
//
//  Created by Mo Bitar on 2/17/13.
//  Copyright (c) 2013 progenius. All rights reserved.
//

#import "UIViewController+Utilities.h"

@implementation UIViewController (Utilities)
-(id)initWithTitle:(NSString*)title {
    if(self = [super init]) {
        self.title = title;
    }
    return self;
}
@end
