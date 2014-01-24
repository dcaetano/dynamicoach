//
//  InitialSetupViewController.h
//  DynamiCoach
//
//  Created by Danilo on 1/24/14.
//  Copyright (c) 2014 dcaetano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrimaryViewController.h"

@interface InitialSetupViewController : UIViewController {
    
    IBOutlet UIView *mainView;
    IBOutlet UIView *teamSetupView;
    IBOutlet UIView *addPlayersView;
    
    IBOutlet UIButton *mainViewButton;
    IBOutlet UIButton *teamSetupButton;
    IBOutlet UIButton *addPlayersButton;
}

@property (nonatomic, strong) PrimaryViewController *pvc;

-(IBAction)mainViewButtonPressed:(id)sender;
-(IBAction)teamSetupButtonPressed:(id)sender;
-(IBAction)addPlayersButtonPressed:(id)sender;

@end
