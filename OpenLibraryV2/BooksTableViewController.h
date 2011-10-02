//
//  BooksTableViewController.h
//  OpenLibraryV2
//
//  Created by Liam Kaufman Simpkins on 11-09-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenLibrary.h"
#import "MBProgressHUD.h"

@interface BooksTableViewController : UITableViewController <MBProgressHUDDelegate, UIAlertViewDelegate, ProcessDataDelegate>{
    MBProgressHUD *HUD;
    
}

@property (retain, nonatomic) OpenLibrary * openLibrary;
@property (retain, nonatomic) NSMutableDictionary * books;

-(id) initWithWorkKey:(NSString *) newKey style:(UITableViewStyle)style;

@end



