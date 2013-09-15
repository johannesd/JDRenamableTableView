//
//  RenamableTableViewCell.m
//  iMIDIPatchbay
//
//  Created by Johannes Dörr on 08.09.13.
//
//

#import "RenamableTableViewCell.h"
#import "NSObject+OneWayBinding.h"

@implementation RenamableTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        textField = [[UITextField alloc] init];
        textField.delegate = self;
        [textField bind:@"font" toObject:self.textLabel withKeyPath:@"font"];
        [textField bind:@"frame" toObject:self.textLabel withKeyPath:@"frame"];
        textField.hidden = TRUE;
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textField.returnKeyType = UIReturnKeyDone;
        [self.contentView addSubview:textField];
    }
    return self;
}

- (void) dealloc
{
    [textField bind:@"font" toObject:nil withKeyPath:nil];
    [textField bind:@"frame" toObject:nil withKeyPath:nil];
}

- (void) setEditing:(BOOL)editing animated:(BOOL)animated
{
    BOOL wasEditing = self.editing;
    [super setEditing:editing animated:animated];
    self.textLabel.hidden = editing;
    textField.hidden = !editing;
    if (editing) {
        textField.text = self.textLabel.text;
    }
    else {
        if (wasEditing) {
            if ([self textFieldShouldEndEditing:textField]) {
                [textField resignFirstResponder];
            }
            else {
                UITableView *tableView = [self.delegate tableViewForRenamableTableViewCell:self];
                [tableView performSelector:@selector(setEditing:) withObject:@TRUE afterDelay:0];
            }
        }
    }
}

- (void) willTransitionToState:(UITableViewCellStateMask)state
{
    [super willTransitionToState:state];
    [self abortRenaming];
}

- (BOOL) textFieldShouldEndEditing:(UITextField*)aTextField
{
    return [self.delegate renamableTableViewCell:self shouldRenameTo:textField.text];
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    [self.delegate renamableTableViewCellDidBeginRenaming:self];
}

- (void) textFieldDidEndEditing:(UITextField*)aTextField
{
    [self.delegate renamableTableViewCell:self wasRenamedTo:textField.text];
}

- (BOOL) textFieldShouldReturn:(UITextField *)aTextField
{
    [textField resignFirstResponder];
    return FALSE;
}

- (void) startRenaming
{
    if (!textField.isFirstResponder) {
        [textField becomeFirstResponder];
    }
}

- (void) abortRenaming
{
    if (textField.isFirstResponder) {
        textField.text = self.textLabel.text;
        [textField resignFirstResponder];
    }
}

@end
