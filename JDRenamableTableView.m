//
//  JDRenamableTableView.m
//
//  Created by Johannes Dörr on 14.09.13.
//
//

#import "JDRenamableTableView.h"
#import "JDRenamableTableViewCell.h"


@implementation UIViewController (JDRenamableTableView)

- (void)tableView:(UITableView *)aTableView willBeginReorderingRowAtIndexPath:(NSIndexPath *)indexPath
{
    // This empty implementation is necessary for the compiler
}

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

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self abortRenamingOfAnyCell];
    if ([userDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [userDelegate scrollViewWillBeginDragging:scrollView];
    }
}

- (void)tableView:(UITableView *)aTableView willBeginReorderingRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self abortRenamingOfAnyCell];
}

- (void)abortRenamingOfAnyCell
{
    for (UITableViewCell *cell in self.visibleCells) {
        if ([cell isKindOfClass:JDRenamableTableViewCell.class]) {
            [((JDRenamableTableViewCell*)cell) abortRenaming];
        }
    }
}

@end
