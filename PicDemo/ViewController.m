//
//  ViewController.m
//  PicDemo
//
//  Created by Bruce on 2018/4/11.
//  Copyright © 2018年 Bruce. All rights reserved.
//

#import "ViewController.h"
#import "BlurPicView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    BlurPicView *picView = [[BlurPicView alloc] initWithFrame:self.view.bounds];
    [picView blur];
    [self.view addSubview:picView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
