//
//  FTCoreTextExamplesListViewController.m
//  FTCTExample
//
//  Created by Lukas Kukacka on 15/11/13.
//  Copyright (c) 2013 Fuerte International. All rights reserved.
//

#import "FTCoreTextExamplesViewController.h"

@interface FTCoreTextExamplesViewController ()

//  Those two are separated to keep the order
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *controllersClassesNames;

@end

@implementation FTCoreTextExamplesViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        self.title = @"FTCoreText";
        
        _titles = @[
            @"Complex \"Giraffe\" example",
            @"Inline Base64-encoded images",
            @"HTML-like syntax"
        ];
        
        _controllersClassesNames = @[
            @"FTCTGiraffeExampleViewController",
            @"FTCTBase64ImagesExampleViewController",
            @"FTCTHTMLSyntaxExampleViewController"
        ];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_titles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
    }
    
    cell.textLabel.text = _titles[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Class controllerClass = NSClassFromString(_controllersClassesNames[indexPath.row]);
    UIViewController *controller = [[controllerClass alloc] init];
    
    if (controller) {
        controller.title = _titles[indexPath.row];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

@end
