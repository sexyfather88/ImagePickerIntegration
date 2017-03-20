//
//  FirstViewPage.m
//  CameraIntegration
//
//  Created by lab702 on 2017/3/20.
//  Copyright © 2017年 Wlson.lin. All rights reserved.
//

#import "FirstViewPage.h"

@interface FirstViewPage ()
{
    NSInteger sourceTag;
    UIView *backgroundView;
}

@end

@implementation FirstViewPage

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title=@"Choose one of options";
    
    sourceTag=0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)handleCameraUsageClciked:(id)sender
{
    NSInteger tag=[sender tag];
    
    switch (tag) {
        case 0:
            
            //Capture Video
            [self handlePresentImagePickerController:0];
            break;
            
        case 1:

            //Capture Photo
            [self handlePresentImagePickerController:1];
            break;
            
        case 2:
            
            //Video Usage
            [self handlePresentImagePickerController:2];

            break;
            
        case 3:
            
            //Photo Usage
            [self handlePresentImagePickerController:3];

            break;
            
        default:
            break;
    }
    
}


-(void)handlePresentImagePickerController:(NSInteger)sourceType
{
    UIImagePickerController *picker =[UIImagePickerController new];
    
    picker.delegate = self;
    picker.allowsEditing=YES;
    
    
    if(sourceType==0)
    {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            //Open Camera
            
            picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Simulator can't use camera!! It can't work" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
            
            return;
        }
    }
    
    else if(sourceType==1)
    {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            //開啟相機
        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Simulator can't use camera!! It can't work" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            
            [alert show];
            
            return;
        }
        
    }
    else if(sourceType==2)
    {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.mediaTypes =  @[@"public.movie"];
    }
    else if(sourceType==3)
    {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.mediaTypes =  @[@"public.image"];
    }
    

    
    sourceTag=sourceType;
    
    [self presentViewController:picker animated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    if(sourceTag==0 ||sourceTag==2)
    {
        self.videoURL =[info objectForKey:UIImagePickerControllerMediaURL];
        [picker dismissViewControllerAnimated:YES completion:NULL];
        
        
        AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:self.videoURL options:nil];
        self.videoPlayerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
        
        
        self.videoPlayer = [AVPlayer playerWithPlayerItem:self.videoPlayerItem];
        self.videoPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:self.videoPlayer];
        
        CGRect videoPlayerFrame=self.view.bounds;
        videoPlayerFrame.origin.y=64;
        self.videoPlayerLayer.frame = videoPlayerFrame;
        self.videoPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        
        [self.view.layer addSublayer:self.videoPlayerLayer];
        [self.videoPlayer play];
        
        self.view.userInteractionEnabled=NO;
        self.navigationItem.title=@"Playing Video";
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerDidEnd)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:self.videoPlayerItem];
    }
    else if(sourceTag==1 || sourceTag==3)
    {
        UIImage *image;
        
        image=[info objectForKey:UIImagePickerControllerEditedImage];
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        
        backgroundView=[[UIView alloc]initWithFrame:self.view.frame];
        
        backgroundView.backgroundColor=[UIColor brownColor];
        
        CGRect imageFrame=CGRectMake(0,0,300,200);
        
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:imageFrame];
        imageView.center=backgroundView.center;
        imageView.image=image;
        
        UIButton *hideButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
        
        hideButton.center=imageView.center;
        CGRect buttonFrame=hideButton.frame;
        buttonFrame.origin.y=backgroundView.frame.size.height-60;
        hideButton.frame=buttonFrame;
        
        [hideButton setTitle:@"Hide" forState:UIControlStateNormal];
        [hideButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [hideButton addTarget:self action:@selector(handleHideImageView) forControlEvents:UIControlEventTouchUpInside];
        
        [backgroundView addSubview:imageView];
        [backgroundView addSubview:hideButton];
        [self.view addSubview:backgroundView];
    }
    
    

    
    
}

-(void)handleHideImageView
{
    [backgroundView removeFromSuperview];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


-(void)playerDidEnd{
    
    [self.videoPlayerLayer removeFromSuperlayer];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.videoPlayerItem];
     
    self.navigationItem.title=@"Choose one of options";
    
    self.view.userInteractionEnabled=YES;
    
    NSLog(@"\n\n%@",@"Video End");
}

////

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSString *titleString;
    
    switch (sourceTag) {
        case 0:
            titleString=@"Capture yuor video";
            break;
        case 1:
            titleString=@"Capture your photo";
            break;
        case 2:
            titleString=@"Select your video";
            break;
        case 3:
            titleString=@"Select your photo";
            break;
            
        default:
            break;
    }
    
    [viewController.navigationItem setTitle:titleString];
}

@end
