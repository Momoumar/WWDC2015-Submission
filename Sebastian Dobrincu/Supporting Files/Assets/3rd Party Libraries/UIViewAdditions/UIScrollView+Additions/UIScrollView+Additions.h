//
//  UIScrollView+Additions.h
//  Sebastian Dobrincu
//
//  Created by Sebastian Dobrincu on 17/04/15.
//  Copyright (c) 2015 Sebastian Dobrincu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (UIScrollView_Additions)

@property (nonatomic) CGFloat scrollPointsPerSecond;
@property (nonatomic, getter = isScrolling) BOOL scrolling;

- (void)startScrolling;
- (void)stopScrolling;

@end
