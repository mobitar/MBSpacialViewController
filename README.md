# MBSpacialViewController

![image](https://github.com/mobitar/MBSpacialViewController/blob/gh/demo.gif?raw=true)

## Overview
MBSpacialViewController lets you create an arbitrarily complex map of view controllers in 2D space. Using gestures, you can navigate up, down, left, and right from any view controller. A map is automatically generated and displayed in the bottom left corner.

##Usage
<br>Usage is best explained by checking out the easy to follow sample code. Basically:</b><br><br>
1. Create a master view controller which inherits from ```MBSpacialMasterViewController```.<br>
2. Set the master's root property to any view controller (must inherit from ```MBSpacialChildViewController```).<br>
3. Set the root's ```left/right/upper/lower viewController``` property. You can do this recursively to create a complex map of view controllers in 2D space: For example:
``` objective-c
self.leftViewController = [some subclass of MBSpacialChildViewController];
self.upperViewController = […];
self.upperViewController.leftViewController.lowerViewController = […];
```
###Navigation
Navigating through view controllers is done via gestures, but can also be done programatically:
```[self moveInDirection:MBDirectionLeft animated:YES];``` where ```self``` is a subclass of ```MBSpacialChildViewController```

###Modals
If you want a view controller to be deallocated and removed from the heirarchy after it disappears, you can make it a modal:
``` objective-c
MBSpacialChildViewController *controller = […]
controller.isModal = YES;
controller.modalPresentingViewController = self;
self.rightViewController = controller;
[self moveInDirection:MBDirectionRight animated:YES];
```

###Gestures
By default, navigation is done via 1 finger pan. If you'd like to require 2 fingers (to avoid clash with scroll views and table views), you can do:
```self.panGesture.minNumberTouchesLeft = 2;```
This will also update the map to display 2 lines instead of 1 to indicate a two-finger swipe requirement.
(Note: Minimal testing was done on this feature)

###View callbacks
MBSpacialViewController doesn't use UIKit view callbacks such as viewDidAppear or viewWillAppear. Instead, we use:
``` objective-c
-(void)spacialViewDidLoad;
-(void)spacialViewWillAppear;
-(void)spacialViewDidAppear;
-(void)spacialViewWillDisappear;
-(void)spacialViewDidDisappear;
```

## Notes
Any view controller that is part of the view heirarchy must inherit from ```MBSpacialChildViewController```.

##Contact
[Bitar](http://www.bitar.io/paragraphs/) [@bitario](https://twitter.com/bitario)

## License
MBSpacialViewController is available under the MIT license.
