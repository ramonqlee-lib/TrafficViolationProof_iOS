//
//  AntiCameraViewController.m
//  TrafficViolationProof
//
//  Created by ramonqlee on 5/22/14.
//  Copyright (c) 2014 iDreems. All rights reserved.
//

#import "AntiCameraViewController.h"

@interface AntiCameraViewController ()

@end

@implementation AntiCameraViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)initViews
{
    UITextView* placeHolderTextView = [[UITextView alloc]initWithFrame:self.view.frame];
    placeHolderTextView.text = @"正在开发，优先级 4";
    
    [[self baseView] addSubview:placeHolderTextView];
}
@end
