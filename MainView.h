//
//  MainView.h
//  WhereAmI
//
//  Created by acs on 10/10/08.
//  Copyright ACS Technologies 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h> 
#import <CoreLocation/CLLocationManagerDelegate.h> 
#import <GameKit/GameKit.h>

@interface MainView : UIView<CLLocationManagerDelegate> {	
    IBOutlet UIButton *easyButton;
    IBOutlet UITextField *latitude;
    IBOutlet UITextField *longitude;
	
	CLLocationManager   *locmanager; 
	BOOL                wasFound;
	
	
}

- (IBAction)easyButtonPushed;



@end
