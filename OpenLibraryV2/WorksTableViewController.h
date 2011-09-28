//
//  WorksTableViewController.h
//  OpenLibraryV2
//
//  Created by Liam Kaufman Simpkins on 11-09-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenLibrary.h"
#import "BooksTableViewController.h"

@interface WorksTableViewController : UITableViewController{
    
}
-(id) initWithSubject:(NSString *) newSubject style:(UITableViewStyle)style;

@property (retain, nonatomic) OpenLibrary * openLibrary;
@property (retain, nonatomic) NSMutableDictionary * works;
@property (retain, nonatomic) NSString * subject;

@end
