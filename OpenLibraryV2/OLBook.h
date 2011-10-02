//
//  OLBook.h
//  OpenLibraryV2
//
//  Created by Liam Kaufman Simpkins on 11-09-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OLWork.h"

@interface OLBook : OLWork{
    
}

@property (retain, nonatomic) NSURL *smallCover;
@property (retain, nonatomic) NSURL *epubLink;
@property (retain, nonatomic) NSURL *daisyLink;
@property (retain, nonatomic) NSNumber *numPages;
@property (retain, nonatomic) UIImage *cover; 

@end
