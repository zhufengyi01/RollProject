//
//  ViewController.m
//  RollProject
//
//  Created by 朱封毅 on 22/01/16.
//  Copyright © 2016年 tairan. All rights reserved.
//

#import "ViewController.h"
#import "THCustomRollView.h"

#import "THCustomRollView.h"

@interface ViewController ()<THCustomRollViewDelegate>


@property(nonatomic,strong) UIScrollView *customScrollView;


@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"THCustomRollViewController";
    
    NSInteger  deviceWith_3  = DEVICE_SCREEN_WIDTH /3;
    
    THCustomRollView *view = [[THCustomRollView alloc] initWithFrame:CGRectMake(0, 10, deviceWith_3*3, 50)];
    
    view.titleArray = @[@"哈哈",@"呵呵",@"嗯呢",@"液压",@"嗯呃啊"];
    view.delegate = self;
    //设置选中那一个选项
    [view showTitleIndex:1];
    [self.view addSubview:view];
    
}

-(void)THCustomRollViewScrollerIndex:(NSInteger)index
{
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
