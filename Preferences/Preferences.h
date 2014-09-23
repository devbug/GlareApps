#import <UIKit/UIKit.h>
#import <Preferences/Preferences.h>
#import "../../FilteredAppListTableView/PSFilteredAppListListController.h"



#ifndef __D_PREFERENCES_HEADERS__
#define __D_PREFERENCES_HEADERS__



@interface PSViewController (Firmware32)
- (void)loadView;
@property (nonatomic, retain) PSSpecifier *specifier;
@property (nonatomic, retain) UIView *view;
- (void)viewDidLoad;
- (void)viewWillAppear:(BOOL)animated;
- (void)viewDidAppear:(BOOL)animated;
- (void)viewWillDisappear:(BOOL)animated;
- (void)viewDidDisappear:(BOOL)animated;
- (void)willResignActive;
- (void)willBecomeActive;

@property(nonatomic,assign) UIModalPresentationStyle modalPresentationStyle;
- (void)presentModalViewController:(UIViewController *)modalViewController animated:(BOOL)animated;
- (void)dismissModalViewControllerAnimated:(BOOL)animated;

@property(nonatomic,readonly,retain) UINavigationController *navigationController;
@property(nonatomic,readonly,retain) UINavigationItem *navigationItem;
@end

@interface PSViewController (Firmware50)
- (void)presentViewController:(UIViewController *)viewControllerToPresent animated: (BOOL)flag completion:(void (^)(void))completion;
- (void)dismissViewControllerAnimated: (BOOL)flag completion: (void (^)(void))completion;
@end

@interface PSViewController (Firmware70)
@property(nonatomic,assign) UIRectEdge edgesForExtendedLayout;
@property(nonatomic,readonly,retain) id<UILayoutSupport> topLayoutGuide;
@property(nonatomic,readonly,retain) id<UILayoutSupport> bottomLayoutGuide;
@property(nonatomic,assign) BOOL extendedLayoutIncludesOpaqueBars;
@property(nonatomic,assign) BOOL automaticallyAdjustsScrollViewInsets;
@end

@interface PSListController (Firmware32)
- (void)endUpdates;
- (void)beginUpdates;
- (void)updateSpecifiersInRange:(NSRange)arg1 withSpecifiers:(id)arg2;
- (void)updateSpecifiers:(id)arg1 withSpecifiers:(id)arg2;
@end

@interface PSListController (Firmware60)
- (UIViewController *)controllerForSpecifier:(PSSpecifier *)specifier;
@end

@interface PSListController (Firmware70)
- (void)lazyLoadBundle:(id)arg1;
- (NSInteger)indexForIndexPath:(NSIndexPath *)arg1;
- (id)tableView:(id)arg1 cellForRowAtIndexPath:(NSIndexPath *)arg2;
- (void)tableView:(id)arg1 didSelectRowAtIndexPath:(NSIndexPath *)arg2;
@end


@interface PSTableCell (Firmware32)
+ (id)stringFromCellType:(NSInteger)arg1;
- (void)setTitle:(id)arg1;
- (void)setShouldHideTitle:(BOOL)arg1;
- (void)setChecked:(BOOL)arg1;
- (BOOL)isChecked;
- (void)setIcon:(id)arg1;
- (void)setValue:(id)arg1;
- (id)value;
- (UILabel *)titleLabel;
- (UILabel *)valueLabel;
- (id)iconImageView;
- (void)setAlignment:(NSInteger)arg1;
- (BOOL)cellEnabled;
- (void)setCellEnabled:(BOOL)arg1;

@property(nonatomic,readonly,retain) UILabel      *textLabel;                   // default is nil.  label will be created if necessary.
@property(nonatomic,readonly,retain) UILabel      *detailTextLabel;             // default is nil.  label will be created if necessary (and the current style supports a detail label).

@property(nonatomic) UITableViewCellSelectionStyle  selectionStyle;             // default is UITableViewCellSelectionStyleBlue.
@property(nonatomic,getter=isSelected) BOOL         selected;                   // set selected state (title, image, background). default is NO. animated is NO
@property(nonatomic,getter=isHighlighted) BOOL      highlighted;                // set highlighted state (title, image, background). default is NO. animated is NO
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;                     // animate between regular and selected state
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated;               // animate between regular and highlighted state

@property(nonatomic,readonly) UITableViewCellEditingStyle editingStyle;         // default is UITableViewCellEditingStyleNone. This is set by UITableView using the delegate's value for cells who customize their appearance accordingly.
@property(nonatomic) BOOL                           showsReorderControl;        // default is NO
@property(nonatomic) BOOL                           shouldIndentWhileEditing;   // default is YES.  This is unrelated to the indentation level below.

@property(nonatomic) UITableViewCellAccessoryType   accessoryType;              // default is UITableViewCellAccessoryNone. use to set standard type
@property(nonatomic,retain) UIView                 *accessoryView;              // if set, use custom view. ignore accessoryType. tracks if enabled can calls accessory action
@property(nonatomic) UITableViewCellAccessoryType   editingAccessoryType;       // default is UITableViewCellAccessoryNone. use to set standard type
@property(nonatomic,retain) UIView                 *editingAccessoryView;       // if set, use custom view. ignore editingAccessoryType. tracks if enabled can calls accessory action

@property(nonatomic) NSInteger                      indentationLevel;           // adjust content indent. default is 0
@property(nonatomic) CGFloat                        indentationWidth;           // width for each level. default is 10.0

@property(nonatomic,getter=isEditing) BOOL          editing;                    // show appropriate edit controls (+/- & reorder). By default -setEditing: calls setEditing:animated: with NO for animated.
- (void)setEditing:(BOOL)editing animated:(BOOL)animated;

@property(nonatomic,readonly) BOOL                  showingDeleteConfirmation;
@end


@interface PSSpecifier (Firmware32)
+ (NSInteger)autoCorrectionTypeForNumber:(id)arg1;
- (NSInteger)titleCompare:(id)arg1;
- (void)setupIconImageWithBundle:(id)arg1;
- (void)setProperties:(id)arg1;
@end

@interface PSSpecifier (Firmware50)
@property(nonatomic) Class editPaneClass;
@property(nonatomic) NSInteger cellType;
@property(nonatomic) Class detailControllerClass;
@property(nonatomic) id target;
@end

@interface PSSpecifier (Firmware60)
@property(nonatomic) SEL controllerLoadAction;
@property(nonatomic) SEL buttonAction;
@property(nonatomic) SEL confirmationCancelAction;
@property(nonatomic) SEL confirmationAction;
@end

@interface PSSpecifier (Firmware70)
@property(nonatomic) BOOL showContentString;
- (void)setValues:(id)arg1 titles:(id)arg2 shortTitles:(id)arg3 usingLocalizedTitleSorting:(BOOL)arg4;
@end

@interface PSConfirmationSpecifier (Fimware)
@property(retain, nonatomic) NSString *cancelButton;
@property(retain, nonatomic) NSString *okButton;
@property(retain, nonatomic) NSString *prompt;
@property(retain, nonatomic) NSString *title;
@end


@interface PSEditableListController (Firmware)
- (BOOL)performDeletionActionForSpecifier:(id)arg1;
- (void)setEditable:(BOOL)arg1;
- (void)_setEditable:(BOOL)arg1 animated:(BOOL)arg2;
- (BOOL)editable;
- (void)editDoneTapped;
- (void)setEditButtonEnabled:(BOOL)arg1;
- (void)setEditingButtonHidden:(BOOL)arg1 animated:(BOOL)arg2;
- (void)_updateNavigationBar;
- (id)_editButtonBarItem;
@end


// http://pastebin.com/NnCHWtqG
extern NSString *PSActionKey; // action
extern NSString *PSAlignmentKey; // alignment
extern NSString *PSAutoCapsKey; // autoCaps
extern NSString *PSAutoCorrectionKey; // autoCorrection
extern NSString *PSBestGuesserkey; // bestGuess
extern NSString *PSBundleOverridePrincipalClassKey; // overridePrincipalClass
extern NSString *PSBundlePathKey; // bundle
extern NSString *PSCancelKey; // cancel
extern NSString *PSCellClassKey; // cellClass
extern NSString *PSConfirmationCancelKey; // cancelTitle
extern NSString *PSConfirmationDestructiveKey; // isDestructive
extern NSString *PSConfirmationKey; // confirmation
extern NSString *PSConfirmationOKKey; // okTitle
extern NSString *PSConfirmationPromptKey; // prompt
extern NSString *PSConfirmationTitleKey; // title
extern NSString *PSControlIsLoadingKey; // control-loading
extern NSString *PSControlKey; // control
extern NSString *PSControlMaximumKey; // max
extern NSString *PSControlMinimumKey; // min
extern NSString *PSCustomIconPathKey; // icon2
extern NSString *PSDefaultValueKey; // default
extern NSString *PSDefaultsKey; // defaults
extern NSString *PSDeferItemSelectionKey; // deferItemSelection
extern NSString *PSDeletionActionKey; // deletionAction
extern NSString *PSDetailControllerClassKey; // detail
extern NSString *PSEditPaneClassKey; // pane
extern NSString *PSEmailAddressKeyboardKey; // isEmail
extern NSString *PSEmailAddressingKeyboardKey; // isEmailAddressing
extern NSString *PSEnabled; // enabled
extern NSString *PSFooterAlignmentGroupKey; // footerAlignment
extern NSString *PSFooterCellClassGroupKey; // footerCellClass
extern NSString *PSFooterTextGroupKey; // footerText
extern NSString *PSFooterViewKey; // footerView
extern NSString *PSGetterKey; // get
extern NSString *PSHasBundleIconKey; // hasBundleIcon
extern NSString *PSHasIconKey; // hasIcon
extern NSString *PSHeaderCellClassKey; // headerCellClass
extern NSString *PSHeaderDetailTextGroupKey; // headerDetailText
extern NSString *PSHeaderView; // headerView
extern NSString *PSIDKey; // id
extern NSString *PSIPKeyboardKey; // isIP
extern NSString *PSIconImageKey; // iconImage
extern NSString *PSIconPathKey; // icon
extern NSString *PSIsControllerKey; // isController
extern NSString *PSIsRadioGroupKey; // isRadioGroup
extern NSString *PSKeyNameKey; // key
extern NSString *PSKeyboardTypeKey; // keyboard
extern NSString *PSLazilyLoadedBundleKey; // lazy-bundle
extern NSString *PSLazyIconAppID; // appIDForLazyIcon
extern NSString *PSLazyIconDontUnload; // dontUnloadLazyIcon
extern NSString *PSLazyIconLoading; // useLazyIcons
extern NSString *PSNegateValuekey; // negate
extern NSString *PSNumberKeyboardKey; // isNumeric
extern NSString *PSPlaceholderKey; // placeholder
extern NSString *PSRadioGroupCheckedSpecifierKey; // radioGroupCheckedSpecifier
extern NSString *PSRequiredCapabilitiesKey; // requiredCapabilities
extern NSString *PSRequiredCapabilitiesOrKey;
extern NSString *PSSetterKey; // set
extern NSString *PSSetupCustomClassKey; // customControllerClass
extern NSString *PSShortTitlesKey; // shortTitles
extern NSString *PSSliderLeftImageKey; // leftImage
extern NSString *PSSliderRightImageKey; // rightImage
extern NSString *PSSliderShowValueKey; // showValue
extern NSString *PSStaticTextMessageKey; // staticTextMessage
extern NSString *PSSwitchAlternateColorsKey; // alternateColors
extern NSString *PSTableCellClassKey; // cell
extern NSString *PSTableCellHeightKey; // height
extern NSString *PSTableCellKey; // cellObject
extern NSString *PSTableCellSubtitleTextKey;
extern NSString *PSTableCellUseEtchedAppearanceKey; // useEtched
extern NSString *PSTextFieldNoAutoCorrectKey; // notAutoCorrect
extern NSString *PSTitleKey; // label
extern NSString *PSTitlesDataSourceKey; // titlesDataSource
extern NSString *PSURLKeyboardKey; // isURL
extern NSString *PSValidTitlesKey; // validTitles
extern NSString *PSValidValuesKey; // validValues
extern NSString *PSValueChangedNotificationKey; // PostNotification
extern NSString *PSValueKey; // value
extern NSString *PSValuesDataSourceKey; // valuesDataSource


extern BOOL PSIsiPad() NS_AVAILABLE_IOS(6_0);


#endif



@interface GlareAppsListController : PSListController
@property (nonatomic, copy) NSString *_title;
- (void)setPreferenceNumberValue:(NSNumber *)value specifier:(PSSpecifier *)specifier;
- (NSNumber *)getPreferenceNumberValue:(PSSpecifier *)specifier;
@end


@interface GlareAppsSettingsListController : GlareAppsListController //<PSFilteredAppListDelegate>
@end

@interface GlareAppsMiscellaneousListController : GlareAppsListController
@end

