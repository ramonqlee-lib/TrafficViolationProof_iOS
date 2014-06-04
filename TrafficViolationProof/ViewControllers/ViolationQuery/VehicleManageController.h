//
//  VehicleManageController.h
//  TrafficViolationProof
//
//  Created by ramonqlee on 5/27/14.
//  Copyright (c) 2014 iDreems. All rights reserved.
//

#import <UIKit/UIKit.h>

//车辆管理界面(支持新增，修改，删除，更新等操作)
@interface VehicleManageController : UIViewController

@property(nonatomic,retain)IBOutlet UITextView* licenceNumberType;//号牌类型
@property(nonatomic,retain)IBOutlet UITextField* licenceNumber;//车牌号码
@property(nonatomic,retain)IBOutlet UITextField* engineNumber;//发动机号
@property(nonatomic,retain)IBOutlet UITextField* frameNumber;//车架号
@property(nonatomic,retain)IBOutlet UITextField* comment;//备注名

-(IBAction)finishSelected:(id)sender;

@end
