MCTimeSeriesView ![License MIT](https://go-shields.herokuapp.com/license-MIT-blue.png)
========================

[![Badge w/ Version](https://cocoapod-badges.herokuapp.com/v/MCTimeSeriesView/badge.png)](https://github.com/matthewcheok/MCTimeSeriesView)
[![Badge w/ Platform](https://cocoapod-badges.herokuapp.com/p/MCTimeSeriesView/badge.svg)](https://github.com/matthewcheok/MCTimeSeriesView)

A light-weight solution for displaying time series charts.

##Screenshot
![Screenshot](https://raw.github.com/matthewcheok/MCTimeSeriesView/master/MCTimeSeriesView.gif "Example of MCTimeSeriesView")

## Installation

Add the following to your [CocoaPods](http://cocoapods.org/) Podfile

    pod 'MCTimeSeriesView', '~> 0.1'

or clone as a git submodule,

or just copy files in the ```MCTimeSeriesView``` folder into your project.

## Using MCTimeSeriesView

Add the `MCTimeSeriesView` class either programmatically or assign the custom class via storyboard. Then set the `points` property. Then tell the view to reload data

```
self.chartView.points = @[
    [MCTimeSeriesPoint pointWithDate:[NSDate dateWithTimeIntervalSince1970:1385827200] average:2083 high:2116 low:2025],
    [MCTimeSeriesPoint pointWithDate:[NSDate dateWithTimeIntervalSince1970:1388505600] average:2201 high:2318 low:2080],
    [MCTimeSeriesPoint pointWithDate:[NSDate dateWithTimeIntervalSince1970:1393603200] average:2022 high:2022 low:2022],
    [MCTimeSeriesPoint pointWithDate:[NSDate dateWithTimeIntervalSince1970:1396281600] average:2017 high:2073 low:1961],
    [MCTimeSeriesPoint pointWithDate:[NSDate dateWithTimeIntervalSince1970:1406822400] average:1906 high:1906 low:1906],
    [MCTimeSeriesPoint pointWithDate:[NSDate dateWithTimeIntervalSince1970:1409500800] average:1906 high:2100 low:1800],
];
[self.chartView reloadData];
```

The view automatically determines the ideal region to display based on the maximum and minimum values of your points. See the demo project for more details.

## License

MCTimeSeriesView is under the MIT license.
