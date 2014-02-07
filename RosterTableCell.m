//
//  RosterTableCell.m
//  DynamiCoach
//
//  Created by Danilo on 2/6/14.
//  Copyright (c) 2014 dcaetano. All rights reserved.
//

#import "RosterTableCell.h"

@implementation RosterTableCell

@synthesize firstNameLabel = _firstNameLabel;
@synthesize lastNameLabel = _lastNameLabel;
@synthesize emailLabel = _emailLabel;
@synthesize phoneLabel = _phoneLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
