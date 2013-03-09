//
//  MBMapUI.h
//  TwoTask
//
//  Created by M B. Bitar on 12/19/12.
//  Copyright (c) 2012 progenius, inc. All rights reserved.
//

#ifndef TwoTask_MBMapUI_h
#define TwoTask_MBMapUI_h

typedef enum{
    MBDirectionNone,  // 0
    MBDirectionRoot,  // 1
    MBDirectionLeft,  // 2
    MBDirectionRight, // 3
    MBDirectionUp,    // 4
    MBDirectionDown,  // 5
}MBDirection;

typedef enum {
    MBMapPositionNone,
    MBMapPositionTopLeft,
    MBMapPositionBottomLeft
}MBMapPosition;


// MAP NODE
#define CIRCLE_RADIUS 10
#define LINE_THICKNESS 2.5
#define LINE_LENGTH 20
#define DEFAULT_CIRCLE_COLOR [UIColor colorWithWhite:1.0 alpha:0.9]
#define POSSIBILITY_CIRCLE_COLOR [UIColor colorWithWhite:1.0 alpha:0.5]

#define DEFAULT_SHAFT_COLOR [UIColor colorWithWhite:1.0 alpha:0.3]
#define POSSIBILITY_SHAFT_COLOR [UIColor colorWithWhite:1.0 alpha:0.3]

// MAP POSITION
#define MAP_MARGIN_X 10
#define MAP_MARGIN_Y_BOTTOM 10
#define MAP_MARGIN_Y_TOP 10

// MAP TITLE LABEL
#define MAP_LABEL_TEXT_COLOR [UIColor colorWithWhite:1.0 alpha:0.8]
#define MAP_LABEL_MAX_WIDTH 150
#define MAP_LABEL_FONT [UIFont boldSystemFontOfSize:10]

#endif
