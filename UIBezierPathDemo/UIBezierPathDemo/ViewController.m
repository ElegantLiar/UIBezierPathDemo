//
//  ViewController.m
//  UIBezierPathDemo
//
//  Created by EL on 2017/6/22.
//  Copyright © 2017年 etouch. All rights reserved.
//

#import "ViewController.h"
#import "ELBezierLineChartView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    ELBezierLineChartView *chartView = [[ELBezierLineChartView alloc] initWithFrame:CGRectMake(0, 0, 300, 130)];
    chartView.backgroundColor = [UIColor whiteColor];
    chartView.center = self.view.center;
    [self.view addSubview:chartView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
