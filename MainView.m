//
//  MainView.m
//  WhereAmI
//
//  Created by acs on 10/10/08.
//  Copyright ACS Technologies 2008. All rights reserved.
//

#import "MainView.h"

@implementation MainView

- (IBAction)easyButtonPushed {
	
	locmanager = [[CLLocationManager alloc] init]; 
	[locmanager setDelegate:self]; 
	[locmanager setDesiredAccuracy:kCLLocationAccuracyBest];
	
	[locmanager startUpdatingLocation];
}

CLLocationManager* locmanager;

-(void)awakeFromNib {
	[self update];
}



- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		// Initialization code
	}
	return self;
}


- (void)drawRect:(CGRect)rect {
	// Drawing code
}


- (void)dealloc {

	[super dealloc];
}




@end
