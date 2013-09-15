//
//  JDRenamableTableView.h
//
//  Created by Johannes Dörr on 14.09.13.
//
//

#import "TPKeyboardAvoidingTableView.h"

@interface JDRenamableTableView : TPKeyboardAvoidingTableView <UITableViewDelegate>
{
    NSObject<UITableViewDelegate> *userDelegate;
}

- (void)abortRenamingOfAnyCell;

@end
