//
//  FlashCardViewController.m
//
//  Created by Jeff on 10/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FlashcardViewController.h"


@implementation FlashcardViewController

// flashcardView synthesizers
@synthesize flashcardView;

@synthesize quitButton, introView, introStatusView, resultsView;
@synthesize timerLabel;
@synthesize gameCenterManager;

@synthesize elapsedTimer;
@synthesize isGameCenter;

@synthesize soundFileObject;

float _currTime = 0;
int introViewCount = 3;

#pragma mark View Init Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {

	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	// Show GameCenter if avaliable
	showLeaderboardButton.enabled = NO;
	showLeaderboardButton.alpha = 0;
	if([GameCenterManager isGameCenterAvailable])
	{
		if(isGameCenter)
		{
			showLeaderboardButton.enabled = YES;
			showLeaderboardButton.alpha = 1;
		}
	}

	
	// Set the max number based on difficulty
	if(difficulty == EASY || difficulty == MEDIUM)
		maxNumber = 12;
	else if(difficulty == HARD)
		maxNumber = 25;
	else if(difficulty == EXPERT)
		maxNumber = 50;
	
	// Reset the counters
	correctCounter = 0;
	wrongCounter   = 0;
	introViewCount = 3;
	
	// Set the max number of questions
	maxQuestionsNum = 20;
	
	// Center IntroView
	CGRect frame = introView.frame;
	frame.origin.x = round((self.view.frame.size.width - frame.size.width) / 2.0);
	frame.origin.y = round((self.view.frame.size.height - frame.size.height) / 2.0);
	introView.frame = frame;
	
	flashcardView.alpha = 0.0;
	introView.alpha     = 1.0;
	
	[self.view addSubview:flashcardView];
	[self.view addSubview:introView];
	
	[self.view insertSubview:introView aboveSubview:self.view];
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
	[super dealloc];
	
	[elapsedTimer invalidate];
	elapsedTimer = nil;
}
-(void) viewDidDisappear:(BOOL)animated
{
	[elapsedTimer invalidate];
	elapsedTimer = nil;
}

#pragma mark Pre-Game Methods
-(void) introButtonClicked:(id)sender
{
	// Disable the button right away
	introPlayButton.enabled = NO;
	
	// Set up the count-down timer
	introTimer = [NSTimer alloc];
	introTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
												  target:self 
												selector:@selector(introViewTimerFired) 
												userInfo:nil 
												 repeats:YES];
	
	// Center ths introStatusView
	CGRect frame = introStatusView.frame;
	frame.origin.x = round((self.view.frame.size.width - frame.size.width) / 2.0);
	frame.origin.y = round((self.view.frame.size.height - frame.size.height) / 2.0);//self.view.frame.size.height - 100;
	introStatusView.frame = frame;
	
	// Animate the labels coming into view
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.20];
	
	
	introView.alpha		  = 0.0;
	introStatusView.alpha = 1.0;
	
	introPlayButton.alpha = 0.0;
	
	[self.view addSubview:introStatusView];
	
	// Do the animations
	[UIView commitAnimations];
	
	// Remove this view
	[introView removeFromSuperview];
	
	// Fire the timer function to account for the 1.0s delay
	[self introViewTimerFired];
}

- (void)introViewTimerFired
{
	[introTimerLabel setText:[NSString stringWithFormat:@"%d", introViewCount]];
	
	// Decrement the timer counter
	introViewCount--;
	
	// Check for zero and unload the timer
	if(introViewCount < 0)
	{
		[introTimer invalidate];
		introTimer = nil;
		[introTimer release];
		
		// Hide the intro view and start the game!
		[self startGame];
	}
}


- (void)startGame
{
	
	// fade animate the view out of view by affecting its alpha
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.50];

	introStatusView.alpha = 0.0;
	flashcardView.alpha = 1.0;
	
	[UIView commitAnimations];
	
	// Remove the intro view
	[introStatusView removeFromSuperview];
	
	// Set up the game
	//Reset counter
	_currTime = 0;
	
	elapsedTimer = [NSTimer scheduledTimerWithTimeInterval:0.01
										 target:self 
									   selector:@selector(updateTimeAlert) 
									   userInfo:nil 
										repeats:YES];
	
	// Generate the question and update the status
	[self generateQuestion];
	
	questionCounter = 1;
	
	[self updateStatus];
}

#pragma mark Button Methods

- (IBAction) answerButtonClicked:(id)sender;
{
	// Assume user is wrong
	bool isCorrect = NO;
	
	// Check to see if the user selected the right answer
	if(sender == answer1Button)
	{
		if(currQuestion.trueIndex + 1 == 1)
			isCorrect = YES;
	}
	else if(sender == answer2Button)
	{
		if(currQuestion.trueIndex + 1 == 2)
			isCorrect = YES;
	}
	else if(sender == answer3Button)
	{
		if(currQuestion.trueIndex + 1 == 3)
			isCorrect = YES;
	}
	else if(sender == answer4Button)
	{
		if(currQuestion.trueIndex + 1 == 4)
			isCorrect = YES;
	}
	
	// Increment the correct counter
	if(isCorrect == YES)
	{
		correctCounter++;
	}
	else
	{
		wrongCounter++;
		
		// Play the "wrong" sound and vibrate
		AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
	}
	
	// Update the labes
	[self updateStatus];
	
	// See if the game is over
	if(questionCounter >= maxQuestionsNum)
		[self processResults];
	else
	{
		// Generate a new question
		[self generateQuestion];
		questionCounter++;
		
		// Update the counter labels
		[self updateStatus];
	}
}
-(IBAction) returnHomeButtonClicked:(id)sender
{
	[self dismissModalViewControllerAnimated:YES];
}
-(IBAction) showLeaderboardButtonClicked:(id)sender
{
	GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
	if (leaderboardController != NULL) 
	{
		if(difficulty == EASY)
			leaderboardController.category = @"easy.leaderboard.1";
		else if(difficulty == MEDIUM)
			leaderboardController.category = @"medium.leaderboard.1";
		else if(difficulty == HARD)
			leaderboardController.category = @"hard.leaderboard.1";
		else if(difficulty == EXPERT)
			leaderboardController.category = @"expert.leaderboard.1";
		
		leaderboardController.timeScope = GKLeaderboardTimeScopeAllTime;
		leaderboardController.leaderboardDelegate = self; 
		[self presentModalViewController: leaderboardController animated: YES];
	}
}
- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	[self dismissModalViewControllerAnimated: YES];
	[viewController release];
}



#pragma mark Process Game Results
-(void)processResults
{	
	// Grab the time
	float thisRoundTime = _currTime;
	
	// Stop the timer
	[elapsedTimer invalidate];
	elapsedTimer = nil;

	// Grab the game data
	GameData *gameData = [self loadGameData];
	
	// Extract out the current saved game data for this level
	NSNumber *currBestTime        = [gameData.currBestTime		  objectAtIndex:difficulty];
	NSNumber *totalTime		      = [gameData.totalTime			  objectAtIndex:difficulty];
	NSNumber *numCorrectQuestions = [gameData.numCorrectQuestions objectAtIndex:difficulty];
	NSNumber *numWrongQuestions   = [gameData.numWrongQuestions   objectAtIndex:difficulty];
	
	// Add in the number of right/wrong questions
	numCorrectQuestions = [NSNumber numberWithFloat:(correctCounter + [numCorrectQuestions floatValue])];
	numWrongQuestions   = [NSNumber numberWithFloat:(wrongCounter + [numWrongQuestions floatValue])];;
	totalTime			= [NSNumber numberWithFloat:(thisRoundTime + [totalTime floatValue])];
	
	// Check if all answers were correct and we beat the last best time
	float oldBestTime = [currBestTime floatValue];
	bool isNewBestTime;
	if(oldBestTime < 0)
		isNewBestTime = (correctCounter >= maxQuestionsNum);
	else {
		isNewBestTime = (correctCounter >= maxQuestionsNum) && (thisRoundTime < oldBestTime);
	}

	// Save the best time only if we need to
	resultsTip2Label.alpha = 0.0;

	if(isNewBestTime)
	{
		resultsTip2Label.alpha = 1.0;
		[[gameData currBestTime] replaceObjectAtIndex:difficulty withObject:[NSNumber numberWithFloat:thisRoundTime]];		
	}
		
	// Save the rest of the data
	[[gameData totalTime] replaceObjectAtIndex:difficulty withObject:totalTime];
	[[gameData numCorrectQuestions] replaceObjectAtIndex:difficulty withObject:numCorrectQuestions];
	[[gameData numWrongQuestions] replaceObjectAtIndex:difficulty withObject:numWrongQuestions];
	
	// Save it to the prefs
	NSData *encodedData = [NSKeyedArchiver archivedDataWithRootObject:gameData];
	[[NSUserDefaults standardUserDefaults] setObject:encodedData forKey:@"GameData"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	// Populate the results view
	NSString *diff;
	if(difficulty == EASY)
		diff = @"Easy";
	else if(difficulty == MEDIUM)
		diff = @"Medium";
	else if(difficulty == HARD)
		diff = @"Hard";
	else if(difficulty == EXPERT)
		diff = @"Expert";
	
	[resultsDifficultyLabel setText:[NSString stringWithFormat:@"Difficulty: %@", diff]];
	[resultsCorrectLabel setText:[NSString stringWithFormat:@"%d out of %d correct!", correctCounter, maxQuestionsNum]];
	[resultsPercentLabel setText:[NSString stringWithFormat:@"%.1f %%", 100*(float)correctCounter / (float)maxQuestionsNum]];
	[resultsRoundTimeLabel setText:[NSString stringWithFormat:@"Round Time: %.3fs", thisRoundTime]];

	// Display previous best time if theere is one
	if(oldBestTime < 0.0)
	{
		resultsBestTimeLabel.alpha = 0;
	}
	else {
		resultsBestTimeLabel.alpha = 1;
		
		if(isNewBestTime)
		{
			[resultsBestTimeLabel setText:[NSString stringWithFormat:@"Old Best Time: %.3fs", oldBestTime]];
		}
		else {
			[resultsBestTimeLabel setText:[NSString stringWithFormat:@"Current Best Time: %.3fs", oldBestTime]];
		}

	}

	// Show user you need 100% for best time
	if(correctCounter >= maxQuestionsNum)
	{
		resultsTip1Label.alpha = 0.0;
	}
	else
	{
		resultsTip1Label.alpha = 1.0;
	}

	
	//// Format the total time based on minutes
	//NSNumber *number = totalTime;
//	NSString *units = @"s";
//	
//	if([number floatValue] > 60.0 && [number floatValue] < 3600.0)
//	{
//		number = [NSNumber numberWithFloat:([totalTime floatValue] / 60.0)];
//		units = @"mins";
//	}
//	else if([number floatValue] >= 3600.0 && [number floatValue] < 86400.0)
//	{
//		number = [NSNumber numberWithFloat:([totalTime floatValue] / 3600.0)];
//		units = @"hours";
//	}
//	else if([number floatValue] >= 86400.0)
//	{
//		number = [NSNumber numberWithFloat:([totalTime floatValue] / 86400.0)];
//		units = @"days";
//	}
//	
//	[resultsTotalTimePlayingLabel setText:[NSString stringWithFormat:@"Total Time: %.2f %@", [number floatValue], units]];
//	
//
//
//	[resultsTotalCorrectLabel setText:[NSString stringWithFormat:@"Total Correct: %d", [numCorrectQuestions intValue]]];
//
//	[resultsTotalWrongLabel setText:[NSString stringWithFormat:@"Total Wrong: %d", [numWrongQuestions intValue]]];
//	[resultsOverallPercentageLabel setText:[NSString stringWithFormat:@"Overall Percentage: %.1f %%", (float)[numCorrectQuestions intValue]/(float)[numWrongQuestions intValue]]];
		
	// Add the results view but make it invisible
	resultsView.alpha = 0.0;
	[self.view addSubview:resultsView];
	
	// Animate the views
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.20];
	
	flashcardView.alpha = 0.0;
	resultsView.alpha = 1.0;

	// Do the animations
	[UIView commitAnimations];
	
	// Remove the game view
	[flashcardView removeFromSuperview];
	
	
	// Update Game Center shit
	if([GameCenterManager isGameCenterAvailable] && isGameCenter)
	{
		// Sumbit the scores if perfect round
		if(correctCounter >= maxQuestionsNum)
		{
			if(difficulty == EASY)
			{
				[gameCenterManager reportScore:(int64_t)floor(thisRoundTime*1000) forCategory:@"easy.leaderboard.1"];
			}
			else if(difficulty == MEDIUM)
			{
				[gameCenterManager reportScore:(int64_t)floor(thisRoundTime*1000) forCategory:@"medium.leaderboard.1"];
			}
			else if(difficulty == HARD)
			{
				[gameCenterManager reportScore:(int64_t)floor(thisRoundTime*1000) forCategory:@"hard.leaderboard.1"];
			}
			else if(difficulty == EXPERT)
			{
				[gameCenterManager reportScore:(int64_t)floor(thisRoundTime*1000) forCategory:@"expert.leaderboard.1"];
			}
		}
		
		// Update achievement status
		[gameCenterManager submitAchievement:@"com.braingame.ach30min" percentComplete:([totalTime floatValue]/60.0)*100];
		[gameCenterManager submitAchievement:@"com.braingame.ach1hr" percentComplete:([totalTime floatValue]/3600.0)*100];
		[gameCenterManager submitAchievement:@"com.braingame.ach5hr" percentComplete:([totalTime floatValue]/21600.0)*100];
		[gameCenterManager submitAchievement:@"com.braingame.ach50questions" percentComplete:([numCorrectQuestions floatValue]/50.0)*100];
		[gameCenterManager submitAchievement:@"com.braingame.ach100questions" percentComplete:([numCorrectQuestions floatValue]/100.0)*100];
		[gameCenterManager submitAchievement:@"com.braingame.ach1000questions" percentComplete:([numCorrectQuestions floatValue]/1000.0)*100];
	}
}


-(GameData*)loadGameData
{
	GameData *currGameData;
	
	NSUserDefaults *userPrefs = [NSUserDefaults standardUserDefaults];
	
	// Uncomment this to clear the data
	//[userPrefs removeObjectForKey:@"GameData"];
	//[userPrefs synchronize];
	
	// Load the data
	NSData *encodedData = [userPrefs objectForKey:@"GameData"];
	
	// No game data, so make a new one
	if(encodedData == nil)
	{
		// Initilize the object
		GameData *tmpGameData = [[GameData alloc] init];
		currGameData = tmpGameData;

		// Encode and save the object to the user prefs
		encodedData = [NSKeyedArchiver archivedDataWithRootObject:tmpGameData];
		[userPrefs setObject:encodedData forKey:@"GameData"];
		[userPrefs synchronize];
		[tmpGameData release];
	}

	// De-code the object
	currGameData = [NSKeyedUnarchiver unarchiveObjectWithData:encodedData];
	
	// Return
	return currGameData;
}
	 
#pragma mark Do Game
- (void)updateTimeAlert {
	_currTime += 0.01;
	[timerLabel setText:[NSString stringWithFormat:@"%.2f s", _currTime]];
}

-(void)generateQuestion
{	
	// Generate questions based on difficulty
	if(difficulty == EASY)
		currQuestion.qType = arc4random() % 2;
	else
		currQuestion.qType = arc4random() % 4;
	
	// Generate the question
	if(currQuestion.qType == Add)
	{
		// Generate a random addition question
		int a = 1 + arc4random() % maxNumber;
		int b = 1 + arc4random() % maxNumber;
		
		// Make sure smaller number is num1
		if(a <= b)
		{
			currQuestion.num1 = a;
			currQuestion.num2 = b;
		}
		else {
			currQuestion.num1 = b;
			currQuestion.num2 = a;
		}
		
		// Set the answer
		currQuestion.answer = a + b;
	}
	else if(currQuestion.qType == Sub)
	{
		// Generate a random subtraction question, making sure there are no negative numbers
		int a = 1 + arc4random() % maxNumber;
		int b = 1 + arc4random() % maxNumber;
		
		// Make sure smaller number is num2
		if(a > b)
		{
			currQuestion.num1 = a;
			currQuestion.num2 = b;
		}
		else {
			currQuestion.num1 = b;
			currQuestion.num2 = a;
		}
		
		// Set the answer
		currQuestion.answer = currQuestion.num1 - currQuestion.num2;
	}
	else if(currQuestion.qType == Mult)
	{
		// Generate a random multiplication question, making sure there are no negative numbers
		int a = 1 + arc4random() % maxNumber;
		int b = 1 + arc4random() % maxNumber;
		
		// Make sure smaller number is num2
		if(a <= b)
		{
			currQuestion.num1 = b;
			currQuestion.num2 = a;
		}
		else {
			currQuestion.num1 = a;
			currQuestion.num2 = b;
		}
		
		// Set the answer
		currQuestion.answer = a * b;
	}
	else if(currQuestion.qType == Div)
	{		
		// Generate a random division question
		// Divisor is less than the maxNumber and not zero
		currQuestion.num2 = 1 + arc4random() % maxNumber;
		
		// Generate the answer, making sure it is less than maxNumber and not zero
		currQuestion.answer = 1 + arc4random() % maxNumber;
		
		// Set the base number
		currQuestion.num1 = currQuestion.answer * currQuestion.num2;
	}
	
	// Select the button for the true answer
	currQuestion.trueIndex = arc4random() % 4;
	
	// Zero out the answer array
	for (int i = 0; i < 4; i++)
		currQuestion.answers[i] = 0;
	
	// Now generate the answer arrays based on the true answer and difficulty level
	for (int i = 0; i < 4; i++)
	{
		if(i == currQuestion.trueIndex)
			currQuestion.answers[i] = currQuestion.answer;
		else
		{
			bool isUnique = NO;
			
			while(!isUnique)
			{	
				// This ensures that the random selected answer index is never the answer, but less than maxNumber
				
				// If we are for "simple" questions, make the answers random, if harder, cluster them
				if(maxNumber < 25)
					currQuestion.answers[i] = 1 + arc4random() % maxNumber;
				else
				{
					// Generate a random sign to add/subtract from true answer
					int signNum = arc4random() % 2;
					int sign = 1;
					if(signNum == 1)
						sign = -1;
					
					currQuestion.answers[i] = currQuestion.answer + sign * (1 + arc4random() % (int)floor(maxNumber/2));
				}

				// Protect against negative
				if(currQuestion.answers[i] < 0)
					currQuestion.answers[i] = 1;
				
				isUnique = YES;
				// Now let's prevent duplicate answers
				for (int j = 0; j <= i; j++)
				{
					if(currQuestion.answers[i] == currQuestion.answer)
						isUnique = NO;
					
					if(j != i)
					{
						if(currQuestion.answers[j] == currQuestion.answers[i])
							isUnique = NO;
					}
				}
			}
		}
	}
	
	// Set the answer buttons
	[answer1Button setTitle:[NSString stringWithFormat:@"%d", currQuestion.answers[0]] forState:UIControlStateNormal];
	[answer2Button setTitle:[NSString stringWithFormat:@"%d", currQuestion.answers[1]] forState:UIControlStateNormal];
	[answer3Button setTitle:[NSString stringWithFormat:@"%d", currQuestion.answers[2]] forState:UIControlStateNormal];
	[answer4Button setTitle:[NSString stringWithFormat:@"%d", currQuestion.answers[3]] forState:UIControlStateNormal];
	
	// Format the output string
	if(currQuestion.qType == Add)
		[activeQuestionLabel setText:[NSString stringWithFormat:@"%d + %d", currQuestion.num1, currQuestion.num2]];
	else if(currQuestion.qType == Sub)
		[activeQuestionLabel setText:[NSString stringWithFormat:@"%d - %d", currQuestion.num1, currQuestion.num2]];
	else if(currQuestion.qType == Mult)
		[activeQuestionLabel setText:[NSString stringWithFormat:@"%d × %d", currQuestion.num1, currQuestion.num2]];
	else if(currQuestion.qType == Div)
		[activeQuestionLabel setText:[NSString stringWithFormat:@"%d ÷ %d", currQuestion.num1, currQuestion.num2]];
}

-(void)setDifficulty:(Difficulty)diff
{
	difficulty = diff;
}

-(void)updateStatus
{
	[questionLabel	setText:[NSString stringWithFormat:@"Question: %d/%d", questionCounter, maxQuestionsNum]];
	[correctLabel   setText:[NSString stringWithFormat:@"%d", correctCounter]];
	[incorrectLabel setText:[NSString stringWithFormat:@"%d", wrongCounter]];
}

@end
