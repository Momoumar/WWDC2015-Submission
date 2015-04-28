//
//  SDTransitionViewController.m
//  Sebastian Dobrincu
//
//  Created by Sebastian Dobrincu on 19/04/15.
//  Copyright (c) 2015 Sebastian Dobrincu. All rights reserved.
//

#import "SDTransitionViewController.h"
static float const fadePercentage = 0.2;

@implementation SDTransitionViewController

- (void)__bindItem
{
    self.imageView.image = self.item.image;
    self.titleLabel.text = self.item.title;
    self.subtitleLabel.text = self.item.subtitle;
    self.titleLabel.font = [self.sourceFrames objectForKey:@"titleFont"];
    self.subtitleLabel.font = [self.sourceFrames objectForKey:@"subtitleFont"];
    

}

- (void)__buildTargetFrames
{
    NSMutableDictionary *frames = [NSMutableDictionary dictionary];
    [frames setObject:[NSValue valueWithCGRect:self.cell.frame] forKey:@"cell"];
    [frames setObject:[NSValue valueWithCGRect:self.imageView.frame] forKey:@"imageView"];

    CGRect originalTitle = [self.sourceFrames[@"titleLabel"] CGRectValue];
    CGRect frame = self.titleLabel.frame;
    frame.origin.x = 32;
    frame.size.width = originalTitle.size.width;
    frame.size.height = originalTitle.size.height;
    [frames setObject:[NSValue valueWithCGRect:frame] forKey:@"titleLabel"];
    
    
    CGRect originalSubtitle = [self.sourceFrames[@"subtitleLabel"] CGRectValue];
    frame = self.subtitleLabel.frame;
    frame.origin.x = 32;
    frame.size.width = 290;
    frame.size.height = originalSubtitle.size.height;
    [frames setObject:[NSValue valueWithCGRect:frame] forKey:@"subtitleLabel"];



    self.targetFrames = [NSDictionary dictionaryWithDictionary:frames];
    
}

-(void)viewDidLayoutSubviews{
    
    
    CGRect fr = self.subtitleLabel.frame;
    if ([SDiPhoneVersion deviceSize] == iPhone4inch) 
        fr.size.width = 248;
    else if ([SDiPhoneVersion deviceSize] == iPhone47inch)
        fr.size.width = 295;
    else if ([SDiPhoneVersion deviceSize] == iPhone55inch)
        fr.size.width = 310;
    
    self.subtitleLabel.frame = fr;
    
    CGRect initialFrame = [self.sourceFrames[@"subtitleLabel"] CGRectValue];
    initialFrame.size.width = fr.size.width;
    
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:self.sourceFrames];
    dict[@"subtitleLabel"] = [NSValue valueWithCGRect:initialFrame];
    self.sourceFrames = [dict copy];
    
}

- (void)__switchToSourceFrames:(BOOL)isSource
{
    NSDictionary *frames = nil;
    if (isSource) {
        frames = self.sourceFrames;
        self.backgroundView.alpha = 1;

    } else {
        frames = self.targetFrames;
        self.backgroundView.alpha = 0;
    }
    
    self.cell.frame = [[frames objectForKey:@"cell"] CGRectValue];
    self.imageView.frame = [[frames objectForKey:@"imageView"] CGRectValue];
    self.titleLabel.frame = [[frames objectForKey:@"titleLabel"] CGRectValue];
    self.subtitleLabel.frame = [[frames objectForKey:@"subtitleLabel"] CGRectValue];
}

- (IBAction)close:(id)sender {
    
    [UIView animateWithDuration:0.1 animations:^{
        for (UIView *eachView in self.view.subviews)
            if (eachView.tag == 99 || eachView.tag == 98)
                eachView.alpha = 0;
    }];
    
    [UIView animateWithDuration:self.animationDuration animations:^{
        [self __switchToSourceFrames:YES];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.7 animations:^{
            self.cell.alpha = 0;
        } completion:^(BOOL finished) {
            [self.navigationController popViewControllerAnimated:NO];
        }];
    }];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        UIGraphicsBeginImageContextWithOptions(window.bounds.size, YES, 0.0f);
        CGContextRef context = UIGraphicsGetCurrentContext();
        [window.layer renderInContext:context];
        self.backgroundColor = [UIColor colorWithPatternImage:UIGraphicsGetImageFromCurrentImageContext()];
        UIGraphicsEndImageContext();
        
        self.animationDuration = 1.0f;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.cellBackgroundColor = _item.overlayColor;
    self.backgroundView.backgroundColor = self.backgroundColor;
    self.cell.backgroundColor = self.cellBackgroundColor;
    
    
    CALayer *sublayer = [CALayer layer];
    [sublayer setBackgroundColor:[_item.overlayColor CGColor]];
    [sublayer setOpacity:0.9f];
    CGRect f = self.cell.bounds;
    f.origin.x -= 2;
    f.size.width += 4;
    [sublayer setFrame:f];
    [self.imageView.layer insertSublayer:sublayer atIndex:0];
    
    
    NSObject *transparent = (NSObject *) [[UIColor colorWithWhite:0 alpha:0] CGColor];
    NSObject *opaque = (NSObject *) [[UIColor colorWithWhite:0 alpha:1] CGColor];
    CALayer *maskLayer = [CALayer layer];
    maskLayer.frame = self.imageView.bounds;
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(self.imageView.bounds.origin.x, 0,
                                     self.imageView.bounds.size.width, self.imageView.bounds.size.height);
    
    gradientLayer.colors = [NSArray arrayWithObjects: transparent, opaque,
                            opaque, transparent, nil];
    gradientLayer.locations = [NSArray arrayWithObjects:
                               [NSNumber numberWithFloat:0],
                               [NSNumber numberWithFloat:0],
                               [NSNumber numberWithFloat:1.0 - fadePercentage],
                               [NSNumber numberWithFloat:1], nil];
    
    [maskLayer addSublayer:gradientLayer];
    self.imageView.layer.mask = maskLayer;
    
    
    [self __bindItem];
    [self __buildTargetFrames];
    [self __switchToSourceFrames:YES];
    
    [UIView animateWithDuration:self.animationDuration animations:^{
        [self __switchToSourceFrames:NO];
    }];

}


@end
