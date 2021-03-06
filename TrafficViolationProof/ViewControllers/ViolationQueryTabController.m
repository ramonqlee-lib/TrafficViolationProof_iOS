//
//  ViolationQueryViewController.m
//  TrafficViolationProof
//
//  Created by ramonqlee on 5/21/14.
//  Copyright (c) 2014 iDreems. All rights reserved.
//

#import "ViolationQueryTabController.h"
#import "EScrollerView.h"
#import "RCDraggableButton.h"
#import "SQLiteManager.h"
#import "ViolationQuery/ViolationDetailController.h"
#import "ViolationQuery/VehicleManageController.h"
#import "RMAppData.h"
#import "Vehicle.h"
#import "RMPreferences.h"

#define kTopCoverFlowHeight 150
#define kAvatarOriginKey @"kAvatarOriginKey"

@interface ViolationQueryTabController ()<EScrollerViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray* vehicleArray;//车辆数组
}
@end

@implementation ViolationQueryTabController

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
    
    Vehicle* vehicle = [[Vehicle new]autorelease];
    NSInteger c = [RMAppData count:vehicle];
    if (c>0) {
        if (!vehicleArray) {
            vehicleArray = [[NSMutableArray alloc]initWithCapacity:c];
        }
        [vehicleArray addObjectsFromArray:[RMAppData query:NSMakeRange(0, c) withPersistable:vehicle]];
    }
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
    //1.悬浮的添加按钮：用于添加新车辆(初始在第一个车牌的位置，可以自由拖动)(P1-done)
    //2.车辆信息管理界面：添加车辆，修改车辆，删除车辆等功能；(P2-添加一个占位页)
    //3.违章查询的展示界面：违章的展示（上部分自动根据查询城市，展示天气信息，背景图片考虑来自google）(P3)
    //4.附近违章；违章排行（sohu违章查询）(P5-待技术调研)
    //5.widget(P4-部分待技术调研)
    //5.1 本地天气（自动定位+可修改城市）
    //5.2 今日油价
    //5.3 北京地区：今日限号（非限号地区不显示）
    //5.4 其他封推广告(来自广告sdk)
    
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
    
    EScrollerView *scroller=[[EScrollerView alloc] initWithFrameRect:CGRectMake(0, 0, self.view.frame.size.width, kTopCoverFlowHeight)
                                                           ViewArray:viewArray];
    scroller.delegate=self;
    [self.view addSubview:scroller];
    
    [self initVehiclesView];
    
    [self addVehicle];
}

#pragma mark - MYIntroduction Delegate
-(void)EScrollerViewDidClicked:(NSUInteger)index
{
    NSLog(@"index--%d",index);
}
#pragma init methods
//弹出添加车辆界面
-(void)addVehicle
{
    //TODO::记录上次拖动的位置，然后在下次使用
    //考虑键值对的通用存储
    
    //TODO::在此提取拖动后的位置使用（有个初始值）
    CGPoint origin=CGPointMake(0, self.view.frame.size.height/2);
    NSString* orginString = [RMPreferences stringForKey:kAvatarOriginKey];
    if (orginString && orginString.length) {
        origin = CGPointFromString(orginString);
    }
    
    RCDraggableButton *avatar = [[RCDraggableButton alloc] initInView:self.view WithFrame:CGRectMake(origin.x,origin.y, 32, 32)];
    [avatar setBackgroundImage:[UIImage imageNamed:@"vehicle_manage_icon_32"] forState:UIControlStateNormal];
    
    [avatar setLongPressBlock:^(RCDraggableButton *avatar) {
        NSLog(@"\n\tAvatar in keyWindow ===  LongPress!!! ===");
        //More todo here.
        
    }];
    
    [avatar setTapBlock:^(RCDraggableButton *avatar) {
        NSLog(@"\n\tAvatar in keyWindow ===  Tap!!! ===");
        //::弹出车辆管理界面（添加|修改|删除）
        //::跳转到对应车辆的违章查询界面
        UIViewController* tmp = [[[VehicleManageController alloc]initWithNibName:@"VehicleManageController" bundle:nil]autorelease];
        UINavigationController* navi = [[[UINavigationController alloc]initWithRootViewController:tmp]autorelease];
        
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:navi animated:YES completion:nil];
    }];
    
    [avatar setAutoDockingDoneBlock:^(RCDraggableButton *avatar) {
        NSLog(@"\n\tAvatar in keyWindow === DragDone!!! ===");
        //TODO::在此记录拖动后的位置
        NSString* originStr = [NSString stringWithFormat:@"{%f,%f}",avatar.frame.origin.x,avatar.frame.origin.y];
        [RMPreferences setString:originStr forKey:kAvatarOriginKey];
    }];
}
//TODO::显示车辆列表
-(void)initVehiclesView
{
    //::读取车辆信息，通过tableview进行显示
    //1.车辆信息的管理
    //2.tableview delegate和datasource的独立处理
    CGRect rc=self.view.frame;
    rc.origin.y = kTopCoverFlowHeight;
    rc.size.height -= kTopCoverFlowHeight;
    //是否有tabbar
    if (self.tabBarController) {
        rc.size.height -= self.tabBarController.tabBar.frame.size.height;
    }
    UITableView* vehicleTableView = [[[UITableView alloc]initWithFrame:rc]autorelease];
    vehicleTableView.delegate = self;
    vehicleTableView.dataSource = self;
    
    [self.view addSubview:vehicleTableView];
}
#pragma mark tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //::跳转到对应车辆的违章查询界面
    ViolationDetailController* tmp = [[[ViolationDetailController alloc]init]autorelease];
    
    NSDictionary* dict = [vehicleArray objectAtIndex:indexPath.row];
    if (!dict) {
        return;
    }
    
    tmp._vehicle = [Vehicle vehicleWithDict:dict];
    UINavigationController* navi = [[[UINavigationController alloc]initWithRootViewController:tmp]autorelease];
    
    [self.parentViewController presentViewController:navi animated:YES completion:nil];
}
#pragma mark tableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //TODO::待读取车辆信息
    return vehicleArray?vehicleArray.count:0;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* kCellIdentifier = @"RMTableCellImageTwinTextType";
    //TODO::按照车辆信息，初始化cell
    
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellIdentifier];
    }
    NSDictionary* dict = [vehicleArray objectAtIndex:indexPath.row];
    if (!dict) {
        return cell;
    }
    Vehicle* vehicle = [Vehicle vehicleWithDict:dict];
    
    cell.textLabel.text = [NSString stringWithFormat:@"车牌号码: %@", vehicle.licNumber];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"发动机号码:%@",vehicle.engineNumber];
    return  cell;
}

//删除支持
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

/*改变删除按钮的title*/
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

/*删除用到的函数*/
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dict = [vehicleArray objectAtIndex:indexPath.row];
    if (!dict) {
        return;
    }
    
    Vehicle* vehicle = [Vehicle vehicleWithDict:dict];
    
    //FIXME：：确认？？
    [RMAppData remove:vehicle];
    
    
    [vehicleArray removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [tableView reloadData];
}

@end
