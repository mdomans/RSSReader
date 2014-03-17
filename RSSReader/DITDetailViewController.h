//
//  DITDetailViewController.h
//  RSSReader
//
//  Created by mdomans on 17.03.2014.
//  Copyright (c) 2014 mdomans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DITDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
