//
//  SDCollectionViewCell.h
//  Sebastian Dobrincu
//
//  Created by Sebastian Dobrincu on 21/04/15.
//  Copyright (c) 2015 Sebastian Dobrincu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+Additions.h"
#import "UIView+RSAdditions.h"

@interface SDCollectionViewCell : UICollectionViewCell <UIScrollViewDelegate, UITextViewDelegate>{
    CAGradientLayer *maskLayer;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *mainLabel;
@property (strong, nonatomic) IBOutlet UIImageView *productImageView;
@property (strong, nonatomic) IBOutlet UITextView *descriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *playIcon;
@property (strong, nonatomic) IBOutlet UIButton *moreAboutLabel;

@end
