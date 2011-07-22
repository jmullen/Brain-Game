//
//  MainViewController.h
//  BrainGame
//
//  Created by Jeff on 10/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

@interface MainViewController : UIViewController {
	IBOutlet UITextField *mTextField;
	IBOutlet UITextView *mTextView;
}

-(IBAction) easyButtonClicked:(id)sender;
//-(IBAction) sendData:(id)sender;

@end
