//
// Created by Azamat Kushmanov on 11/10/16.
// Copyright (c) 2016 Azamat Kushmanov. All rights reserved.
//

#import "ApiService.h"
#import "AFHTTPRequestOperationManager.h"
#import "DCKeyValueObjectMapping.h"
#import "Task.h"
#import "DCParserConfiguration.h"


@implementation ApiService

+ (ApiService *)sharedService {
    static ApiService *service;
    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^{
        NSURL *url = [[NSURL alloc] initWithString:@"https://zbtn.herokuapp.com"];
        service = [[ApiService alloc] initWithBaseURL:url];
    });
    return service;
}

-(DCKeyValueObjectMapping *) taskJsonParser{
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    config.datePattern = @"yyyy-MM-dd'T'HH:mm:ss.SSSZ";
    return [DCKeyValueObjectMapping mapperForClass: [Task class] andConfiguration:config];
}

- (RACSignal *)getAllTasksForUser:(NSString *)userId {
    @weakify(self);
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        @strongify(self);

        [self GET:[NSString stringWithFormat:@"tasks?user_id=%@", userId] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            @try {
                NSArray *jsonArr = responseObject;

                NSArray *tasks = [jsonArr.rac_sequence map:^id(NSDictionary *JSON) {
                    return [[self taskJsonParser] parseDictionary:JSON];
                }].array;

                [subscriber sendNext:tasks];
                [subscriber sendCompleted];
            }
            @catch(NSException *e){
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
            }

        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"%@", error.description);
            [subscriber sendError:error];
        }];

        return nil;
    }];
    return signal;
}

- (RACSignal *)createTaskForUser:(NSString *)userId title:(NSString *)title {
    @weakify(self);
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        @strongify(self);

        NSDictionary *params = @{@"user_id" : userId, @"title": title};

        [self POST:@"tasks" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
            [subscriber sendNext:[[self taskJsonParser] parseDictionary:responseObject]];
            [subscriber sendCompleted];

        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"%@", error.description);
            [subscriber sendError:error];
        }];

        return nil;
    }];
    return signal;
}

- (RACSignal *)updateTask:(NSString *)taskId title:(NSDictionary *)title {
    @weakify(self);
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        @strongify(self);

        NSDictionary *params = @{@"title": title};

        [self PATCH:[NSString stringWithFormat:@"tasks/%@", taskId] parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
            [subscriber sendNext:[[self taskJsonParser] parseDictionary:responseObject]];
            [subscriber sendCompleted];

        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"%@", error.description);
            [subscriber sendError:error];
        }];

        return nil;
    }];
    return signal;
}

- (RACSignal *)deleteTask:(NSString *)taskId {
    @weakify(self);
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        @strongify(self);

        [self DELETE:[NSString stringWithFormat:@"tasks/%@", taskId] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            [subscriber sendNext:responseObject];
            [subscriber sendCompleted];

        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"%@", error.description);
            [subscriber sendError:error];
        }];

        return nil;
    }];
    return signal;
}

- (RACSignal *)startTask:(NSString *)taskId {
    return nil;
}

- (RACSignal *)stopTask:(NSString *)taskId {
    return nil;
}


@end

