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
    
    [super viewDidLoad];
    
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
    
    
    [self getDefaultValues];
    
    //teamName.transform = CGAffineTransformMakeRotation((M_PI)/2);
    //teamName2.transform = CGAffineTransformMakeRotation(-(M_PI)/2);
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) getDefaultValues {
    
    NSString *teamNameStr = [[NSUserDefaults standardUserDefaults]
                             stringForKey:@"teamName"];
    teamNameStr = [teamNameStr uppercaseString];
    teamName.text = teamNameStr;
    teamName2.text = teamNameStr;
    NSLog(@"Team Name: %@", teamNameStr);
    
    player0Button.titleLabel.text = [[NSUserDefaults standardUserDefaults]
                                     stringForKey:@"player0"];
    player1Button.titleLabel.text = [[NSUserDefaults standardUserDefaults]
                                     stringForKey:@"player1"];
    player2Button.titleLabel.text = [[NSUserDefaults standardUserDefaults]
                                     stringForKey:@"player2"];
    player3Button.titleLabel.text = [[NSUserDefaults standardUserDefaults]
                                     stringForKey:@"player3"];
    player4Button.titleLabel.text = [[NSUserDefaults standardUserDefaults]
                                     stringForKey:@"player4"];
    player5Button.titleLabel.text = [[NSUserDefaults standardUserDefaults]
                                     stringForKey:@"player5"];
    player6Button.titleLabel.text = [[NSUserDefaults standardUserDefaults]
                                     stringForKey:@"player6"];
    player7Button.titleLabel.text = [[NSUserDefaults standardUserDefaults]
                                     stringForKey:@"player7"];
    player8Button.titleLabel.text = [[NSUserDefaults standardUserDefaults]
                                     stringForKey:@"player8"];
    player9Button.titleLabel.text = [[NSUserDefaults standardUserDefaults]
                                     stringForKey:@"player9"];
    player10Button.titleLabel.text = [[NSUserDefaults standardUserDefaults]
                                      stringForKey:@"player10"];
}

-(void) setCustomFontForEverything {
    
    UIFont *nikeTotal90 = [UIFont fontWithName:@"NikeTotal90" size:27.0];
    UIFont *nikeTotal90_18 = [UIFont fontWithName:@"NikeTotal90" size:18.0];
    
    stopWatchTimerLabel.font = nikeTotal90;
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
    UIGraphicsBeginImageContextWithOptions(mainImage.bounds.size, NO,0.0);
    [mainImage.image drawInRect:CGRectMake(0, 0, mainImage.frame.size.width, mainImage.frame.size.height)];
    UIImage *SaveImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(SaveImage, self,@selector(image:didFinishSavingWithError:contextInfo:), nil);
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
        
        red = 0.0/255.0;
        green = 0.0/255.0;
        blue = 0.0/255.0;
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

-(IBAction)blackPencilPressed:(id)sender {
    red = 0.0/255.0;
    green = 0.0/255.0;
    blue = 0.0/255.0;
}

-(IBAction)choosePlayerFormation:(id)sender {
    
    btnSender = sender;
    
    CGFloat height = player0View.frame.size.height;
    CGFloat width = player0View.frame.size.width;

    UIButton *pressedButton = (UIButton*)btnSender;
    switch(pressedButton.tag)
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
            NSLog(@"4-3-3 selected.");
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

    }
}

@end
