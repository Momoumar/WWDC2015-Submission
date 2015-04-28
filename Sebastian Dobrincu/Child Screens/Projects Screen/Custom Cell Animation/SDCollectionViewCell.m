//
//  SDCollectionViewCell.m
//  Sebastian Dobrincu
//
//  Created by Sebastian Dobrincu on 21/04/15.
//  Copyright (c) 2015 Sebastian Dobrincu. All rights reserved.
//

#import "SDCollectionViewCell.h"

@implementation SDCollectionViewCell

-(void)awakeFromNib{
    
    _moreAboutLabel.layer.borderWidth = 2;
    _moreAboutLabel.layer.borderColor = [UIColor colorWithRed:0.87 green:0.29 blue:0.64 alpha:1].CGColor;
    _moreAboutLabel.layer.cornerRadius = 20;
    
    _descriptionLabel.delegate = self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [_descriptionLabel startScrolling];
    if (!maskLayer) {
        
        maskLayer = [CAGradientLayer layer];
        maskLayer.locations = [NSArray arrayWithObjects:
                               [NSNumber numberWithFloat:0.0],
                               [NSNumber numberWithFloat:0.1],
                               [NSNumber numberWithFloat:0.9],
                               [NSNumber numberWithFloat:1.0],
                               nil];
        
        maskLayer.colors = [NSArray arrayWithObjects:
                            (__bridge id)[UIColor clearColor].CGColor,
                            (__bridge id)[UIColor whiteColor].CGColor,
                            (__bridge id)[UIColor whiteColor].CGColor,
                            (__bridge id)[UIColor clearColor].CGColor,
                            nil];
        maskLayer.bounds = CGRectMake(0, 0,
                                      _descriptionLabel.frame.size.width,
                                      _descriptionLabel.frame.size.height);
        maskLayer.anchorPoint = CGPointZero;
        
        _descriptionLabel.layer.mask = maskLayer;
    }
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    maskLayer.position = CGPointMake(0, scrollView.contentOffset.y);
    [CATransaction commit];
    
}


@end
