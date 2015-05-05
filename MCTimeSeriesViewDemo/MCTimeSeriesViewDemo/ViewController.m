//
//  ViewController.m
//  MCTimeSeriesViewDemo
//
//  Created by Matthew Cheok on 5/5/15.
//  Copyright (c) 2015 matthewcheok. All rights reserved.
//

#import "ViewController.h"
#import "MCTimeSeriesView.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet MCTimeSeriesView *chartView;

@end

@implementation ViewController

- (IBAction)handleScrollLeft:(id)sender {
	MCTimeSeriesPoint *point = [self.chartView.points firstObject];
	[self.chartView scrollDate:point.date toVisibleAtPosition:TimeSeriesViewScrollPositionLeft animated:YES];
}

- (IBAction)handleScrollRight:(id)sender {
	MCTimeSeriesPoint *point = [self.chartView.points lastObject];
	[self.chartView scrollDate:point.date toVisibleAtPosition:TimeSeriesViewScrollPositionRight animated:YES];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

	self.chartView.valueAxisTextTransformBlock = ^(CGFloat value) {
		return [NSString stringWithFormat:@"$%.0f", value];
	};
	self.chartView.points = @[
	    [MCTimeSeriesPoint pointWithDate:[NSDate dateWithTimeIntervalSince1970:1385827200] average:2700 high:2700 low:2700],
	    [MCTimeSeriesPoint pointWithDate:[NSDate dateWithTimeIntervalSince1970:1392505600] average:2350 high:2420 low:2100],
	    [MCTimeSeriesPoint pointWithDate:[NSDate dateWithTimeIntervalSince1970:1399603200] average:2460 high:2460 low:2460],
	    [MCTimeSeriesPoint pointWithDate:[NSDate dateWithTimeIntervalSince1970:1406822400] average:2100 high:2150 low:1960],
	    [MCTimeSeriesPoint pointWithDate:[NSDate dateWithTimeIntervalSince1970:1411500800] average:2500 high:2660 low:2450],
        [MCTimeSeriesPoint pointWithDate:[NSDate dateWithTimeIntervalSince1970:1419500800] average:2020 high:2020 low:2020],
	];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.chartView reloadData];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
