//
//  ChartVC.m
//  ZBTN
//
//  Created by Azamat Kushmanov on 11/20/16.
//  Copyright © 2016 Azamat Kushmanov. All rights reserved.
//

#import "ChartVC.h"
#import "PNChart.h"
#import "Task.h"

@interface ChartVC ()

@end

@implementation ChartVC

- (void)viewDidLoad {
    [super viewDidLoad];

    NSMutableArray *items = [NSMutableArray new];
    for(Task *task in self.tasks){
        [items addObject:[PNPieChartDataItem dataItemWithValue:task.time color:[self getRandomColor] description:task.title]];
    }
    
    
    PNPieChart *pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(25, 100, SCREEN_WIDTH - 50 , SCREEN_WIDTH - 50) items:items];
    pieChart.descriptionTextColor = [UIColor whiteColor];
    pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:8.0];
    [pieChart strokeChart];
    
    [self.view addSubview:pieChart];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIColor *)getRandomColor{
    return [UIColor colorWithRed:arc4random() %(255) / 255.0 green:arc4random() %(255) / 255.0 blue: arc4random() %(255) / 255.0 alpha:1.0f];
}

@end
