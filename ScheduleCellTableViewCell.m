//
//  ScheduleCellTableViewCell.m
//  TableViewWithCustomCells
//
//  Created by Basanth Verma on 12/09/15.
//

#import "ScheduleCellTableViewCell.h"

@implementation ScheduleCellTableViewCell
@synthesize customerName,serviceBooked;


-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        // Initialization code
        customerName = [[UILabel alloc]init];
        customerName.textAlignment = NSTextAlignmentLeft;
        customerName.font = [UIFont systemFontOfSize:14];
        customerName.textColor = [UIColor blackColor];
        
        serviceBooked = [[UILabel alloc]init];
        serviceBooked.textAlignment = NSTextAlignmentLeft;
        serviceBooked.font = [UIFont systemFontOfSize:12];
        serviceBooked.textColor = [UIColor blueColor];
        
        [self.contentView addSubview:customerName];
        [self.contentView addSubview:serviceBooked];
        
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];


    CGRect frame;
    
    frame= CGRectMake(10,5, self.frame.size.width,self.frame.size.height*.5);
    customerName.frame = frame;
    
    frame= CGRectMake(100 ,self.frame.size.height*.6,self.frame.size.width ,self.frame.size.height*.4-5);
    serviceBooked.frame = frame;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
