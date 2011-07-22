//
//  FlashCardViewController.h
//
//  Created by Jeff on 10/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "GameData.h"
#import "GameCenterManager.h"
#import <GameKit/GameKit.h>
#include <AudioToolbox/AudioToolbox.h>

@class GameData;
@class FlashcardView;

typedef enum
{
	Add = 0, Sub = 1, Mult = 2, Div = 3
} QuestionTypes;

typedef enum
{
	EASY = 0, MEDIUM = 1, HARD = 2, EXPERT = 3
} Difficulty;

@interface FlashcardViewController : UIViewController<GKLeaderboardViewControllerDelegate> {
	// System Sounds
	SystemSoundID	soundFileObject;
	
	// Main view
	IBOutlet UIView			*flashcardView;
	IBOutlet UILabel		*correctLabel;
	IBOutlet UILabel		*incorrectLabel;
	IBOutlet UILabel		*questionLabel;
	IBOutlet UILabel		*timerLabel;
	IBOutlet UILabel		*activeQuestionLabel;
	
	// The answer buttons
	IBOutlet UIButton		*answer1Button;
	IBOutlet UIButton		*answer2Button;
	IBOutlet UIButton		*answer3Button;
	IBOutlet UIButton		*answer4Button;
	
	
	// Variables for the intro view
	IBOutlet UIButton		*introPlayButton;
	IBOutlet UIView			*introView;

	IBOutlet UIView			*introStatusView;
	IBOutlet UILabel		*introTimerLabel;
	
	// Results view
	IBOutlet UIView			*resultsView;
	
	
	IBOutlet UILabel		*resultsCorrectLabel;
	IBOutlet UILabel		*resultsPercentLabel;
	IBOutlet UILabel		*resultsRoundTimeLabel;
	IBOutlet UILabel		*resultsBestTimeLabel;
	IBOutlet UILabel		*resultsTip1Label;
	IBOutlet UILabel		*resultsTip2Label;
	IBOutlet UILabel		*resultsDifficultyLabel;
	
	IBOutlet UIButton		*returnHome;
	//IBOutlet UILabel		*resultsTotalTimePlayingLabel;
	
	//IBOutlet UILabel		*resultsTotalCorrectLabel;
	//IBOutlet UILabel		*resultsTotalWrongLabel;
	//IBOutlet UILabel		*resultsOverallPercentageLabel;
	
	bool isGameCenter;
	
	// Timers
	NSTimer *elapsedTimer;
	NSTimer *introTimer;
	
	// Level difficulty
	Difficulty difficulty;
	
	// A bunch of counter and misc variables
	int maxNumber, correctCounter, wrongCounter, questionCounter, maxQuestionsNum;
	
	// Gamekit
	GameCenterManager* gameCenterManager;
	IBOutlet UIButton		*showLeaderboardButton;

	
	// The current question struction
	struct Question {		
		int num1;
		int num2;
		
		int answer;
		int answers[4];
		int trueIndex;
		
		QuestionTypes qType;
		
	} currQuestion;
}
@property (nonatomic, retain) UIButton *quitButton;
@property (nonatomic, retain) IBOutlet UILabel *timerLabel;
@property (nonatomic, retain) NSTimer *elapsedTimer;
@property (nonatomic, retain) UIView *introView;
@property (nonatomic, retain) UIView *introStatusView;
@property (nonatomic, retain) UIView *flashcardView;
@property (nonatomic, retain) UIView *resultsView;
@property (nonatomic, retain) GameCenterManager *gameCenterManager;
@property (assign) bool isGameCenter;
@property (readonly)	SystemSoundID	soundFileObject;

// Function Declarations
- (IBAction) returnHomeButtonClicked:(id)sender;
- (IBAction) answerButtonClicked:(id)sender;
- (IBAction) introButtonClicked:(id)sender;
- (IBAction) showLeaderboardButtonClicked:(id)sender;

- (void) updateTimeAlert;

- (void)updateStatus;
- (void)generateQuestion;
- (void)startGame;
- (void)processResults;
- (void)introViewTimerFired;
- (GameData*)loadGameData;
- (void)setDifficulty:(Difficulty)diff;
@end
