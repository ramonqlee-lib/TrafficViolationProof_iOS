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
#import "WzTableViewCell.h"
#import "LeveyPopListView.h"

#define kTrafficQueryUrl @"http://trafficviolationproof.duapp.com/trafficquery.php"//查询违章
static NSString* DES_KEY =  @"ab345678";
static NSString*  DES_IV = @"12345678";

#define kNoViolationFoundString  @"未查询到违章信息!"
#define kErrorString @"网络不给力，查询失败!"
#define kWaitNetRespondString @"正在查询违章..."

@interface ViolationDetailController ()<UITableViewDelegate,UITableViewDataSource,LeveyPopListViewDelegate>
{
    ViolationResult* violations;
    UITableView* _tableView;
    UILabel* _placeholderlabel;
    NSInteger selectedTableviewRow;
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
    
    //TODO::查询违章后，显示违章(done)
    //右边菜单下拉列表(去除地区选择，查询全国的违章)(实用性不高，暂时不添加)
    //中间展示违章列表（有可能为空）(done)
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
    //TODO::待添加查询违章请求数据(done,通过vehicle设定)
    NSData* orgData = [@"134" dataUsingEncoding:NSUTF8StringEncoding];
    ViolationQueryProtocol* protocol = [[[ViolationQueryProtocol alloc]init]autorelease];
    
    //预留的车辆信息
    if (!__vehicle) {
        Vehicle* vehicle = [[[Vehicle alloc]init]autorelease];
        vehicle.area = @"北京";
        vehicle.licNumber = @"冀FRB091";
        vehicle.engineNumber = @"hgdddf";
        vehicle.frameNumber = @"";
        __vehicle = vehicle;
    }
    
    self.title = __vehicle.licNumber;
    
    orgData = [protocol pack:__vehicle];
    
    //des only
    NSData* encryptedData = [orgData encryptUseDES:DES_KEY iv:DES_IV];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getResult:) name:kTrafficQueryUrl object:nil];
    [[HTTPHelper sharedInstance]beginPostRequest:kTrafficQueryUrl withData:encryptedData];
    
    [self populatePlaceholderview:kWaitNetRespondString];
}

//::根据从服务器获得的数据，更新本地数据
-(void)getResult:(NSNotification*)notification
{
    if (notification && notification.object && ![notification.object isKindOfClass:[NSError class]]) {
        if (!notification.userInfo || notification.userInfo.count==0) {
            [self populatePlaceholderview:kNoViolationFoundString];
            return;
        }
        
        //获取查询结果，并进行展示
        ViolationQueryProtocol* protocol = [[[ViolationQueryProtocol alloc]init]autorelease];
        violations = [protocol unpack:[notification.userInfo objectForKey:kTrafficQueryUrl] ];
        
        [self populateTableView:violations];

        [[NSNotificationCenter defaultCenter]removeObserver:self name:kTrafficQueryUrl object:nil];
    }
    else
    {
        [self populatePlaceholderview:kErrorString];
    }
}
#pragma no violation found
-(void)populatePlaceholderview:(NSString*)text
{
    if (_placeholderlabel) {
        _placeholderlabel.text = text;
        return;
    }
    _placeholderlabel = [[UILabel alloc]init];
    CGRect rc= self.view.frame;
    //是否有tabbar
    if (self.navigationItem) {
        rc.size.height -= self.navigationController.navigationBar.frame.size.height;
    }
    _placeholderlabel.frame = rc;
    
    _placeholderlabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_placeholderlabel];
    
    [_placeholderlabel release];
}

#pragma tableview related
-(void)populateTableView:(ViolationResult*) result
{
    //确实存在违章
    if (!violations || !violations.penalties||violations.penalties.count==0) {
        [self populatePlaceholderview:kNoViolationFoundString];
        return;
    }
    
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
    selectedTableviewRow = indexPath.row;
    
    //::点击了某一项后弹出界面
    [self showListView];
}
#pragma mark tableview datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [WzTableViewCell cellHeight];
}
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
    static NSString* kCellIdentifier = @"WzTableViewCell";
    //::按照车辆违章信息，初始化cell
    if (!violations || !violations.penalties) {
        return nil;
    }
    
    NSInteger row = (indexPath.row)%violations.penalties.count;
    Penalty* penalty = [violations.penalties objectAtIndex:row];
    
    BOOL registeredNib = NO;
    if(!registeredNib){
        UINib* nib = [UINib nibWithNibName:kCellIdentifier bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:kCellIdentifier];
        registeredNib = YES;
    }
    
    WzTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (!cell) {
        cell = [[WzTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
        NSLog(@"cell init");
    }
    [cell setIndexLabelValue:[NSString stringWithFormat:@"%d",row+1]];
    cell.timeLabel.text = penalty.timeString;
    cell.locationLabel.text = penalty.locationString;
    cell.fineLabel.text = penalty.fineString;
    [cell setScoreLabelValue:penalty.scoreString];
    
    return  cell;
}

- (void)showListView
{
#if 0
    NSArray* _options = [[NSArray arrayWithObjects:
                 [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"facebook.png"],@"img",@"实景图",@"text", nil],
                 [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"twitter.png"],@"img",@"周边违章",@"text", nil],
                 [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"tumblr.png"],@"img",@"违章处理",@"text", nil],
                 nil] retain];
    
    LeveyPopListView *lplv = [[LeveyPopListView alloc] initWithTitle:@"更多..." options:_options];
    lplv.delegate = self;
    [lplv showInView:self.view.window animated:YES];
    [lplv release];
#endif
}

#pragma mark - LeveyPopListView delegates
- (void)leveyPopListView:(LeveyPopListView *)popListView didSelectedIndex:(NSInteger)anIndex
{
    //TODO::待完善功能
    /*
     1. 实景图：集成地图的三维实景图；
     2. 周边违章：sohu的周边违章功能（后续增加？）
     3. 违章处理(违章处理地点，电话，行程规划<缺省从当前地点到违章处理地点>)
        根据当前城市，从服务器端请求违章处理地点的数据
     */
}
- (void)leveyPopListViewDidCancel
{
//    _infoLabel.text = @"You have cancelled";
}
@end
