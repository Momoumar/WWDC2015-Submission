//
//  RevealFromBottomSegue.m
//  Sebastian Dobrincu
//
//  Created by Sebastian Dobrincu on 19/04/15.
//  Copyright (c) 2015 Sebastian Dobrincu. All rights reserved.
//

#import "RevealFromBottomSegue.h"

@implementation RevealFromBottomSegue

-(void)perform{
    
    UIViewController *sourceViewController = self.sourceViewController;
    UIViewController *destinationViewController = self.destinationViewController;
    
    UIView *duplicatedSourceView = [sourceViewController.view snapshotViewAfterScreenUpdates:false];
    [destinationViewController.view addSubview:duplicatedSourceView];
    
    [sourceViewController presentViewController:destinationViewController animated:false completion:^{
        [destinationViewController.view addSubview:duplicatedSourceView];
        
        [UIView animateWithDuration:0.4 animations:^{
            
            destinationViewController.view.transform = CGAffineTransformMakeTranslation(0, 0);
            duplicatedSourceView.transform = CGAffineTransformMakeTranslation(0, -sourceViewController.view.frame.size.height);
            duplicatedSourceView.alpha = 0;
        
        } completion:^(BOOL finished) {
            [duplicatedSourceView removeFromSuperview];
        }];
    }];
    
}

@end
