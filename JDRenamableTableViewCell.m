//
//  JDRenamableTableViewCell.m
//
//  Created by Johannes Dörr on 08.09.13.
//
//

#import "JDRenamableTableViewCell.h"
#import <JDBindings/NSObject+JDOneWayBinding.h>
#import <JDBindings/NSObject+JDObservation.h>

@implementation JDRenamableTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        textField = [[UITextField alloc] init];
        textField.delegate = self;
        [textField bind:@"font" toObject:self.textLabel withKeyPath:@"font"];
        __weak UITextField *weakTextField = textField;
        __weak JDRenamableTableViewCell *weakSelf = self;
        [textField bind:@"frame" toObject:self.textLabel withKeyPath:@"frame" withTransform:^id(NSValue *rectValue) {
            CGRect rect = [rectValue CGRectValue];
            if (weakTextField.font.pointSize > 20) {
                rect = CGRectMake(rect.origin.x, rect.origin.y + 2, rect.size.width, rect.size.height - 2);
            }
            CGFloat fillableMargin = MIN(rect.origin.y, weakSelf.contentView.bounds.size.height - rect.origin.y - rect.size.height);
            rect = CGRectMake(rect.origin.x,
                              rect.origin.y - fillableMargin,
                              weakSelf.contentView.bounds.size.width - rect.origin.x,
                              rect.size.height + 2 * fillableMargin);
            return [NSValue valueWithCGRect:rect];
        }];
        [self updateTextColorBinding:TRUE];
        [self.textLabel observeKeyPath:@"text" withObserver:self withSelector:@selector(textLabelChanged:)];
        textField.hidden = TRUE;
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textField.returnKeyType = UIReturnKeyDone;
        [self.contentView addSubview:textField];
    }
    return self;
}

- (void)dealloc
{
    [textField bind:@"font" toObject:nil withKeyPath:nil];
    [textField bind:@"frame" toObject:nil withKeyPath:nil];
    [self updateTextColorBinding:FALSE];
    [self.textLabel unobserveKeyPath:@"text" withObserver:self withSelector:@selector(textLabelChanged:)];
}

- (void)textLabelChanged:(id)sender
{
    textField.text = self.textLabel.text;
}

- (void)activateRenaming:(BOOL)activate
{
    self.textLabel.hidden = activate;
    textField.hidden = !activate;
    if (activate) {
        textField.text = self.textLabel.text;
    }
    else {
        if (self.renaming) {
            if (![self textFieldShouldEndEditing:textField]) {
                [self abortRenaming];
            }
            [textField resignFirstResponder];
        }
    }
}

- (void)activateRenamingIfNecessary
{
    BOOL activateRenaming = self.editing && !self.showingDeleteConfirmation;
    [self activateRenaming:activateRenaming];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self activateRenamingIfNecessary];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    [self updateTextColorBinding:TRUE];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    [self updateTextColorBinding:TRUE];
}

- (void)updateTextColorBinding:(BOOL)enable
{
    if (enable) {
        if (self.selected) {
            [textField bind:@"textColor" toObject:self.textLabel withKeyPath:@"highlightedTextColor"];
        }
        else {
            [textField bind:@"textColor" toObject:self.textLabel withKeyPath:@"textColor"];
        }
    }
    else {
        [textField bind:@"textColor" toObject:nil withKeyPath:nil];
    }
}

- (BOOL)renaming
{
    return [textField isFirstResponder];
}

- (void)willTransitionToState:(UITableViewCellStateMask)state
{
    [super willTransitionToState:state];
    [self abortRenaming];
}

- (BOOL)shouldEndRenaming
{
    return [self.delegate renamableTableViewCell:self shouldRenameTo:textField.text];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)aTextField
{
    return [self shouldEndRenaming];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.delegate renamableTableViewCellDidBeginRenaming:self];
}

- (void)textFieldDidEndEditing:(UITextField *)aTextField
{
    if (![textField.text isEqualToString:self.textLabel.text]) {
        [self.delegate renamableTableViewCell:self wasRenamedTo:textField.text];
    }
    // If only this cell but not the whole table is being edited, renaming
    // has to be turned off:
    [self performSelector:@selector(activateRenamingIfNecessary) withObject:nil afterDelay:0];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    // Necessary on iOS7
    return !self.showingDeleteConfirmation;
}

- (BOOL)textFieldShouldReturn:(UITextField *)aTextField
{
    [textField resignFirstResponder];
    return FALSE;
}

- (void)startRenaming
{
    if (!textField.isFirstResponder) {
        self.editing = FALSE;
        [self activateRenaming:TRUE];
        [textField becomeFirstResponder];
    }
}

- (void)endRenaming
{
    if (textField.isFirstResponder) {
        [textField resignFirstResponder];
    }
}

- (void)abortRenaming
{
    if (textField.isFirstResponder) {
        textField.text = self.textLabel.text;
        [textField resignFirstResponder];
    }
}

@end
