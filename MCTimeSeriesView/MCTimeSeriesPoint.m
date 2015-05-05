//
//  TimeSeriesPoint.m
//  TimeSeries
//
//  Created by Matthew Cheok on 5/5/15.
//  Copyright (c) 2015 matthewcheok. All rights reserved.
//

#import "MCTimeSeriesPoint.h"

@implementation MCTimeSeriesPoint

+ (instancetype)pointWithDate:(NSDate *)date value:(CGFloat)value {
    return [[self alloc] initWithDate:date value:value];
}

+ (instancetype)pointWithDate:(NSDate *)date average:(CGFloat)average high:(CGFloat)high low:(CGFloat)low {
    return [[self alloc] initWithDate:date average:average high:high low:low];
}

- (instancetype)initWithDate:(NSDate *)date value:(CGFloat)value {
    return [self initWithDate:date average:value high:MAXFLOAT low:MAXFLOAT];
}

- (instancetype)initWithDate:(NSDate *)date average:(CGFloat)average high:(CGFloat)high low:(CGFloat)low {
    self = [super init];
    if (self) {
        self.date = date;
        self.average = average;
        self.high = high;
        self.low = low;
    }
    return self;
}

@end
