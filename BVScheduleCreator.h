//
//  BVScheduleCreator.h
//  TableViewWithCustomCells
//
//  Created by Basanth Verma on 01/09/15.
//

#import <UIKit/UIKit.h>

@interface BVScheduleCreator : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property UITableView *firstTableView;
@property UITableView *secondTableView;

@property NSMutableArray *timeList;
@property NSMutableArray *custList;

@property UIButton *menuButton1;
@property UIButton *menuButton2;
@property UIButton *menuButton3;

@property  UIView *frameWithTheThreeButtons;
@property  UIView *readyToMoveView ;

@end

