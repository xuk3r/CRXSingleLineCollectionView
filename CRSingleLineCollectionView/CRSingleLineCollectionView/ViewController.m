//
//  ViewController.m
//  CRSingleLineCollectionView
//
//  Created by MacMini2017 on 2017/2/22.
//  Copyright © 2017年 xuk. All rights reserved.
//

#import "ViewController.h"
#import "MererialCollectionView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    MererialCollectionView *view = [[MererialCollectionView alloc]initWithFrame:self.view.bounds];
    view.backgroundColor = [UIColor whiteColor];
    view.arrData = nil;
    [self.view addSubview:view];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
