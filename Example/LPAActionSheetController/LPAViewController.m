//
//  LPAViewController.m
//  LPAActionSheetController
//
//  Created by leeping610 on 05/21/2018.
//  Copyright (c) 2018 leeping610. All rights reserved.
//

#import "LPAViewController.h"
#import <LPAActionSheetController/LPAActionSheetController.h>

@interface LPAViewController ()

@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation LPAViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonHandler:(id)sender {
    LPAActionSheetController *actionSheetController = [[LPAActionSheetController alloc] initWithTitle:@"hahaha" titleImage:[UIImage imageNamed:@"bhp"] dismissBlock:^{
        
    }];
    actionSheetController.tapToClose = NO;
    LPAActionSheetAction *action1 = [LPAActionSheetAction actionWithTitle:@"action1"
                                                                textColor:[UIColor blackColor]
                                                          backgroundColor:[UIColor blueColor]
                                                                  handler:^(LPAActionSheetAction *actionSheetAction){
                                                                      NSLog(@"action1 clicked.");
                                                                  }];
    LPAActionSheetAction *action2 = [LPAActionSheetAction actionWithTitle:@"action2"
                                                                textColor:[UIColor yellowColor]
                                                          backgroundColor:[UIColor greenColor]
                                                                  handler:^(LPAActionSheetAction *actionSheetAction){
                                                                      NSLog(@"action2 clicked.");
                                                                  }];
    [actionSheetController addAction:action1];
    [actionSheetController addAction:action2];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:actionSheetController animated:NO completion:nil];
//    [self.navigationController presentViewController:actionSheetController animated:NO completion:nil];
}

@end
