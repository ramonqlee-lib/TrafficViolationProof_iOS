//
//  ViolationQueryViewController.m
//  TrafficViolationProof
//
//  Created by ramonqlee on 5/21/14.
//  Copyright (c) 2014 iDreems. All rights reserved.
//

#import "ViolationQueryViewController.h"
#import "EScrollerView.h"

@interface ViolationQueryViewController ()<EScrollerViewDelegate>

@end

@implementation ViolationQueryViewController

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

#pragma mark initViews
//TODO::初始化页面布局，顶部一个可滑动的view；底下一个tableview
//顶部的view支持自定义自定义view插入；
-(void)initViews
{
    NSMutableArray* viewArray = [[NSMutableArray alloc]initWithCapacity:3];
    for (int i =1; i<4; ++i) {
        NSString* imageName = [NSString stringWithFormat:@"%d.jpg",i];
        UIImageView* imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName ]];
        [viewArray addObject:imageView];
    }
    EScrollerView *scroller=[[EScrollerView alloc] initWithFrameRect:CGRectMake(0, 0, self.view.frame.size.width, 150)
                                                           ViewArray:viewArray];
    scroller.delegate=self;
    [self.view addSubview:scroller];
}

#pragma mark - MYIntroduction Delegate
-(void)EScrollerViewDidClicked:(NSUInteger)index
{
    NSLog(@"index--%d",index);
}

@end
