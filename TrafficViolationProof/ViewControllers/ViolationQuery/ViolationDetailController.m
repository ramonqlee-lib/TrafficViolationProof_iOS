//
//  ViolationDetailController.m
//  TrafficViolationProof
//
//  Created by ramonqlee on 5/27/14.
//  Copyright (c) 2014 iDreems. All rights reserved.
//

#import "ViolationDetailController.h"
#import "UIBarButtonItem+Customed.h"
#import "HTTPHelper.h"

#define kTrafficQueryUrl @"http://trafficviolationproof.duapp.com/trafficquery.php"//查询违章

@interface ViolationDetailController ()

@end

@implementation ViolationDetailController

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
    self.title = @"违章";
    
    UIBarButtonItem *button =
    [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"top_navigation_back.png"]
                        selectedImage:[UIImage imageNamed:@"top_navigation_back.png"]
                               target:self
                               action:@selector(back)];
    self.navigationItem.leftBarButtonItem = button;
    
    //TODO::查询违章后，显示违章
    //右边菜单下拉列表
    //中间展示违章列表（有可能为空）
    [self startRequest];
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
#pragma mark http request and response
-(void)startRequest
{
    //TODO::待添加查询违章请求数据
    NSData* data = [@"134" dataUsingEncoding:NSUTF8StringEncoding];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getResult:) name:kTrafficQueryUrl object:nil];
    [[HTTPHelper sharedInstance]beginPostRequest:kTrafficQueryUrl withData:data];
}

//TODO::根据从服务器获得的数据，更新本地数据
-(void)getResult:(NSNotification*)notification
{
    if (notification && notification.object && ![notification.object isKindOfClass:[NSError class]]) {
        if (!notification.userInfo || notification.userInfo.count==0) {
            return;
        }
        
        //parse ads and send notification
//        AdsConfiguration* adsConfig = [AdsConfiguration sharedInstance];
//        if(![adsConfig initWithJson:[notification.userInfo objectForKey:kSyncAdsJsonUrl]])
//        {
//            return;
//        }
        
        //notify
//        [[NSNotificationCenter defaultCenter]postNotificationName:kAdsConfigUpdated object:nil];
//        
//        [[NSNotificationCenter defaultCenter]removeObserver:self name:kSyncAdsJsonUrl object:nil];
    }
}
@end
