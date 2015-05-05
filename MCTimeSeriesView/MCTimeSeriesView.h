//
//  TimeSeriesView.h
//  TimeSeries
//
//  Created by Matthew Cheok on 4/5/15.
//  Copyright (c) 2015 matthewcheok. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCTimeSeriesPoint.h"

typedef NS_ENUM(NSInteger, TimeSeriesViewScrollPosition) {
    TimeSeriesViewScrollPositionLeft = 0,
    TimeSeriesViewScrollPositionRight
};

@interface MCTimeSeriesView : UIScrollView

@property (nonatomic, strong) NSArray *points;

@property (nonatomic, assign) NSInteger valueAxisMaximumLabels;
@property (nonatomic, assign) CGFloat valueAxisMinimumInterLabelSpacing;
@property (nonatomic, assign) CGFloat valueAxislabelWidth;
@property (nonatomic, copy) NSString* (^valueAxisTextTransformBlock)(CGFloat value);

@property (nonatomic, assign) CGFloat timeAxisLabelHeight;
@property (nonatomic, assign) CGFloat timeAxisMonthSpacing;

@property (nonatomic, assign) UIEdgeInsets chartInset;

// visual appearance

@property (nonatomic, strong, readonly) NSDateFormatter *dateFormatter;

@property (nonatomic, assign) CGFloat strokeWidth;
@property (nonatomic, strong) UIColor *strokeColor;
@property (nonatomic, strong) UIColor *fillColor;

@property (nonatomic, strong) NSDictionary *textAttributesInTimeAxis;
@property (nonatomic, strong) NSDictionary *textAttributesInValueAxis;
@property (nonatomic, strong) NSDictionary *highlightedTextAttributesInValueAxis;

- (void)reloadData;
- (void)scrollDate:(NSDate *)date toVisibleAtPosition:(TimeSeriesViewScrollPosition)position animated:(BOOL)animated;

@end
