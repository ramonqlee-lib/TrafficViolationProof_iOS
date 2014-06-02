//
//  WzTableViewCell.h
//  TrafficViolationProof
//
//  Created by ramonqlee on 6/2/14.
//  Copyright (c) 2014 iDreems. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WzTableViewCell : UITableViewCell

@property(nonatomic,retain)IBOutlet UILabel* indexLabel;
@property(nonatomic,retain)IBOutlet UILabel* timeLabel;
@property(nonatomic,retain)IBOutlet UILabel* locationLabel;
@property(nonatomic,retain)IBOutlet UILabel* fineLabel;
@property(nonatomic,retain)IBOutlet UILabel* scoreLabel;
@property(nonatomic,retain)IBOutlet UILabel* scoreLabelTip;
+(NSInteger)cellHeight;
-(void)setIndexLabelValue:(NSString *)str;
-(void)setScoreLabelValue:(NSString *)str;

@end
