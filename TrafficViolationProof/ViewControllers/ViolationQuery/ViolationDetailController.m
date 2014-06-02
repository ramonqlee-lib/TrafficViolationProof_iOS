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
#import "GZIP.h"
#import "DESUtils.h"
#import "ViolationQueryProtocol.h"
#import "Vehicle.h"
#import "ViolationResult.h"
#import "Penalty.h"

#define kTrafficQueryUrl @"http://trafficviolationproof.duapp.com/trafficquery.php"//查询违章
static NSString* DES_KEY =  @"ab345678";
static NSString*  DES_IV = @"12345678";

@interface ViolationDetailController ()<UITableViewDelegate,UITableViewDataSource>
{
    ViolationResult* violations;
    UITableView* _tableView;
}
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
    NSData* orgData = [@"134" dataUsingEncoding:NSUTF8StringEncoding];
    ViolationQueryProtocol* protocol = [[[ViolationQueryProtocol alloc]init]autorelease];
    
    //FIXME::待替换为正式的车辆信息
    Vehicle* vehicle = [[[Vehicle alloc]init]autorelease];
    vehicle.area = @"北京";
    vehicle.licNumber = @"冀FRB091";
    vehicle.engineNumber = @"hgdddf";
    vehicle.frameNumber = @"";
    
    orgData = [protocol pack:vehicle];
    
    //des only
    NSData* encryptedData = [orgData encryptUseDES:DES_KEY iv:DES_IV];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getResult:) name:kTrafficQueryUrl object:nil];
    [[HTTPHelper sharedInstance]beginPostRequest:kTrafficQueryUrl withData:encryptedData];
}

//TODO::根据从服务器获得的数据，更新本地数据
-(void)getResult:(NSNotification*)notification
{
    if (notification && notification.object && ![notification.object isKindOfClass:[NSError class]]) {
        if (!notification.userInfo || notification.userInfo.count==0) {
            return;
        }
        
        //获取查询结果，并进行展示
        ViolationQueryProtocol* protocol = [[[ViolationQueryProtocol alloc]init]autorelease];
        violations = [protocol unpack:[notification.userInfo objectForKey:kTrafficQueryUrl] ];
        [self populateTableView:violations];

        [[NSNotificationCenter defaultCenter]removeObserver:self name:kTrafficQueryUrl object:nil];
    }
}

#pragma tableview related
-(void)populateTableView:(ViolationResult*) result
{
    //tableview exist already,reload data only
    if (_tableView) {
        [_tableView reloadData];
        return;
    }
    
    CGRect rc= self.view.frame;
    //是否有tabbar
    if (self.navigationItem) {
        rc.size.height -= self.navigationController.navigationBar.frame.size.height;
    }
    
    _tableView = [[[UITableView alloc]initWithFrame:rc]autorelease];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
}
#pragma mark tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //::点击了某一项后的反应
}
#pragma mark tableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!violations || !violations.penalties) {
        return 0;
    }
    return violations.penalties.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* kCellIdentifier = @"RMTableCellType";
    //TODO::按照车辆信息，初始化cell
    if (!violations || !violations.penalties) {
        return nil;
    }
    Penalty* penalty = [violations.penalties objectAtIndex:indexPath.row];
    
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellIdentifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"在 %@ %@",penalty.locationString,penalty.reasonString];
    cell.detailTextLabel.text = penalty.timeString;
    
    return  cell;
}
@end
