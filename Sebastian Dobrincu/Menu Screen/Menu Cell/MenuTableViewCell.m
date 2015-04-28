//
//  MenuTableViewCell.m
//  Sebastian Dobrincu
//
//  Created by Sebastian Dobrincu on 19/04/15.
//  Copyright (c) 2015 Sebastian Dobrincu. All rights reserved.
//

#import "MenuTableViewCell.h"

@implementation MenuTableViewCell

-(void)layoutSubviews{

    [super layoutSubviews];
    
    //Resize the cells to match the different screen sizes
    if ([SDiPhoneVersion deviceSize] == iPhone47inch || [SDiPhoneVersion deviceSize] == iPhone55inch) {
        self.cellView.frame = CGRectMake(25, 0, self.frame.size.width-50, self.cellView.frame.size.height);
        self.bgImage.frame = CGRectMake(0, 0, self.cellView.frame.size.width, self.cellView.frame.size.height);

        CALayer *mask = [self.bgImage.layer sublayers][0];
        mask.frame = self.bgImage.frame;
        [[self.bgImage.layer sublayers][0] removeFromSuperlayer];
        [self.bgImage.layer insertSublayer:mask atIndex:0];
        
        CGFloat height = 295;
        if([SDiPhoneVersion deviceSize] == iPhone55inch) height = 305;
        
        self.subtitleLabel.frame = CGRectMake(self.subtitleLabel.frame.origin.x, self.subtitleLabel.frame.origin.y, height, self.subtitleLabel.frame.size.height);
    }

}

@end
