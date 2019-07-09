//
//  TimeSliderView.m
//  Demo
//
//  Created by Maxim Makhun on 5/26/14.
//  Copyright © 2014 Maxim Makhun. All rights reserved.
//

#import "TimeSliderView.h"

static const int MinutesStep = 5;

@interface TimeSliderView ()

@property (nonatomic) BOOL isIndicatorTouched;
@property (nonatomic) CGFloat indicatorOffset;

- (void)initialize;

@end

@implementation TimeSliderView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        [self initialize];
    }

    return self;
}

- (id)init {
    self = [super init];

    if (self) {
        [self initialize];
    }

    return self;
}

- (void)initialize {
    self.timeSelectorLabel = [UILabel new];
    self.timeSelectorLabel.textAlignment = NSTextAlignmentCenter;
    self.sliderOrientation = OrientationVertical;
    self.timeSelectorLabel.frame = CGRectMake(0, 0, self.bounds.size.width, 35);
    [self addSubview:self.timeSelectorLabel];
    self.timeSelectorLabel.text = [self handleUpdate];
}

- (void)setSliderOrientation:(TimeSliderViewOrientation)sliderOrientation {
    _sliderOrientation = sliderOrientation;
    
    [self.timeSelectorLabel removeFromSuperview];
    self.timeSelectorLabel = [UILabel new];
    self.timeSelectorLabel.textAlignment = NSTextAlignmentCenter;
    
    if (sliderOrientation == OrientationHorizontal) {
        self.timeSelectorLabel.frame = CGRectMake(0, 0, 65, self.bounds.size.height);
    } else if (sliderOrientation == OrientationVertical) {
        self.timeSelectorLabel.frame = CGRectMake(0, 0, self.bounds.size.width, 35);
    }
    
    [self addSubview:self.timeSelectorLabel];
    self.timeSelectorLabel.text = [self handleUpdate];
}

- (NSString *)handleUpdate {
    int hour = self.sliderValue * 24;
    int minute = (self.sliderValue * 24 - hour) * 60;
    NSString *str = self.timeSelectorLabel.text;
    
    if (minute % MinutesStep != 0) {
        minute += 1;
        
        if (minute == 60) {
            hour += 1;
            minute = 0;
        }
    }
    
    _hour = hour;
    _minute = minute;
    
    if (self.is24HourFormat) {
        if (minute % MinutesStep == 0) {
            if (hour == 24) {
                if (minute == 0) {
                    hour = 23;
                    minute = 59;
                }
            }
            
            str = [NSString stringWithFormat:@"%0*d:%0*d", 2, hour, 2, minute];
        }
    } else {
        if (minute % MinutesStep == 0) {
            NSString *splitStr = @"";
            if (hour == 0) {
                splitStr = @"am";
                hour = 12;
            } else if ((hour > 0) && (hour < 12)) {
                splitStr = @"am";
            } else if (hour == 12) {
                splitStr = @"pm";
                hour = 12;
            } else if ((hour > 12) && (hour < 24)) {
                splitStr = @"pm";
                hour = hour - 12;
            } else if (hour == 24) {
                if (hour == 0) {
                    splitStr = @"pm";
                    hour = 11;
                    minute = 59;
                } else {
                    splitStr = @"pm";
                    hour = hour - 12;
                }
            }
            
            str = [NSString stringWithFormat:@"%d:%0*d %@", hour, 2, minute, splitStr];
        }
    }
    
    return str;
}

- (void)setSliderValue:(CGFloat)value {
    [self setSliderValue:value animated:NO];
}

- (void)setSliderValue:(CGFloat)value animated:(BOOL)animated {
    _sliderValue = value;
    
    CGRect newFrame = self.timeSelectorLabel.frame;
    if (self.sliderOrientation == OrientationHorizontal) {
        newFrame.origin.x = value * (self.frame.size.width - self.timeSelectorLabel.frame.size.width);
    } else if (self.sliderOrientation == OrientationVertical) {
        newFrame.origin.y = value * (self.frame.size.height - self.timeSelectorLabel.frame.size.height);
    }
    
    if ([self.delegate respondsToSelector:@selector(timeSliderViewWillStartMoving:)]) {
        [self.delegate timeSliderViewWillStartMoving:self];
    }
    
    if (animated) {
        [UIView animateWithDuration:0.3f
                              delay:0.0f
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.timeSelectorLabel.frame = newFrame;
                         } completion:^(BOOL finished) {
                             if ([self.delegate respondsToSelector:@selector(timeSliderViewDidStopMoving:)]) {
                                 [self.delegate timeSliderViewDidStopMoving:self];
                             }
                         }];
    } else {
        self.timeSelectorLabel.frame = newFrame;
        
        if ([self.delegate respondsToSelector:@selector(timeSliderViewDidStopMoving:)]) {
            [self.delegate timeSliderViewDidStopMoving:self];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(timeSliderViewDidChangeValue:)]) {
        [self.delegate timeSliderViewDidChangeValue:self];
    }
    
    self.timeSelectorLabel.text = [self handleUpdate];
}

#pragma mark - UIResponder touch handling methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchCoord = [touch locationInView:self];
    
    if (CGRectContainsPoint(self.timeSelectorLabel.frame, touchCoord)) {
        self.isIndicatorTouched = YES;
        
        CGPoint touchCoordInIndicator = [touch locationInView:self.timeSelectorLabel];
        if (self.sliderOrientation == OrientationHorizontal) {
            self.indicatorOffset = touchCoordInIndicator.x;
        } else if (self.sliderOrientation == OrientationVertical) {
            self.indicatorOffset = touchCoordInIndicator.y;
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    self.isIndicatorTouched = NO;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.isIndicatorTouched) {
        UITouch *touch = [touches anyObject];
        CGPoint touchCoord = [touch locationInView:self];
        
        if (self.sliderOrientation == OrientationHorizontal) {
            CGFloat width = self.frame.size.width - self.timeSelectorLabel.frame.size.width;
            touchCoord.x -= self.indicatorOffset;
            touchCoord.x = MIN(touchCoord.x, width);
            touchCoord.x = MAX(touchCoord.x, 0);
            
            [self setSliderValue:touchCoord.x / width animated:NO];
        } else if (self.sliderOrientation == OrientationVertical) {
            CGFloat height = self.frame.size.height - self.timeSelectorLabel.frame.size.height;
            touchCoord.y -= self.indicatorOffset;
            touchCoord.y = MIN(touchCoord.y, height);
            touchCoord.y = MAX(touchCoord.y, 0);
            
            [self setSliderValue:touchCoord.y / height animated:NO];
        }
        
        if ([self.delegate respondsToSelector:@selector(timeSliderViewDidChangeValue:)]) {
            [self.delegate timeSliderViewDidChangeValue:self];
        }
        
        self.timeSelectorLabel.text = [self handleUpdate];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.isIndicatorTouched) {
        UITouch *touch = [touches anyObject];
        CGPoint touchCoord = [touch locationInView:self];
        
        if (self.sliderOrientation == OrientationHorizontal) {
            CGFloat trueWidth = self.frame.size.width - self.timeSelectorLabel.frame.size.width;
            touchCoord.x = MIN(touchCoord.x, trueWidth);
            CGFloat sliderX = self.timeSelectorLabel.frame.origin.x;
            
            CGFloat divWidth = trueWidth / (24 * 12);
            long hr = self.hour * 12;
            
            if (touchCoord.x > sliderX) { // press was made below time indicator
                long min = (self.minute + MinutesStep) / 5;
                sliderX = (divWidth * (hr + min)) / trueWidth;
            } else { // press was made above time indicator
                long min = (self.minute - MinutesStep) / 5;
                sliderX = divWidth * (hr + min) / trueWidth;
            }
            
            [self setSliderValue:sliderX animated:YES];
        } else if (self.sliderOrientation == OrientationVertical) {
            CGFloat trueHeight = self.frame.size.height - self.timeSelectorLabel.frame.size.height;
            touchCoord.y = MIN(touchCoord.y, trueHeight);
            CGFloat sliderY = self.timeSelectorLabel.frame.origin.y;
            
            CGFloat divHeight = trueHeight / (24 * 12);
            long hr = self.hour * 12;
            
            if (touchCoord.y > sliderY) { // press was made below time indicator
                long min = (self.minute + MinutesStep) / 5;
                sliderY = (divHeight * (hr + min)) / trueHeight;
            } else { // press was made above time indicator
                long min = (self.minute - MinutesStep) / 5;
                sliderY = divHeight * (hr + min) / trueHeight;
            }
            
            [self setSliderValue:sliderY animated:YES];
        }
    }
    
    self.isIndicatorTouched = NO;
}

- (CGFloat)calculatePositionWithHour:(NSUInteger)hour minute:(NSUInteger)minute {
    if (self.sliderOrientation == OrientationHorizontal) {
        CGFloat width = self.frame.size.width - self.timeSelectorLabel.frame.size.width;
        CGFloat divWidth = width / (24 * 12);
        long hr = hour * 12;
        long min = minute / 5;
        
        return (divWidth * (hr + min)) / width;
    } else if (self.sliderOrientation == OrientationVertical) {
        CGFloat height = self.frame.size.height - self.timeSelectorLabel.frame.size.height;
        CGFloat divHeight = height / (24 * 12);
        long hr = hour * 12;
        long min = minute / 5;
        
        return (divHeight * (hr + min)) / height;
    }
    
    return 0.0f;
}

- (void)placeIndicatorViewWithHour:(NSUInteger)hour minute:(NSUInteger)minute {
    [self setSliderValue:[self calculatePositionWithHour:hour minute:minute] animated:YES];
}

- (void)placeIndicatorWithDate:(NSDate *)date {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitHour | NSCalendarUnitMinute fromDate:date];
    
    [self setSliderValue:[self calculatePositionWithHour:dateComponents.hour minute:dateComponents.minute] animated:YES];
}

@end
