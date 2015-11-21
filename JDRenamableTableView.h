//
//  JDRenamableTableView.h
//
//  Created by Johannes Dörr on 14.09.13.
//
//

#import <TPKeyboardAvoiding/TPKeyboardAvoidingTableView.h>

@interface JDRenamableTableView : TPKeyboardAvoidingTableView <UITableViewDelegate>
{
    __weak NSObject<UITableViewDelegate> *userDelegate;
}

@property (nonatomic, assign, readonly) BOOL goballyEditing;

- (void)endRenamingOfAnyCell;
- (void)abortRenamingOfAnyCell;
- (BOOL)shouldEndEditing;
- (NSIndexPath *)indexPathForRenamingCell;

@end
