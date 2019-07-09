//
//  TimeSliderView.h
//  Demo
//
//  Created by Maxim Makhun on 5/26/14.
//  Copyright © 2014 Maxim Makhun. All rights reserved.
//

@import UIKit;

@class TimeSliderView;

typedef NS_ENUM(NSInteger, TimeSliderViewOrientation) {
    OrientationHorizontal = 1,
    OrientationVertical = 2
};

@protocol TimeSliderViewDelegate <NSObject>

@optional
- (void)timeSliderViewDidChangeValue:(TimeSliderView *)sliderView;
- (void)timeSliderViewWillStartMoving:(TimeSliderView *)sliderView;
- (void)timeSliderViewDidStopMoving:(TimeSliderView *)sliderView;

@end

@interface TimeSliderView : UIView

@property (nonatomic, strong) id<TimeSliderViewDelegate> delegate;
@property (nonatomic, strong) UILabel *timeSelectorLabel;
@property (nonatomic) CGFloat sliderValue;
@property (nonatomic) BOOL is24HourFormat;
@property (nonatomic) TimeSliderViewOrientation sliderOrientation;
@property (nonatomic, readonly) int hour;
@property (nonatomic, readonly) int minute;

- (void)setSliderValue:(CGFloat)value animated:(BOOL)animated;
- (void)placeIndicatorViewWithHour:(NSUInteger)hour minute:(NSUInteger)minute;
- (void)placeIndicatorWithDate:(NSDate *)date;

@end
