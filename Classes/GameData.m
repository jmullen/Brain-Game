//
//  GameData.m
//  BrainGame
//
//  Created by Jeff on 11/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameData.h"

@implementation GameData

@synthesize currBestTime, totalTime, numWrongQuestions, numCorrectQuestions;

-(id) init{
	
	self = [super init];
	if(self != NULL)
	{
		// Hard-coded for now until game starts to expand
		int numLevels = 4;
		
		totalTime = [[NSMutableArray alloc] init];
		currBestTime = [[NSMutableArray alloc] init];
		numWrongQuestions = [[NSMutableArray alloc] init];
		numCorrectQuestions = [[NSMutableArray alloc] init];
		
		for (int i = 0; i < numLevels; i++)
		{
			[currBestTime addObject:[NSNumber numberWithFloat:-1.0]];
			[totalTime addObject:[NSNumber numberWithFloat:0]];
			[numWrongQuestions addObject:[NSNumber numberWithFloat:0.0]];
			[numCorrectQuestions addObject:[NSNumber numberWithFloat:0.0]];
		}
	}
	return self;
}

-(void) dealloc
{
	[currBestTime release];
	[totalTime release];
	[numWrongQuestions release];
	[numCorrectQuestions release];
	
	[super dealloc];
}


- (void) encodeWithCoder:(NSCoder*)encoder {
	[encoder encodeObject:currBestTime		  forKey:@"currBestTime"];
	[encoder encodeObject:totalTime			  forKey:@"totalTime"];
	[encoder encodeObject:numWrongQuestions   forKey:@"numWrongQuestions"];
	[encoder encodeObject:numCorrectQuestions forKey:@"numCorrectQuestions"];
}

- (id) initWithCoder:(NSCoder*)decoder {
    if (self = [super init])
	{
		// NOTE: Decoded objects are auto-released and must be retained
		currBestTime		= [[decoder decodeObjectForKey:@"currBestTime"] retain];
		totalTime		    = [[decoder decodeObjectForKey:@"totalTime"] retain];
		numWrongQuestions   = [[decoder decodeObjectForKey:@"numWrongQuestions"] retain];
		numCorrectQuestions = [[decoder decodeObjectForKey:@"numCorrectQuestions"] retain];
    }
    return self;
}


@end
