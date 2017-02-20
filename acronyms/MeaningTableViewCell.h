//
//  MeaningTableViewCell.h
//  acronyms
//
//  Created by Ahmed Zaytoun on 6/23/16.
//  
//

#import <UIKit/UIKit.h>

@interface MeaningTableViewCell : UITableViewCell

@property(nonatomic,weak) IBOutlet UILabel *meaningLabel;
@property(nonatomic,weak) IBOutlet UILabel *frequencyLabel;
@property(nonatomic,weak) IBOutlet UILabel *yearLabel;

@end
