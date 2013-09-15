//
//  RenamableTableView.h
//  iMIDIPatchbay
//
//  Created by Johannes Dörr on 14.09.13.
//
//

#import "TPKeyboardAvoidingTableView.h"

@interface RenamableTableView : TPKeyboardAvoidingTableView <UITableViewDelegate>
{
    NSObject<UITableViewDelegate> *userDelegate;
}

- (void)abortRenamingOfAnyCell;

@end
