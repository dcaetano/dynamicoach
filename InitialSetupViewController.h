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
    
    NSString *teamNameStr;
    
    IBOutlet UIView *mainView;
    IBOutlet UIView *teamSetupView;
    IBOutlet UIView *addPlayersView;
    
    IBOutlet UIButton *mainViewButton;
    IBOutlet UIButton *teamSetupButton;
    IBOutlet UIButton *addPlayersButton;
    
    IBOutlet UITextField *teamName;
    IBOutlet UIButton *selectCrest;
    IBOutlet UIImageView *crestImage;
}

@property (nonatomic, strong) PrimaryViewController *pvc;

-(IBAction)mainViewButtonPressed:(id)sender;
-(IBAction)teamSetupButtonPressed:(id)sender;
-(IBAction)addPlayersButtonPressed:(id)sender;

@end
