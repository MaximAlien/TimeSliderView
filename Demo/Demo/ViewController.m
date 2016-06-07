//
//  ViewController.m
//  Demo
//
//  Created by maxim.makhun on 5/26/14.
//  Copyright (c) 2014 MMA. All rights reserved.
//

#import "ViewController.h"
#import "TimeSliderView.h"

@interface ViewController () <TimeSliderViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    TimeSliderView *verticalSliderView = [[TimeSliderView alloc] initWithFrame:CGRectMake(10, 30, 60, 300)];
    verticalSliderView.delegate = self;
    verticalSliderView.is24HourFormat = YES;
    verticalSliderView.sliderOrientation = OrientationVertical;
    verticalSliderView.timeSelectorLabel.textColor = [UIColor whiteColor];
    verticalSliderView.timeSelectorLabel.backgroundColor = [UIColor lightGrayColor];
    [verticalSliderView setBackgroundColor:[UIColor greenColor]];
    [self.view addSubview:verticalSliderView];
    [verticalSliderView placeIndicatorWithDate:[NSDate date]];
    
    TimeSliderView *horizontalSliderView = [[TimeSliderView alloc] initWithFrame:CGRectMake(10, 350, 300, 40)];
    horizontalSliderView.delegate = self;
    horizontalSliderView.is24HourFormat = YES;
    horizontalSliderView.sliderOrientation = OrientationHorizontal;
    horizontalSliderView.timeSelectorLabel.textColor = [UIColor whiteColor];
    horizontalSliderView.timeSelectorLabel.backgroundColor = [UIColor lightGrayColor];
    [horizontalSliderView setBackgroundColor:[UIColor greenColor]];
    [self.view addSubview:horizontalSliderView];
    [horizontalSliderView placeIndicatorWithDate:[NSDate date]];
}

- (void)timeSliderViewDidChangeValue:(TimeSliderView *)sliderView
{
    NSLog(@"timeSliderViewDidChangeValue : %f", sliderView.sliderValue);
}

- (void)timeSliderViewWillStartMoving:(TimeSliderView *)sliderView
{
    NSLog(@"timeSliderViewWillStartMoving");
}

- (void)timeSliderViewDidStopMoving:(TimeSliderView *)sliderView
{
    NSLog(@"timeSliderViewWillStartMoving");
}

@end
