//
//  ToDoListTableViewController.m
//  ToDoListStoryBoard-2
//
//  Created by malena mesarina on 1/25/14.
//  Copyright (c) 2014 malena mesarina. All rights reserved.
//

//NOTE: Thing we learn with this homework
// NSUserDefaults: is used to store the array of To Do Texts and restore.
// Where we store the array of texts ( in textView methods 'shouldChangeTextInRange:" and tableView
// c"ommitEditingStyle:") that is where we store the array in NSUserDefaults
// We restore the data in the ViewLoad method


#import "ToDoListTableViewController.h"
#import "ToDoCell.h"

@interface ToDoListTableViewController ()

- (void)Add:(id) sender;
- (void) loadInitialData; //We use NSUserDefaults to restore array of texts for tablevies
@property NSMutableArray *myTextArray;
@property ToDoCell *my_cell;
@property NSInteger rowSelected;
@property NSInteger testIteration; // for testing
@end

@implementation ToDoListTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
		self.title = @"To Do List";
		self.myTextArray = [[NSMutableArray alloc] init];

    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
		self.title = @"To Do List";
		NSMutableArray *my = [[NSMutableArray alloc] initWithCapacity:1];
		self.myTextArray = my;
        
    }
    return self;
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd  target:self action:@selector(Add:)];
	
	self.navigationItem.leftBarButtonItem = self.editButtonItem;
	self.tableView.scrollEnabled = YES;
	[self loadInitialData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.myTextArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ToDoCell";
    ToDoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
	
	
	
	//cell.EditableCell.text = [self.toDoTextArray objectAtIndex:indexPath.row];
	
    
	// Configure the cell...
	NSString *my_text = [self.myTextArray objectAtIndex:indexPath.row];
	
	// NEW
	
	//CGSize stringSize = [my_text sizeWithFont:[UIFont boldSystemFontOfSize:15] constrainedToSize:CGSizeMake(320, 9999) lineBreakMode:UILineBreakModeWordWrap];
	//UITextView *textV=[[UITextView alloc] initWithFrame:CGRectMake(5, 5, 290, stringSize.height+10)];
	//textV.font = [UIFont systemFontOfSize:15.0];
    //textV.text=my_text;
	//[cell.contentView addSubview:textV];
	
	
	
	//works
	cell.EditableCell.text = my_text;
	
	cell.EditableCell.delegate = self;
	cell.EditableCell.tag = indexPath.row;
	cell.tag = indexPath.row;
		 
    return cell;
}


#pragma - UITextView methods

/*
- (void)textViewDidChange:(UITextView *)textView
{
	// this is quite expensive, as it will save the item to Parse on every text change :(
	//[self updateItem:textView.tag withText:textView.text];
	
	[self.myTextArray replaceObjectAtIndex:textView.tag withObject:textView.text];
	[[NSUserDefaults standardUserDefaults] setObject:self.myTextArray forKey:@"myTextArray"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	[textView resignFirstResponder];
	[self.tableView beginUpdates];
	[self.tableView endUpdates];
	[self.tableView reloadData];
	
}
 */

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString *myString = [self.myTextArray objectAtIndex:indexPath.row];
	
	UITextView *textView = [[UITextView alloc] init];
	[textView setAttributedText:[[NSAttributedString alloc] initWithString:myString]];
	
	CGRect screenRect = [[UIScreen mainScreen] bounds];
	//CGFloat width = [self isPortraitOrientation] ? screenRect.size.width : screenRect.size.height;
	CGFloat width = screenRect.size.width;
	width -= 64;
	
	CGRect textRect = [textView.text boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
												  options:NSStringDrawingUsesLineFragmentOrigin
											   attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}
												  context:nil];
	
	NSLog(@"height = %f", textRect.size.height);
	return textRect.size.height + 20;
	
	
	//NEW
	//CGSize boundingSize = CGSizeMake(320, 115);
    //UIFont *font = [UIFont fontWithName:@"Helvetica Neue" size:15];
	
    //CGRect textRect = [myString boundingRectWithSize:boundingSize options:NSStringDrawingUsesFontLeading attributes: //@{NSFontAttributeName:font} context:nil];

	
	//
	//return textRect.size.height + 25;
	
}

//#pragma mark - UITextView delegates


// Gets called just before a UITexfield becomes first responder
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView {
	
    //NSLog(@"In textFieldShouldBeginEditing");
	
	return YES;
}
- (void) textViewDidBeginEditing:(UITextView *) textView {
	//NSLog(@"In textField DIDBEGINEDITING");
	return;
}



//Gets called just before a textfield stops being first responder
-(BOOL)textViewShouldEndEditing:(UITextView *)textView {
	//NSLog(@"textViewShouldEndEditing");
	//[self.myTextArray replaceObjectAtIndex:self.rowSelected withObject:textView.text];
	return YES;
}


//Method detect new characters entered, if the return key or new line character have been entered then eliminate the keyboard

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
	//NSLog(@"In shouldChangeTextInRange");
    NSCharacterSet *doneButtonCharacterSet = [NSCharacterSet newlineCharacterSet];
    NSRange replacementTextRange = [text rangeOfCharacterFromSet:doneButtonCharacterSet];
    NSUInteger location = replacementTextRange.location;
    if (location != NSNotFound){
		
		[self.myTextArray replaceObjectAtIndex:textView.tag withObject:textView.text];
		[[NSUserDefaults standardUserDefaults] setObject:self.myTextArray forKey:@"myTextArray"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		[textView resignFirstResponder];
		
		[self.tableView reloadData];
		
		return YES;
    } else {
		[self.myTextArray replaceObjectAtIndex:textView.tag withObject:textView.text];
		[[NSUserDefaults standardUserDefaults] setObject:self.myTextArray forKey:@"myTextArray"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		[self.tableView beginUpdates];
		[self.tableView endUpdates];

	}
	
	
    return YES;
}

#pragma - Row delegate methods
- (void)setEditing:(BOOL)editing animated:(BOOL)animate
{
	
	[super setEditing:editing animated:animate];
	if (editing == YES) {
		//NSLog(@"Editing mode");
	}
}

- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	//NSLog(@"in editingStyle");
	return UITableViewCellEditingStyleDelete;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete)
	{
		[self.myTextArray removeObjectAtIndex:indexPath.row];
		// Delete the row from the data source
		[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
		
		[[NSUserDefaults standardUserDefaults] setObject:self.myTextArray forKey:@"myTextArray"];
        [[NSUserDefaults standardUserDefaults] synchronize];
	}
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
	return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
	
}



#pragma - private methods

- (void)Add:(id) sender
{ //Add a string to mUtable array
	
	//NSLog(@"In Add");
	
	NSString *myString= @"test";
	myString = [myString stringByAppendingString:[NSString stringWithFormat:@"%u", self.testIteration]];
	//NSLog(@"myString = %@", myString);
	
	[self.myTextArray addObject:myString];
	self.testIteration = self.testIteration + 1;
	[self.tableView reloadData];
	
	//NSLog( @"array count is %u",[self.myTextArray count]);
	//NSLog( @"Button clicked." );
	
}

- (void) loadInitialData
{  NSArray *tempArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"myTextArray"];
    
    if(tempArray != nil){
        NSMutableArray *array = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"myTextArray"]];
        for (NSString *item in array) {
            //NSLog(@"loading item [%@]", item);
        }
        self.myTextArray = array;
    }
    
    [self.tableView reloadData];
	
}


@end
