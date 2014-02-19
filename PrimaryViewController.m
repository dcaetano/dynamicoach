//
//  PrimaryViewController.m
//  DynamiCoach
//
//  Created by Danilo on 1/15/14.
//  Copyright (c) 2014 dcaetano. All rights reserved.
//
//******************************************************************
// BUG NOTES / TO-DO LIST:
//
// Priority 1
// - Cache players on field*
// - Need a better eraser that doesn't erase the field background
// - Missing "Edit" player from roster
//
// Priority 2
// - Missing RGB picker
// - Missing brush size selector
// - When saving the image, needs to include players as well!
// - "Undo" button drawing
// - Press/hold to drag and position
// - Team Logo
//
// Priority UI
// - Update UI as a whole
//   > Color scheme
//   > Logos, loading page, app icon
//
//******************************************************************

#import "PrimaryViewController.h"
#import "RosterTableCell.h"
#import "FMDatabase.h"
#import <QuartzCore/QuartzCore.h>

@interface PrimaryViewController ()

@end

@implementation PrimaryViewController

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
    red = 0.0/255.0;
    green = 0.0/255.0;
    blue = 0.0/255.0;
    brush = 3.0;
    opacity = 1.0;
    
    [self setCustomFontForEverything];
    
    selectedPlayer = @"";
    running = NO;
    stopWatchTimer = [[NSTimer alloc] init];
    
    [self toggleDrawingEnabled];
    [self toggleSubstitutionButtons];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *path = [docsPath stringByAppendingPathComponent:@"players.sqlite"];
    
    database = [FMDatabase databaseWithPath:path];
    
    [database open];
    [database executeUpdate:@"create table if not exists roster(id int primary key, firstname text, lastname text, email text, phone text, jersey text)"];
    
    //popuate Player List from DB
    playerList_lastName = [[NSMutableArray alloc] init];
    playerList_firstName = [[NSMutableArray alloc] init];
    playerList_email = [[NSMutableArray alloc] init];
    playerList_phoneNumber = [[NSMutableArray alloc] init];
    
    if([playerList_lastName count] == 0)
        [self repopulatePlayerList];
    
    [super viewDidLoad];

    //teamName.transform = CGAffineTransformMakeRotation((M_PI)/2);
    //teamName2.transform = CGAffineTransformMakeRotation(-(M_PI)/2);
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidAppear:(BOOL)animated {
    NSLog(@"viewDidAppear");
    [self refreshUI];
    [super viewDidAppear:NO];
}

-(void) refreshUI {
    NSLog(@"Refresh UI");
    [self getDefaultValues];
    [self setCustomFontForEverything];
    [self prettyButtonsFTW];
}

-(void) getDefaultValues {
    
    if([[NSUserDefaults standardUserDefaults]
        integerForKey:@"setFormation"])
    {
        formationNumber = [[NSUserDefaults standardUserDefaults] integerForKey:@"setFormation"];
        NSLog(@"formation # : %ld", (long)formationNumber);
        [self formationSelected:formationNumber];
        NSLog(@"formationSelected - went through");
    }
    
    NSString *teamNameStr = [[NSUserDefaults standardUserDefaults]
                             stringForKey:@"teamName"];
    teamNameStr = [teamNameStr uppercaseString];
    teamName.text = teamNameStr;
    teamName2.text = teamNameStr;
    NSLog(@"Team Name: %@", teamNameStr);
    
    NSString *playerLog;
    
    //Player 0
    if([[NSUserDefaults standardUserDefaults] stringForKey:@"player0"]) {
        player0Button.titleLabel.text = [[NSUserDefaults standardUserDefaults]
                                         stringForKey:@"player0"];
    }
    else {
        player0Button.titleLabel.text = @"SET PLAYER";
    }
    playerLog = [[NSUserDefaults standardUserDefaults]
                 stringForKey:@"player0"];
    NSLog(@"Player 0 - %@", playerLog);
    
    //Player 1
    if([[NSUserDefaults standardUserDefaults] stringForKey:@"player1"]) {
        player1Button.titleLabel.text = [[NSUserDefaults standardUserDefaults]
                                         stringForKey:@"player1"];
    }
    else {
        player1Button.titleLabel.text = @"SET PLAYER";
    }
    playerLog = [[NSUserDefaults standardUserDefaults]
                 stringForKey:@"player1"];
    NSLog(@"Player 1 - %@", playerLog);
    
    //Player 2
    if([[NSUserDefaults standardUserDefaults] stringForKey:@"player2"]) {
        player2Button.titleLabel.text = [[NSUserDefaults standardUserDefaults]
                                         stringForKey:@"player2"];
    }
    else {
        player2Button.titleLabel.text = @"SET PLAYER";
    }
    playerLog = [[NSUserDefaults standardUserDefaults]
                 stringForKey:@"player2"];
    NSLog(@"Player 2 - %@", playerLog);
    
    //Player 3
    if([[NSUserDefaults standardUserDefaults] stringForKey:@"player3"]) {
        player3Button.titleLabel.text = [[NSUserDefaults standardUserDefaults]
                                         stringForKey:@"player3"];
    }
    else {
        player3Button.titleLabel.text = @"SET PLAYER";
    }
    playerLog = [[NSUserDefaults standardUserDefaults]
                 stringForKey:@"player3"];
    NSLog(@"Player 3 - %@", playerLog);
    
    //Player 4
    if([[NSUserDefaults standardUserDefaults] stringForKey:@"player4"]) {
        player4Button.titleLabel.text = [[NSUserDefaults standardUserDefaults]
                                         stringForKey:@"player4"];
    }
    else {
        player4Button.titleLabel.text = @"SET PLAYER";
    }
    playerLog = [[NSUserDefaults standardUserDefaults]
                 stringForKey:@"player4"];
    NSLog(@"Player 4 - %@", playerLog);
    
    //Player 5
    if([[NSUserDefaults standardUserDefaults] stringForKey:@"player5"]) {
        player5Button.titleLabel.text = [[NSUserDefaults standardUserDefaults]
                                         stringForKey:@"player5"];
    }
    else {
        player5Button.titleLabel.text = @"SET PLAYER";
    }
    playerLog = [[NSUserDefaults standardUserDefaults]
                 stringForKey:@"player5"];
    NSLog(@"Player 5 - %@", playerLog);
    
    //Player 6
    if([[NSUserDefaults standardUserDefaults] stringForKey:@"player6"]) {
        player6Button.titleLabel.text = [[NSUserDefaults standardUserDefaults]
                                         stringForKey:@"player6"];
    }
    else {
        player6Button.titleLabel.text = @"SET PLAYER";
    }
    playerLog = [[NSUserDefaults standardUserDefaults]
                 stringForKey:@"player6"];
    NSLog(@"Player 6 - %@", playerLog);
    
    //Player 7
    if([[NSUserDefaults standardUserDefaults] stringForKey:@"player7"]) {
        player7Button.titleLabel.text = [[NSUserDefaults standardUserDefaults]
                                         stringForKey:@"player7"];
    }
    else {
        player7Button.titleLabel.text = @"SET PLAYER";
    }
    playerLog = [[NSUserDefaults standardUserDefaults]
                 stringForKey:@"player7"];
    NSLog(@"Player 7 - %@", playerLog);
    
    //Player 8
    if([[NSUserDefaults standardUserDefaults] stringForKey:@"player8"]) {
        player8Button.titleLabel.text = [[NSUserDefaults standardUserDefaults]
                                         stringForKey:@"player8"];
    }
    else {
        player8Button.titleLabel.text = @"SET PLAYER";
    }
    playerLog = [[NSUserDefaults standardUserDefaults]
                 stringForKey:@"player8"];
    NSLog(@"Player 8 - %@", playerLog);
    
    //Player 9
    if([[NSUserDefaults standardUserDefaults] stringForKey:@"player9"]) {
        player9Button.titleLabel.text = [[NSUserDefaults standardUserDefaults]
                                         stringForKey:@"player9"];
    }
    else {
        player9Button.titleLabel.text = @"SET PLAYER";
    }
    playerLog = [[NSUserDefaults standardUserDefaults]
                 stringForKey:@"player9"];
    NSLog(@"Player 9 - %@", playerLog);
    
    //Player 10
    if([[NSUserDefaults standardUserDefaults] stringForKey:@"player10"]) {
        player10Button.titleLabel.text = [[NSUserDefaults standardUserDefaults]
                                         stringForKey:@"player10"];
    }
    else {
        player10Button.titleLabel.text = @"SET PLAYER";
    }
    playerLog = [[NSUserDefaults standardUserDefaults]
                 stringForKey:@"player10"];
    NSLog(@"Player 10 - %@", playerLog);
}

-(void) prettyButtonsFTW {
    
    //Player 0 Button
    player0Button.layer.cornerRadius = 3;
    player0Button.layer.borderWidth = 2;
    player0Button.layer.borderColor = [UIColor blackColor].CGColor;
    player0Button.layer.backgroundColor = [UIColor lightGrayColor].CGColor;
    
    //Player 1 Button
    player1Button.layer.cornerRadius = 3;
    player1Button.layer.borderWidth = 2;
    player1Button.layer.borderColor = [UIColor blackColor].CGColor;
    player1Button.layer.backgroundColor = [UIColor lightGrayColor].CGColor;
    
    //Player 2 Button
    player2Button.layer.cornerRadius = 3;
    player2Button.layer.borderWidth = 2;
    player2Button.layer.borderColor = [UIColor blackColor].CGColor;
    player2Button.layer.backgroundColor = [UIColor lightGrayColor].CGColor;
    
    //Player 3 Button
    player3Button.layer.cornerRadius = 3;
    player3Button.layer.borderWidth = 2;
    player3Button.layer.borderColor = [UIColor blackColor].CGColor;
    player3Button.layer.backgroundColor = [UIColor lightGrayColor].CGColor;
    
    //Player 4 Button
    player4Button.layer.cornerRadius = 3;
    player4Button.layer.borderWidth = 2;
    player4Button.layer.borderColor = [UIColor blackColor].CGColor;
    player4Button.layer.backgroundColor = [UIColor lightGrayColor].CGColor;
    
    //Player 5 Button
    player5Button.layer.cornerRadius = 3;
    player5Button.layer.borderWidth = 2;
    player5Button.layer.borderColor = [UIColor blackColor].CGColor;
    player5Button.layer.backgroundColor = [UIColor lightGrayColor].CGColor;
    
    //Player 6 Button
    player6Button.layer.cornerRadius = 3;
    player6Button.layer.borderWidth = 2;
    player6Button.layer.borderColor = [UIColor blackColor].CGColor;
    player6Button.layer.backgroundColor = [UIColor lightGrayColor].CGColor;
    
    //Player 7 Button
    player7Button.layer.cornerRadius = 3;
    player7Button.layer.borderWidth = 2;
    player7Button.layer.borderColor = [UIColor blackColor].CGColor;
    player7Button.layer.backgroundColor = [UIColor lightGrayColor].CGColor;
    
    //Player 8 Button
    player8Button.layer.cornerRadius = 3;
    player8Button.layer.borderWidth = 2;
    player8Button.layer.borderColor = [UIColor blackColor].CGColor;
    player8Button.layer.backgroundColor = [UIColor lightGrayColor].CGColor;
    
    //Player 9 Button
    player9Button.layer.cornerRadius = 3;
    player9Button.layer.borderWidth = 2;
    player9Button.layer.borderColor = [UIColor blackColor].CGColor;
    player9Button.layer.backgroundColor = [UIColor lightGrayColor].CGColor;
    
    //Player 10 Button
    player10Button.layer.cornerRadius = 3;
    player10Button.layer.borderWidth = 2;
    player10Button.layer.borderColor = [UIColor blackColor].CGColor;
    player10Button.layer.backgroundColor = [UIColor lightGrayColor].CGColor;
    
    //Roster Button
    rosterButton.layer.cornerRadius = 5;
    rosterButton.layer.borderWidth = 2;
    //rosterButton.layer.borderColor = [UIColor colorWithRed:0.0/255.0f green:197.0/255.0f blue:1.0/255.0f alpha:0.62].CGColor;
    rosterButton.layer.backgroundColor = [UIColor darkGrayColor].CGColor;
    
    //Formation Button
    formationButton.layer.cornerRadius = 5;
    formationButton.layer.borderWidth = 2;
    //formationButton.layer.borderColor = [UIColor colorWithRed:0.0/255.0f green:197.0/255.0f blue:1.0/255.0f alpha:0.62].CGColor;
    formationButton.layer.backgroundColor = [UIColor darkGrayColor].CGColor;

    //Settings Button
    settingsButton.layer.cornerRadius = 5;
    settingsButton.layer.borderWidth = 2;
    //settingsButton.layer.borderColor = [UIColor colorWithRed:0.0/255.0f green:197.0/255.0f blue:1.0/255.0f alpha:0.62].CGColor;
    settingsButton.layer.backgroundColor = [UIColor darkGrayColor].CGColor;
    
    //Drawer View
    drawer.layer.cornerRadius = 5;
    drawer.layer.borderWidth = 2;
    //drawer.layer.borderColor = [UIColor colorWithRed:0.0/255.0f green:197.0/255.0f blue:1.0/255.0f alpha:0.62].CGColor;
    drawer.layer.backgroundColor = [UIColor darkGrayColor].CGColor;
    
    //Game Timer View
    gameTimerView.layer.cornerRadius = 5;
    gameTimerView.layer.borderWidth = 2;
    //gameTimerView.layer.borderColor = [UIColor colorWithRed:0.0/255.0f green:197.0/255.0f blue:1.0/255.0f alpha:0.62].CGColor;
    gameTimerView.layer.backgroundColor = [UIColor darkGrayColor].CGColor;
    
    //Add Player Button
    addPlayerButton.layer.cornerRadius = 5;
    addPlayerButton.layer.borderWidth = 2;
    //addPlayerButton.layer.borderColor = [UIColor colorWithRed:0.0/255.0f green:197.0/255.0f blue:1.0/255.0f alpha:0.62].CGColor;
    addPlayerButton.layer.backgroundColor = [UIColor darkGrayColor].CGColor;
    
    //Clear Roster Button
    clearRosterButton.layer.cornerRadius = 5;
    clearRosterButton.layer.borderWidth = 2;
    //clearRosterButton.layer.borderColor = [UIColor colorWithRed:0.0/255.0f green:197.0/255.0f blue:1.0/255.0f alpha:0.62].CGColor;
    clearRosterButton.layer.backgroundColor = [UIColor darkGrayColor].CGColor;
    
    //Add Player Submit Button
    addPlayerSubmitButton.layer.cornerRadius = 5;
    addPlayerSubmitButton.layer.borderWidth = 2;
    //addPlayerSubmitButton.layer.borderColor = [UIColor colorWithRed:0.0/255.0f green:197.0/255.0f blue:1.0/255.0f alpha:0.62].CGColor;
    addPlayerSubmitButton.layer.backgroundColor = [UIColor darkGrayColor].CGColor;
    
    //Add Player Cancel Button
    addPlayerCancelButton.layer.cornerRadius = 5;
    addPlayerCancelButton.layer.borderWidth = 2;
    //addPlayerCancelButton.layer.borderColor = [UIColor colorWithRed:0.0/255.0f green:197.0/255.0f blue:1.0/255.0f alpha:0.62].CGColor;
    addPlayerCancelButton.layer.backgroundColor = [UIColor darkGrayColor].CGColor;
    
    //Formation Cancel Button
    formationBackButton.layer.cornerRadius = 5;
    formationBackButton.layer.borderWidth = 2;
    //addPlayerCancelButton.layer.borderColor = [UIColor colorWithRed:0.0/255.0f green:197.0/255.0f blue:1.0/255.0f alpha:0.62].CGColor;
    formationBackButton.layer.backgroundColor = [UIColor darkGrayColor].CGColor;
    
    //Roster Back Button
    rosterBackButton.layer.cornerRadius = 5;
    rosterBackButton.layer.borderWidth = 2;
    //rosterBackButton.layer.borderColor = [UIColor colorWithRed:0.0/255.0f green:197.0/255.0f blue:1.0/255.0f alpha:0.62].CGColor;
    rosterBackButton.layer.backgroundColor = [UIColor darkGrayColor].CGColor;
    
    //Settings Back Button
    settingsBackButton.layer.cornerRadius = 5;
    settingsBackButton.layer.borderWidth = 2;
    //settingsBackButton.layer.borderColor = [UIColor colorWithRed:0.0/255.0f green:197.0/255.0f blue:1.0/255.0f alpha:0.62].CGColor;
    settingsBackButton.layer.backgroundColor = [UIColor darkGrayColor].CGColor;
    
    //Settings Submit Button
    settingsSubmitButton.layer.cornerRadius = 5;
    settingsSubmitButton.layer.borderWidth = 2;
    //settingsSubmitButton.layer.borderColor = [UIColor colorWithRed:0.0/255.0f green:197.0/255.0f blue:1.0/255.0f alpha:0.62].CGColor;
    settingsSubmitButton.layer.backgroundColor = [UIColor darkGrayColor].CGColor;
}

-(void) setCustomFontForEverything {
    
    UIFont *nikeTotal90 = [UIFont fontWithName:@"NikeTotal90" size:27.0];
    UIFont *nikeTotal90_18 = [UIFont fontWithName:@"NikeTotal90" size:18.0];
    UIFont *nikeTotal90_42 = [UIFont fontWithName:@"NikeTotal90" size:42.0];
    
    stopWatchTimerLabel.font = nikeTotal90_42;
    teamName.font = nikeTotal90;
    teamName2.font = nikeTotal90;
    
    rosterButton.titleLabel.font = nikeTotal90;
    rosterBackButton.titleLabel.font = nikeTotal90_18;
    formationButton.titleLabel.font = nikeTotal90;
    formationBackButton.titleLabel.font = nikeTotal90_18;
    addPlayerButton.titleLabel.font = nikeTotal90_18;
    addPlayerSubmitButton.titleLabel.font = nikeTotal90_18;
    addPlayerCancelButton.titleLabel.font = nikeTotal90_18;
    clearRosterButton.titleLabel.font = nikeTotal90_18;
    settingsButton.titleLabel.font = nikeTotal90;
    
    quickSubstitution.font = nikeTotal90;
    okModalBenchButton.titleLabel.font = nikeTotal90;
    firstNameLabel.font = nikeTotal90;
    lastNameLabel.font = nikeTotal90;
    emailLabel.font = nikeTotal90;
    phoneNumberLabel.font = nikeTotal90;
    
    player0Button.titleLabel.font = nikeTotal90_18;
    player1Button.titleLabel.font = nikeTotal90_18;
    player2Button.titleLabel.font = nikeTotal90_18;
    player3Button.titleLabel.font = nikeTotal90_18;
    player4Button.titleLabel.font = nikeTotal90_18;
    player5Button.titleLabel.font = nikeTotal90_18;
    player6Button.titleLabel.font = nikeTotal90_18;
    player7Button.titleLabel.font = nikeTotal90_18;
    player8Button.titleLabel.font = nikeTotal90_18;
    player9Button.titleLabel.font = nikeTotal90_18;
    player10Button.titleLabel.font = nikeTotal90_18;
    
    settingsSubmitButton.titleLabel.font = nikeTotal90_18;
    settingsBackButton.titleLabel.font = nikeTotal90_18;
    settingsBrushColorLabel.font = nikeTotal90;
    settingsTeamNameLabel.font = nikeTotal90;
    settingsLabel.font = nikeTotal90;
}

-(IBAction)rosterButtonPressed:(id)sender {
    [self rosterView];
}

-(IBAction)formationButtonPressed:(id)sender {
    [self formationView];
}

-(IBAction)contactButtonPressed:(id)sender {
    [self contactView];
}

-(IBAction)rosterBackButtonPressed:(id)sender{
    [self mainView];
}

-(IBAction)formationBackButtonPressed:(id)sender{
    [self mainView];
}

-(IBAction)contactBackButtonPressed:(id)sender{
    [self mainView];
}

-(IBAction)addPlayerButtonPressed:(id)sender{
    [self addPlayerView];
    [self.view endEditing:YES];
}

-(IBAction)addPlayerSubmitButtonPressed:(id)sender{
    firstNameStr = firstName.text;
    lastNameStr = lastName.text;
    phoneNumberStr = phoneNumber.text;
    emailAddressStr = emailAddress.text;
    
    firstNameStr = [firstNameStr uppercaseString];
    lastNameStr = [lastNameStr uppercaseString];
    
    NSLog(@"Add Player");
    NSLog(@"First Name: %@", firstNameStr);
    NSLog(@"Last Name: %@", lastNameStr);
    NSLog(@"Phone Number: %@", phoneNumberStr);
    NSLog(@"Email Address: %@", emailAddressStr);
    NSLog(@"Number: ##");
    
    BOOL success = NO;
    NSString *alertString = @"Data Insertion failed";
    if (firstNameStr.length>0 && lastNameStr.length>0 &&phoneNumberStr.length>0 && emailAddressStr.length>0)
    {
        [database open];
        // Let fmdb do the work
        [database executeUpdate:@"insert into roster(firstname, lastname, email, phone, jersey) values(?,?,?,?,?)",
        firstNameStr, lastNameStr, emailAddressStr, phoneNumberStr, @"##",nil];
        [database close];
    
        success = YES;
        firstName.text = @"";
        lastName.text = @"";
        emailAddress.text = @"";
        phoneNumber.text = @"";
    }
    else{
        alertString = @"Enter all fields!";
    }
    if (success == NO) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:
                              alertString message:nil
                            delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else {
        [self repopulatePlayerList];
        [self.view endEditing:YES];
        addPlayerView.hidden = YES;
    }
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

-(void) repopulatePlayerList {
    playerList_lastName = [self playerList_LAST];
    playerList_firstName = [self playerList_FIRST];
    playerList_phoneNumber = [self playerList_PHONE];
    playerList_email = [self playerList_EMAIL];
    [rosterTable reloadData];
}

-(IBAction)addPlayerCancelButtonPressed:(id)sender{
    
    firstName.text = @"";
    lastName.text = @"";
    emailAddress.text = @"";
    phoneNumber.text = @"";
    
    addPlayerView.hidden = YES;
    [self.view endEditing:YES];
}

-(IBAction)clearRosterButtonPressed:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc] init];
    [alert setTitle:@"WARNING"];
    [alert setMessage:@"Are you sure you want to clear your roster? This is permanent and cannot be reversed."];
    [alert setDelegate:self];
    [alert addButtonWithTitle:@"Yes"];
    [alert addButtonWithTitle:@"No"];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self clearRoster];
        [self repopulatePlayerList];
    }
    else if (buttonIndex == 1)
    {
        NSLog(@"Do nothing.");
    }
}

-(void) deletePlayerFromRoster:(NSString*)playerStr {
    
    [database open];
    FMResultSet *results = [database executeQuery:@"delete from roster where lastname = ?", playerStr];
    while([results next]) {
        NSLog(@"%@ deleted!", playerStr);
    }
    [database close];
}

-(void) clearRoster {
    [database open];
    FMResultSet *results = [database executeQuery:@"delete from roster"];
    while([results next]) {
        NSLog(@"Roster deleted!");
    }
    [database close];
    
    [player0Button setTitle:@"SET PLAYER" forState:UIControlStateNormal];
    [player1Button setTitle:@"SET PLAYER" forState:UIControlStateNormal];
    [player2Button setTitle:@"SET PLAYER" forState:UIControlStateNormal];
    [player3Button setTitle:@"SET PLAYER" forState:UIControlStateNormal];
    [player4Button setTitle:@"SET PLAYER" forState:UIControlStateNormal];
    [player5Button setTitle:@"SET PLAYER" forState:UIControlStateNormal];
    [player6Button setTitle:@"SET PLAYER" forState:UIControlStateNormal];
    [player7Button setTitle:@"SET PLAYER" forState:UIControlStateNormal];
    [player8Button setTitle:@"SET PLAYER" forState:UIControlStateNormal];
    [player9Button setTitle:@"SET PLAYER" forState:UIControlStateNormal];
    [player10Button setTitle:@"SET PLAYER" forState:UIControlStateNormal];
}

-(NSMutableArray*) playerList_LAST {
    
    NSMutableArray *list = [[NSMutableArray alloc] init];
    [database open];
    FMResultSet *results = [database executeQuery:@"select lastname from roster"];
    while([results next]) {
        lastNameStr = [results stringForColumn:@"lastname"];
        [list addObject:lastNameStr];
    }
    [database close];
    
    return list;
}

-(NSMutableArray*) playerList_FIRST {
    
    NSMutableArray *list = [[NSMutableArray alloc] init];
    [database open];
    FMResultSet *results = [database executeQuery:@"select firstname from roster"];
    while([results next]) {
        firstNameStr = [results stringForColumn:@"firstname"];
        [list addObject:firstNameStr];
    }
    [database close];
    
    return list;
}

-(NSMutableArray*) playerList_EMAIL {
    
    NSMutableArray *list = [[NSMutableArray alloc] init];
    [database open];
    FMResultSet *results = [database executeQuery:@"select email from roster"];
    while([results next]) {
        emailAddressStr = [results stringForColumn:@"email"];
        [list addObject:emailAddressStr];
    }
    [database close];
    
    return list;
}

-(NSMutableArray*) playerList_PHONE {
    
    NSMutableArray *list = [[NSMutableArray alloc] init];
    [database open];
    FMResultSet *results = [database executeQuery:@"select phone from roster"];
    while([results next]) {
        phoneNumberStr = [results stringForColumn:@"phone"];
        [list addObject:phoneNumberStr];
    }
    [database close];
    
    return list;
}

- (void)updateTimer
{
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:self.startDate];
    NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"H:mm:ss:SS"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    NSString *timeString=[dateFormatter stringFromDate:timerDate];
    stopWatchTimerLabel.text = timeString;
}

- (IBAction)startStopwatchPressed:(id)sender {
    if(!running){
        self.startDate = [NSDate date];
        running = TRUE;
        [sender setTitle:@"Stop" forState:UIControlStateNormal];
        if (stopWatchTimer == nil) {
            stopWatchTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/10.0
                                                         target:self
                                                       selector:@selector(updateTimer)
                                                       userInfo:nil
                                                        repeats:YES];
        }
    }else{
        running = FALSE;
        [sender setTitle:@"Start" forState:UIControlStateNormal];
        [stopWatchTimer invalidate];
        stopWatchTimer = nil;
    }
}

- (IBAction)stopStopwatchPressed:(id)sender {
    [stopWatchTimer invalidate];
    stopWatchTimer = nil;
    stopWatchTimerLabel.text = @"0:00:00:00";
    running = FALSE;
}

-(void) rosterView {
    controllerView.hidden = NO;
}

-(void) formationView {
    formationView.hidden = NO;
}

-(void) contactView {
    //contactView.hidden = NO;
}

-(void) addPlayerView {
    addPlayerView.hidden = NO;
}

-(void) mainView {
    controllerView.hidden = YES;
    formationView.hidden = YES;
}
//******************************************************************
//Keyboard Methods
//******************************************************************
-(void) returnKeyboard {
    [self.view endEditing:YES];
}

//******************************************************************
//Substitution Methods
//******************************************************************

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    [self repopulatePlayerList];
    
    if([playerList_lastName count])
        return [playerList_lastName count];
    
    return 1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
    [self repopulatePlayerList];
    
    if([playerList_lastName count])
        return [playerList_lastName objectAtIndex:row];
    else
        return @"EMPTY";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component{
    
    NSLog(@"Selected Row %d", row);
    selectedPlayer = @"";
    
    [self repopulatePlayerList];
    
    if([playerList_lastName count])
        selectedPlayer = [playerList_lastName objectAtIndex:row];
    else
        selectedPlayer = @"SET PLAYER";
    
    NSLog(@"selectedPlayer = %@", selectedPlayer);
}

-(void) benchModalWindow {
    pressedOK = NO;
    if([playerList_lastName count])
        selectedPlayer = [playerList_lastName objectAtIndex:0];
    else
        selectedPlayer = @"SET PLAYER";
    
    [self repopulatePlayerList];
    [self.picker reloadAllComponents];
    modalBenchView.hidden = NO;
}

-(IBAction)okModalBenchButtonPressed:(id)sender{
    
    NSString *substituteString = selectedPlayer;
    
    UIButton *pressedButton = (UIButton*)btnSender;
    switch(pressedButton.tag)
    {
        case 1000: //Player 0
            NSLog(@"Player 0 selected.");
            [player0Button setTitle:substituteString forState:UIControlStateNormal];
            [[NSUserDefaults standardUserDefaults] setObject:substituteString forKey:@"player0"];
            break;
        case 1001: //Player 1
            NSLog(@"Player 1 selected.");
            [player1Button setTitle:substituteString forState:UIControlStateNormal];
            [[NSUserDefaults standardUserDefaults] setObject:substituteString forKey:@"player1"];
            break;
        case 1002: //Player 2
            NSLog(@"Player 2 selected.");
            [player2Button setTitle:substituteString forState:UIControlStateNormal];
            [[NSUserDefaults standardUserDefaults] setObject:substituteString forKey:@"player2"];
            break;
        case 1003: //Player 3
            NSLog(@"Player 3 selected.");
            [player3Button setTitle:substituteString forState:UIControlStateNormal];
            [[NSUserDefaults standardUserDefaults] setObject:substituteString forKey:@"player3"];
            break;
        case 1004: //Player 4
            NSLog(@"Player 4 selected.");
            [player4Button setTitle:substituteString forState:UIControlStateNormal];
            [[NSUserDefaults standardUserDefaults] setObject:substituteString forKey:@"player4"];
            break;
        case 1005: //Player 5
            NSLog(@"Player 5 selected.");
            [player5Button setTitle:substituteString forState:UIControlStateNormal];
            [[NSUserDefaults standardUserDefaults] setObject:substituteString forKey:@"player5"];
            break;
        case 1006: //Player 6
            NSLog(@"Player 6 selected.");
            [player6Button setTitle:substituteString forState:UIControlStateNormal];
            [[NSUserDefaults standardUserDefaults] setObject:substituteString forKey:@"player6"];
            break;
        case 1007: //Player 7
            NSLog(@"Player 7 selected.");
            [player7Button setTitle:substituteString forState:UIControlStateNormal];
            [[NSUserDefaults standardUserDefaults] setObject:substituteString forKey:@"player7"];
            break;
        case 1008: //Player 8
            NSLog(@"Player 8 selected.");
            [player8Button setTitle:substituteString forState:UIControlStateNormal];
            [[NSUserDefaults standardUserDefaults] setObject:substituteString forKey:@"player8"];
            break;
        case 1009: //Player 9
            NSLog(@"Player 9 selected.");
            [player9Button setTitle:substituteString forState:UIControlStateNormal];
            [[NSUserDefaults standardUserDefaults] setObject:substituteString forKey:@"player9"];
            break;
        case 1010: //Player 10
            NSLog(@"Player 10 selected.");
            [player10Button setTitle:substituteString forState:UIControlStateNormal];
            [[NSUserDefaults standardUserDefaults] setObject:substituteString forKey:@"player10"];
            break;
    }
    pressedOK = YES;
    modalBenchView.hidden = YES;
}

-(NSString*) setSubstitutePlayer {
    
    return selectedPlayer;
}

-(IBAction)selectPlayerToSub:(id)sender {
    btnSender = sender;
    [self benchModalWindow];
}

-(void)toggleSubstitutionButtons {
    if(!drawingView.hidden && !mainImage.hidden){
        player0Button.enabled = NO;
        player1Button.enabled = NO;
        player2Button.enabled = NO;
        player3Button.enabled = NO;
        player4Button.enabled = NO;
        player5Button.enabled = NO;
        player6Button.enabled = NO;
        player7Button.enabled = NO;
        player8Button.enabled = NO;
        player9Button.enabled = NO;
        player10Button.enabled = NO;
    }
    else {
        player0Button.enabled = YES;
        player1Button.enabled = YES;
        player2Button.enabled = YES;
        player3Button.enabled = YES;
        player4Button.enabled = YES;
        player5Button.enabled = YES;
        player6Button.enabled = YES;
        player7Button.enabled = YES;
        player8Button.enabled = YES;
        player9Button.enabled = YES;
        player10Button.enabled = YES;
    }
    
    [self refreshUI];
}

//******************************************************************
//Table Delegate Methods
//******************************************************************
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RosterTableCell";
    
    RosterTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RosterTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    int rowCount = indexPath.row;
    
    NSString *playerLastName = [playerList_lastName objectAtIndex:rowCount];
    NSString *playerFirstName = [playerList_firstName objectAtIndex:rowCount];
    NSString *playerPhoneNumber = [playerList_phoneNumber objectAtIndex:rowCount];
    NSString *playerEmail = [playerList_email objectAtIndex:rowCount];

    playerFirstName = [playerFirstName substringToIndex:1];
    playerFirstName = [NSString stringWithFormat:@"%@.", playerFirstName];
    
    cell.firstNameLabel.text = playerFirstName;
    cell.lastNameLabel.text = playerLastName;
    cell.emailLabel.text = playerEmail;
    cell.phoneLabel.text = playerPhoneNumber;

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [playerList_lastName count];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        NSString *playerToRemove = [playerList_lastName objectAtIndex:indexPath.row];
        [self deletePlayerFromRoster:playerToRemove];
        [self repopulatePlayerList];
        NSLog(@"playerList_lastName: %@", playerList_lastName);
    }
    [rosterTable reloadData];
}

//******************************************************************
//Drawing Methods
//******************************************************************
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    mouseSwiped = NO;
    UITouch *touch = [touches anyObject];
    lastPoint = [touch locationInView:drawingView];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    mouseSwiped = YES;
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:drawingView];
    
    UIGraphicsBeginImageContext(drawingView.frame.size);
    [tempDrawImage.image drawInRect:CGRectMake(0, 0, drawingView.frame.size.width, drawingView.frame.size.height)];
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush );
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, 1.0);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
    [tempDrawImage setAlpha:opacity];
    UIGraphicsEndImageContext();
    
    lastPoint = currentPoint;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(!mouseSwiped) {
        UIGraphicsBeginImageContext(drawingView.frame.size);
        [tempDrawImage.image drawInRect:CGRectMake(0, 0, drawingView.frame.size.width, drawingView.frame.size.height)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, opacity);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        CGContextFlush(UIGraphicsGetCurrentContext());
        tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    UIGraphicsBeginImageContext(mainImage.frame.size);
    [mainImage.image drawInRect:CGRectMake(0, 0, drawingView.frame.size.width, drawingView.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    [tempDrawImage.image drawInRect:CGRectMake(0, 0, drawingView.frame.size.width, drawingView.frame.size.height) blendMode:kCGBlendModeNormal alpha:opacity];
    mainImage.image = UIGraphicsGetImageFromCurrentImageContext();
    tempDrawImage.image = nil;
    UIGraphicsEndImageContext();
}

- (IBAction)reset:(id)sender {
    [self resetImage];
}

-(IBAction)saveDrawingButton:(id)sender {
    /*
    UIGraphicsBeginImageContextWithOptions(mainImage.bounds.size, NO,0.0);
    [mainImage.image drawInRect:CGRectMake(0, 0, mainImage.frame.size.width, mainImage.frame.size.height)];
    UIImage *SaveImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(SaveImage, self,@selector(image:didFinishSavingWithError:contextInfo:), nil);
     */
    
    if(!player0View.hidden) {
        
        player0View.hidden = YES;
        player1View.hidden = YES;
        player2View.hidden = YES;
        player3View.hidden = YES;
        player4View.hidden = YES;
        player5View.hidden = YES;
        player6View.hidden = YES;
        player7View.hidden = YES;
        player8View.hidden = YES;
        player9View.hidden = YES;
        player10View.hidden = YES;
        [saveDrawingButton setImage:[UIImage imageNamed:@"closed-eye-icon-hi"] forState:UIControlStateNormal];

    }
    else {
        player0View.hidden = NO;
        player1View.hidden = NO;
        player2View.hidden = NO;
        player3View.hidden = NO;
        player4View.hidden = NO;
        player5View.hidden = NO;
        player6View.hidden = NO;
        player7View.hidden = NO;
        player8View.hidden = NO;
        player9View.hidden = NO;
        player10View.hidden = NO;
        [saveDrawingButton setImage:[UIImage imageNamed:@"open-eye-icon-hi"] forState:UIControlStateNormal];
    }
}

-(void) resetImage {
    mainImage.image = nil;
    [mainImage setImage:[UIImage imageNamed:@"soccerField2"]];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    // Was there an error?
    if (error != NULL)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Image could not be saved. Please try again."  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Close", nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Image was successfully saved in photo album!"  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Close", nil];
        [alert show];
    }
}

-(void) toggleDrawingEnabled {
    
    [self resetImage];
    
    if(!drawingView.hidden && !mainImage.hidden){
        NSLog(@"Draw disabled.");
        drawingView.hidden = YES;
        mainImage.hidden = YES;

        [pencilDrawingButton setAlpha:0.40];
        [saveDrawingButton setAlpha:0.40];
        [resetDrawingButton setAlpha:0.40];
        saveDrawingButton.enabled = NO;
        resetDrawingButton.enabled = NO;
    }
    else {
        NSLog(@"Draw enabled.");
        drawingView.hidden = NO;
        mainImage.hidden = NO;
        
        [pencilDrawingButton setAlpha:1.0];
        [saveDrawingButton setAlpha:1.0];
        [resetDrawingButton setAlpha:1.0];
        
        saveDrawingButton.enabled = YES;
        resetDrawingButton.enabled = YES;
        
        //red = 0.0/255.0;
        //green = 0.0/255.0;
        //blue = 0.0/255.0;
    }
}

-(IBAction)drawButtonPressed:(id)sender{
    NSLog(@"Draw button pressed.");
    
    [self toggleDrawingEnabled];
    [self toggleSubstitutionButtons];
}

- (IBAction)eraserPressed:(id)sender {
    
    red = 255.0/255.0;
    green = 255.0/255.0;
    blue = 255.0/255.0;
    opacity = 1.0;
}

-(IBAction)blackPenPressed:(id)sender {
    red = 0.0/255.0;
    green = 0.0/255.0;
    blue = 0.0/255.0;
}

-(IBAction)greyPenPressed:(id)sender {
    red = 120.0/255.0;
    green = 120.0/255.0;
    blue = 120.0/255.0;
}

-(IBAction)redPenPressed:(id)sender {
    red = 255.0/255.0;
    green = 0.0/255.0;
    blue = 0.0/255.0;
}

-(IBAction)greenPenPressed:(id)sender {
    red = 0.0/255.0;
    green = 255.0/255.0;
    blue = 0.0/255.0;
}

-(IBAction)bluePenPressed:(id)sender {
    red = 0.0/255.0;
    green = 0.0/255.0;
    blue = 255.0/255.0;
}

-(IBAction)settingsSaveButtonPressed:(id)sender {
    
    NSString *teamNameSave = teamNameSettings.text;
    teamNameSave = [teamNameSave uppercaseString];
    
    [[NSUserDefaults standardUserDefaults] setObject:teamNameSave forKey:@"teamName"];
    teamNameSave = [[NSUserDefaults standardUserDefaults] stringForKey:@"teamName"];
    
    teamName.text = teamNameSave;
    teamName2.text = teamNameSave;
    NSLog(@"New team name saved: %@", teamNameSettings.text);
    [self refreshUI];
}

-(IBAction)settingsBackButtonPressed:(id)sender {
    settingsView.hidden = YES;
}

-(IBAction)settingsButtonPressed:(id)sender {
    settingsView.hidden = NO;
    
    teamNameSettings.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"teamName"];
}

-(IBAction)choosePlayerFormation:(id)sender {
    
    btnSender = sender;

    UIButton *pressedButton = (UIButton*)btnSender;
    [self formationSelected:pressedButton.tag];
    
    formationNumber = pressedButton.tag;
    [[NSUserDefaults standardUserDefaults] setInteger:formationNumber forKey:@"setFormation"];
}

-(void)formationSelected:(NSInteger)formation{
    
    CGFloat height = player0View.frame.size.height;
    CGFloat width = player0View.frame.size.width;
    
    switch(formation)
    {
        case 2000: //4-4-2 Normal
            NSLog(@"4-4-2 (Normal) selected.");
            // Forwards - 0,1
            player0View.frame = CGRectMake(131.0, 140.0, width, height);
            player1View.frame = CGRectMake(342.0, 140.0, width, height);
            
            //Midfielders - 2,3,4,5
            player2View.frame = CGRectMake(111.0, 255.0, width, height);
            player3View.frame = CGRectMake(362.0, 255.0, width, height);
            player4View.frame = CGRectMake(111.0, 415.0, width, height);
            player5View.frame = CGRectMake(362.0, 415.0, width, height);
            
            //Defenders - 6,7,8,9
            player6View.frame = CGRectMake(43.0, 525.0, width, height);
            player7View.frame = CGRectMake(166.0, 525.0, width, height);
            player8View.frame = CGRectMake(309.0, 525.0, width, height);
            player9View.frame = CGRectMake(427.0, 525.0, width, height);
            
            // Save as current default
            break;
        case 2001: //4-4-2 Diamond
            NSLog(@"4-4-2 (Diamond) selected.");
            // Forwards - 0,1
            player0View.frame = CGRectMake(131.0, 140.0, width, height);
            player1View.frame = CGRectMake(342.0, 140.0, width, height);
            
            //Midfielders - 2,3,4,5
            player2View.frame = CGRectMake(240.0, 255.0, width, height);
            player3View.frame = CGRectMake(131.0, 325.0, width, height);
            player4View.frame = CGRectMake(342.0, 325.0, width, height);
            player5View.frame = CGRectMake(240.0, 415.0, width, height);
            
            //Defenders - 6,7,8,9
            player6View.frame = CGRectMake(43.0, 525.0, width, height);
            player7View.frame = CGRectMake(166.0, 525.0, width, height);
            player8View.frame = CGRectMake(309.0, 525.0, width, height);
            player9View.frame = CGRectMake(427.0, 525.0, width, height);
            // Save as current default
            break;
        case 2002: //4-4-2 Narrow
            NSLog(@"4-4-2 (Narrow) selected.");
            // Forwards - 0,1
            player0View.frame = CGRectMake(131.0, 140.0, width, height);
            player1View.frame = CGRectMake(342.0, 140.0, width, height);
            
            //Midfielders - 2,3,4,5
            player2View.frame = CGRectMake(131.0, 255.0, width, height);
            player3View.frame = CGRectMake(342.0, 255.0, width, height);
            player4View.frame = CGRectMake(131.0, 415.0, width, height);
            player5View.frame = CGRectMake(342.0, 415.0, width, height);
            
            //Defenders - 6,7,8,9
            player6View.frame = CGRectMake(43.0, 525.0, width, height);
            player7View.frame = CGRectMake(166.0, 525.0, width, height);
            player8View.frame = CGRectMake(309.0, 525.0, width, height);
            player9View.frame = CGRectMake(427.0, 525.0, width, height);
            break;
        case 2003: //4-4-2 Diamond Wide
            NSLog(@"4-4-2 (Diamond Wide) selected.");
            // Forwards - 0,1
            player0View.frame = CGRectMake(131.0, 140.0, width, height);
            player1View.frame = CGRectMake(342.0, 140.0, width, height);
            
            //Midfielders - 2,3,4,5
            player2View.frame = CGRectMake(240.0, 255.0, width, height);
            player3View.frame = CGRectMake(43.0, 325.0, width, height);
            player4View.frame = CGRectMake(427.0, 325.0, width, height);
            player5View.frame = CGRectMake(240.0, 415.0, width, height);
            
            //Defenders - 6,7,8,9
            player6View.frame = CGRectMake(43.0, 525.0, width, height);
            player7View.frame = CGRectMake(166.0, 525.0, width, height);
            player8View.frame = CGRectMake(309.0, 525.0, width, height);
            player9View.frame = CGRectMake(427.0, 525.0, width, height);
            // Save as current default
            break;
        case 2004: //4-3-3
            NSLog(@"4-3-3 selected.");
            // Forwards - 0,1,2
            player0View.frame = CGRectMake(43.0, 190.0, width, height);
            player1View.frame = CGRectMake(240.0, 190.0, width, height);
            player2View.frame = CGRectMake(427.0, 190.0, width, height);
            
            //Midfielders - 3,4,5
            player3View.frame = CGRectMake(43.0, 375.0, width, height);
            player4View.frame = CGRectMake(240.0, 375.0, width, height);
            player5View.frame = CGRectMake(427.0, 375.0, width, height);
            
            //Defenders - 6,7,8,9
            player6View.frame = CGRectMake(43.0, 525.0, width, height);
            player7View.frame = CGRectMake(166.0, 525.0, width, height);
            player8View.frame = CGRectMake(309.0, 525.0, width, height);
            player9View.frame = CGRectMake(427.0, 525.0, width, height);
            // Save as current default
            break;
        case 2005: //4-2-4
            NSLog(@"4-2-4 selected.");
            // Forwards - 0,1,2,3
            player0View.frame = CGRectMake(111.0, 140.0, width, height);
            player1View.frame = CGRectMake(362.0, 140.0, width, height);
            player2View.frame = CGRectMake(111.0, 225.0, width, height);
            player3View.frame = CGRectMake(362.0, 225.0, width, height);
            
            //Midfielders - 4,5
            player4View.frame = CGRectMake(111.0, 375.0, width, height);
            player5View.frame = CGRectMake(362.0, 375.0, width, height);
            
            //Defenders - 6,7,8,9
            player6View.frame = CGRectMake(43.0, 525.0, width, height);
            player7View.frame = CGRectMake(166.0, 525.0, width, height);
            player8View.frame = CGRectMake(309.0, 525.0, width, height);
            player9View.frame = CGRectMake(427.0, 525.0, width, height);
            // Save as current default
            break;
        case 2006: //4-5-1
            NSLog(@"4-5-1 selected.");
            // Forwards - 0
            player0View.frame = CGRectMake(240.0, 190.0, width, height);
            
            //Midfielders - 1,2,3,4,5
            player1View.frame = CGRectMake(43.0, 325.0, width, height);
            player2View.frame = CGRectMake(240.0, 325.0, width, height);
            player3View.frame = CGRectMake(427.0, 325.0, width, height);
            player4View.frame = CGRectMake(131.0, 365.0, width, height);
            player5View.frame = CGRectMake(342.0, 365.0, width, height);
            
            //Defenders - 6,7,8,9
            player6View.frame = CGRectMake(43.0, 525.0, width, height);
            player7View.frame = CGRectMake(166.0, 525.0, width, height);
            player8View.frame = CGRectMake(309.0, 525.0, width, height);
            player9View.frame = CGRectMake(427.0, 525.0, width, height);
            // Save as current default
            break;
        case 2007: //4-2-3-1
            NSLog(@"4-2-3-1 selected.");
            // Forwards - 0
            player0View.frame = CGRectMake(240.0, 160.0, width, height);
            
            //Midfielders (Split) - 1,2,3,4,5
            player1View.frame = CGRectMake(43.0, 255.0, width, height);
            player2View.frame = CGRectMake(240.0, 255.0, width, height);
            player3View.frame = CGRectMake(427.0, 255.0, width, height);
            
            player4View.frame = CGRectMake(131.0, 415.0, width, height);
            player5View.frame = CGRectMake(342.0, 415.0, width, height);
            
            //Defenders - 6,7,8,9
            player6View.frame = CGRectMake(43.0, 525.0, width, height);
            player7View.frame = CGRectMake(166.0, 525.0, width, height);
            player8View.frame = CGRectMake(309.0, 525.0, width, height);
            player9View.frame = CGRectMake(427.0, 525.0, width, height);
            // Save as current default
            break;
        case 2008: //4-1-4-1
            NSLog(@"4-1-4-1 selected.");
            // Forwards - 0
            player0View.frame = CGRectMake(240.0, 160.0, width, height);
            
            //Midfielders (Split) - 1,2,3,4,5
            player1View.frame = CGRectMake(43.0, 255.0, width, height);
            player2View.frame = CGRectMake(166.0, 255.0, width, height);
            player3View.frame = CGRectMake(309.0, 255.0, width, height);
            player4View.frame = CGRectMake(427.0, 255.0, width, height);
            
            player5View.frame = CGRectMake(240.0, 415.0, width, height);
            
            //Defenders - 6,7,8,9
            player6View.frame = CGRectMake(43.0, 525.0, width, height);
            player7View.frame = CGRectMake(166.0, 525.0, width, height);
            player8View.frame = CGRectMake(309.0, 525.0, width, height);
            player9View.frame = CGRectMake(427.0, 525.0, width, height);
            // Save as current default
            break;
        case 2009: //4-4-1-1
            NSLog(@"4-4-1-1 selected.");
            // Forwards - 0,1
            player0View.frame = CGRectMake(240.0, 160.0, width, height);
            player1View.frame = CGRectMake(240.0, 255.0, width, height);
            
            //Midfielders - 2,3,4,5
            player2View.frame = CGRectMake(43.0, 415.0, width, height);
            player3View.frame = CGRectMake(166.0, 415.0, width, height);
            player4View.frame = CGRectMake(309.0, 415.0, width, height);
            player5View.frame = CGRectMake(427.0, 415.0, width, height);
            
            //Defenders - 6,7,8,9
            player6View.frame = CGRectMake(43.0, 525.0, width, height);
            player7View.frame = CGRectMake(166.0, 525.0, width, height);
            player8View.frame = CGRectMake(309.0, 525.0, width, height);
            player9View.frame = CGRectMake(427.0, 525.0, width, height);
            // Save as current default
            break;
        case 2010: //4-3-1-2
            NSLog(@"4-3-1-2 selected.");
            // Forwards - 0,1
            player0View.frame = CGRectMake(166.0, 160.0, width, height);
            player1View.frame = CGRectMake(309.0, 160.0, width, height);
            
            //Midfielders (Split) - 2,3,4,5
            player2View.frame = CGRectMake(240.0, 255.0, width, height);
            
            player3View.frame = CGRectMake(131.0, 415.0, width, height);
            player4View.frame = CGRectMake(240.0, 415.0, width, height);
            player5View.frame = CGRectMake(342.0, 415.0, width, height);
            
            //Defenders - 6,7,8,9
            player6View.frame = CGRectMake(43.0, 525.0, width, height);
            player7View.frame = CGRectMake(166.0, 525.0, width, height);
            player8View.frame = CGRectMake(309.0, 525.0, width, height);
            player9View.frame = CGRectMake(427.0, 525.0, width, height);
            // Save as current default
            break;
        case 2011: //4-2-2-2
            NSLog(@"4-2-2-2 selected.");
            // Forwards - 0,1
            player0View.frame = CGRectMake(166.0, 160.0, width, height);
            player1View.frame = CGRectMake(309.0, 160.0, width, height);
            
            //Midfielders (Split) - 2,3,4,5
            player2View.frame = CGRectMake(166.0, 255.0, width, height);
            player3View.frame = CGRectMake(309.0, 255.0, width, height);
            
            player4View.frame = CGRectMake(166.0, 415.0, width, height);
            player5View.frame = CGRectMake(309.0, 415.0, width, height);
            
            //Defenders - 6,7,8,9
            player6View.frame = CGRectMake(43.0, 525.0, width, height);
            player7View.frame = CGRectMake(166.0, 525.0, width, height);
            player8View.frame = CGRectMake(309.0, 525.0, width, height);
            player9View.frame = CGRectMake(427.0, 525.0, width, height);
            // Save as current default
            break;
        case 2012: //3-5-2
            NSLog(@"3-5-2 selected.");
            // Forwards - 0,1
            player0View.frame = CGRectMake(166.0, 160.0, width, height);
            player1View.frame = CGRectMake(309.0, 160.0, width, height);
            
            //Midfielders - 2,3,4,5,6
            player2View.frame = CGRectMake(43.0, 325.0, width, height);
            player3View.frame = CGRectMake(240.0, 325.0, width, height);
            player4View.frame = CGRectMake(427.0, 325.0, width, height);
            player5View.frame = CGRectMake(131.0, 365.0, width, height);
            player6View.frame = CGRectMake(342.0, 365.0, width, height);
            
            //Defenders - 7,8,9
            player7View.frame = CGRectMake(131.0, 525.0, width, height);
            player8View.frame = CGRectMake(240.0, 525.0, width, height);
            player9View.frame = CGRectMake(342.0, 525.0, width, height);
            // Save as current default
            break;
        case 2013: //3-6-1
            NSLog(@"3-6-1 selected.");
            // Forwards - 0
            player0View.frame = CGRectMake(240.0, 160.0, width, height);
            
            //Midfielders - 1,2,3,4,5,6
            player1View.frame = CGRectMake(131.0, 255.0, width, height);
            player2View.frame = CGRectMake(240.0, 255.0, width, height);
            player3View.frame = CGRectMake(342.0, 255.0, width, height);
            player4View.frame = CGRectMake(131.0, 415.0, width, height);
            player5View.frame = CGRectMake(240.0, 415.0, width, height);
            player6View.frame = CGRectMake(342.0, 415.0, width, height);
            
            //Defenders - 7,8,9
            player7View.frame = CGRectMake(131.0, 525.0, width, height);
            player8View.frame = CGRectMake(240.0, 525.0, width, height);
            player9View.frame = CGRectMake(342.0, 525.0, width, height);
            // Save as current default
            break;
        case 2014: //3-4-3
            NSLog(@"3-4-3 selected.");
            // Forwards - 0,1,2
            player0View.frame = CGRectMake(131.0, 160.0, width, height);
            player1View.frame = CGRectMake(240.0, 160.0, width, height);
            player2View.frame = CGRectMake(342.0, 160.0, width, height);
            
            //Midfielders - 3,4,5,6
            player3View.frame = CGRectMake(166.0, 255.0, width, height);
            player4View.frame = CGRectMake(309.0, 255.0, width, height);
            player5View.frame = CGRectMake(166.0, 415.0, width, height);
            player6View.frame = CGRectMake(309.0, 415.0, width, height);
            
            //Defenders - 7,8,9
            player7View.frame = CGRectMake(131.0, 525.0, width, height);
            player8View.frame = CGRectMake(240.0, 525.0, width, height);
            player9View.frame = CGRectMake(342.0, 525.0, width, height);
            // Save as current default
            break;
    }

}

@end
