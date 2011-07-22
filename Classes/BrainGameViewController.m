//
//  BrainGameViewController.m
//  BrainGame
//
//  Created by Jeff on 10/18/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "BrainGameViewController.h"
#import "FlashcardViewController.h"
#import "GameCenterManager.h"

#import "GameData.h"

@implementation BrainGameViewController

@synthesize gameCenterManager;
@synthesize infoButton;
@synthesize flipsideNavigationBar;
@synthesize infoView;
@synthesize splashScreenView;
@synthesize mainMenuView;
@synthesize isGameCenter;

#pragma mark View Controller Methods
- (void)viewDidLoad {
	//self.currentLeaderBoard= kEasyLeaderboardID;
	
	//self.currentScore= 0;
	//
	
	[super viewDidLoad];
	
	// Initilize game center
	showAchievementsButton.enabled = NO;
	showAchievementsButton.alpha = 0;
	if([GameCenterManager isGameCenterAvailable])
	{
		self.gameCenterManager= [[[GameCenterManager alloc] init] autorelease];
		[self.gameCenterManager setDelegate: self];
		[self.gameCenterManager authenticateLocalUser];

		showAchievementsButton.enabled = YES;
		showAchievementsButton.alpha = 1;
	}

	
	// Load up the splash screen
	[self.view addSubview:splashScreenView];
	
	mainMenuView.alpha = 0.0;
	
	// Load the main menu
	[self.view insertSubview:mainMenuView belowSubview:infoButton];
	
	// Remove the splash screen and load the main view after some time
	[self performSelector:@selector(removeSplashScreen) withObject:nil afterDelay:2.0];
	
}
- (void) showAlertWithTitle: (NSString*) title message: (NSString*) message
{
	UIAlertView* alert= [[[UIAlertView alloc] initWithTitle: title message: message 
												   delegate: NULL cancelButtonTitle: @"OK" otherButtonTitles: NULL] autorelease];
	[alert show];
	
}

- (void)removeSplashScreen
{

	
	// Animate the labels coming into view
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.50];
	
	
	splashScreenView.alpha = 0.0;
	mainMenuView.alpha = 1.0;
	
	// Do the animations
	[UIView commitAnimations];
	
	// Remove this view
	[splashScreenView removeFromSuperview];
}

- (IBAction)toggleView {	
	/*
	 This method is called when the info or Done button is pressed.
	 It flips the displayed view from the main view to the flipside view and vice-versa.
	 */
	
	if (flipsideNavigationBar == nil) {
		// Set up the navigation bar
		UINavigationBar *aNavigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 44.0)];
		aNavigationBar.barStyle = UIBarStyleBlackOpaque;
		self.flipsideNavigationBar = aNavigationBar;
		[aNavigationBar release];
		
		UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(toggleView)];
		UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:@"About Brain Game"];
		navigationItem.rightBarButtonItem = buttonItem;
		[flipsideNavigationBar pushNavigationItem:navigationItem animated:NO];
		[navigationItem release];
		[buttonItem release];
	}
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1];
	[UIView setAnimationTransition:([mainMenuView superview] ? UIViewAnimationTransitionCurlDown : UIViewAnimationTransitionCurlUp) forView:self.view cache:YES];
   
	if ([mainMenuView superview] != nil) {
		[mainMenuView removeFromSuperview];
		[infoButton removeFromSuperview];
		[self.view addSubview:infoView];
		[self.view insertSubview:flipsideNavigationBar aboveSubview:infoView];
	   
	}
	else {
		[infoView removeFromSuperview];
		[flipsideNavigationBar removeFromSuperview];
		[self.view addSubview:mainMenuView];
		[self.view insertSubview:infoButton aboveSubview:mainMenuView];
	}
	[UIView commitAnimations];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}

- (void)dealloc {
	[infoButton release];
	[flipsideNavigationBar release];
	[infoView release];
	[mainMenuView release];
	[splashScreenView release];

	[super dealloc];
}

#pragma mark Button Handler Methods
- (void) loadLevelClicked:(id)sender
{
	// Initilize the controller
	FlashcardViewController *viewController = [[FlashcardViewController alloc] initWithNibName:@"FlashcardView" bundle:nil];

	// Set the difficulty
	if(sender == easyButton)
		[viewController setDifficulty:EASY];
	else if(sender == mediumButton)
		[viewController setDifficulty:MEDIUM];
	else if(sender == hardButton)
		[viewController setDifficulty:HARD];
	else if(sender == expertButton)
		[viewController setDifficulty:EXPERT];
	
	viewController.gameCenterManager = gameCenterManager;
	viewController.isGameCenter = isGameCenter;
	// Show it!
	[self presentModalViewController:viewController animated:YES];
	
	// Release it!
	[viewController release];
}

-(IBAction) clearAllDataClicked:(id)sender
{
	UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Really reset?" message:@"Do you really want to reset the local game data? This will not remove data on Game Center." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil] autorelease];
    [alert addButtonWithTitle:@"Yes"];
	alert.tag = 69;
    [alert show];
}


#pragma mark GameCenter View Controllers


//- (IBAction) resetAchievements: (id) sender
//{
//	[gameCenterManager resetAchievements];
//}


#pragma mark GameCenterDelegateProtocol Methods
//Delegate method used by processGameCenterAuth to support looping waiting for game center authorization
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	
	
	// See if they clicked yes
	if (buttonIndex == 1 && [alertView tag] == 69)
	{
		NSUserDefaults *userPrefs = [NSUserDefaults standardUserDefaults];
		
		// Uncomment this to clear the data
		[userPrefs removeObjectForKey:@"GameData"];
		[userPrefs synchronize];
		
		UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Reset Complete" message:@"Local game data has been reset." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease];
		[alert show];
		
		
	}
	//else if([alertView tag] == 77)
	//{
	//}
	//else {
//		[self.gameCenterManager authenticateLocalUser];
//	}

}

- (void) processGameCenterAuth: (NSError*) error
{
	if(error != NULL)
	{
		//UIAlertView* alert= [[[UIAlertView alloc] initWithTitle: @"Are you sure you want to continue?" 
		//												message: @"A Game Center Account reccomended for the full gaming experience."
		//											   delegate: self cancelButtonTitle: @"Try Again..." otherButtonTitles: NULL] autorelease];
		//alert.tag = 77;
		//[alert show];
		self.isGameCenter = NO;
		
		showAchievementsButton.enabled = NO;
		showAchievementsButton.alpha = 0;
	}	
}

- (void) scoreReported: (NSError*) error;
{
	NSLog(@"reported!");
	//if(error == NULL)
//	{
//		//[self.gameCenterManager reloadHighScoresForCategory:@"EasyLeaderboard"];
//		[self showAlertWithTitle: @"Score Reported!"
//						 message: [NSString stringWithFormat: @"", [error localizedDescription]]];
//	}
//	else
//	{
//		[self showAlertWithTitle: @"Score Report Failed!"
//						 message: [NSString stringWithFormat: @"Reason: %@", [error localizedDescription]]];
//	}
}



- (void) achievementSubmitted: (GKAchievement*) ach error:(NSError*) error;
{//
//	if((error == NULL) && (ach != NULL))
//	{
//		if(ach.percentComplete == 100.0)
//		{
//			[self showAlertWithTitle: @"Achievement Earned!"
//							 message: [NSString stringWithFormat: @"Great job!  You earned an achievement: \"%@\"", NSLocalizedString(ach.identifier, NULL)]];
//		}
//	}
		//else
//		{
//			if(ach.percentComplete > 0)
//			{
//				[self showAlertWithTitle: @"Achievement Progress!"
//								 message: [NSString stringWithFormat: @"Great job!  You're %.0f\%% of the way to: \"%@\"",ach.percentComplete, NSLocalizedString(ach.identifier, NULL)]];
//			}
//		}
	//}
//	else
//	{
//		[self showAlertWithTitle: @"Achievement Submission Failed!"
//						 message: [NSString stringWithFormat: @"Reason: %@", [error localizedDescription]]];
//	}
}
-(IBAction) showAchievementsButtonClicked:(id)sender
{
	GKAchievementViewController *achievements = [[GKAchievementViewController alloc] init];
	if (achievements != NULL)
	{
		achievements.achievementDelegate = self;
		[self presentModalViewController: achievements animated: YES];
	}
	
}

- (void)achievementViewControllerDidFinish:(GKAchievementViewController *)viewController;
{
	[self dismissModalViewControllerAnimated: YES];
	[viewController release];
}


@end
