//
//  ViewController.h
//  Demo
//
//  Created by maxim.makhun on 5/26/14.
//  Copyright (c) 2014 MMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeSliderView.h"

@interface ViewController : UIViewController <TimeSliderViewDelegate>

@property (strong, nonatomic) TimeSliderView *timeSliderView;

@end
