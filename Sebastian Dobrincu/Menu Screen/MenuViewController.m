//
//  MenuViewController.m
//  Sebastian Dobrincu
//
//  Created by Sebastian Dobrincu on 19/04/15.
//  Copyright (c) 2015 Sebastian Dobrincu. All rights reserved.
//

#import "MenuViewController.h"

@implementation MenuViewController

#pragma mark - Controller Delegates

- (void)viewDidLoad {
    [super viewDidLoad];
   
    progressView = [[GradientProgressView alloc] initWithFrame:self.view.frame];
    [progressView setProgress:1];
    [self.view insertSubview:progressView aboveSubview:self.view];
    
    //Apply overlay effect to the gradient background
    UIView *overlayView = [[UIView alloc] initWithFrame:self.view.frame];
    [overlayView setBackgroundColor:[UIColor blackColor]];
    overlayView.alpha = 0.5f;
    [self.view addSubview:overlayView];

    //Add more about me label
    moreLabel = [[SDShineLabel alloc] initWithFrame:CGRectMake(0, 45, self.view.frame.size.width, 55)];
    if ([SDiPhoneVersion deviceSize] == iPhone4inch)
        [moreLabel setFrame:CGRectMake(0, 15, self.view.frame.size.width, 55)];
    else if ([SDiPhoneVersion deviceSize] == iPhone55inch)
        [moreLabel setFrame:CGRectMake(0, 45, self.view.frame.size.width, 55)];
    
    moreLabel.text = @"WWDC 2015";
    moreLabel.font = [UIFont fontWithName:@"SourceSansPro-Light" size:39];
    moreLabel.backgroundColor = [UIColor clearColor];
    moreLabel.textColor = [UIColor whiteColor];
    moreLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:moreLabel];
    
    titles = @[@"Education", @"Projects", @"Professional background", @"About me"];
    
    subtitles = @[@"Find some more about my education and achievements.",
                  @"Browse some of the projects I’ve been working on.",
                  @"The technical skills I posses and more about my interests.",
                  @"See some more about my personal life and hobbies."];
    
    bgImage = @[@"education", @"projects", @"knowledge", @"hobbies"];
    
    bgColors = @[[UIColor colorWithRed:0.234 green:0.748 blue:0.891 alpha:1.000],
                 [UIColor colorWithRed:0.87 green:0.29 blue:0.64 alpha:1],
                 [UIColor colorWithRed:0.339 green:0.786 blue:0.077 alpha:1.000],
                 [UIColor colorWithRed:0.838 green:0.256 blue:0.105 alpha:1.000]];

    gradiendHues = @[[UIColor colorWithRed:0.13 green:0.81 blue:0.67 alpha:1],
                     [UIColor colorWithRed:0.11 green:0.67 blue:0.87 alpha:1],
                     
                     [UIColor colorWithRed:0 green:0.65 blue:0.91 alpha:1],
                     [UIColor colorWithRed:0.32 green:0.4 blue:0.95 alpha:1],
                     
                     [UIColor colorWithRed:0.38 green:0.33 blue:0.93 alpha:1],
                     [UIColor colorWithRed:0.58 green:0.24 blue:0.84 alpha:1],
                     
                     [UIColor colorWithRed:0.7 green:0.24 blue:0.73 alpha:1],
                     [UIColor colorWithRed:0.87 green:0.19 blue:0.52 alpha:1],
                     
                     [UIColor colorWithRed:0.26 green:0.81 blue:0.64 alpha:1.000],
                     [UIColor colorWithRed:0.1 green:0.36 blue:0.62 alpha:1.000]
                     ];
    grIndex = 0;
    
    // Create menu objects from datasource
    for (int i=0; i<titles.count; i++) {
        SDMenuItem *item = [[SDMenuItem alloc] init];
        item.image = [UIImage imageNamed:bgImage[i]];
        item.title = titles[i];
        item.subtitle = subtitles[i];
        item.overlayColor = bgColors[i];
        [self.items addObject:item];
    }
    
    shouldAnimate = NO;
    //Add table & configure it
    UITableView *menuTable = [[UITableView alloc] initWithFrame:CGRectMake(0, moreLabel.frame.origin.y+moreLabel.frame.size.height+10, self.view.frame.size.width, self.view.frame.size.height-(moreLabel.frame.origin.y+moreLabel.frame.size.height+10)) style:UITableViewStylePlain];
    menuTable.delegate = self;
    menuTable.dataSource = self;
    menuTable.backgroundColor = [UIColor clearColor];
    menuTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    menuTable.alpha = 0;
    menuTable.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    if ([SDiPhoneVersion deviceSize] == iPhone47inch)
        menuTable.contentInset = UIEdgeInsetsMake(40, 0, 0, 0);
    else if([SDiPhoneVersion deviceSize] == iPhone55inch)
        menuTable.contentInset = UIEdgeInsetsMake(55, 0, 0, 0);
    [self.view addSubview:menuTable];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self speakText:@"Welcome to my WWDC 2015 application!"];
    });

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // Starting recursive animation
        [self recursiveBackgroundAnimation];
    });
    
    selectedItems = [[NSMutableArray alloc] init];
    
    //Not so grate workaround for custom cell layout
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [menuTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0],
                                            [NSIndexPath indexPathForRow:1 inSection:0],
                                            [NSIndexPath indexPathForRow:2 inSection:0],
                                            [NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            shouldAnimate = YES;
            [UIView animateWithDuration:0.25 animations:^{
                menuTable.alpha = 1;
            }];
            [menuTable reloadData];
        });
    });
   
}

-(void)viewDidAppear:(BOOL)animated{
    
    //Animate header label
    [moreLabel shine];
    [progressView startAnimating];
    
    if (selectedItems.count == 4) {
        [selectedItems addObject:@"End"];
        
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        alert.backgroundType = Blur;
        alert.completeButtonFormatBlock = ^NSDictionary* (void)
        {
            NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
            buttonConfig[@"backgroundColor"] = [UIColor colorWithRed:0.99 green:0.42 blue:0.57 alpha:1];
            buttonConfig[@"textColor"] = [UIColor colorWithRed:0.997 green:0.995 blue:0.961 alpha:1.000];
            
            return buttonConfig;
        };
        [alert showNotice:self title:@"That's it!" subTitle:@"Thank you for checking out my app! I had a lot of fun crafting it and I hope you enjoyed it." closeButtonTitle:@"OK" duration:8.5];
    }
}

-(void)viewDidDisappear:(BOOL)animated {
    [progressView stopAnimating];
}

#pragma mark - TableView Methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 117;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    MenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell){
        [tableView registerNib:[UINib nibWithNibName:@"MenuCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.cellView.layer.shadowColor = [UIColor colorWithWhite:0.088 alpha:1.000].CGColor;
    cell.cellView.layer.shadowOffset = CGSizeMake(-0.5, 1.5);
    cell.cellView.layer.shadowOpacity = 0.5;
    cell.cellView.layer.shadowRadius = 1;
    
    cell.bgImage.image = [UIImage imageNamed:bgImage[indexPath.row]];
    cell.bgImage.clipsToBounds = YES;

    if ([cell.bgImage.layer sublayers].count == 0){
        CALayer *sublayer = [CALayer layer];
        [sublayer setBackgroundColor:[bgColors[indexPath.row] CGColor]];
        [sublayer setOpacity:0.9f];
        CGRect f = cell.bgImage.bounds;
        f.origin.x -= 2;
        f.size.width += 4;
        [sublayer setFrame:f];
        [cell.bgImage.layer insertSublayer:sublayer atIndex:0];
    }
    
    if ([SDiPhoneVersion deviceSize] == iPhone4inch) {
        cell.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:18];
        cell.subtitleLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:14.5];
    }
    
    cell.titleLabel.text = titles[indexPath.row];
    cell.subtitleLabel.text = subtitles[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(MenuTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (shouldAnimate) {
        
        CATransform3D rotation;
        rotation = CATransform3DMakeRotation( (90.0*M_PI)/180, 0.0, 0.7, 0.4);
        rotation.m34 = 1.0/ -600;
        
        cell.layer.shadowColor = [[UIColor blackColor]CGColor];
        cell.layer.shadowOffset = CGSizeMake(10, 10);
        cell.alpha = 0;
        
        cell.layer.transform = rotation;
        cell.layer.anchorPoint = CGPointMake(0, 0.5);
        
        [UIView beginAnimations:@"rotation" context:NULL];
        [UIView setAnimationDuration:0.75];
        cell.layer.transform = CATransform3DIdentity;
        cell.alpha = 1;
        cell.layer.shadowOffset = CGSizeMake(0, 0);
        [UIView commitAnimations];
        

    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (![selectedItems containsObject:indexPath])
        [selectedItems addObject:indexPath];
    
    switch (indexPath.row) {
        case 0:{
            EducationViewController *viewController = (EducationViewController* )[self.storyboard instantiateViewControllerWithIdentifier:@"education"];
            viewController.sourceFrames = [tableView framesForRowAtIndexPath:indexPath];
            viewController.item = [self.items objectAtIndex:[indexPath row]];
            viewController.animationDuration = 0.3f;
            [self.navigationController pushViewController:viewController animated:NO];
            break;
        }
        
        case 1:{
            
            ProjectsViewController *viewController = (ProjectsViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"projects"];
            viewController.sourceFrames = [tableView framesForRowAtIndexPath:indexPath];
            viewController.item = [self.items objectAtIndex:[indexPath row]];
            viewController.animationDuration = 0.3f;
            [self.navigationController pushViewController:viewController animated:NO];
            break;
        }

        case 2:{
            
            ProfessionalViewController *viewController = (ProfessionalViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"professional"];
            viewController.sourceFrames = [tableView framesForRowAtIndexPath:indexPath];
            viewController.item = [self.items objectAtIndex:[indexPath row]];
            viewController.animationDuration = 0.3f;
            [self.navigationController pushViewController:viewController animated:NO];
            break;
        }

            
        case 3:{
            
            AboutViewController *viewController = (AboutViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"about"];
            viewController.sourceFrames = [tableView framesForRowAtIndexPath:indexPath];
            viewController.item = [self.items objectAtIndex:[indexPath row]];
            viewController.animationDuration = 0.3f;
            [self.navigationController pushViewController:viewController animated:NO];
            break;
        }
        
        default:
            break;
    }
    

}

#pragma mark - Gradient Background

-(void)recursiveBackgroundAnimation{
    
    if (grIndex < gradiendHues.count) {
        NSTimeInterval duration = 1.0f;
       
            [CATransaction begin];
            [CATransaction setAnimationDuration:duration];
            [CATransaction setCompletionBlock:^{
                [self recursiveBackgroundAnimation];
                grIndex += 2;
            }];
            gradient.colors = [NSArray arrayWithObjects:(__bridge id)[gradiendHues[grIndex] CGColor], (__bridge id)[gradiendHues[grIndex+1] CGColor], nil];

            [CATransaction commit];

    }else
        return;
}

#pragma mark - Speech Method

- (void)speakText:(NSString *)toBeSpoken {
    
    synthesizer = [[AVSpeechSynthesizer alloc] init];
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:toBeSpoken];
    utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-US"];
    utterance.rate = AVSpeechUtteranceMinimumSpeechRate+0.16;
    [synthesizer speakUtterance:utterance];
    
}

#pragma mark - Additional Methods

- (NSMutableArray *)items{
    if (!_items)
        _items = [[NSMutableArray alloc] init];
    
    return _items;
}

@end
