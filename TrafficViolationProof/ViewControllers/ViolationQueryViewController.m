//
//  ViolationQueryViewController.m
//  TrafficViolationProof
//
//  Created by ramonqlee on 5/21/14.
//  Copyright (c) 2014 iDreems. All rights reserved.
//

#import "ViolationQueryViewController.h"
#import "EScrollerView.h"
#import "RCDraggableButton.h"

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
    //TODO:本模块的功能
    //1.悬浮的添加按钮：用于添加新车辆(初始在第一个车牌的位置，可以自由拖动)(P1)
    //2.车辆信息管理界面：添加车辆，修改车辆，删除车辆等功能；(P2-添加一个占位页)
    //3.违章查询的展示界面：违章的展示（上部分自动根据查询城市，展示天气信息，背景图片考虑来自google）(P3)
    //4.附近违章；违章排行（sohu违章查询）(P5-待技术调研)
    //5.widget(P4-部分待技术调研)
    //5.1 本地天气（自动定位+可修改城市）
    //5.2 今日油价
    //5.3 北京地区：今日限号（非限号地区不显示）
    //5.4 其他封推广告(来自广告sdk)
    [self addVehicle];
    //FIXME:测试一下
    NSMutableArray* viewArray = [[[NSMutableArray alloc]initWithCapacity:3]autorelease];
    for (int i =1; i<4; ++i) {
        NSString* imageName = [NSString stringWithFormat:@"%d.jpg",i];
        UIImageView* imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName ]];
        [viewArray addObject:imageView];
        [imageView release];
    }
    
    for (int i =1; i<4; ++i) {
        UILabel* labelView = [[UILabel alloc]init];
        labelView.text = [NSString stringWithFormat:@"Text %d",i];
        [viewArray addObject:labelView];
        [labelView release];
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
#pragma init methods
-(void)addVehicle
{
    //TODO::记录上次拖动的位置，然后在下次使用
    //考虑键值对的通用存储
    
    //TODO::在此提取拖动后的位置使用（有个初始值）
    RCDraggableButton *avatar = [[RCDraggableButton alloc] initInKeyWindowWithFrame:CGRectMake(0, 400, 50, 50)];
    [avatar setBackgroundImage:[UIImage imageNamed:@"vehicle_manage_icon.jpeg"] forState:UIControlStateNormal];
    
    [avatar setLongPressBlock:^(RCDraggableButton *avatar) {
        NSLog(@"\n\tAvatar in keyWindow ===  LongPress!!! ===");
        //More todo here.
        
    }];
    
    [avatar setTapBlock:^(RCDraggableButton *avatar) {
        NSLog(@"\n\tAvatar in keyWindow ===  Tap!!! ===");
        //TODO::弹出车辆管理界面（添加|修改|删除）
        
    }];
    
    [avatar setDragDoneBlock:^(RCDraggableButton *avatar) {
        NSLog(@"\n\tAvatar in keyWindow === DragDone!!! ===");
        //TODO::在此记录拖动后的位置
        
    }];
}

@end
