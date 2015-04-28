//
//  SDShineLabel.m
//  Sebastian Dobrincu
//
//  Created by Sebastian Dobrincu on 22/04/15.
//  Copyright (c) 2015 Sebastian Dobrincu. All rights reserved.
//

#import "SDShineLabel.h"

@interface SDShineLabel()

@property (strong, nonatomic) NSMutableAttributedString *attributedString;
@property (nonatomic, strong) NSMutableArray *characterAnimationDurations;
@property (nonatomic, strong) NSMutableArray *characterAnimationDelays;
@property (strong, nonatomic) CADisplayLink *displaylink;
@property (assign, nonatomic) CFTimeInterval beginTime;
@property (assign, nonatomic) CFTimeInterval endTime;
@property (assign, nonatomic, getter = isFadedOut) BOOL fadedOut;
@property (nonatomic, copy) void (^completion)();

@end

@implementation SDShineLabel

- (instancetype)init{
    self = [super init];
    if (!self)
        return nil;
    
    [self commonInit];
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (!self)
        return nil;
    
    [self commonInit];
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (!self)
        return nil;
    
    [self commonInit];
    
    [self setText:self.text];
    
    return self;
}

- (void)commonInit{
    
    _shineDuration   = 1.5;
    _fadeoutDuration = 1.5;
    _autoStart       = NO;
    _fadedOut        = YES;
    self.textColor  = [UIColor whiteColor];
    
    _characterAnimationDurations = [NSMutableArray array];
    _characterAnimationDelays    = [NSMutableArray array];
    
    _displaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateAttributedString)];
    _displaylink.paused = YES;
    [_displaylink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)didMoveToWindow{
    if (self.window != nil && self.autoStart)
        [self shine];
}

- (void)setText:(NSString *)text{
    self.attributedText = [[NSAttributedString alloc] initWithString:text];
}

-(void)setAttributedText:(NSAttributedString *)attributedText{
    self.attributedString = [self initialAttributedStringFromAttributedString:attributedText];
    [super setAttributedText:self.attributedString];
    for (NSUInteger i = 0; i < attributedText.length; i++) {
        self.characterAnimationDelays[i] = @(arc4random_uniform(self.shineDuration / 2 * 100) / 100.0);
        CGFloat remain = self.shineDuration - [self.characterAnimationDelays[i] floatValue];
        self.characterAnimationDurations[i] = @(arc4random_uniform(remain * 100) / 100.0);
    }
}

- (void)shine{
    [self shineWithCompletion:NULL];
}

- (void)shineWithCompletion:(void (^)())completion{
    
    if (!self.isShining && self.isFadedOut) {
        self.completion = completion;
        self.fadedOut = NO;
        [self startAnimationWithDuration:self.shineDuration];
    }
}

- (BOOL)isShining{
    return !self.displaylink.isPaused;
}

- (BOOL)isVisible{
    return NO == self.isFadedOut;
}


#pragma mark - Private methods

- (void)startAnimationWithDuration:(CFTimeInterval)duration{
    self.beginTime = CACurrentMediaTime();
    self.endTime = self.beginTime + self.shineDuration;
    self.displaylink.paused = NO;
}

- (void)updateAttributedString{
    CFTimeInterval now = CACurrentMediaTime();
    for (NSUInteger i = 0; i < self.attributedString.length; i ++) {
        [self.attributedString enumerateAttribute:NSForegroundColorAttributeName
                                          inRange:NSMakeRange(i, 1)
                                          options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired
                                       usingBlock:^(id value, NSRange range, BOOL *stop) {
                                           
                                           CGFloat currentAlpha = CGColorGetAlpha([(UIColor *)value CGColor]);
                                           BOOL shouldUpdateAlpha = (self.isFadedOut && currentAlpha > 0) || (!self.isFadedOut && currentAlpha < 1) || (now - self.beginTime) >= [self.characterAnimationDelays[i] floatValue];
                                           
                                           if (!shouldUpdateAlpha) {
                                               return;
                                           }
                                           
                                           CGFloat percentage = (now - self.beginTime - [self.characterAnimationDelays[i] floatValue]) / ( [self.characterAnimationDurations[i] floatValue]);
                                           if (self.isFadedOut) {
                                               percentage = 1 - percentage;
                                           }
                                           UIColor *color = [self.textColor colorWithAlphaComponent:percentage];
                                           [self.attributedString addAttribute:NSForegroundColorAttributeName value:color range:range];
                                       }];
    }
    [super setAttributedText:self.attributedString];
    if (now > self.endTime) {
        self.displaylink.paused = YES;
        if (self.completion)
            self.completion();
    }
}

- (NSMutableAttributedString *)initialAttributedStringFromAttributedString:(NSAttributedString *)attributedString
{
    NSMutableAttributedString *mutableAttributedString = [attributedString mutableCopy];
    UIColor *color = [self.textColor colorWithAlphaComponent:0];
    [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, mutableAttributedString.length)];
    return mutableAttributedString;
}


@end
