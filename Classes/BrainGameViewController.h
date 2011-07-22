//
//  BrainGameViewController.h
//  BrainGame
//
//  Created by Jeff on 10/18/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

#import "GameCenterManager.h"

@class FlashcardViewController;
@class GameData;

@interface BrainGameViewController : UIViewController <UIActionSheetDelegate, GKAchievementViewControllerDelegate, GameCenterManagerDelegate> {	
//@interface BrainGameViewController : UIViewController {	
	IBOutlet UIButton		*infoButton;
	
	
	UIView					*splashScreenView;	
	UIView					*mainMenuView;	
	UIView					*infoView;	
	UINavigationBar			*flipsideNavigationBar;
	IBOutlet UIButton		*easyButton;
	IBOutlet UIButton		*mediumButton;
	IBOutlet UIButton		*hardButton;
	IBOutlet UIButton		*expertButton;
	IBOutlet UIButton		*clearAllDataButton;
	IBOutlet UIImageView	*imageView;
	IBOutlet UIButton		*showAchievementsButton;
	bool isGameCenter;
	
	// Gamekit
	GameCenterManager* gameCenterManager;
}

@property (nonatomic, retain) UIButton *infoButton;
@property (nonatomic, retain) UINavigationBar *flipsideNavigationBar;
@property (nonatomic, retain) IBOutlet UIView *splashScreenView;
@property (nonatomic, retain) IBOutlet UIView *mainMenuView;
@property (nonatomic, retain) IBOutlet UIView *infoView;

@property (nonatomic, retain) GameCenterManager *gameCenterManager;
@property (assign) bool isGameCenter;


- (IBAction)toggleView;

- (void)removeSplashScreen;
- (IBAction) loadLevelClicked:(id)sender;
- (IBAction) clearAllDataClicked:(id)sender;
- (IBAction) showAchievementsButtonClicked:(id)sender;
-(void) showAlertWithTitle: (NSString*) title message: (NSString*) message;
@end

