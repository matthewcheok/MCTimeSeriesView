//
//  TimeSeriesPoint.h
//  TimeSeries
//
//  Created by Matthew Cheok on 5/5/15.
//  Copyright (c) 2015 matthewcheok. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCTimeSeriesPoint : NSObject

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) CGFloat average;
@property (nonatomic, assign) CGFloat high;
@property (nonatomic, assign) CGFloat low;

+ (instancetype)pointWithDate:(NSDate *)date value:(CGFloat)value;
+ (instancetype)pointWithDate:(NSDate *)date average:(CGFloat)average high:(CGFloat)high low:(CGFloat)low;

@end
