//
//  FlipsideViewController.m
//  BrainGame
//
//  Created by Jeff on 10/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FlipsideViewController.h"


@implementation FlipsideViewController

- (void)viewDidLoad {
	self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];		
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
}




@end
