//
// Created by Azamat Kushmanov on 11/10/16.
// Copyright (c) 2016 Azamat Kushmanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveCocoa.h"
#import "AFHTTPSessionManager.h"

@protocol Services <NSObject>

- (RACSignal *) getAllTasksForUser:(NSString *)userId;
- (RACSignal *) createTaskForUser:(NSString *)userId title:(NSString *)title;
- (RACSignal *) updateTask:(NSString *)taskId title:(NSDictionary *)title;
- (RACSignal *) deleteTask:(NSString *)taskId;
- (RACSignal *) startTask:(NSString *)taskId;
- (RACSignal *) stopTask:(NSString *)taskId;

@end

@interface ApiService : AFHTTPSessionManager <Services>

+ (ApiService *)sharedService;

@end