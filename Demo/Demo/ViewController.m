//
//  ViewController.m
//  Demo
//
//  Created by maxim.makhun on 5/26/14.
//  Copyright (c) 2014 MMA. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

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
    
    // [self.timeSliderView placeIndicatorViewWithHour:1 andMinute:13];
    
    [self.timeSliderView placeIndicatorWithDate:[NSDate date]];
}

- (void)timeSliderViewDidChangeValue:(TimeSliderView *)sliderView;
{
    // NSLog(@"%f", sliderView.sliderValue);
}

@end
