//
//  TimeSliderView.h
//  Demo
//
//  Created by maxim.makhun on 5/26/14.
//  Copyright (c) 2014 MMA. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TimeSliderView;

@protocol TimeSliderViewDelegate <NSObject>

@optional
- (void)timeSliderViewDidChangeValue:(TimeSliderView *)sliderView;
- (void)timeSliderViewWillStartMoving:(TimeSliderView *)sliderView;
- (void)timeSliderViewDidStopMoving:(TimeSliderView *)sliderView;

@end

@interface TimeSliderView : UIView

@property (nonatomic, retain) id<TimeSliderViewDelegate> delegate;
@property (nonatomic) CGFloat sliderValue;
@property (nonatomic, strong) UILabel *timeSelectorLabel;
@property (nonatomic) BOOL is24HourFormat;
@property (nonatomic) int minutesStep;

// public methods
- (void)setSliderValue:(CGFloat)value animated:(BOOL)animated;
- (void)placeIndicatorViewWithHour:(NSUInteger)hour andMinute:(NSUInteger)minute;
// TODO: Additional method with date was added in aother submission (not yet pushed)

@end
