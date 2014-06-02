//
//  WzTableViewCell.m
//  TrafficViolationProof
//
//  Created by ramonqlee on 6/2/14.
//  Copyright (c) 2014 iDreems. All rights reserved.
//

#import "WzTableViewCell.h"

@implementation WzTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setIndexLabelValue:(NSString *)str
{
    _indexLabel.text = str;
    if (!str||str.length==0) {
        _indexLabel.hidden = YES;
        return;
    }
    _indexLabel.hidden = NO;
    
    CGRect rc = _indexLabel.frame;
    rc.size.width = [str sizeWithFont:_indexLabel.font constrainedToSize:rc.size lineBreakMode:NSLineBreakByClipping].width;
    _indexLabel.frame = rc;
}
-(void)setScoreLabelValue:(NSString *)str
{
    _scoreLabel.text = str;
    if (!str||str.length==0|| [@"0" isEqualToString:str]) {
        _scoreLabel.hidden = YES;
        _scoreLabelTip.hidden = YES;
        return;
    }

    _scoreLabel.hidden = NO;
    _scoreLabelTip.hidden = NO;
}
+(NSInteger)cellHeight
{
    return 140;
}

@end
