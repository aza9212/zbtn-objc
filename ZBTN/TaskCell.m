//
//  TaskCell.m
//  ZBTN
//
//  Created by Azamat Kushmanov on 11/9/16.
//  Copyright © 2016 Azamat Kushmanov. All rights reserved.
//

#import "TaskCell.h"

@implementation TaskCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)initCardView{
    self.cardView.alpha = 0.6;
    self.cardView.backgroundColor = [[UIColor alloc] initWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1.0];
    self.rightView.backgroundColor = [[UIColor alloc] initWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1.0];
    
    self.cardView.layer.cornerRadius = 3.0;
    self.cardView.layer.masksToBounds = true;
    self.cardView.layer.borderWidth = 0.1;
    
    [self.startStopButton removeTarget:nil action:nil forControlEvents:UIControlEventAllEvents];
    [self.checkboxButton removeTarget:nil action:nil forControlEvents:UIControlEventAllEvents];
}

@end
