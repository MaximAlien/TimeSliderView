//
//  TimeSliderView.m
//  Demo
//
//  Created by maxim.makhun on 5/26/14.
//  Copyright (c) 2014 MMA. All rights reserved.
//

#import "TimeSliderView.h"

@interface TimeSliderView ()
{
    BOOL isIndicatorTouched;
    CGFloat indicatorYOffset;
}

- (void)initialize;

@end

@implementation TimeSliderView

- (void)initialize
{
    CGRect indicatorFrame = self.bounds;
    indicatorFrame.size.height = 80.0f;
    
    _indicatorView = [[UIView alloc] initWithFrame:indicatorFrame];
    [self addSubview:_indicatorView];
    _indicatorView.backgroundColor = [UIColor clearColor];
    
    isIndicatorTouched = NO;
    indicatorYOffset = 0.0f;
    
    _sliderValue = 0.0f;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self initialize];
    }
    
    return self;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        [self initialize];
    }
    
    return self;
}

- (void)setSliderValue:(CGFloat)value
{
    [self setSliderValue:value animated:NO];
}

- (void)setSliderValue:(CGFloat)value animated:(BOOL)animated
{
    _sliderValue = value;
    
    CGFloat height = self.frame.size.height - self.indicatorView.frame.size.height;
    CGRect newFrame = self.indicatorView.frame;
    newFrame.origin.y = value * height;
    
    if ([self.delegate respondsToSelector:@selector(timeSliderViewWillStartMoving:)])
    {
        [self.delegate timeSliderViewWillStartMoving:self];
    }
    
    if (animated)
    {
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseIn animations:^{
            self.indicatorView.frame = newFrame;
        }
                         completion:^(BOOL finished) {
                             if ([self.delegate respondsToSelector:@selector(timeSliderViewDidStopMoving:)])
                             {
                                 [self.delegate timeSliderViewDidStopMoving:self];
                             }
                         }
         ];
    }
    else
    {
        self.indicatorView.frame = newFrame;
        
        if ([self.delegate respondsToSelector:@selector(timeSliderViewDidStopMoving:)])
        {
            [self.delegate timeSliderViewDidStopMoving:self];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(timeSliderViewDidChangeValue:)])
    {
        [self.delegate timeSliderViewDidChangeValue:self];
    }
}

- (void)setPositionIndicator:(UIView *)indicatorView
{
    CGRect origFrame = indicatorView.frame;
    origFrame.origin.y = indicatorView.frame.origin.y;
    indicatorView.frame = origFrame;
    
    [_indicatorView removeFromSuperview];
    
    _indicatorView = indicatorView;
    
    [self addSubview:indicatorView];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchCoord = [touch locationInView:self];
    
    if (CGRectContainsPoint(self.indicatorView.frame, touchCoord))
    {
        isIndicatorTouched = YES;
        
        CGPoint touchCoordInIndicator = [touch locationInView:self.indicatorView];
        indicatorYOffset = touchCoordInIndicator.y;
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    isIndicatorTouched = NO;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (isIndicatorTouched)
    {
        UITouch *touch = [touches anyObject];
        CGPoint touchCoord = [touch locationInView:self];
        
        CGFloat height = self.frame.size.height - self.indicatorView.frame.size.height;
        touchCoord.y -= indicatorYOffset;
        touchCoord.y = MIN(touchCoord.y, height);
        touchCoord.y = MAX(touchCoord.y, 0);
        
        self.sliderValue = touchCoord.y / height;
        
        if ([self.delegate respondsToSelector:@selector(timeSliderViewDidChangeValue:)])
        {
            [self.delegate timeSliderViewDidChangeValue:self];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!isIndicatorTouched)
    {
        UITouch *touch = [touches anyObject];
        CGPoint touchCoord = [touch locationInView:self];
        CGFloat trueHeight = self.frame.size.height - self.indicatorView.frame.size.height;
        touchCoord.y = MIN(touchCoord.y, trueHeight);                   // Stores Y pos where user tapped. Used only to check whether it was pressed above or below time picker.
        CGFloat sliderY = self.indicatorView.frame.origin.y;            // Stores slider Y position
        
        CGFloat divHeight = trueHeight / (24 * 12);
        long hr = self.hour * 12;
        
        if (touchCoord.y > sliderY)
        {
            long min = (self.minute + 5) / 5;    // from 1 to 12
            sliderY = (divHeight * (hr + min)) / trueHeight;
        }
        else
        {
            long min = (self.minute - 5) / 5;
            sliderY = divHeight * (hr + min) / trueHeight;
        }
        
        [self setSliderValue: sliderY animated:YES];
    }
    
    isIndicatorTouched = NO;
}

- (void)placeIndicatorView
{
    CGFloat trueHeight = self.frame.size.height - self.indicatorView.frame.size.height;
    CGFloat sliderY = 0.0;
    
    CGFloat divHeight = trueHeight / (24 * 12);
    long hr = self.hour * 12;
    
    long min = self.minute / 5;
    sliderY = (divHeight * (hr + min)) / trueHeight;
    
    [self setSliderValue: sliderY animated:YES];
}

@end
