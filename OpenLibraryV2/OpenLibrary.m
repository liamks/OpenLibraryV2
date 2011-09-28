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

/*
 
 [{"key": "/books/OL11784104M"}, {"key": "/books/OL2386636M"}, {"key": "/books/OL3372656M"}, {"key": "/books/OL18340958M"}, {"key": "/books/OL12372130M"}, {"key": "/books/OL24288542M"}, {"key": "/books/OL10416746M"}, {"key": "/books/OL5877785M"}, {"key": "/books/OL22720503M"}, {"key": "/books/OL7584701M"}, {"key": "/books/OL3783702M"}, {"key": "/books/OL24273050M"}, {"key": "/books/OL926583M"}, {"key": "/books/OL12502473M"}, {"key": "/books/OL22157782M"}, {"key": "/books/OL11346361M"}, {"key": "/books/OL22839448M"}, {"key": "/books/OL17768937M"}, {"key": "/books/OL24284954M"}, {"key": "/books/OL824527M"}]
 */

-(void)connectionBooks:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSDictionary *results = [jsonString JSONValue];
    
    
    for (NSDictionary *newBookKey in results) {
        NSArray * book = [newBookKey allValues];
        NSString *stringBookKey = [book objectAtIndex:0];
        
        [self getFromOpenLibrary:DOWNLOAD_BOOK_INFO withKey:stringBookKey];
    }

}

-(void)connectionBookInfos:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"connectionBooks: %@", jsonString);
    /*
     create book instance form JSON and add it to self.books
     */
}



-(void)getFromOpenLibrary:(int) typeOfDownload withKey:(NSString *) key{
    

    
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
            NSLog(@"key: %@", justString);
            urlString =  [NSString stringWithFormat:@"http://openlibrary.org/api/books?bibkeys=OLID:%@&jscmd=data&format=json", justString];
            break;
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


-(NSMutableDictionary *) getBooksBasedOnWork{
    [self getFromOpenLibrary:DOWNLOAD_BOOKS withKey:self.workKey];
    return self.books;
}







@end
