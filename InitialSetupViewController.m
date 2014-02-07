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
    
    UIFont *nikeTotal90 = [UIFont fontWithName:@"NikeTotal90" size:27.0];
    selectCrest.titleLabel.font = nikeTotal90;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)mainViewButtonPressed:(id)sender {
    teamSetupView.hidden = NO;
    addPlayersView.hidden = YES;
}

-(IBAction)teamSetupButtonPressed:(id)sender{
    teamSetupView.hidden = YES;
    addPlayersView.hidden = YES;
    [self saveTeamName];
    [self saveTeamCrest];
    
    [self loadPrimaryViewController];
    [self presentViewController:pvc animated:YES completion:NULL];
}

-(IBAction)addPlayersButtonPressed:(id)sender{
    [self loadPrimaryViewController];
    [self presentViewController:pvc animated:YES completion:NULL];
}

-(void) loadPrimaryViewController {
    pvc = [[PrimaryViewController alloc] initWithNibName:@"PrimaryViewController" bundle:NULL];
}

-(void) saveTeamName {
    teamNameStr = teamName.text;
    [[NSUserDefaults standardUserDefaults] setObject:teamNameStr forKey:@"teamName"];
}

-(void) saveTeamCrest {
    
}

@end
