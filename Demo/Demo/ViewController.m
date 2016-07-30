//
//  ViewController.m
//  Demo
//
//  Created by junpengwang on 16/7/30.
//  Copyright © 2016年 wilddog. All rights reserved.
//

#import "ViewController.h"
#import "DTMessageInputToolBar.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DTMessageInputToolBar *inputToolBar = [[DTMessageInputToolBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - DT_INPUTVIEW_HEIGHT, self.view.frame.size.width, self.view.frame.size.height)];
    inputToolBar.delegate = self;
    [self.view addSubview:inputToolBar];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
