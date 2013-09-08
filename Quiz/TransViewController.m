//
//  TransViewController.m
//  Quiz
//
//  Created by 遠藤 豪 on 13/06/27.
//
//

#import "TransViewController.h"

@interface TransViewController ()

@end

@implementation TransViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //    UIImage* im = [UIImage imageNamed:@"brown_light.jpg"];
    //    UIImageView *iv = [[UIImageView alloc] initWithImage:im];
    //    [self.view addSubview:iv];
    //    iv.userInteractionEnabled = YES;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pushRtn:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
@end
