//
//  BVScheduleCreator.m
//  TableViewWithCustomCells
//
//  Created by Basanth Verma on 01/09/15.
//

#import "BVScheduleCreator.h"
#import "TimingsTableViewController.h"
#import "TableViewCustomCellViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ScheduleCellTableViewCell.h"
#import "ScheduleDetailsViewController.h"

#define VIEW_TAG 20
#define degreesToRadian(x) (M_PI * x / 180.0)

@interface BVScheduleCreator ()
@property UILongPressGestureRecognizer * G ;
@property ScheduleCellTableViewCell *cellReadyToMove;
@property CGPoint TouchOnTheScreenMade;
@property UINavigationBar *myBar;
@end

@implementation BVScheduleCreator

@synthesize firstTableView;
@synthesize secondTableView;
@synthesize myBar;

@synthesize timeList;
@synthesize custList;
@synthesize menuButton1;
@synthesize menuButton2;
@synthesize menuButton3;
@synthesize frameWithTheThreeButtons;
@synthesize readyToMoveView;
@synthesize TouchOnTheScreenMade;


- (void)viewDidLoad {
   
    [super viewDidLoad];
    [self.view setMultipleTouchEnabled:YES];
    
    //Create Nav Bar and Add the Nav Bar Title
    myBar = [[UINavigationBar alloc]init];
    myBar.backgroundColor = [UIColor blueColor];
    UINavigationItem *navItem = [[UINavigationItem alloc] init];
    navItem.title = @"Today";
    myBar.items = @[ navItem ];
    [[UINavigationBar appearance] setBarTintColor:[UIColor yellowColor]];
    [self.view addSubview:myBar];
 
    firstTableView = [[UITableView alloc ]init];
    secondTableView=  [[UITableView alloc]init];
  
    firstTableView.delegate =self;
    secondTableView.delegate =self;
    
    firstTableView.dataSource = self;
    secondTableView.dataSource = self;
    
    [self addDataToList];

    [firstTableView setShowsHorizontalScrollIndicator:NO];
    [firstTableView setShowsVerticalScrollIndicator:NO];
    
    [secondTableView setShowsHorizontalScrollIndicator:NO];
    [secondTableView setShowsVerticalScrollIndicator:YES];
    
    [self.view addSubview:firstTableView];
    [self.view addSubview:secondTableView];
    

}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    myBar.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height*.1);
    
    firstTableView.frame = CGRectMake(0, self.view.frame.size.height*.1,self.view.frame.size.width*.2,self.view.frame.size.height);
    secondTableView.frame = CGRectMake(self.view.frame.size.width*.2, self.view.frame.size.height*.1,self.view.frame.size.width*.8 ,self.view.frame.size.height);
    
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    UITableView *slaveTable = nil;
    
    if (firstTableView == scrollView) {
        slaveTable = secondTableView;
    } else if (secondTableView == scrollView) {
        slaveTable = firstTableView;
    }
    
    [slaveTable setContentOffset:scrollView.contentOffset];
}

// adding Time to the First TableView and Adding some dummy Schedule data to the Second TableView
-(void)addDataToList
{
  timeList = [[NSMutableArray alloc]init];

    [timeList addObject:@"12 AM"];
     [timeList addObject:@"12:15"];
     [timeList addObject:@"12:30"];
     [timeList addObject:@"12:45"];
    
    for (NSInteger i = 1; i<12; i++) {
         [timeList addObject:[NSString stringWithFormat:@"%lu  AM", (unsigned long)i]];
         [timeList addObject:[NSString stringWithFormat:@"%lu:15", (unsigned long)i]];
         [timeList addObject:[NSString stringWithFormat:@"%lu:30", (unsigned long)i]];
         [timeList addObject:[NSString stringWithFormat:@"%lu:45", (unsigned long)i]];
    }
    [timeList addObject:@"12 PM"];
     [timeList addObject:@"12:15"];
     [timeList addObject:@"12:30"];
     [timeList addObject:@"12:45"];
    for (NSInteger i = 1; i<12; i++) {
        [timeList addObject:[NSString stringWithFormat:@"%lu  PM", (unsigned long)i]];
        [timeList addObject:[NSString stringWithFormat:@"%lu:15", (unsigned long)i]];
        [timeList addObject:[NSString stringWithFormat:@"%lu:30", (unsigned long)i]];
        [timeList addObject:[NSString stringWithFormat:@"%lu:45", (unsigned long)i]];
    }
    
    //adding dummy data to the Schedule list
    custList = [[NSMutableArray alloc] initWithCapacity:96];
    [custList addObject:@"Title"];
     [custList addObject:@"1"]; [custList addObject:@"2"]; [custList addObject:@" "]; [custList addObject:@" "];
    [custList addObject:@"1"]; [custList addObject:@"2"]; [custList addObject:@"3"]; [custList addObject:@"4"];
     [custList addObject:@"5"]; [custList addObject:@"6"]; [custList addObject:@"7"]; [custList addObject:@" "];
    for(NSInteger i=12;i<timeList.count;i++)
        [custList addObject:@" "];

}

#pragma mark - default tableview functions
//Number of rows for tableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [timeList count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if(tableView == secondTableView) // Right table view, that displays schedule booked, this cell is created First
    {
          static NSString *CellIdentifier = @"RightTablesCell";
        
        ScheduleCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil) {
            cell = [[ScheduleCellTableViewCell alloc]
                    //initWithFrame:CGRectMake(0, 0, secondTableView.frame.size.width, 100) reuseIdentifier:CellIdentifier];
                    initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            NSLog(@"RIGHT cell was nil");
        }
     
        cell.customerName.text = [custList objectAtIndex:indexPath.row];
        cell.serviceBooked.text = [custList objectAtIndex:indexPath.row];
        cell.selectionStyle =  UITableViewCellSelectionStyleBlue;
        
        
        if(![cell.customerName.text isEqualToString:@" "])
        {
            UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureMenu:)];
            [secondTableView addGestureRecognizer:recognizer];
            [cell becomeFirstResponder];
        }
           return cell;
    }
   else// if(tableView == firstTableView) // Left tableview, Only Time is displayed
    {
         static NSString *CellIdentifier = @"LeftTablesCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            NSLog(@"LEFT Cell was nil");
        }
        
          NSLog(@"------LEFT------");
          cell.textLabel.text = [timeList objectAtIndex:indexPath.row];
          cell.textLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:12.0];
          cell.textLabel.textColor = [UIColor whiteColor];
          cell.backgroundColor = [UIColor grayColor];
          cell.selectionStyle =  UITableViewCellSelectionStyleNone;
           return cell;
    }
 
}

#pragma mark - Show scheduled Details
-(void)showMeTheScheduleDetails:(NSIndexPath *) indexPath
{
    ScheduleDetailsViewController *viewController = [[ScheduleDetailsViewController alloc] init];
    viewController.customerName = [custList objectAtIndex:indexPath.row];
    [self presentViewController:viewController animated:YES
                     completion:nil];
}

#pragma mark - Long Press Gesture Menu
- (void)longPressGestureMenu :(UILongPressGestureRecognizer *)gesture
{
    
    CGPoint touchPointInFrame;
    ScheduleCellTableViewCell *cell;

    if(!secondTableView.editing)
    {
        if (gesture.state == UIGestureRecognizerStateBegan)
        {
            cell  = (ScheduleCellTableViewCell *)[gesture view];
            TouchOnTheScreenMade = [gesture locationInView:secondTableView];
          //  NSIndexPath *cells=  [secondTableView indexPathForRowAtPoint:TouchOnTheScreenMade];
            
            NSLog(@"Touch Point was: %@",NSStringFromCGPoint(TouchOnTheScreenMade));
          //  NSLog(@"index probably is %ld", cells.row);
            
            
          ScheduleCellTableViewCell * checkTheCell= (ScheduleCellTableViewCell *)[secondTableView cellForRowAtIndexPath:[secondTableView indexPathForRowAtPoint:TouchOnTheScreenMade]];
          if(![checkTheCell.customerName.text isEqualToString:@" "])
            {
                [self showCellModMenu:cell forTheGesture:gesture];
                NSLog(@"Gesture  Description---> %@",gesture.description);
            }
        
        }
        else if(gesture.state == UIGestureRecognizerStateEnded)
        {
                  touchPointInFrame = [gesture locationInView:[self.view viewWithTag:VIEW_TAG]];
                    
                    if(CGRectContainsPoint(menuButton1.frame, touchPointInFrame))
                    {
                        NSLog(@"Dropped at Button1");
                     
                        [frameWithTheThreeButtons removeFromSuperview];
                        //Supposed to be a view Controller that shows the schedule details
                        [self showMeTheScheduleDetails:[secondTableView indexPathForRowAtPoint:TouchOnTheScreenMade]];
                    }
                    else if(CGRectContainsPoint(menuButton2.frame, touchPointInFrame)){
                        NSLog(@"Dropped at Button2");
                        [frameWithTheThreeButtons removeFromSuperview];
                        //Supposed to be a view Controller that shows the recommended product
                        [self showMeTheScheduleDetails:[secondTableView indexPathForRowAtPoint:TouchOnTheScreenMade]];
                    }
                    //Move the Customer's schedule to another location
                    else if(CGRectContainsPoint(menuButton3.frame, touchPointInFrame)){
                        NSLog(@"Dropped at Button3");
                    
                        [frameWithTheThreeButtons removeFromSuperview];
            
                        self.cellReadyToMove = (ScheduleCellTableViewCell *)[secondTableView cellForRowAtIndexPath:[secondTableView indexPathForRowAtPoint:TouchOnTheScreenMade]];
                        readyToMoveView= [[UIView alloc ]initWithFrame:CGRectMake(0, 0, self.cellReadyToMove.frame.size.width*.6, self.cellReadyToMove.frame.size.height)];
                        readyToMoveView.alpha = 0.9;
                        readyToMoveView.backgroundColor = [UIColor grayColor];
                        
                        UIButton *closeTheMoveView = [[UIButton alloc]initWithFrame:CGRectMake(self.cellReadyToMove.frame.size.width*.5, 0, 50, 50 )];
                        [closeTheMoveView setTitle:@"x" forState:UIControlStateNormal];
                        [closeTheMoveView addTarget:self action:@selector(removeThisReadyToMoveView) forControlEvents:UIControlEventTouchUpInside];
                  
                        UILabel *textReady = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.cellReadyToMove.frame.size.width*.6, self.cellReadyToMove.frame.size.height)];
                        textReady.text = @"Move Me";
                        secondTableView.editing = true;
                        
            
                        [readyToMoveView addSubview:closeTheMoveView];
                        [readyToMoveView addSubview:textReady];
                        [self.cellReadyToMove addSubview:readyToMoveView];
                    }
                    //Dropped to a location other than the 3 buttons
                    else{
                              [frameWithTheThreeButtons removeFromSuperview];
                            NSLog(@"Just removing..");
                    }
                
                 }
       else if(gesture.state == UIGestureRecognizerStateChanged)
        {

          touchPointInFrame = [gesture locationInView:[self.view viewWithTag:VIEW_TAG]];

          //Enlarge Button 1
            if(CGRectContainsPoint(menuButton1.frame, touchPointInFrame))
        
            {
                NSLog(@"button <<<<<<<<1>>>>>>>>>>");
                menuButton1.frame = CGRectMake(0, 20, 44, 44);
                menuButton1.layer.cornerRadius = 22;
            }
            //Enlarge Button 2
            else  if(CGRectContainsPoint(menuButton2.frame, touchPointInFrame))
            {
                        NSLog(@"button <<<<<<<<2>>>>>>>>>>");
                menuButton2.frame = CGRectMake(50, 12, 44, 44);
                menuButton2.layer.cornerRadius = 22;

            }
            //Enlarge Button 3
            else if(CGRectContainsPoint(menuButton3.frame, touchPointInFrame))
            {
                NSLog(@"button <<<<<<<<3>>>>>>>>>>");
                menuButton3.frame = CGRectMake(100, 20, 44, 44);
                menuButton3.layer.cornerRadius = 22;

            }
            //Retore the sizes of the buttons
            else
            {
                       NSLog(@"nothing ----------");
                
                menuButton1.frame = CGRectMake(0, 20, 30, 30);
                menuButton1.layer.cornerRadius = 15;

                menuButton2.frame = CGRectMake(50, 12, 30, 30);
                menuButton2.layer.cornerRadius = 15;

                menuButton3.frame = CGRectMake(100, 20, 30, 30);
                menuButton3.layer.cornerRadius = 12;

                }
        }
    }
    
}

//Shows the Menu with 3 buttons
-(void) showCellModMenu:(UITableViewCell *) cell forTheGesture:(UILongPressGestureRecognizer *)gesture
{
   
    CGPoint touchPoint = [gesture locationInView:secondTableView];
    CGPoint touchPointScreen = [gesture locationInView:self.view];
    
    NSLog(@"touch point %@", NSStringFromCGPoint( touchPoint));
    NSLog(@"screen point %@", NSStringFromCGPoint(touchPointScreen));

   frameWithTheThreeButtons = [[UIView alloc]init];
   frameWithTheThreeButtons.tag=VIEW_TAG;
    
    //Following Logic is being used to detect the location of the Long press gesture:
    //1) Detect whether it was Top
    //1a Then whether it was top Left - if
    //1b OR it was Top Right - else if
    //1c OR JUST TOP -else
    
    //2) Detect whether it was Bottom
    //2a Then whether it was bottom left - if
    //2b or it was bottom right - else if
    //2c or just BOTTOM -  else
    

    //3) Either JUST LEFT - else if
    //4) OR JUST RIGHT - else if
    //5) OR JUST MID - else
    
    // IF the long press was made in TOP
    if(touchPointScreen.y < (secondTableView.frame.size.height* .2))
    {
        //Check if it was Top Left
        if(touchPointScreen.y < secondTableView.frame.size.height*.2 && touchPoint.x< secondTableView.frame.size.width *.2)
        {
            CGAffineTransform landscapeTransform = CGAffineTransformMakeRotation( degreesToRadian(135) );
            landscapeTransform = CGAffineTransformTranslate( landscapeTransform, 0.0, 0.0 );
            [frameWithTheThreeButtons setTransform:landscapeTransform];
            frameWithTheThreeButtons.frame = CGRectMake(touchPoint.x-74, touchPoint.y-134, 180, 150);
            NSLog(@"Top Left");
        }
        //Check if it was Top Right
        else if(touchPointScreen.y < secondTableView.frame.size.height*.2 && touchPoint.x > secondTableView.frame.size.width*.8)
        {
            CGAffineTransform landscapeTransform = CGAffineTransformMakeRotation( degreesToRadian(-130) );
            landscapeTransform = CGAffineTransformTranslate( landscapeTransform, 0.0, 0.0 );
            [frameWithTheThreeButtons setTransform:landscapeTransform];
            frameWithTheThreeButtons.frame = CGRectMake(touchPoint.x-124, touchPoint.y-14, 126, 100);
            NSLog(@"Top Right");
        }
        //Or it was just Top
        else
        {
            CGAffineTransform landscapeTransform = CGAffineTransformMakeRotation( degreesToRadian(180) );
            //landscapeTransform = CGAffineTransformTranslate( landscapeTransform, 0.0, 0.0 );
            [frameWithTheThreeButtons setTransform:landscapeTransform];
            
            frameWithTheThreeButtons.frame = CGRectMake(touchPoint.x-62, touchPoint.y-12, 126, 100);
            
            NSLog(@"TOP");
        }
    }
    //Check if the Touch was made in the BOTTOM of the screen
    else if(touchPointScreen.y > secondTableView.frame.size.height* .8)
    {
        //Was it at the Bottom RIGHT??
        if(touchPointScreen.y > secondTableView.frame.size.height*.8 && touchPoint.x > secondTableView.frame.size.width*.8 )
        {
            CGAffineTransform landscapeTransform = CGAffineTransformMakeRotation( degreesToRadian(-45) );
            landscapeTransform = CGAffineTransformTranslate( landscapeTransform, 0.0, 0.0 );
            [frameWithTheThreeButtons setTransform:landscapeTransform];
            
            frameWithTheThreeButtons.frame = CGRectMake(touchPoint.x-106, touchPoint.y-24, 126, 100);
            NSLog(@"Bottom Right");
        }
        //OR was it at the Bottom Left??
        else if(touchPointScreen.y > secondTableView.frame.size.height*.8 && touchPoint.x< secondTableView.frame.size.width *.2)
        {
            CGAffineTransform landscapeTransform = CGAffineTransformMakeRotation( degreesToRadian(45) );
            landscapeTransform = CGAffineTransformTranslate( landscapeTransform, 0, 0.0 );
            [frameWithTheThreeButtons setTransform:landscapeTransform];
            
            frameWithTheThreeButtons.frame = CGRectMake(touchPoint.x+7, touchPoint.y-102, 126, 100);
            NSLog(@"Bottom Left");
        }
        //OR was it just the Bottom
        else
        {
            NSLog(@"Buttom");
            frameWithTheThreeButtons.frame = CGRectMake(touchPoint.x-60,touchPoint.y-75,126,100);
        }
    }
    //Was the long touch made Somewhere in the Left?? (Excluding Top & Bottom)
   else if( touchPointScreen.y > secondTableView.frame.size.height*.2 && touchPointScreen.y < secondTableView.frame.size.height*.8 && touchPoint.x < secondTableView.frame.size.width*.2)
    {
        CGAffineTransform landscapeTransform = CGAffineTransformMakeRotation(degreesToRadian(90));
        landscapeTransform = CGAffineTransformTranslate( landscapeTransform, 0, 0.0 );
        [frameWithTheThreeButtons setTransform:landscapeTransform];
        frameWithTheThreeButtons.frame = CGRectMake(touchPoint.x-12, touchPoint.y-63, 100, 126);
        NSLog(@"Left side" );
    }
    //OR was the long touch made Somewhere on the right?? ( Excluding Top & bottom)
   else if(touchPointScreen.y > secondTableView.frame.size.height*.2 && touchPointScreen.y < secondTableView.frame.size.height*.78 && touchPoint.x > secondTableView.frame.size.width*.78)
   {
       CGAffineTransform landscapeTransform = CGAffineTransformMakeRotation(degreesToRadian(-90));
       landscapeTransform = CGAffineTransformTranslate( landscapeTransform, 0.0, 0.0 );
       [frameWithTheThreeButtons setTransform:landscapeTransform];
       frameWithTheThreeButtons.frame = CGRectMake(touchPoint.x-88, touchPoint.y-63, 100, 126);
       NSLog(@"Right side");
   }
    //Well then it is definitely somewhere in the MID section of the screen
   else
   {
       NSLog(@"MID");
       // theView.frame = CGRectMake(80 ,-30, 126, 100);
       frameWithTheThreeButtons.frame = CGRectMake(touchPoint.x-60,touchPoint.y-75,126,100);
   }
    
    
    // Draw a red circle where the touch occurred //First button 24x24
    UIButton *touchView = [[UIButton alloc] init];
    [touchView setBackgroundColor:[UIColor redColor]];
    touchView.frame = CGRectMake(50,70, 24, 24);
    touchView.layer.cornerRadius = 10;
    [frameWithTheThreeButtons addSubview:touchView];
    
    menuButton1 = [[UIButton alloc]init];//
    [menuButton1 setBackgroundColor:[UIColor blueColor]];
    menuButton1.frame = CGRectMake(0, 20, 30, 30);
    menuButton1.layer.cornerRadius = 15;
    [menuButton1 setTitle:@"A" forState:UIControlStateNormal];
    NSLog(@"BUTTON ONE's frame %@",NSStringFromCGRect(menuButton1.frame));
    menuButton1.userInteractionEnabled = YES;
    [frameWithTheThreeButtons addSubview:menuButton1];
    
    
    menuButton2 = [[UIButton alloc]init];
    [menuButton2 setBackgroundColor:[UIColor grayColor]];
    menuButton2.frame = CGRectMake(50,12 ,30, 30);
    [menuButton2 setTitle:@"B"  forState:UIControlStateNormal];
    NSLog(@"Button two's frame %@", NSStringFromCGRect(menuButton2.frame));
    menuButton2.layer.cornerRadius = 15;
    menuButton2.userInteractionEnabled = YES;
    [frameWithTheThreeButtons addSubview:menuButton2];
    
    
    menuButton3 = [[UIButton alloc]init];
    [menuButton3 setBackgroundColor:[UIColor purpleColor]];
    menuButton3.frame = CGRectMake(100,20, 30, 30);
    [menuButton3 setTitle:@"C" forState:UIControlStateNormal];
    NSLog(@"Button three's frame %@", NSStringFromCGRect(menuButton3.frame));
    menuButton3.layer.cornerRadius = 15;
    menuButton3.userInteractionEnabled = YES;
    [frameWithTheThreeButtons addSubview:menuButton3];
    
    [cell addSubview:frameWithTheThreeButtons];
    

}


//When A cell is being moved . .
- (IBAction) EditTable:(id)sender{
    if(self.editing)
    {
        [super setEditing:NO animated:NO];
        [secondTableView setEditing:NO animated:NO];
        [secondTableView reloadData];
    }
    else
    {
        [super setEditing:YES animated:YES];
        [secondTableView setEditing:YES animated:YES];
        [secondTableView reloadData];
    }
}

//Removes the "Move Me" view from the Cell being moved
-(void)removeThisReadyToMoveView{
    
    [readyToMoveView removeFromSuperview];
    readyToMoveView.hidden =true;
    secondTableView.editing = false;
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return [touch.view isKindOfClass:[UIControl class]] ? NO : YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    UITableViewCell *my;
    my=[secondTableView cellForRowAtIndexPath:fromIndexPath];
   
    if((self.cellReadyToMove == my))
    {
        [self removeThisReadyToMoveView];
        [secondTableView reloadData];
        
    }
    
}

//Replace the Cells, Only if the Destination Cell is Empty
- (NSIndexPath *)tableView:(UITableViewCell *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    ScheduleCellTableViewCell *cell =(ScheduleCellTableViewCell *) [secondTableView cellForRowAtIndexPath:proposedDestinationIndexPath];
    
    if([cell.customerName.text isEqualToString:@" "])
    {
        [self.custList exchangeObjectAtIndex:(proposedDestinationIndexPath.row) withObjectAtIndex:sourceIndexPath.row];
        return proposedDestinationIndexPath;
    }
    else
    {
        return sourceIndexPath;
    }
}


//Can the row be moved?
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [secondTableView cellForRowAtIndexPath:indexPath];
    
    if(cell == self.cellReadyToMove)
        return YES;
    else
        return NO;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
