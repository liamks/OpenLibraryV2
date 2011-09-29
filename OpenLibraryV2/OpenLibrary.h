//
//  OpenLibrary.h
//  OpenLibraryV2
//
//  Created by Liam Kaufman Simpkins on 11-09-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OLBook.h"
/*
 
 1. get works based on subject
 2. get books based on work
 3. download book
 
 */


@interface OpenLibrary : NSObject{
    
}

@property (retain, nonatomic) NSString * subject;
@property (retain, nonatomic) NSString * workKey;
@property (retain, nonatomic) NSString * bookKey;
@property (retain, nonatomic) NSMutableDictionary * works;
@property (retain, nonatomic) NSMutableDictionary * books;

-(NSMutableDictionary *) getWorksBasedOnSubject;
-(NSMutableDictionary *) getBooksBasedOnWork;

-(void)getFromOpenLibrary:(int) typeOfDownload withKey:(NSString *) key;

@end
