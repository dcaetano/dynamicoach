//
//  InitialSetupViewController.m
//  DynamiCoach
//
//  Created by Danilo on 1/24/14.
//  Copyright (c) 2014 dcaetano. All rights reserved.
//

#import "InitialSetupViewController.h"
#import "AppDelegate.h"

@interface InitialSetupViewController ()

@end

@implementation InitialSetupViewController
@synthesize pvc;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    teamSetupView.hidden = YES;
    addPlayersView.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)mainViewButtonPressed:(id)sender {
    //mainView.hidden = YES;
    teamSetupView.hidden = NO;
    addPlayersView.hidden = YES;
}

-(IBAction)teamSetupButtonPressed:(id)sender{
    //mainView.hidden = YES;
    teamSetupView.hidden = YES;
    addPlayersView.hidden = NO;
}

-(IBAction)addPlayersButtonPressed:(id)sender{
    //mainView.hidden = YES;
    teamSetupView.hidden = YES;
    addPlayersView.hidden = YES;
    
    [self loadPrimaryViewController];
    [self presentViewController:pvc animated:YES completion:NULL];
}

-(void) loadPrimaryViewController {
    pvc = [[PrimaryViewController alloc] initWithNibName:@"PrimaryViewController" bundle:NULL];
}

@end
