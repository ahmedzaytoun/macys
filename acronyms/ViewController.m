//
//  ViewController.m
//  acronyms
//
//  Created by Ahmed Zaytoun on 6/23/16.
//  
//

#import "ViewController.h"
#import "MeaningTableViewCell.h"
#import "MeaningsEntity.h"
#import "AbbreviationEntity.h"

#import <MBProgressHUD/MBProgressHUD.h>


#define kMeaningCell @"MeaningCell"

@interface ViewController ()

@property(nonatomic,strong) NSArray *meaningsList;

@end

@implementation ViewController

@synthesize meaningsTableView;
@synthesize searchController;
@synthesize tableBottomConstraint;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [self initializeViewController];
    [self initializeOperations];
    [self initializeOperationQueue];
    [self initializeSearchController];
    [self initNotifications];
    
}

#pragma mark - ViewController initializers

//initialize view controller
- (void) initializeViewController
{
    self.title = @"Acromine";
}

//initialize search controller
- (void) initializeSearchController
{
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    
    self.searchController.searchBar.delegate = self;
    self.searchController.searchBar.placeholder = @"Look for abbreviation";
    self.meaningsTableView.tableHeaderView = self.searchController.searchBar;
    
    self.definesPresentationContext = YES;
}

//initialize Meaning operation
- (void) initializeOperations
{
    meaningsOperation = [[MeaningOperation alloc] init];
    meaningsOperation.delegate = self;
}

//initialize NSOperation Queues
- (void) initializeOperationQueue
{
    mainOperationQueue = [[NSOperationQueue alloc] init];
    mainOperationQueue.maxConcurrentOperationCount = 1;
}

#pragma mark - Memory warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

//Number of sections in tableView
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    //return number of items in meaning list, otherwise reutrn zero
    return self.meaningsList != nil ? self.meaningsList.count : 0;
}

//Number of rows in section (Number of meanings returned for API)
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if(self.meaningsList != nil && section < self.meaningsList.count)
    {
        MeaningsEntity *entity = [self.meaningsList objectAtIndex:section];
        
        return entity != nil && entity.abbreviations != nil ? entity.abbreviations.count : 0;
    }
    
    return 0;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.meaningsTableView dequeueReusableCellWithIdentifier:kMeaningCell];
    
    if ([cell isKindOfClass:[MeaningTableViewCell class]])
    {
        MeaningTableViewCell *meaningCell = (MeaningTableViewCell *)cell;
        
        MeaningsEntity *meaningsEntity = [self.meaningsList objectAtIndex:indexPath.section];
        
        
        AbbreviationEntity *abbreviation = [meaningsEntity.abbreviations objectAtIndex:indexPath.row];
        
        meaningCell.meaningLabel.text = abbreviation.lf != nil ? abbreviation.lf : @" - ";
        
        meaningCell.yearLabel.text = [NSString stringWithFormat:@"Since %@", abbreviation.since != nil ? abbreviation.since.stringValue : @"-"];
        
        meaningCell.frequencyLabel.text = [NSString stringWithFormat:@"Frequency %@", abbreviation.frequency != nil ? abbreviation.frequency.stringValue : @"-"];
        
        return meaningCell;
    }
    
    return cell;
}

#pragma mark - Search bar Delegate

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self searchForText:searchText];
}

#pragma mark - Sub views updates

- (void) updateUIViews
{
    [self.meaningsTableView reloadData];
}

- (void) updateSearchResultsForSearchController:(UISearchController *)searchController
{
    [self performSelectorOnMainThread:@selector(updateUIViews) withObject:nil waitUntilDone:YES];
}

- (void) hideProgressView
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

#pragma mark - Operation Delegate

-(void) didLoadMeaningListWithResult:(NSArray *)result
{
    self.meaningsList = result;
    
    [self performSelectorOnMainThread:@selector(updateUIViews) withObject:nil waitUntilDone:YES];
    [self performSelectorOnMainThread:@selector(hideProgressView) withObject:nil waitUntilDone:YES];
}


- (void) failedToLoadMeaningListWithError:(NSError *)error
{
    [self performSelectorOnMainThread:@selector(updateUIViews) withObject:nil waitUntilDone:YES];
    [self performSelectorOnMainThread:@selector(hideProgressView) withObject:nil waitUntilDone:YES];
    [self performSelectorOnMainThread:@selector(showErrorToast) withObject:nil waitUntilDone:YES];
}

- (void) showErrorToast
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    // Set the annular determinate mode to show task progress.
    hud.mode = MBProgressHUDModeText;
    hud.labelText = NSLocalizedString(@"Error while loading data from server!", @"");
    // Move to bottm center.
    [hud hide:YES afterDelay:3.0];
}

#pragma mark - Search business logic

- (void) searchForText:(NSString *)text
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if(mainOperationQueue != nil)
    {
        [mainOperationQueue cancelAllOperations];
        
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(loadAbbreviationMeanings:) object:text];
        
        [mainOperationQueue addOperation:operation];
    }
}

- (void) loadAbbreviationMeanings:(NSString *)phrase
{
    [meaningsOperation getMeaningForAbbreviation:phrase];
}


- (void) initNotifications
{
    [self initKeyboardNotification];
}

#pragma mark - Keyboard notifications 

- (void) initKeyboardNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChange:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)keyboardWillChange:(NSNotification *)notification {
  
    [self updateKeyboardLayoutFromNotification:notification];
    
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    self.tableBottomConstraint.constant = 0;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        [self.view layoutIfNeeded];
        
    }];

}

- (void) updateKeyboardLayoutFromNotification:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    
    if(userInfo != nil)
    {
        NSValue *value = [userInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardFrame = value.CGRectValue;
        
        self.tableBottomConstraint.constant = keyboardFrame.size.height;

        [self.view setNeedsLayout];
        
        [UIView animateWithDuration:0.25 animations:^{
            
            [self.view layoutIfNeeded];
            
        }];
    }
}

@end
