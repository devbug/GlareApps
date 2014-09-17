
#import "../headers.h"


@interface ABMemberNameView : UIView
@property(nonatomic) BOOL highlighted;
// < 7.1
@property(readonly, nonatomic) UILabel *meLabel;
@property(readonly, nonatomic) UILabel *nameLabel;
// >= 7.1
@property(nonatomic, retain) UITableViewCell *cell;
@end

@interface ABMemberCell : UITableViewCell
@property(retain, nonatomic) ABMemberNameView *contactNameView;
@end

@interface ABMembersController : UIViewController
- (UISearchDisplayController *)__searchController;
- (UISearchBar *)__searchBar;
- (UITableView *)currentTableView;
- (UIView *)contentView;
- (UITableView *)tableView;
@end

@interface ABContactCell : UITableViewCell
// < 7.1
@property(retain, nonatomic) UIColor *separatorColor;
// >= 7.1
@property(retain, nonatomic) UIColor *contactSeparatorColor;
@end
@interface ABPropertyCell : UITableViewCell
@property(readonly, nonatomic) UILabel *valueLabel;
@property(readonly, nonatomic) UILabel *labelLabel;
@property(copy, nonatomic) NSDictionary *valueTextAttributes;
@property(copy, nonatomic) NSDictionary *labelTextAttributes;
@end
@interface ABPropertyNameCell : UITableViewCell
@property(readonly, nonatomic) UITextField *textField;
@end
@interface ABPropertyNoteCell : ABPropertyCell
@property(retain, nonatomic) UITextView *textView;
@end

@interface ABGroupHeaderFooterView : UITableViewHeaderFooterView
@property(readonly, nonatomic) UIView *bottomSeparatorView;
@property(readonly, nonatomic) UIView *topSeparatorView;
@property(readonly, nonatomic) UILabel *titleLabel;
@end

@interface ABBannerView : UITableViewCell @end

@interface ABContactView : UITableView @end

