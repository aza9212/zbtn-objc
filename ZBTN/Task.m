//
//  Task.m
//  ZBTN
//
//  Created by Azamat Kushmanov on 11/9/16.
//  Copyright © 2016 Azamat Kushmanov. All rights reserved.
//

#import "Task.h"

@implementation Task


- (NSString *)getTimeString {
    int seconds = self.time % 60;
    int minutes = (self.time / 60) % 60;
    int hours = (self.time / 3600 ) % 60;

    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours,minutes,seconds];
}

- (BOOL)isEqual:(id)object {
    return self.id == ((Task *)object).id;
}

@end
