//
//  TimeSeriesView.m
//  TimeSeries
//
//  Created by Matthew Cheok on 4/5/15.
//  Copyright (c) 2015 matthewcheok. All rights reserved.
//

#import "MCTimeSeriesView.h"

@interface MCTimeSeriesView ()

@property (nonatomic, assign) CGFloat minX;
@property (nonatomic, assign) CGFloat maxX;
@property (nonatomic, assign) CGFloat minY;
@property (nonatomic, assign) CGFloat maxY;
@property (nonatomic, assign) CGFloat jumpY;

@property (nonatomic, assign) CGFloat ratioX;
@property (nonatomic, assign) CGFloat ratioY;

@property (nonatomic, assign) CGSize chartSize;
@property (nonatomic, strong) NSArray *verticalAxisLabels;
@property (nonatomic, strong) NSArray *horizontalAxisLabels;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation MCTimeSeriesView

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		[self _setup];
	}
	return self;
}

- (void)awakeFromNib {
	[super awakeFromNib];
	[self _setup];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self reloadData];
}

- (void)reloadData {
	[self _computeLayout];
	[self setNeedsDisplay];
}

- (void)scrollDate:(NSDate *)date toVisibleAtPosition:(TimeSeriesViewScrollPosition)position animated:(BOOL)animated {
	CGPoint p = [self _pointInViewFromDataPoint:CGPointMake([date timeIntervalSince1970], self.minY)];
	p.y = 0;

	if (position == TimeSeriesViewScrollPositionRight) {
		p.x -= CGRectGetWidth(self.bounds) - self.timeAxisLabelHeight - self.chartInset.left - self.chartInset.right;
	}

	if (p.x < -self.contentInset.left) {
		p.x = -self.contentInset.left;
	}

	[self setContentOffset:p animated:animated];
}

#pragma mark - Internal

- (void)_setup {
	self.showsVerticalScrollIndicator = NO;
	self.contentMode = UIViewContentModeRedraw;

	self.valueAxisMaximumLabels = 5;
	self.valueAxisMinimumInterLabelSpacing = 100;
	self.valueAxislabelWidth = 40;

	self.timeAxisLabelHeight = 70;
	self.timeAxisMonthSpacing = 60;

	self.chartInset = UIEdgeInsetsMake(10, 0, 10, 0);

	self.dateFormatter = [[NSDateFormatter alloc] init];
	self.dateFormatter.dateFormat = @"MMM\nYYYY";

	NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	style.alignment = NSTextAlignmentCenter;
	self.textAttributesInTimeAxis = @{
		NSFontAttributeName: [UIFont boldSystemFontOfSize:14],
		NSForegroundColorAttributeName: [UIColor colorWithRed:0.8668 green:0.8668 blue:0.8668 alpha:1.0],
		NSParagraphStyleAttributeName: style
	};

	self.textAttributesInValueAxis = @{
		NSFontAttributeName: [UIFont boldSystemFontOfSize:14],
		NSForegroundColorAttributeName: [UIColor colorWithRed:0.8668 green:0.8668 blue:0.8668 alpha:1.0]
	};

	self.highlightedTextAttributesInValueAxis = @{
		NSFontAttributeName: [UIFont boldSystemFontOfSize:16],
		NSForegroundColorAttributeName: [UIColor colorWithRed:0.3525 green:0.6422 blue:0.8871 alpha:1.0]
	};
    
    self.strokeWidth = 4;
}

- (void)_computeLayout {
	NSInteger count = self.points.count;

	self.minX = MAXFLOAT;
	self.maxX = -MAXFLOAT;
	self.minY = MAXFLOAT;
	self.maxY = -MAXFLOAT;

	for (NSInteger i = 0; i < count; i++) {
		MCTimeSeriesPoint *point = self.points[i];
		CGFloat val = point.average;
		CGFloat time = [point.date timeIntervalSince1970];

		CGFloat high = point.high == MAXFLOAT ? val : point.high;
		CGFloat low = point.low == MAXFLOAT ? val : point.low;

		if (high > self.maxY) {
			self.maxY = high;
		}

		if (low < self.minY) {
			self.minY = low;
		}

		if (time > self.maxX) {
			self.maxX = time;
		}

		if (time < self.minX) {
			self.minX = time;
		}
	}

	CGFloat height = CGRectGetHeight(self.bounds);

	self.chartSize = CGSizeMake((self.maxX - self.minX) * self.timeAxisMonthSpacing / (30 * 24 * 60 * 60), height - self.valueAxislabelWidth - self.chartInset.top - self.chartInset.bottom);
	self.contentSize = CGSizeMake(self.chartSize.width + self.timeAxisLabelHeight + self.chartInset.left + self.chartInset.right, height);

	self.ratioX = self.chartSize.width / (self.maxX - self.minX);
	self.ratioY = self.chartSize.height / (self.maxY - self.minY);

	CGFloat jump = self.valueAxisMinimumInterLabelSpacing;
	while ((self.maxY - self.minY) / jump > self.valueAxisMaximumLabels - 1) {
		jump += self.valueAxisMinimumInterLabelSpacing;
	}
	self.jumpY = jump;
}

- (void)drawRect:(CGRect)rect {
	// determine how much to draw
	CGFloat minX = CGRectGetMinX(self.bounds);
	CGFloat maxX = CGRectGetMaxX(self.bounds) - self.timeAxisLabelHeight;

	NSInteger minIndex = 0;
	while (minIndex + 1 < self.points.count &&
	       [self _pointInViewFromDataPoint:CGPointMake([[self.points[minIndex + 1] date] timeIntervalSince1970], 0)].x < minX) {
		minIndex++;
	}

	NSInteger maxIndex = self.points.count - 1;
	while (maxIndex - 1 >= 0 &&
	       [self _pointInViewFromDataPoint:CGPointMake([[self.points[maxIndex - 1] date] timeIntervalSince1970], 0)].x > maxX) {
		maxIndex--;
	}

	// setup
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSaveGState(context);

	CGRect clipRect = CGRectMake(minX, -2, maxX - minX, CGRectGetHeight(self.bounds) + 4);
	UIRectClip(clipRect);

	// draw fill
	UIBezierPath *path = [UIBezierPath bezierPath];

	for (NSInteger i = minIndex; i <= maxIndex; i++) {
		MCTimeSeriesPoint *point = self.points[i];
		CGFloat high = point.high == MAXFLOAT ? point.average : point.high;
		CGFloat time = [point.date timeIntervalSince1970];

		CGPoint p = [self _pointInViewFromDataPoint:CGPointMake(time, high)];
		if (i == minIndex) {
			[path moveToPoint:p];
		}
		else {
			[path addLineToPoint:p];
		}
	}

	for (NSInteger i = maxIndex; i >= minIndex; i--) {
		MCTimeSeriesPoint *point = self.points[i];
		CGFloat low = point.low == MAXFLOAT ? point.average : point.low;
		CGFloat time = [point.date timeIntervalSince1970];

		CGPoint p = [self _pointInViewFromDataPoint:CGPointMake(time, low)];
		[path addLineToPoint:p];
	}

    UIColor *fillColor = self.fillColor ?: [UIColor colorWithRed:0.937 green:0.9499 blue:0.9563 alpha:1.0];
	[fillColor setFill];
	[path fill];

	// draw line

	path = [UIBezierPath bezierPath];

	for (NSInteger i = minIndex; i <= maxIndex; i++) {
		MCTimeSeriesPoint *point = self.points[i];
		CGFloat val = point.average;
		CGFloat time = [point.date timeIntervalSince1970];

		CGPoint p = [self _pointInViewFromDataPoint:CGPointMake(time, val)];
		if (i == minIndex) {
			[path moveToPoint:p];
		}
		else {
			[path addLineToPoint:p];
		}
	}

    UIColor *strokeColor = self.strokeColor ?: [UIColor colorWithRed:0.4436 green:0.7971 blue:0.9916 alpha:1.0];
	[strokeColor setStroke];

	path.lineWidth = self.strokeWidth;
	[path stroke];
    
    CGContextRestoreGState(context);
    CGContextSaveGState(context);
	UIRectClip(self.bounds);

	// draw time labels
	NSDate *date = [self.points[minIndex] date];
	date = [self _firstOfFollowingMonthFromDate:date];

	do {
		NSDate *prevDate = [self _firstOfPreviousMonthFromDate:date];
		CGPoint p = [self _pointInViewFromDataPoint:CGPointMake([prevDate timeIntervalSince1970], self.minY)];

		if (p.x > minX) {
			date = prevDate;
		}
		else {
			break;
		}
	}
	while (true);

	CGPoint p = [self _pointInViewFromDataPoint:CGPointMake([date timeIntervalSince1970], self.minY)];
	while (p.x < maxX) {
		NSString *text = [self.dateFormatter stringFromDate:date];

		CGSize size = [text sizeWithAttributes:self.textAttributesInTimeAxis];
		p.x -= size.width / 2;
		p.y += 10;
		[text drawInRect:CGRectMake(p.x, p.y, size.width, size.height) withAttributes:self.textAttributesInTimeAxis];

		date = [self _firstOfFollowingMonthFromDate:date];
		p = [self _pointInViewFromDataPoint:CGPointMake([date timeIntervalSince1970], self.minY)];
	}

	CGContextRestoreGState(context);
	CGContextSaveGState(context);
	UIRectClip(self.bounds);

	// draw value labels
	CGFloat value = floor(self.minY / self.valueAxisMinimumInterLabelSpacing) * self.valueAxisMinimumInterLabelSpacing;

	NSInteger lastIndex = maxIndex;
	if ([self _pointInViewFromDataPoint:CGPointMake([[self.points[lastIndex] date] timeIntervalSince1970], 0)].x > maxX) {
		lastIndex -= 1;
	}
	if (lastIndex < minIndex) {
		lastIndex = minIndex;
	}

	CGFloat pointValue = [self.points[lastIndex] average];

	while (value <= self.maxY) {
        NSString *text = self.valueAxisTextTransformBlock ? self.valueAxisTextTransformBlock(value) : [NSString stringWithFormat:@"%.2f", value];

        NSDictionary *attributes = (fabs(pointValue - value) < self.jumpY / 2 && self.highlightedTextAttributesInValueAxis) ? self.highlightedTextAttributesInValueAxis : self.textAttributesInValueAxis;

		CGSize size = [text sizeWithAttributes:attributes];
		CGPoint p = [self _pointInViewFromDataPoint:CGPointMake(0, value)];
		p.x = maxX + 10;
		p.y -= size.height / 2;
        [text drawInRect:CGRectMake(p.x, p.y, size.width, size.height) withAttributes:attributes];

		value += self.jumpY;
	}
}

#pragma mark - Private

- (NSDate *)_firstOfFollowingMonthFromDate:(NSDate *)date {
	NSDateComponents *comp = [[NSCalendar currentCalendar] components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:date];
	comp.day = 1;
	comp.month += 1;
	return [[NSCalendar currentCalendar] dateFromComponents:comp];
}

- (NSDate *)_firstOfPreviousMonthFromDate:(NSDate *)date {
	NSDateComponents *comp = [[NSCalendar currentCalendar] components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:date];
	comp.day = 1;
	comp.month -= 1;
	return [[NSCalendar currentCalendar] dateFromComponents:comp];
}

- (CGPoint)_pointInViewFromDataPoint:(CGPoint)point {
	return CGPointMake((point.x - self.minX) * self.ratioX + self.chartInset.left, (self.maxY - point.y) * self.ratioY + self.chartInset.top);
}

@end
