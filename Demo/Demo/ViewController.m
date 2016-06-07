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

@property (strong, nonatomic) TimeSliderView *timeSliderView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.timeSliderView = [[TimeSliderView alloc] initWithFrame:CGRectMake(10, 30, 100, 300)];
    self.timeSliderView.delegate = self;
    self.timeSliderView.timeSelectorLabel.textColor = [UIColor whiteColor];
    self.timeSliderView.timeSelectorLabel.backgroundColor = [UIColor lightGrayColor];
    [self.timeSliderView setBackgroundColor:[UIColor greenColor]];
    [self.view addSubview:self.timeSliderView];
    [self.timeSliderView placeIndicatorWithDate:[NSDate date]];
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
