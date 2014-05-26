//
//  MMAViewController.h
//  Demo
//
//  Created by maxim.makhun on 5/26/14.
//  Copyright (c) 2014 MMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeSliderView.h"

@interface MMAViewController : UIViewController <TimeSliderViewDelegate>
{
    TimeSliderView *timeSliderView;
    UILabel *timeSelectorLabel;
    int currentHour;
    int currentMinute;
    NSString *splitString;
}

@end