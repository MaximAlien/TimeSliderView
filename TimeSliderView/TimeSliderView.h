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
@property (nonatomic, retain) UIView *indicatorView;
@property (nonatomic, assign) CGFloat sliderValue;
@property (nonatomic, assign) int hour;
@property (nonatomic, assign) int minute;

- (void)setPositionIndicator:(UIView *)indicatorView;
- (void)setSliderValue:(CGFloat)value;
- (void)setSliderValue:(CGFloat)value animated:(BOOL)animated;
- (void)placeIndicatorView;

@end
