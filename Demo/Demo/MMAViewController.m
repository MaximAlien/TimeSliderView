//
//  MMAViewController.m
//  Demo
//
//  Created by maxim.makhun on 5/26/14.
//  Copyright (c) 2014 MMA. All rights reserved.
//

#import "MMAViewController.h"

static NSString *HourFormat24 = @"HH:mm";
static NSString *HourFormat12 = @"hh:mm a";
static int Hour = 0;
static int Minute = 0;

@interface MMAViewController ()

@end

@implementation MMAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    timeSliderView = [[TimeSliderView alloc] initWithFrame:CGRectMake(0, 30, 320, self.view.frame.size.height - 60)];
    timeSliderView.delegate = self;
    [self.view addSubview:timeSliderView];
    
    timeSelectorLabel = [[UILabel alloc] init];
    timeSelectorLabel.frame = CGRectMake(0, 0, 320, 50);
    [timeSelectorLabel setTextColor:[UIColor whiteColor]];
    [timeSelectorLabel setBackgroundColor:[UIColor grayColor]];
    
    timeSliderView.positionIndicator = timeSelectorLabel;
    
    int hour = timeSliderView.sliderValue * 24;
    float valFloat = timeSliderView.sliderValue * 24;
    int minute = (valFloat - hour) * 60;
    NSString *splitStr = @"";
    BOOL is24HourFormat = [[NSUserDefaults standardUserDefaults] boolForKey:@"24HourFormat"];
    
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
        
        NSString *str = [NSString stringWithFormat:@"   %d:%0*d %@", hour, 2, minute, splitStr];
        [timeSelectorLabel setText:str];
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
        
        NSString *str = [NSString stringWithFormat:@"   %0*d:%0*d", 2, hour, 2, minute];
        [timeSelectorLabel setText:str];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSDate *alarmTime = [NSDate date];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    dateComponents = [calendar components:
                      NSTimeZoneCalendarUnit
                      | NSYearCalendarUnit
                      | NSMonthCalendarUnit
                      | NSDayCalendarUnit
                      | NSHourCalendarUnit
                      | NSMinuteCalendarUnit
                      | NSSecondCalendarUnit fromDate:alarmTime];
    
    long hour = [dateComponents hour];
    long minute = [dateComponents minute];
    
    timeSliderView.hour = hour;
    timeSliderView.minute = minute;
    
    [timeSliderView placeIndicatorView];
    
    NSString *splitStr = @"";
    
    BOOL is24HourFormat = [[NSUserDefaults standardUserDefaults] boolForKey:@"24HourFormat"];
    
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
        
        NSString *str = [NSString stringWithFormat:@"   %ld:%0*ld %@", hour, 2, minute, splitStr];
        [timeSelectorLabel setText:str];
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
        
        NSString *str = [NSString stringWithFormat:@"   %0*ld:%0*ld", 2, hour, 2, minute];
        [timeSelectorLabel setText:str];
    }
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)timeSliderViewDidChangeValue:(TimeSliderView *)sliderView
{
    float sliderValue = timeSliderView.sliderValue;
    
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
    
    timeSliderView.hour = currentHour;
    timeSliderView.minute = currentMinute;
    
    BOOL is24HourFormat = [[NSUserDefaults standardUserDefaults] boolForKey:@"24HourFormat"];
    
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
            
            NSString *str = [NSString stringWithFormat:@"   %d:%0*d %@", currentHour, 2, currentMinute, splitString];
            [timeSelectorLabel setText:str];
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
            
            NSString *str = [NSString stringWithFormat:@"   %0*d:%0*d", 2, currentHour, 2, currentMinute];
            [timeSelectorLabel setText:str];
        }
    }
}

@end
