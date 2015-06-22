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
    
    timeSliderView = [[TimeSliderView alloc] initWithFrame:CGRectMake(10, 30, 100, 300)];
    timeSliderView.delegate = self;
    [self.view addSubview:timeSliderView];
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)timeSliderViewDidChangeValue:(TimeSliderView *)sliderView;
{
    NSLog(@"%f", sliderView.sliderValue);
}

@end
