//
//  Task.h
//  ZBTN
//
//  Created by Azamat Kushmanov on 11/9/16.
//  Copyright © 2016 Azamat Kushmanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Task : NSObject

@property (readwrite, nonatomic) NSString *id;
@property (readwrite, nonatomic) NSString *title;
@property (readwrite, nonatomic) long time;
@property (readwrite, nonatomic) bool active;

-(NSString *)getTimeString;

@end
