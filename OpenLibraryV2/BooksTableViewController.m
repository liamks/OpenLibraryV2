//
//  BooksTableViewController.m
//  OpenLibraryV2
//
//  Created by Liam Kaufman Simpkins on 11-09-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BooksTableViewController.h"

@implementation BooksTableViewController
@synthesize openLibrary, books;

//- (id)initWithStyle:(UITableViewStyle)style
//{
//    self = [super initWithStyle:style];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

-(id) initWithWorkKey:(NSString *) newKey style:(UITableViewStyle)style{
    self = [super initWithStyle:style];
    if (self) {

        openLibrary = [[OpenLibrary alloc] init];
        openLibrary.workKey = newKey;
        
        //UINavigationController *nav = self.navigationController;
        
        [self.navigationItem setHidesBackButton:YES];
        
        
        //[openLibrary performSelectorInBackground:@selector(getBooksBasedOnWork:) withObject:self];
        //self.parentViewController.navigationController.view
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        
        HUD = [[MBProgressHUD alloc] initWithWindow:window];
        [window addSubview:HUD];
        
        HUD.delegate = self;
        HUD.labelText = @"Loading Books...";
        
        [HUD showWhileExecuting:@selector(getBooksBasedOnWork:) onTarget:openLibrary withObject:self animated:YES];
        
        //[openLibrary getBooksBasedOnWork:self.books];

        self.tableView.rowHeight = 100.0f;
    }
    return self;
    
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [books count];;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Books";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    NSString * key = [[books allKeys] objectAtIndex:indexPath.row];
    OLBook * book = [books valueForKey:key];
    
    cell.textLabel.text = book.title;
    cell.detailTextLabel.text = book.author;
    cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:book.smallCover]];
    
    /* LARGE SIZE FOR POOR VISION! */
    cell.textLabel.font = [UIFont boldSystemFontOfSize:22.0f];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:18.0f];


    //NSLog(@"Origin x: %@| Origin y: %@| width: %@| height: %@", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
    
    //[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}


/* HUD */

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [self.navigationItem setHidesBackButton:NO];

    [HUD removeFromSuperview];
    [HUD release];
	HUD = nil;
    
    if ([books count] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Books Found." 
                                                        message:@"There were no books, with ebooks, found for that work." 
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        
    }
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
