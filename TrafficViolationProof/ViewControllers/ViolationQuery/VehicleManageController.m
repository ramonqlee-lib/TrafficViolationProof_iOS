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

CGFloat keyboardHeight=216.0f;

@interface VehicleManageController ()<UITextFieldDelegate,UIActionSheetDelegate>
{
}
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
                               action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = button;

    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(backgroundTap:)];
    tapRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapRecognizer];
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
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
-(void)back:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"放弃当前操作?"
                                                             delegate:self
                                                    cancelButtonTitle:@"放弃"
                                               destructiveButtonTitle:@"不，继续"
                                                    otherButtonTitles:nil
                                  ];
    [actionSheet showInView:self.view];
    [actionSheet release];
}
-(void)back
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(buttonIndex ==[actionSheet cancelButtonIndex]){
        [self back];
    }
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
    if (![vehicle isLegal]) {
        return;
    }
    
    //FIXME::在保存之前，检查下是否已经存在相同车牌，如果存在提示一下
    if ([RMAppData recordExist:vehicle]) {
        //是否覆盖
    }
    [RMAppData add:vehicle];

    [self back];
}
#pragma mark single tap
-(IBAction)backgroundTap:(id)sender
{
    for (UIView* view in self.view.subviews) {
        if ([view isFirstResponder] && [view isKindOfClass:[UITextField class]]) {
            [self textFieldShouldReturn:(UITextField *)view];
            break;//only one exist,find end exit is OK
        }
    }
}

#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // When the user presses return, take focus away from the text field so that the keyboard is dismissed.
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = rect;
    [UIView commitAnimations];
    [textField resignFirstResponder];
    return YES;
}

#define Move_Height 80
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    int offset = frame.origin.y + Move_Height - (self.view.frame.size.height - keyboardHeight);//键盘高度216
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    if(offset > 0)
    {
        CGRect rect = CGRectMake(0.0f, -offset,width,height);
        self.view.frame = rect;
    }
    [UIView commitAnimations];
}

#pragma mark keyboard notification
//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardHeight = keyboardRect.size.height;//尽管有点晚了，但是只有第一次采用了设定的缺省值
    
    //完成了键盘的高度获取，不再接受后续的键盘出现通知
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}
@end
