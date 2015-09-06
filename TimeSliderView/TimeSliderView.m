//
//  TimeSliderView.m
//  Demo
//
//  Created by maxim.makhun on 5/26/14.
//  Copyright (c) 2014 MMA. All rights reserved.
//

#import "TimeSliderView.h"

static int Hour = 0;
static int Minute = 0;
static const int MinutesStep = 5;

@interface TimeSliderView ()
{
    BOOL isIndicatorTouched;
    CGFloat indicatorYOffset;
    int currentHour;
    int currentMinute;
    NSString *splitString;
}

@property (nonatomic, assign) int hour;
@property (nonatomic, assign) int minute;

- (void)initialize;

@end

@implementation TimeSliderView

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

- (void)initialize
{
    isIndicatorTouched = NO;
    indicatorYOffset = 0.0f;
    _sliderValue = 0.0f;
    
    self.timeSelectorLabel = [[UILabel alloc] init];
    self.timeSelectorLabel.textAlignment = NSTextAlignmentCenter;
    self.timeSelectorLabel.frame = CGRectMake(0, 0, self.bounds.size.width, 40);
    
    [self addSubview:self.timeSelectorLabel];
    
    int hour = _sliderValue * 24;
    float valFloat = _sliderValue * 24;
    int minute = (valFloat - hour) * 60;
    NSString *splitStr = @"";
    
    if (!self.is24HourFormat)
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
        
        self.timeSelectorLabel.text = str;
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
        self.timeSelectorLabel.text = str;
    }
}

- (void)updateSlider
{
    float sliderValue = _sliderValue;
    
    currentHour = sliderValue * 24;
    float valFloat = sliderValue * 24;
    currentMinute = (valFloat - currentHour) * 60;
    
    if (currentMinute % MinutesStep != 0)
    {
        currentMinute += 1;
        
        if (currentMinute == 60)
        {
            currentHour += 1;
            currentMinute = 0;
        }
    }
    
    self.hour = currentHour;
    self.minute = currentMinute;
    
    if (!self.is24HourFormat)
    {
        if (currentMinute % MinutesStep == 0)
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
            self.timeSelectorLabel.text = str;
        }
    }
    else
    {
        if (currentMinute % MinutesStep == 0)
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
            self.timeSelectorLabel.text = str;
        }
    }
}

- (void)setSliderValue:(CGFloat)value
{
    [self setSliderValue:value animated:NO];
}

- (void)setSliderValue:(CGFloat)value animated:(BOOL)animated
{
    _sliderValue = value;
    
    CGFloat height = self.frame.size.height - self.timeSelectorLabel.frame.size.height;
    CGRect newFrame = self.timeSelectorLabel.frame;
    newFrame.origin.y = value * height;
    
    if ([self.delegate respondsToSelector:@selector(timeSliderViewWillStartMoving:)])
    {
        [self.delegate timeSliderViewWillStartMoving:self];
    }
    
    if (animated)
    {
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseIn animations:^{
            self.timeSelectorLabel.frame = newFrame;
        } completion:^(BOOL finished) {
            if ([self.delegate respondsToSelector:@selector(timeSliderViewDidStopMoving:)])
            {
                [self.delegate timeSliderViewDidStopMoving:self];
            }
        }];
    }
    else
    {
        self.timeSelectorLabel.frame = newFrame;
        
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchCoord = [touch locationInView:self];
    
    if (CGRectContainsPoint(self.timeSelectorLabel.frame, touchCoord))
    {
        isIndicatorTouched = YES;
        
        CGPoint touchCoordInIndicator = [touch locationInView:self.timeSelectorLabel];
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
        
        CGFloat height = self.frame.size.height - self.timeSelectorLabel.frame.size.height;
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
        CGFloat trueHeight = self.frame.size.height - self.timeSelectorLabel.frame.size.height;
        touchCoord.y = MIN(touchCoord.y, trueHeight);
        CGFloat sliderY = self.timeSelectorLabel.frame.origin.y;
        
        CGFloat divHeight = trueHeight / (24 * 12);
        long hr = self.hour * 12;
        
        if (touchCoord.y > sliderY)
        {
            long min = (self.minute + MinutesStep) / 5;
            sliderY = (divHeight * (hr + min)) / trueHeight;
        }
        else
        {
            long min = (self.minute - MinutesStep) / 5;
            sliderY = divHeight * (hr + min) / trueHeight;
        }
        
        [self updateSlider];
        [self setSliderValue:sliderY animated:YES];
    }
    
    isIndicatorTouched = NO;
}

- (void)placeIndicatorViewWithHour:(NSUInteger)hour andMinute:(NSUInteger)minute
{
    CGFloat trueHeight = self.frame.size.height - self.timeSelectorLabel.frame.size.height;
    CGFloat sliderY = 0.0;
    
    CGFloat divHeight = trueHeight / (24 * 12);
    long hr = hour * 12;
    long min = minute / 5;
    sliderY = (divHeight * (hr + min)) / trueHeight;
    
    [self setSliderValue:sliderY animated:YES];
}

@end
