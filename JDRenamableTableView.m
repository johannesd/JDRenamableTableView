//
//  JDRenamableTableView.m
//
//  Created by Johannes Dörr on 14.09.13.
//
//

#import "JDRenamableTableView.h"
#import "JDRenamableTableViewCell.h"


@implementation UIViewController (JDRenamableTableView)

//- (void)tableView:(UITableView *)tableView willBeginReorderingRowAtIndexPath:(NSIndexPath *)indexPath
//{
//}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}

@end


@interface JDRenamableTableView ()

@property (nonatomic, assign) BOOL goballyEditing;

@end


@implementation JDRenamableTableView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame style:UITableViewStylePlain]) {
        [self doInitialization];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self doInitialization];
    }
    return self;
}

- (void)doInitialization
{
    super.delegate = self;
}

- (void)setDelegate:(id<UITableViewDelegate>)aUserDelegate
{
    userDelegate = aUserDelegate;
    super.delegate = nil;
    super.delegate = self;
}

- (id<UITableViewDelegate>)delegate
{
    return userDelegate;
}

- (BOOL)respondsToSelector:(SEL)selector {
    return [userDelegate respondsToSelector:selector] ||
        [super respondsToSelector:selector];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    [invocation invokeWithTarget:userDelegate];
}

- (void)setEditing:(BOOL)editing
{
    [super setEditing:editing];
    self.goballyEditing = editing;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    self.goballyEditing = editing;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self endRenamingOfAnyCell];
    if ([userDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [userDelegate scrollViewWillBeginDragging:scrollView];
    }
}

- (void)tableView:(UITableView *)tableView willBeginReorderingRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self abortRenamingOfAnyCell];
    if ([userDelegate respondsToSelector:@selector(tableView:willBeginReorderingRowAtIndexPath:)]) {
        [userDelegate performSelector:@selector(tableView:willBeginReorderingRowAtIndexPath:) withObject:tableView withObject:indexPath];
    }
}

//- (void)tableView:(UITableView *)tableView didEndReorderingRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([userDelegate respondsToSelector:@selector(tableView:didEndReorderingRowAtIndexPath:)]) {
//        [userDelegate performSelector:@selector(tableView:didEndReorderingRowAtIndexPath:) withObject:tableView withObject:indexPath];
//    }
//}
//
//- (void)tableView:(UITableView *)tableView didCancelReorderingRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([userDelegate respondsToSelector:@selector(tableView:didCancelReorderingRowAtIndexPath:)]) {
//        [userDelegate performSelector:@selector(tableView:didCancelReorderingRowAtIndexPath:) withObject:tableView withObject:indexPath];
//    }
//}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([userDelegate respondsToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)]) {
//        [userDelegate performSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:) withObject:tableView withObject:indexPath];
//    }
//}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *renamingIndexPath = [self indexPathForRenamingCell];
    if (renamingIndexPath != nil) {
        if (![renamingIndexPath isEqual:indexPath]) {
            [self endRenamingOfAnyCell];
        }
        return nil;
    }
    else {
        return indexPath;
    }
}

- (void)endRenamingOfAnyCell
{
    NSIndexPath *indexPath = [self indexPathForRenamingCell];
    JDRenamableTableViewCell *cell = (JDRenamableTableViewCell *)[self cellForRowAtIndexPath:indexPath];
    if (cell.renaming) {
        [((JDRenamableTableViewCell*)cell) endRenaming];
    }
}

- (void)abortRenamingOfAnyCell
{
    NSIndexPath *indexPath = [self indexPathForRenamingCell];
    JDRenamableTableViewCell *cell = (JDRenamableTableViewCell *)[self cellForRowAtIndexPath:indexPath];
    if (cell.renaming) {
        [((JDRenamableTableViewCell*)cell) abortRenaming];
    }
}

- (BOOL)shouldEndEditing
{
    NSIndexPath *indexPath = [self indexPathForRenamingCell];
    JDRenamableTableViewCell *cell = (JDRenamableTableViewCell *)[self cellForRowAtIndexPath:indexPath];
    if (cell.renaming) {
        return [cell shouldEndRenaming];
    }
    return TRUE;
}

- (NSIndexPath *)indexPathForRenamingCell
{
    for (UITableViewCell *cell in self.visibleCells) {
        if ([cell isKindOfClass:[JDRenamableTableViewCell class]]) {
            if (((JDRenamableTableViewCell *)cell).renaming) {
                return [self indexPathForCell:cell];
            }
        }
    }
    return nil;
}

@end
