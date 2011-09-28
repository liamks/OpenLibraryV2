//
//  OpenLibrary.m
//  OpenLibraryV2
//
//  Created by Liam Kaufman Simpkins on 11-09-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OpenLibrary.h"
#import "SBJSON.h"

#define DOWNLOAD_WORK 1
#define DOWNLOAD_BOOKS 2
#define DOWNLOAD_BOOK_INFO 3

/*
 
 1. get works based on subject
 2. get books based on work
 3. download book
 
 */
@implementation OpenLibrary

@synthesize subject, workKey, bookKey, works, books;

- (id)init
{
    self = [super init];
    if (self) {
        self.works = [[NSMutableDictionary alloc] init];
        self.books = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

-(void)connectionWorks:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    OLWork *newWork;
    
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSDictionary *results = [jsonString JSONValue];
    
    NSArray *rawBooks = [results objectForKey:@"works"];
    
    for (NSDictionary *work in rawBooks) {
        
        newWork = [[OLWork alloc] init];
        newWork.title = [work objectForKey:@"title"];
        newWork.author = [[[work objectForKey:@"authors"] objectAtIndex:0] objectForKey:@"name"];
        newWork.key = [work objectForKey:@"key"];
        
        [self.works setValue:newWork forKey:newWork.title];
        
    }
}

-(void)connectionBooks:(NSURLConnection *)connection didReceiveData:(NSData *)data{

        /*
         1. get key of each book
         2. Iterate over each key and call getFromOpenLibrary with DOWNLOAD_BOOK_INFO
         */

}

-(void)connectionBookInfos:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    /*
     create book instance form JSON and add it to self.books
     */
}



-(void)getFromOpenLibrary:(int) typeOfDownload withKey:(NSString *) key{
    

    
    NSNumber *offset = [NSNumber numberWithInt:0]; //[self getOffset];
    NSString *urlString;
    
    switch (typeOfDownload) {
        case DOWNLOAD_WORK:
            urlString=
            [NSString stringWithFormat:@"http://openlibrary.org/subjects/%@.json?ebooks=true&limit=20&offset=%@", self.subject, [offset stringValue]];
            break;
        case DOWNLOAD_BOOKS:
            
            break;
            
        case DOWNLOAD_BOOK_INFO:
        default:
            break;
    }
    


    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLResponse *response = nil;
    NSError *error;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSURLConnection *c = [[NSURLConnection alloc] init];
    
    
    switch (typeOfDownload) {
        case DOWNLOAD_WORK:
            [self connectionWorks:c didReceiveData:data];
            break;
        case DOWNLOAD_BOOKS:
            [self connectionBooks:c didReceiveData:data];
            break;
            
        case DOWNLOAD_BOOK_INFO:
            [self connectionBookInfos:c didReceiveData:data];
            break;
        default:
            break;
    }
    
    //[response release];
    //[error release];
    [request release];
}



-(NSMutableDictionary *) getWorksBasedOnSubject{
    [self getFromOpenLibrary:DOWNLOAD_WORK withKey:nil];
    return self.works;
}


-(NSMutableDictionary *) getBooksBasedOnWork:(NSString *) newWorkKey{
    [self getFromOpenLibrary:DOWNLOAD_BOOKS withKey:newWorkKey];
    return self.books;
}







@end
