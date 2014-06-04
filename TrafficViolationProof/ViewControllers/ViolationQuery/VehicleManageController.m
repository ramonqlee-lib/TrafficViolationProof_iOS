//
//  VehicleManageController.m
//  TrafficViolationProof
//
//  Created by ramonqlee on 5/27/14.
//  Copyright (c) 2014 iDreems. All rights reserved.
//

#import "VehicleManageController.h"
#import "UIBarButtonItem+Customed.h"
#include "Vehicle.h"
#import "RMAppData.h"

@interface VehicleManageController ()

@end

@implementation VehicleManageController

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
    UIBarButtonItem *button =
    [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"top_navigation_back.png"]
                        selectedImage:[UIImage imageNamed:@"top_navigation_back.png"]
                               target:self
                               action:@selector(back)];
    self.navigationItem.leftBarButtonItem = button;
    
    //TODO::车辆管理界面，支持车辆信息的增删改等操作
    //车辆信息的操作，均通过数据库持久化进行
    //1.首先考虑车辆增加
    //2.车辆的信息修改
    //3.车辆信息的删除
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
-(void)back
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)finishSelected:(id)sender
{
    //TODO::收集车辆信息
    NSLog(@"vehicle logged");
    Vehicle* vehicle = [[Vehicle new]autorelease];
    
    vehicle.area = @"北京";
    
    vehicle.licNumber = _licenceNumber.text;
    vehicle.licNumberType = _licenceNumberType.text;
    vehicle.engineNumber  = _engineNumber.text;
    vehicle.frameNumber = _frameNumber.text;
    vehicle.comment = _comment.text;
    
    //校验下是否合法，然后再保存.不合法的，变下标题的颜色
    
    //save
    [RMAppData add:vehicle];
    
    [self back];
}
@end
