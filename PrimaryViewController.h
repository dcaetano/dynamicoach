//
//  PrimaryViewController.h
//  DynamiCoach
//
//  Created by Danilo on 1/15/14.
//  Copyright (c) 2014 dcaetano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "FMDatabase.h"

@interface PrimaryViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIAlertViewDelegate> {
    
    NSString *firstNameStr, *lastNameStr, *phoneNumberStr, *emailAddressStr;
    NSString *regCount;
    NSMutableArray *playerList_lastName;
    NSMutableArray *playerList_firstName;
    NSMutableArray *playerList_email;
    NSMutableArray *playerList_phoneNumber;
    NSString *selectedPlayer;
    NSInteger formationNumber;
    BOOL pressedOK;
    id btnSender;
    
    FMDatabase *database;
    
    //Primary View Controller vars
    IBOutlet UIView *mainMenuView;
    IBOutlet UIView *controllerView;
    IBOutlet UIView *formationView;
    IBOutlet UIView *contactView;
    IBOutlet UIView *addPlayerView;
    
    IBOutlet UIView *player0View;
    IBOutlet UIView *player1View;
    IBOutlet UIView *player2View;
    IBOutlet UIView *player3View;
    IBOutlet UIView *player4View;
    IBOutlet UIView *player5View;
    IBOutlet UIView *player6View;
    IBOutlet UIView *player7View;
    IBOutlet UIView *player8View;
    IBOutlet UIView *player9View;
    IBOutlet UIView *player10View;
    
    IBOutlet UIButton *rosterBackButton;
    IBOutlet UIButton *rosterButton;
    IBOutlet UIButton *formationButton;
    IBOutlet UIButton *formationBackButton;
    IBOutlet UIButton *contactButton;
    IBOutlet UIButton *contactBackButton;
    IBOutlet UIButton *settingsButton;
    
    IBOutlet UIButton *player0Button;
    IBOutlet UIButton *player1Button;
    IBOutlet UIButton *player2Button;
    IBOutlet UIButton *player3Button;
    IBOutlet UIButton *player4Button;
    IBOutlet UIButton *player5Button;
    IBOutlet UIButton *player6Button;
    IBOutlet UIButton *player7Button;
    IBOutlet UIButton *player8Button;
    IBOutlet UIButton *player9Button;
    IBOutlet UIButton *player10Button;
    
    IBOutlet UITableView *rosterTable;
    IBOutlet UIButton *addPlayerButton;
    IBOutlet UIButton *clearRosterButton;
    
    IBOutlet UIButton *addPlayerCancelButton;
    IBOutlet UIButton *addPlayerSubmitButton;
    
    IBOutlet UITextField *firstName;
    IBOutlet UITextField *lastName;
    IBOutlet UITextField *phoneNumber;
    IBOutlet UITextField *emailAddress;
    
    IBOutlet UIView *modalBenchView;
    IBOutlet UIButton *okModalBenchButton;
    
    IBOutlet UILabel *teamName;
    IBOutlet UILabel *teamName2;
    IBOutlet UILabel *quickSubstitution;
    
    IBOutlet UILabel *firstNameLabel;
    IBOutlet UILabel *lastNameLabel;
    IBOutlet UILabel *phoneNumberLabel;
    IBOutlet UILabel *emailLabel;
    IBOutlet UILabel *addPlayerLabel;
    
    //Stopwatch section
    IBOutlet UILabel *stopWatchTimerLabel;
    NSTimer *stopWatchTimer;
    BOOL running;
    IBOutlet UIView *gameTimerView;
    
    //Drawable section
    IBOutlet UIView *drawingView;
    IBOutlet UIImageView *mainImage;
    IBOutlet UIImageView *tempDrawImage;
    IBOutlet UIButton *eraserButton;
    IBOutlet UIButton *saveDrawingButton;
    IBOutlet UIButton *resetDrawingButton;
    IBOutlet UIButton *pencilDrawingButton;
    IBOutlet UIView *drawer;
    CGPoint lastPoint;
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat brush;
    CGFloat opacity;
    BOOL mouseSwiped;
    
    //Settings
    IBOutlet UITextField *teamNameSettings;
    IBOutlet UIButton *blackPen;
    IBOutlet UIButton *grayPen;
    IBOutlet UIButton *redPen;
    IBOutlet UIButton *bluePen;
    IBOutlet UIButton *greenPen;
    IBOutlet UIButton *settingsBackButton;
    IBOutlet UIButton *settingsSubmitButton;
    IBOutlet UIView *settingsView;
    IBOutlet UILabel *settingsLabel;
    IBOutlet UILabel *settingsTeamNameLabel;
    IBOutlet UILabel *settingsBrushColorLabel;
    
    //Formations
    IBOutlet UIButton *form2000;
    IBOutlet UIButton *form2001;
    IBOutlet UIButton *form2002;
    IBOutlet UIButton *form2003;
    IBOutlet UIButton *form2004;
    IBOutlet UIButton *form2005;
    IBOutlet UIButton *form2006;
    IBOutlet UIButton *form2007;
    IBOutlet UIButton *form2008;
    IBOutlet UIButton *form2009;
    IBOutlet UIButton *form2010;
    IBOutlet UIButton *form2011;
    IBOutlet UIButton *form2012;
    IBOutlet UIButton *form2013;
    IBOutlet UIButton *form2014;
}

@property (strong, nonatomic) NSString *databasePath;
@property (nonatomic) sqlite3 *playerDB;
@property (strong, nonatomic) NSDate *startDate; // Stores the date of the click on the start button
@property (strong, nonatomic) IBOutlet UIPickerView *picker;

-(IBAction)rosterBackButtonPressed:(id)sender;
-(IBAction)formationBackButtonPressed:(id)sender;
-(IBAction)contactBackButtonPressed:(id)sender;
-(IBAction)contactButtonPressed:(id)sender;
-(IBAction)rosterButtonPressed:(id)sender;
-(IBAction)formationButtonPressed:(id)sender;
-(IBAction)clearRosterButtonPressed:(id)sender;
-(IBAction)reset:(id)sender;
-(IBAction)eraserPressed:(id)sender;
-(IBAction)saveDrawingButton:(id)sender;
-(IBAction)selectPlayerToSub:(id)sender;
-(IBAction)drawButtonPressed:(id)sender;
-(IBAction)okModalBenchButtonPressed:(id)sender;
-(IBAction)choosePlayerFormation:(id)sender;

@end
