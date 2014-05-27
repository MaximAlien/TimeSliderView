//
//  TimeSliderView.m
//  Demo
//
//  Created by maxim.makhun on 5/26/14.
//  Copyright (c) 2014 MMA. All rights reserved.
//

#import "TimeSliderView.h"

static NSString *HourFormat24 = @"HH:mm";
static NSString *HourFormat12 = @"hh:mm a";
static int Hour = 0;
static int Minute = 0;

const BOOL Is24HourFormat = NO;

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
    _indicatorView.backgroundColor = [UIColor grayColor];
    
    isIndicatorTouched = NO;
    indicatorYOffset = 0.0f;
    
    _sliderValue = 0.0f;
    
    _timeSelectorLabel = [[UILabel alloc] init];
    _timeSelectorLabel.textAlignment = NSTextAlignmentCenter;
    _timeSelectorLabel.frame = CGRectMake(0, 0, 80, 50);
    [_timeSelectorLabel setTextColor:[UIColor whiteColor]];
    [_timeSelectorLabel setBackgroundColor:[UIColor lightGrayColor]];
    
    [self setIndicatorView:_timeSelectorLabel];
    
    int hour = _sliderValue * 24;
    float valFloat = _sliderValue * 24;
    int minute = (valFloat - hour) * 60;
    NSString *splitStr = @"";
    BOOL is24HourFormat = Is24HourFormat;
    
    if (!is24HourFormat)
    {
        if (hour == 0)
        {
            splitStr = @"am";
            hour = 12;
        }
        else if ((hour > 0) && (hour < 12))
        {
            splitStr = @"am";
        }
        else if (hour == 12)
        {
            splitStr = @"pm";
            hour = 12;
        }
        else if ((hour > 12) && (hour < 24))
        {
            splitStr = @"pm";
            hour = hour - 12;
        }
        else if (hour == 24)
        {
            if (minute == 0)
            {
                splitStr = @"pm";
                hour = 11;
                minute = 59;
            }
            else
            {
                splitStr = @"pm";
                hour = hour - 12;
            }
        }
        
        NSString *str = [NSString stringWithFormat:@"%d:%0*d %@", hour, 2, minute, splitStr];
        
        _timeSelectorLabel.text = str;
    }
    else
    {
        if (minute == 24)
        {
            if (minute == 0)
            {
                hour = 23;
                minute = 59;
            }
        }
        
        NSString *str = [NSString stringWithFormat:@"%0*d:%0*d", 2, hour, 2, minute];
        _timeSelectorLabel.text = str;
    }
}

- (void)updateSlider
{
    float sliderValue = _sliderValue;
    
    currentHour = sliderValue * 24;
    float valFloat = sliderValue * 24;
    currentMinute = (valFloat - currentHour) * 60; // transforming to minutes
    
    if (currentMinute % 5 != 0)
    {
        currentMinute += 1;
        
        if (currentMinute == 60)
        {
            currentHour += 1;
            currentMinute = 0;
        }
    }
    
    _hour = currentHour;
    _minute = currentMinute;
    
    BOOL is24HourFormat = Is24HourFormat;
    
    if (!is24HourFormat)
    {
        if (currentMinute % 5 == 0)
        {
            splitString = @"";
            
            if (currentHour == 0)
            {
                splitString = @"am";
                currentHour = 12;
            }
            else if ((currentHour > 0) && (currentHour < 12))
            {
                splitString = @"am";
            }
            else if (currentHour == 12)
            {
                splitString = @"pm";
                currentHour = 12;
            }
            else if ((currentHour > 12) && (currentHour < 24))
            {
                splitString = @"pm";
                currentHour = currentHour - 12;
            }
            else if (currentHour == 24)
            {
                if (currentMinute == 0)
                {
                    splitString = @"pm";
                    currentHour = 11;
                    currentMinute = 59;
                }
                else
                {
                    splitString = @"pm";
                    currentHour = currentHour - 12;
                }
            }
            
            Hour = currentHour;
            Minute = currentMinute;
            
            NSString *str = [NSString stringWithFormat:@"%d:%0*d %@", currentHour, 2, currentMinute, splitString];
            _timeSelectorLabel.text = str;
        }
    }
    else
    {
        if (currentMinute % 5 == 0)
        {
            if (currentHour == 24)
            {
                if (currentMinute == 0)
                {
                    currentHour = 23;
                    currentMinute = 59;
                }
            }
            
            Hour = currentHour;
            Minute = currentMinute;
            
            NSString *str = [NSString stringWithFormat:@"%0*d:%0*d", 2, currentHour, 2, currentMinute];
            _timeSelectorLabel.text = str;
        }
    }
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
        [self updateSlider];
    }
}

- (void)setIndicatorView:(UIView *)indicatorView
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
            [self updateSlider];
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
