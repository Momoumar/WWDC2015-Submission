//
//  EducationViewController.h
//  Sebastian Dobrincu
//
//  Created by Sebastian Dobrincu on 19/04/15.
//  Copyright (c) 2015 Sebastian Dobrincu. All rights reserved.
//

#import "SDTransitionViewController.h"
#import "SCLAlertView.h"
#import "MarqueeLabel.h"


@interface EducationViewController : SDTransitionViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>{
    int year;
    NSInteger selectedRow;
    NSArray *events;
    UIView *selectionView;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
