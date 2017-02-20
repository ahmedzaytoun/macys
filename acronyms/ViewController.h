//
//  ViewController.h
//  acronyms
//
//  Created by Ahmed Zaytoun on 6/23/16.
//  
//

#import <UIKit/UIKit.h>

#import "MeaningOperation.h"

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MeaningOperationDelegate,UISearchBarDelegate,UISearchResultsUpdating>

{
    MeaningOperation *meaningsOperation;
    NSOperationQueue *mainOperationQueue;
    
}
@property (strong, nonatomic) UISearchController *searchController;

@property(nonatomic,weak) IBOutlet UITableView* meaningsTableView;
@property(nonatomic,weak) IBOutlet NSLayoutConstraint* tableBottomConstraint;

@end

