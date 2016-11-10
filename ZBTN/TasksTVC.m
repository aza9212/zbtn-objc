//
//  TasksTVC.m
//  ZBTN
//
//  Created by Azamat Kushmanov on 11/9/16.
//  Copyright © 2016 Azamat Kushmanov. All rights reserved.
//

#import "TasksTVC.h"
#import "TaskCell.h"
#import "Task.h"
#import "ApiService.h"
#import "SVProgressHUD.h"

@interface TasksTVC ()

@property NSArray *tasks;
@property NSString *userId;
@property NSTimer *timer;

@end

@implementation TasksTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];

    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 315;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tasks_bg"]];

    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerTick) userInfo:nil repeats:YES];
}

- (void)timerTick {
    NSLog(@"time");
    for(Task *task in self.tasks){
        if(task.active){
            int index = [self.tasks indexOfObject:task];
            TaskCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
            task.time++;
            cell.timeLabel.text = [task getTimeString];
            break;
        }
    }
}


-(void)refresh{
    @weakify(self)
    [[[ApiService sharedService] getAllTasksForUser:self.userId] subscribeNext:^(NSMutableArray *tasks){
        @strongify(self)
        [self.refreshControl endRefreshing];
        self.tasks = tasks;
        [self.tableView reloadData];
    }                                              error:^(NSError *error){
        @strongify(self)
        [self.refreshControl endRefreshing];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [self refresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tasks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskCell *cell = [tableView dequeueReusableCellWithIdentifier:@"taskCell" forIndexPath:indexPath];

    [cell initCardView];

    Task *task = self.tasks[indexPath.row];
    cell.timeLabel.text = [task getTimeString];
    cell.startStopButton.tag = indexPath.row;
    [cell.startStopButton addTarget:self action:@selector(startOrStop:) forControlEvents:UIControlEventTouchUpInside];

    cell.taskTitle.text = task.title;

    if (task.active){
        cell.cardView.backgroundColor = [UIColor whiteColor];
        cell.rightView.backgroundColor = [UIColor whiteColor];
        cell.cardView.alpha = 1.0;

        [cell.startStopButton setImage:[UIImage imageNamed:@"pause_button"] forState:UIControlStateNormal];
    }else{
        [cell.startStopButton setImage:[UIImage imageNamed:@"start_button"] forState:UIControlStateNormal];
    }

    return cell;
}

- (void)startOrStop:(UIButton *)sender {
    Task *task = self.tasks[sender.tag];

    if(task.active){
        [SVProgressHUD show];
        [[[ApiService sharedService] stopTask:task.id] subscribeNext:^(Task *task1) {
            [SVProgressHUD dismiss];
            [self refresh];
        } error:^(NSError *error){
            [SVProgressHUD showErrorWithStatus:@"Ошибка"];
        }];
    } else{
        [SVProgressHUD show];
        [[[ApiService sharedService] startTask:task.id] subscribeNext:^(Task *task1) {
            [SVProgressHUD dismiss];
            [self refresh];
        } error:^(NSError *error){
            [SVProgressHUD showErrorWithStatus:@"Ошибка"];
        }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Task *task = self.tasks[indexPath.row];

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    [alertController addAction:[UIAlertAction actionWithTitle:@"Отмена" style:UIAlertActionStyleCancel handler:nil]];

    [alertController addAction:[UIAlertAction actionWithTitle:@"Изменить" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

        UIAlertController *alertController2 = [UIAlertController alertControllerWithTitle:@"Изменить задачу" message:@"Введите новое название задачи" preferredStyle:UIAlertControllerStyleAlert];

        [alertController2 addAction:[UIAlertAction actionWithTitle:@"Отмена" style:UIAlertActionStyleCancel handler:nil]];

        [alertController2 addAction:[UIAlertAction actionWithTitle:@"Изменить" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            UITextField *textField = [alertController2 textFields][0];
            [self editTask:task.id title:textField.text];
        }]];

        [alertController2 addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder =  @"Название задачи";
            textField.text = task.title;
        }];

        [self presentViewController:alertController2 animated:YES completion:nil];

    }]];

    [alertController addAction:[UIAlertAction actionWithTitle:@"Удалить" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [self deleteTask:task.id];
    }]];


    [self presentViewController:alertController animated:YES completion:nil];
}
- (IBAction)addTask:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Добавить задачу" message:@"Введите название задачи" preferredStyle:UIAlertControllerStyleAlert];

    [alertController addAction:[UIAlertAction actionWithTitle:@"Отмена" style:UIAlertActionStyleCancel handler:nil]];

    [alertController addAction:[UIAlertAction actionWithTitle:@"Добавить" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *textField = [alertController textFields][0];
        [self createTask:textField.text];
    }]];

    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Название задачи";
    }];

    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)createTask:(NSString *)text{
    [SVProgressHUD show];
    [[[ApiService sharedService] createTaskForUser:self.userId title:text] subscribeNext:^(id x) {
        [SVProgressHUD dismiss];
        [self refresh];
    } error:^(NSError *error){
        [SVProgressHUD showErrorWithStatus:@"Ошибка"];
    }];
}

-(void)editTask:(NSString *)taskId title:(NSString *)text{
    [SVProgressHUD show];
    [[[ApiService sharedService] updateTask:taskId title:text] subscribeNext:^(id x) {
        [SVProgressHUD dismiss];
        [self refresh];
    } error:^(NSError *error){
        [SVProgressHUD showErrorWithStatus:@"Ошибка"];
    }];
}


-(void)deleteTask:(NSString *)taskId{
    [SVProgressHUD show];
    [[[ApiService sharedService] deleteTask:taskId] subscribeNext:^(id x) {
        [SVProgressHUD dismiss];
        [self refresh];
    } error:^(NSError *error){
        [SVProgressHUD showErrorWithStatus:@"Ошибка"];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"userId"];
}


@end
