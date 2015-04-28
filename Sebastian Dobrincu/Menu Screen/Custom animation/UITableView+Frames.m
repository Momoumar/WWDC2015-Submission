//
//  UITableView+Frames.m
//  RSTransitionEffect
//
//  Created by R0CKSTAR on 12/11/13.
//  Copyright (c) 2013 P.D.Q. All rights reserved.
//

#import "UITableView+Frames.h"

@implementation UITableView (Frames)

- (NSDictionary *)framesForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuTableViewCell *cell = (MenuTableViewCell*)[self cellForRowAtIndexPath:indexPath];
    CGRect cellFrameInTableView = [self rectForRowAtIndexPath:indexPath];
    cellFrameInTableView.origin.x = cell.cellView.frame.origin.x;
    cellFrameInTableView.size.width = cell.cellView.frame.size.width;
    cellFrameInTableView.size.height = cell.cellView.frame.size.height;
    
    CGRect cellFrameInWindow = [self convertRect:cellFrameInTableView toView:[UIApplication sharedApplication].keyWindow];
    
    NSMutableDictionary *frames = [NSMutableDictionary dictionary];
    
    [frames setObject:[NSValue valueWithCGRect:cellFrameInWindow] forKey:@"cell"];
    [frames setObject:[NSValue valueWithCGRect:CGRectOffset(cell.bgImage.frame, cellFrameInWindow.origin.x, cellFrameInWindow.origin.y)] forKey:@"imageView"];
    [frames setObject:[NSValue valueWithCGRect:CGRectOffset(cell.titleLabel.frame, cellFrameInWindow.origin.x, cellFrameInWindow.origin.y)] forKey:@"titleLabel"];
    
    CGRect subtitleFrame = cell.subtitleLabel.frame;
    subtitleFrame.size.width = 295;

    
    [frames setObject:cell.titleLabel.font forKey:@"titleFont"];
    [frames setObject:[NSValue valueWithCGRect:CGRectOffset(subtitleFrame, cellFrameInWindow.origin.x, cellFrameInWindow.origin.y)] forKey:@"subtitleLabel"];
    [frames setObject:cell.subtitleLabel.font forKey:@"subtitleFont"];
    
    return [NSDictionary dictionaryWithDictionary:frames];
}

@end
