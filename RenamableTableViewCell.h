//
//  RenamableTableViewCell.h
//  iMIDIPatchbay
//
//  Created by Johannes Dörr on 08.09.13.
//
//

#import <UIKit/UIKit.h>
@class RenamableTableViewCell;


@protocol RenamableTableViewCellDelegate <NSObject>

- (BOOL) renamableTableViewCell:(RenamableTableViewCell*)cell shouldRenameTo:(NSString*)name;
- (void) renamableTableViewCell:(RenamableTableViewCell*)cell wasRenamedTo:(NSString*)name;
- (void) renamableTableViewCellDidBeginRenaming:(RenamableTableViewCell*)cell;
- (UITableView*) tableViewForRenamableTableViewCell:(RenamableTableViewCell*)cell;

@end


@interface RenamableTableViewCell : UITableViewCell <UITextFieldDelegate>
{
    UITextField *textField;
}

@property (nonatomic, weak) id<RenamableTableViewCellDelegate> delegate;

- (void) startRenaming;
- (void) abortRenaming;

@end
