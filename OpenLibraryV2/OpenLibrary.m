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

@synthesize subject, workKey, bookKey, works, books, delegate;

- (id)init
{
    self = [super init];
    if (self) {
        self.works = [[NSMutableDictionary alloc] init];
        self.books = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

//-(void)connectionWorks:(NSURLConnection *)connection didReceiveData:(NSData *)data{
-(void) parseWorksData:(NSData *)data{
    OLWork *newWork;
    
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSDictionary *results = [jsonString JSONValue];
    
    NSArray *rawBooks = [results objectForKey:@"works"];
    
    self.works = [[NSMutableDictionary alloc] init];

    for (NSDictionary *work in rawBooks) {
        
        newWork = [[OLWork alloc] init];
        newWork.title = [work objectForKey:@"title"];
        newWork.author = [[[work objectForKey:@"authors"] objectAtIndex:0] objectForKey:@"name"];
        newWork.key = [work objectForKey:@"key"];
        
        [self.works setValue:newWork forKey:newWork.title];
        [newWork release];
        
    }
    
   
    [jsonString release];
}



//-(void)connectionBooks:(NSURLConnection *)connection didReceiveData:(NSData *)data{
-(void)parseBookData:(NSData *)data{
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSDictionary *results = [jsonString JSONValue];
    
    
    for (NSDictionary *newBookKey in results) {
        NSArray * book = [newBookKey allValues];
        NSString *stringBookKey = [book objectAtIndex:0];
        
        [self getFromOpenLibrary:DOWNLOAD_BOOK_INFO withKey:stringBookKey];
    }
    [jsonString release];

}

//-(void)connectionBookInfos:(NSURLConnection *)connection didReceiveData:(NSData *)data{
-(void)parseBookInfo:(NSData *)data{
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    NSDictionary *results = [jsonString JSONValue];
    NSDictionary *actualBook = [[results allValues] objectAtIndex:0];
    
    OLBook * newBook;
    
    NSArray *ebookArray = [actualBook valueForKey:@"ebooks"];
    NSString *key = [[results allKeys] objectAtIndex:0];
   
    if (ebookArray) {
       
        NSString * epubURL = [[[[ebookArray objectAtIndex:0] valueForKey:@"formats"] valueForKey:@"epub"] valueForKey:@"url"];

        
        newBook = [[OLBook alloc] init];
        
        newBook.key = [key substringFromIndex:5];
        newBook.title = [actualBook valueForKey:@"title"];
        newBook.author = [[[actualBook objectForKey:@"authors"] objectAtIndex:0] objectForKey:@"name"];
        newBook.numPages = [NSNumber numberWithInt:[[actualBook valueForKey:@"number_of_pages"] intValue]] ;
        newBook.smallCover = [NSURL URLWithString:[[actualBook valueForKey:@"cover"] valueForKey:@"medium"]];
        newBook.epubLink = [NSURL URLWithString: epubURL];
        newBook.cover = [UIImage imageWithData:[NSData dataWithContentsOfURL:newBook.smallCover]];
        
        [self.books setValue:newBook forKey:key];
        [newBook release];
     
        
    }
    
    [jsonString release];
}



-(void)getFromOpenLibrary:(int) typeOfDownload withKey:(NSString *) key{
    
    [key retain];
    NSNumber *offset = [NSNumber numberWithInt:0]; //[self getOffset];
    NSString *urlString, *justString ;
    
    switch (typeOfDownload) {
        case DOWNLOAD_WORK:
            urlString=
            [NSString stringWithFormat:@"http://openlibrary.org/subjects/%@.json?ebooks=true&limit=20&offset=%@", self.subject, [offset stringValue]];
            break;
        case DOWNLOAD_BOOKS:
            urlString = [NSString stringWithFormat:@"http://openlibrary.org/query.json?type=/type/edition&works=%@", key];
            break;
        case DOWNLOAD_BOOK_INFO:
            //need to remove first part of key (it's a url)
            justString = [key substringFromIndex:7];
            urlString =  [NSString stringWithFormat:@"http://openlibrary.org/api/books?bibkeys=OLID:%@&jscmd=data&format=json", justString];
            break;
        default:
            break;
    }
    


    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLResponse *response = nil;
    NSError *error;
    
    NSLog(@"Before synch");
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSLog(@"After synch");
    //NSURLConnection *c = [[NSURLConnection alloc] init];
    
    
    switch (typeOfDownload) {
        case DOWNLOAD_WORK:
            //[self connectionWorks:c didReceiveData:data];
            [self parseWorksData:data];
            break;
        case DOWNLOAD_BOOKS:
            //[self connectionBooks:c didReceiveData:data];
            [self parseBookData:data];
            break;
            
        case DOWNLOAD_BOOK_INFO:
            //[self connectionBookInfos:c didReceiveData:data];
            [self parseBookInfo:data];
            break;
        default:
            break;
    }
    
    //[response release];
    //[error release];
    //[c release];
    [request release];
    [key release];
}



-(NSMutableDictionary *) getWorksBasedOnSubject{
    [self getFromOpenLibrary:DOWNLOAD_WORK withKey:nil];
    return self.works;
}


-(void) getBooksBasedOnWork{
    NSAutoreleasePool *pool;
    pool = [[NSAutoreleasePool alloc] init];
    
    [self getFromOpenLibrary:DOWNLOAD_BOOKS withKey:self.workKey];

    [delegate getData:self.books];

    [pool drain];
}




-(void) dealloc{
    [workKey release];
    [works release];
    [super dealloc];
}


@end
