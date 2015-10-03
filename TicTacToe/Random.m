//
//  Random.m
//  TicTacToe
//
//  Created by Francis Bato on 10/2/15.
//  Copyright © 2015 Francis Bato. All rights reserved.
//

#import "Random.h"

@implementation Random

-(id)randomObject {
    NSUInteger myCount = [self count];
    if (myCount)
        return [self objectAtIndex:arc4random_uniform(myCount)];
    else
        return nil;
}


@end
