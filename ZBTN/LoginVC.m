//
//  LoginVC.m
//  ZBTN
//
//  Created by Azamat Kushmanov on 11/10/16.
//  Copyright © 2016 Azamat Kushmanov. All rights reserved.
//

#import "LoginVC.h"
#import "TasksTVC.h"

@interface LoginVC ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *loginTextView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];

    if([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]){
        TasksTVC *vc =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TasksTVC"];
        [self.navigationController pushViewController:vc animated:NO];
    }

    [self.loginTextView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login:(id)sender {
    if(self.loginTextView.text.length > 0){
        [[NSUserDefaults standardUserDefaults] setObject:self.loginTextView.text forKey:@"userId"];
        TasksTVC *vc =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TasksTVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
