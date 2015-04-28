//
//  EducationViewController.m
//  Sebastian Dobrincu
//
//  Created by Sebastian Dobrincu on 19/04/15.
//  Copyright (c) 2015 Sebastian Dobrincu. All rights reserved.
//

#import "EducationViewController.h"

@implementation EducationViewController

#pragma mark - Controller Delegates

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.cell addGestureRecognizer:swipeDown];


    // Initialize default cell checker
    selectedRow = 0;
    
    // Create events datasource
    events = @[@{@"year":@2007, @"event":@"Discovered the world of software", @"color":[UIColor colorWithRed:0.99 green:0.42 blue:0.57 alpha:1]},
               @{@"year":@2008, @"event":@"Started learning C++"},
               @{@"year":@2009, @"event":@"Got into UI design"},
               @{@"year":@2010, @"event":@"Started freelancing mobile UIs"},
               @{@"year":@2011, @"event":@"Learning iOS Development", @"color":[UIColor colorWithRed:0.772 green:0.475 blue:0.886 alpha:1.000]},
               @{@"year":@2012, @"event":@"Freelancing iOS Apps"},
               @{@"year":@2013, @"event":@"Reached highschool"},
               @{@"year":@2014, @"event":@"Shake device for more :)", @"color":[UIColor colorWithRed:1 green:0.8 blue:0.18 alpha:1]},
               @{@"year":@2015, @"event":@"WWDC in San Francisco, CA", @"color":[UIColor colorWithRed:0.26 green:0.81 blue:0.64 alpha:1]}
             ];
    
    // Set tableView's delegate & datasource
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.userInteractionEnabled = NO;
    
    // Create selection view for cells
    selectionView = [[UIView alloc] initWithFrame:CGRectMake(0, self.tableView.frame.origin.y, self.view.frame.size.width, 55)];
    selectionView.tag = 99;
    [selectionView setBackgroundColor:[UIColor colorWithRed:0.19 green:0.67 blue:0.85 alpha:1]];
    [self.view insertSubview:selectionView belowSubview:self.tableView];
    
    [self.tableView bringSubviewToFront:selectionView];

    for (UIView *eachView in self.view.subviews) {
        if (eachView.tag == 99) {
            eachView.alpha = 0;
            CGRect fr = eachView.frame;
            fr.origin.x -= self.view.frame.size.width;
            [eachView setFrame:fr];
            
        }else if (eachView.tag == 98)
            eachView.alpha = 0;
        
    }
    
    [UIView animateWithDuration:0.3 delay:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        for (UIView *eachView in self.view.subviews) {
            if (eachView.tag == 99) {
                eachView.alpha = 1;
                CGRect fr = eachView.frame;
                fr.origin.x += self.view.frame.size.width;
                [eachView setFrame:fr];
            }
        }
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            [UIView animateWithDuration:0.3 animations:^{
                [[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] viewWithTag:5] setAlpha:1];
            }];
            
            for (UIView *eachView in self.view.subviews)
                if (eachView.tag == 98)
                    eachView.alpha = 1;
            
        } completion:^(BOOL finished) {
            self.tableView.userInteractionEnabled = YES;
        }];
    }];
    
}

#pragma mark - TableView & ScrollView Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return events.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    UIView *lineUp = [cell viewWithTag:1];
    UIView *lineDown = [cell viewWithTag:2];
    UIView *circle = [cell viewWithTag:3];
    UILabel *yearLabel = (UILabel*)[cell viewWithTag:4];
    MarqueeLabel *eventLabel = (MarqueeLabel*)[cell viewWithTag:5];
    
    if (indexPath.row == 0)
        lineUp.hidden = YES;
    else if (indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section]-1)
        lineDown.hidden = YES;
    
    circle.backgroundColor = [UIColor whiteColor];
    circle.layer.cornerRadius = circle.frame.size.width/2;
    circle.clipsToBounds = YES;
    
    if ([SDiPhoneVersion deviceSize] == iPhone4inch)
        [eventLabel setFrame:CGRectMake(110, eventLabel.frame.origin.y, 100, eventLabel.frame.size.height)];
    
    eventLabel.marqueeType = MLContinuous;
    eventLabel.scrollDuration = 10.0f;
    eventLabel.fadeLength = 10.0f;
    eventLabel.trailingBuffer = 30.0f;
    
    NSDictionary *event = events[indexPath.row];
    yearLabel.text = [NSString stringWithFormat:@"%@", event[@"year"]];
    eventLabel.text = event[@"event"];
    
    if ((![tableView indexPathForSelectedRow] && indexPath.row == 0) || indexPath.row == selectedRow)
        eventLabel.alpha = 1;
    else
        eventLabel.alpha = 0;
    
    if (event[@"color"]) {
        [circle setBackgroundColor:event[@"color"]];
        circle.layer.borderColor = [UIColor whiteColor].CGColor;
        circle.layer.borderWidth = 3;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    selectedRow = indexPath.row;
    
    if ([[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] viewWithTag:5] alpha] == 1) {
        [UIView animateWithDuration:0.07 animations:^{
            [[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] viewWithTag:5] setAlpha:0];
        }];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rectInTableView = [tableView rectForRowAtIndexPath:indexPath];
        CGRect rectInSuperview = [tableView convertRect:rectInTableView toView:[tableView superview]];

        CGRect finalFrame = CGRectMake(0, rectInSuperview.origin.y, self.view.frame.size.width, selectionView.frame.size.height);
        [selectionView setFrame:finalFrame];
        
    } completion:^(BOOL finished) {
        
        for (int i=0; i<events.count; i++) {
            if ([[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]] viewWithTag:5] alpha] == 1 && i != selectedRow) {
                [UIView animateWithDuration:0.15 animations:^{
                    [[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]] viewWithTag:5] setAlpha:0];
                }];
            }
        }
        
        [UIView animateWithDuration:0.15 animations:^{
            UILabel *eventLabel = (UILabel*)[[tableView cellForRowAtIndexPath:indexPath] viewWithTag:5];
            eventLabel.alpha = 1.0f;
        }];
    }];
    
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [UIView animateWithDuration:0.1 animations:^{
        UILabel *eventLabel = (UILabel*)[[tableView cellForRowAtIndexPath:indexPath] viewWithTag:5];
        eventLabel.alpha = 0.0f;
    }];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if ([selectionView alpha] == 1) {
        
        [UIView animateWithDuration:0.15 animations:^{
            [selectionView setAlpha:0];
        }];
    }
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if([selectionView alpha] == 0){
        
        [UIView animateWithDuration:0.15 animations:^{
            selectionView.alpha = 1;
            CGRect rectInTableView = [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedRow inSection:0]];
            
            [selectionView setFrame:CGRectMake(0, rectInTableView.origin.y+self.tableView.frame.origin.y-self.tableView.contentOffset.y, self.view.frame.size.width, selectionView.frame.size.height)];
        }];
        
    }
    
}

#pragma mark - Motion callback

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    
    if (selectedRow == [self tableView:self.tableView numberOfRowsInSection:0]-2) {

        SCLAlertView *alert = [[SCLAlertView alloc] init];
        alert.backgroundType = Blur;
        alert.completeButtonFormatBlock = ^NSDictionary* (void)
        {
            NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
            
            buttonConfig[@"backgroundColor"] = [UIColor colorWithRed:0.99 green:0.42 blue:0.57 alpha:1];
            buttonConfig[@"textColor"] = [UIColor colorWithRed:0.997 green:0.995 blue:0.961 alpha:1.000];
            
            return buttonConfig;
        };
        [alert showNotice:self title:@"What a fantastic year!" subTitle:@"2014 has been by far the best year of my life. I've managed to perfectionize my programming techniques. I've launched quite a few interesting projects, that I'm really proud of and also had the oportunity to work with amazing clients and some prestigious companies. Besides that, I've also managed to create and maintain some open-source libraries for iOS, which became pretty popular. " closeButtonTitle:@"OK" duration:0.0f];

    }
    
}

#pragma mark - Additional methods

-(void)close{
    [self close:nil];
}

@end
