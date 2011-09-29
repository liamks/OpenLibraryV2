//
//  OLBook.m
//  OpenLibraryV2
//
//  Created by Liam Kaufman Simpkins on 11-09-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OLBook.h"

@implementation OLBook

@synthesize smallCover, epubLink, daisyLink, numPages;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

@end
