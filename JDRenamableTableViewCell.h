//
//  JDRenamableTableViewCell.h
//
//  Created by Johannes Dörr on 08.09.13.
//
//

#import <UIKit/UIKit.h>
@class JDRenamableTableViewCell;


@protocol JDRenamableTableViewCellDelegate <NSObject>

- (BOOL) renamableTableViewCell:(JDRenamableTableViewCell*)cell shouldRenameTo:(NSString*)name;
- (void) renamableTableViewCell:(JDRenamableTableViewCell*)cell wasRenamedTo:(NSString*)name;
- (void) renamableTableViewCellDidBeginRenaming:(JDRenamableTableViewCell*)cell;
- (UITableView*) tableViewForRenamableTableViewCell:(JDRenamableTableViewCell*)cell;

@end


@interface JDRenamableTableViewCell : UITableViewCell <UITextFieldDelegate>
{
    UITextField *textField;
}

@property (nonatomic, weak) id<JDRenamableTableViewCellDelegate> delegate;

- (void) startRenaming;
- (void) abortRenaming;

@end
