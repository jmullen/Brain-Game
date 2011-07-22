//
//  GameData.h
//  BrainGame
//
//  Created by Jeff on 11/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameData : NSObject<NSCoding> {	
	NSMutableArray *currBestTime;
	NSMutableArray *totalTime;
	NSMutableArray *numCorrectQuestions;
	NSMutableArray *numWrongQuestions;
}
@property (nonatomic, retain) NSMutableArray *currBestTime;
@property (nonatomic, retain) NSMutableArray *totalTime;
@property (nonatomic, retain) NSMutableArray *numCorrectQuestions;
@property (nonatomic, retain) NSMutableArray *numWrongQuestions;


@end
