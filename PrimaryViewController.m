//
//  PrimaryViewController.m
//  DynamiCoach
//
//  Created by Danilo on 1/15/14.
//  Copyright (c) 2014 dcaetano. All rights reserved.
//

// Bug notes:
// - Need a better eraser that doesn't erase the field background
// - Missing rgb picker
// - Missing brush size selector
// - When saving the image, needs to include players as well!
// - Need icons/graphics for better UI
//


#import "PrimaryViewController.h"

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
    brush = 5.0;
    opacity = 1.0;
    
    [super viewDidLoad];
    
    stopWatchTimer = [[NSTimer alloc] init];
    
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = dirPaths[0];
    
    // Build the path to the database file
    _databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent:@"players.db"]];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: _databasePath ] == NO)
    {
        const char *dbpath = [_databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &_playerDB) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt =
            "CREATE TABLE IF NOT EXISTS PLAYERS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, ADDRESS TEXT, PHONE TEXT, EMAIL TEXT)";
            
            if (sqlite3_exec(_playerDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Failed to create table.");
            }
            sqlite3_close(_playerDB);
        } else {
            //_status.text = @"Failed to open/create database";
            NSLog(@"Failed to open/create database.");
        }
    }
    
    
    //popuate Player List from DB
    playerList_lastName = [[NSMutableArray alloc] init];
    
    if([playerList_lastName count] == 0)
        [self repopulatePlayerList];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    NSLog(@"Add Player");
    NSLog(@"First Name: %@", firstNameStr);
    NSLog(@"Last Name: %@", lastNameStr);
    NSLog(@"Phone Number: %@", phoneNumberStr);
    NSLog(@"Email Address: %@", emailAddressStr);
    
    BOOL success = NO;
    NSString *alertString = @"Data Insertion failed";
    if (firstNameStr.length>0 && lastNameStr.length>0 &&phoneNumberStr.length>0 && emailAddressStr.length>0)
    {
        sqlite3_stmt    *statement;
        const char *dbpath = [_databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &_playerDB) == SQLITE_OK)
        {
            
            NSString *insertSQL = [NSString stringWithFormat:
                                   @"INSERT INTO PLAYERS (name, address, phone, email) VALUES (\"%@\", \"%@\", \"%@\", \"%@\")",
                                   firstNameStr, lastNameStr, phoneNumberStr, emailAddressStr];
            
            const char *insert_stmt = [insertSQL UTF8String];
            sqlite3_prepare_v2(_playerDB, insert_stmt, -1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Player added.");
                success = YES;
                firstName.text = @"";
                lastName.text = @"";
                emailAddress.text = @"";
                phoneNumber.text = @"";
            } else {
                //_status.text = @"Failed to add contact";
                NSLog(@"Failed to add contact.");
                alertString = @"Failed to add contact.";
            }
            sqlite3_finalize(statement);
            sqlite3_close(_playerDB);
        }
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
        playerList_lastName = [self playerList];
        [rosterTable reloadData];
        [self.view endEditing:YES];
        addPlayerView.hidden = YES;
    }
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

-(void) repopulatePlayerList {
    playerList_lastName = [self playerList];
    NSLog(@"playerList: %@", playerList_lastName);
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

-(void) findPlayer {
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt    *statement;
    NSString *status;
    
    if (sqlite3_open(dbpath, &_playerDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
        @"SELECT address, phone FROM contacts WHERE lastName=\"%@\"", lastNameStr];
            
        const char *query_stmt = [querySQL UTF8String];
            
        if (sqlite3_prepare_v2(_playerDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *emailAddressField = [[NSString alloc]
                                            initWithUTF8String:
                                            (const char *) sqlite3_column_text(statement, 0)];
                emailAddressStr = emailAddressField;
                NSString *phoneField = [[NSString alloc]
                                        initWithUTF8String:(const char *)
                                        sqlite3_column_text(statement, 1)];
                phoneNumberStr = phoneField;
                status = @"Match found";
            } else {
                status = @"Match not found";
                emailAddressStr = @"";
                phoneNumberStr = @"";
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_playerDB);
    }
}

-(IBAction)clearRosterButtonPressed:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:
                          @"Are you sure you want to clear your roster?" message:nil
                                                  delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alert show];
    NSLog(@"clearRosterButtonPressed");
    [self clearRoster];
    [self repopulatePlayerList];
}

-(void) clearRoster {
    NSLog(@"clearRoster");
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt *statement;
    NSString *status;
    
    if (sqlite3_open(dbpath, &_playerDB) == SQLITE_OK)
    {
        NSString *querySQL = @"DELETE FROM players";
        NSLog(@"%@", querySQL);
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_playerDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            status = @"SQLITE_OK";
            //if (sqlite3_step(statement) == SQLITE_ROW)
            //{
            status = @"Player roster cleared.";
            //} else {
            //}
            sqlite3_finalize(statement);
        }
        else {
            status = @"!SQLITE_OK";
            status = @"Could not clear player roster.";
        }
        NSLog(@"%@", status);
        sqlite3_close(_playerDB);
    }
}


-(NSMutableArray*)playerList{
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    sqlite3_stmt *sqlStatement;
    @try {
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        const char *dbpath = [_databasePath UTF8String];
        BOOL success = [fileMgr fileExistsAtPath:_databasePath];
        if(!success)
        {
            NSLog(@"Cannot locate database file '%s'.", dbpath);
        }
        if(!(sqlite3_open([_databasePath UTF8String], &_playerDB) == SQLITE_OK))
        {
            NSLog(@"An error has occured: %s", sqlite3_errmsg(_playerDB));
            
        }
        
        const char *sql = "SELECT * FROM players";
        if(sqlite3_prepare(_playerDB, sql, -1, &sqlStatement, NULL) != SQLITE_OK)
        {
            NSLog(@"Problem with prepare statement:  %s", sqlite3_errmsg(_playerDB));
        }else{
            while (sqlite3_step(sqlStatement)==SQLITE_ROW) {
                lastNameStr = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 2)];
                [list addObject:lastNameStr];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Problem with prepare statement:  %s", sqlite3_errmsg(_playerDB));
    }
    @finally {
        sqlite3_finalize(sqlStatement);
        sqlite3_close(_playerDB);
        
        return list;
    }
}

- (void)updateTimer
{
    // Create date from the elapsed time
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:self.startDate];
    NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    // Create a date formatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss.SS"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    
    // Format the elapsed time and set it to the label
    NSString *timeString = [dateFormatter stringFromDate:timerDate];
    stopWatchTimerLabel.text = timeString;
}

- (IBAction)startStopwatchPressed:(id)sender {
    self.startDate = [NSDate date];
    
    // Create the stop watch timer that fires every 100 ms
    stopWatchTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/10.0
                                                           target:self
                                                         selector:@selector(updateTimer)
                                                         userInfo:nil
                                                          repeats:YES];
}

- (IBAction)stopStopwatchPressed:(id)sender {
    stopWatchTimerLabel.text = @"00:00:00:00";
    [stopWatchTimer invalidate];
    stopWatchTimer = nil;
    [self updateTimer];
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

//Keyboard Methods
-(void) returnKeyboard {
    [self.view endEditing:YES];
}

//Table Delegate Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PlayerCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    int rowCount = indexPath.row;
    
    NSString *player = [playerList_lastName objectAtIndex:rowCount];
    cell.textLabel.text = player;
    //cell.detailTextLabel.text = author.title;

    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [playerList_lastName count];
}

//Drawing Methods
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
    mainImage.image = nil;
    [mainImage setImage:[UIImage imageNamed:@"soccerField2"]];
}

-(IBAction)saveDrawingButton:(id)sender {
    UIGraphicsBeginImageContextWithOptions(mainImage.bounds.size, NO,0.0);
    [mainImage.image drawInRect:CGRectMake(0, 0, mainImage.frame.size.width, mainImage.frame.size.height)];
    UIImage *SaveImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(SaveImage, self,@selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    // Was there an error?
    if (error != NULL)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Image could not be saved.Please try again"  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Close", nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Image was successfully saved in photoalbum"  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Close", nil];
        [alert show];
    }
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

@end
