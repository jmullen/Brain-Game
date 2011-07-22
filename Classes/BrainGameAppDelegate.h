//
//  BrainGameAppDelegate.h
//  BrainGame
//
//  Created by Jeff on 10/18/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BrainGameViewController;

@interface BrainGameAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    BrainGameViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet BrainGameViewController *viewController;

@end

