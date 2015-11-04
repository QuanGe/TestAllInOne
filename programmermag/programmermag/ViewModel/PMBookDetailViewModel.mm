//
//  PMBookDetailViewModel.m
//  programmermag
//
//  Created by 张如泉 on 15/11/2.
//  Copyright © 2015年 csdn. All rights reserved.
//

#import "PMBookDetailViewModel.h"
#import <CoreText/CoreText.h>
#import "tinyxml2.h"
#import "PMArticleImageModel.h"
#import "PMArticleModel.h"
#import "PMArticlePaperModel.h"

/* Callbacks */

static CGFloat ascentCallback( void *ref ){
    return [(NSString*)[(__bridge NSDictionary*)ref objectForKey:@"height"] floatValue];
}
static CGFloat descentCallback( void *ref ){
    return [(NSString*)[(__bridge NSDictionary*)ref objectForKey:@"descent"] floatValue];
}
static CGFloat widthCallback( void* ref ){
    return [(NSString*)[(__bridge NSDictionary*)ref objectForKey:@"width"] floatValue];
}

@interface PMBookDetailViewModel ()
@property (nonatomic,readwrite,copy) NSString * bookLocalUrl;
@property (nonatomic,readwrite,strong) NSMutableArray * articles;
@end

@implementation PMBookDetailViewModel

- (instancetype)initWithBookLocalUrl:(NSString*)bookLocalUrl
{
    self = [super init];
    if (self) {
        self.bookLocalUrl = bookLocalUrl;
        //[self fetchArticleList];
    }
    return self;
}

- (RACSignal*)fetchArticleList
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSString * frontLocalUrl = [self.bookLocalUrl componentsSeparatedByString:@"me.magazine"].firstObject;
        NSDate* tmpStartData = [NSDate date];
        self.articles = [NSMutableArray arrayWithCapacity:10];
        NSString* text = [NSString stringWithContentsOfFile:self.bookLocalUrl encoding:NSUTF8StringEncoding error:NULL];
        text = [text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSData * resultDataChange = [[NSData alloc] initWithBase64EncodedString:text options:NSDataBase64DecodingIgnoreUnknownCharacters];
        resultDataChange = [resultDataChange qgocc_aes256_decrypt:kBookAESKey];
        text = [[NSString alloc ] initWithData:resultDataChange encoding:NSUTF8StringEncoding];
        tinyxml2::XMLDocument *pDoc = new tinyxml2::XMLDocument();
        pDoc->Parse(text.UTF8String);
        //rss
        tinyxml2::XMLElement *rssEle = pDoc->RootElement();
        //channel
        tinyxml2::XMLElement *channelEle = rssEle->FirstChildElement();
        //title
        tinyxml2::XMLElement *keyEle = channelEle->FirstChildElement("item");
        
        //创建文本对齐方式
        CTTextAlignment alignment = kCTJustifiedTextAlignment;//对齐方
        CTParagraphStyleSetting alignmentStyle;
        alignmentStyle.spec=kCTParagraphStyleSpecifierAlignment;
        alignmentStyle.valueSize=sizeof(alignment);
        alignmentStyle.value=&alignment;
        
        
        //创建文本,    行间距
        CGFloat lineSpace=10;//间距数据
        CTParagraphStyleSetting lineSpaceStyle;
        lineSpaceStyle.spec=kCTParagraphStyleSpecifierLineSpacing;
        lineSpaceStyle.valueSize=sizeof(lineSpace);
        lineSpaceStyle.value=&lineSpace;
        
        
        //设置  段落间距
        CGFloat paragraph = 25;
        CTParagraphStyleSetting paragraphStyle;
        paragraphStyle.spec = kCTParagraphStyleSpecifierParagraphSpacing;
        paragraphStyle.valueSize = sizeof(CGFloat);
        paragraphStyle.value = &paragraph;
        
        //创建设置数组
        CTParagraphStyleSetting settings[]={
            lineSpaceStyle,paragraphStyle,alignmentStyle
        };
        
        int allNum = 0;
        CTParagraphStyleRef style = CTParagraphStyleCreate(settings , 3);
        //往下遍历
        while (keyEle != NULL) {
            //printf("%s,%s\n", keyEle->Name(),keyEle->GetText());
            
            //item
            const tinyxml2::XMLAttribute *attribute = keyEle->FirstAttribute();
            //printf("这里是文章 %s %s\n",attribute->Name(),attribute->Value());
            {
                PMArticleModel * a = [[PMArticleModel alloc] init];
                a.type = [NSString stringWithUTF8String:attribute->Value()];
                a.images = [NSMutableArray arrayWithCapacity:10];
                a.content =[[NSMutableAttributedString alloc] initWithString:@""];
                tinyxml2::XMLElement *ArticleTitleEle = keyEle->FirstChildElement("title");
                if(ArticleTitleEle != NULL)
                {
                    
                    if(ArticleTitleEle->GetText() != NULL)
                    {
                        a.titile = [NSString stringWithUTF8String:ArticleTitleEle->GetText()];
                    }
                    else
                    {
                        keyEle = keyEle->NextSiblingElement();
                        continue;
                    }
                }
                else
                {
                    keyEle = keyEle->NextSiblingElement();
                    continue;
                }
                tinyxml2::XMLElement *ArticleSubTitleEle = keyEle->FirstChildElement("me:subTitle");
                if(ArticleSubTitleEle != NULL)
                {
                    if(ArticleSubTitleEle->GetText() != NULL)
                        a.subTitile = [NSString stringWithUTF8String:ArticleSubTitleEle->GetText()];
                }
                tinyxml2::XMLElement *ArticleDesEle = keyEle->FirstChildElement("description");
                if(ArticleDesEle != NULL)
                {
                    if(ArticleDesEle->GetText() != NULL)
                    {
                        a.articleDescription = [NSString stringWithUTF8String:ArticleDesEle->GetText()];
                        if(a.articleDescription != nil)
                        {
                            NSString * subTitleFont= [UIFont boldSystemFontOfSize:14].fontName;
                            CTFontRef subTitleFontRef = CTFontCreateWithName((CFStringRef)subTitleFont,
                                                                             14.0f, NULL);
                            
                            NSDictionary* subTitleAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
                                                           (id)[UIColor lightGrayColor], NSForegroundColorAttributeName,
                                                           (__bridge id)subTitleFontRef, kCTFontAttributeName,
                                                           (id)style,kCTParagraphStyleAttributeName,
                                                           nil];
                            [a.content appendAttributedString:[[NSAttributedString alloc] initWithString:[a.articleDescription stringByAppendingString:@"\n"]  attributes:subTitleAttrs] ];
                        }
                        
                        
                    }
                }
                tinyxml2::XMLElement *ArticleCatEle = keyEle->FirstChildElement("category");
                if(ArticleCatEle != NULL)
                {
                    if(ArticleCatEle->GetText() != NULL)
                        a.category = [NSString stringWithUTF8String:ArticleCatEle->GetText()];
                }
                tinyxml2::XMLElement *ArticleDateEle = keyEle->FirstChildElement("pubDate");
                if(ArticleDateEle != NULL)
                {
                    if(ArticleDateEle->GetText() != NULL)
                        a.pubDate = [NSString stringWithUTF8String:ArticleDateEle->GetText()];
                }
                tinyxml2::XMLElement *ArticleEditorEle = keyEle->FirstChildElement("me:editor");
                if(ArticleEditorEle != NULL)
                {
                    if(ArticleEditorEle->GetText() != NULL)
                        a.editor = [NSString stringWithUTF8String:ArticleEditorEle->GetText()];
                }
                
                tinyxml2::XMLElement *ArticleContentEle = keyEle->FirstChildElement("me:content");
                if(ArticleContentEle != NULL)
                {
                    tinyxml2::XMLElement *ArticleContentStr= ArticleContentEle->FirstChildElement();
                    while (ArticleContentStr != NULL) {
                        
                        if(strcmp(ArticleContentStr->Name(), "p") == 0 )
                        {
                            NSString * font = nil ;
                            CTFontRef fontRef;
                            if( ArticleContentStr->Attribute("font") != NULL)
                            {
                                //printf("这里是文章段落 %s \n",ArticleContentStr->GetText());
                                font = [UIFont boldSystemFontOfSize:14].fontName;
                                fontRef = CTFontCreateWithName((CFStringRef)font,
                                                               19.0f, NULL);
                            }
                            else
                            {
                                font = [UIFont systemFontOfSize:13.f].fontName;
                                fontRef = CTFontCreateWithName((CFStringRef)font,
                                                               17.0f, NULL);
                            }
                            
                            
                            //apply the current text style //2
                            NSDictionary* attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                                                   (id)[UIColor blackColor], NSForegroundColorAttributeName,
                                                   (__bridge id)fontRef, kCTFontAttributeName,
                                                   (id)style,kCTParagraphStyleAttributeName,
                                                   
                                                   nil];
                            NSString *str = [NSString stringWithUTF8String: ArticleContentStr->GetText()];
                            str=[str stringByAppendingString:@"\n"];
                            [a.content appendAttributedString:[[NSAttributedString alloc] initWithString:str  attributes:attrs] ];
                        }
                        else if(strcmp(ArticleContentStr->Name(), "me:media") ==0 )
                        {
                            
                            PMArticleImageModel* theImage = [[PMArticleImageModel alloc] init];
                            if(strcmp(ArticleContentStr->Attribute("type"), "image") == 0)
                            {
                                theImage.type = PMArticleImageTypeContentImage;
                                if(ArticleContentStr->FirstChildElement("me:imageDetail") != NULL)
                                    theImage.cickImageFileName = [frontLocalUrl stringByAppendingString: [NSString stringWithUTF8String:ArticleContentStr->FirstChildElement("me:imageDetail")->Attribute("url")]];
                            }
                            else if(strcmp(ArticleContentStr->Attribute("type"), "link") == 0)
                            {
                                theImage.type = PMArticleImageTypeContentCodeLink;
                                theImage.cickImageFileName = [frontLocalUrl stringByAppendingString:[NSString stringWithUTF8String:ArticleContentStr->Attribute("url")]];
                            }
                            theImage.imageFileName = [frontLocalUrl stringByAppendingString:[NSString stringWithUTF8String:ArticleContentStr->Attribute("imageUrl")]];
                            theImage.height = atof(ArticleContentStr->Attribute("height"));
                            theImage.imageCaption = [NSString stringWithUTF8String:ArticleContentStr->Attribute("caption")];
                            theImage.location = (int)[a.content length];
                            [a.images addObject:theImage];
                            
                            //render empty space for drawing the image in the text //1
                            CTRunDelegateCallbacks callbacks;
                            callbacks.version = kCTRunDelegateVersion1;
                            callbacks.getAscent = ascentCallback;
                            callbacks.getDescent = descentCallback;
                            callbacks.getWidth = widthCallback;
                            
                            
                            NSDictionary* imgAttr = [NSDictionary dictionaryWithObjectsAndKeys: //2
                                                     [NSNumber numberWithFloat:364.0 ], @"width",
                                                     [NSNumber numberWithFloat:theImage.height], @"height",
                                                     nil] ;
                            
                            CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, (__bridge void*)imgAttr); //3
                            NSDictionary *attrDictionaryDelegate = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                    //set the delegate
                                                                    (__bridge id)delegate, (NSString*)kCTRunDelegateAttributeName,
                                                                    nil];
                            
                            //add a space to the text so that it can call the delegate
                            [a.content appendAttributedString:[[NSAttributedString alloc] initWithString:@" " attributes:attrDictionaryDelegate]];
                        }
                        ArticleContentStr = ArticleContentStr->NextSiblingElement();
                    }
                }
                
                
                tinyxml2::XMLElement *ArticleStaticImageEle = NULL;
                if(strcmp(keyEle->Attribute("me:itemtype"), "image")==0 )
                    ArticleStaticImageEle = keyEle->FirstChildElement("status");
                else
                    ArticleStaticImageEle = keyEle->FirstChildElement("me:media");
                if(ArticleStaticImageEle != NULL)
                {
                    if(strcmp(keyEle->Attribute("me:itemtype"), "image")==0 )
                    {
                        PMArticleImageModel * staticImage = [[PMArticleImageModel alloc] init];
                        staticImage.type = PMArticleImageTypeContentHomeImage;
                        staticImage.colspan = 2;
                        staticImage.imageFileName = [frontLocalUrl stringByAppendingString:[NSString stringWithUTF8String:ArticleStaticImageEle->Attribute("imgPortrait")]];
                        a.staticImage = staticImage;
                        
                        
                    }
                    else
                    {
                        
                        const char*type = ArticleStaticImageEle->Attribute("type");
                        if(strcmp(type, "image") == 0)
                        {
                            PMArticleImageModel * staticImage = [[PMArticleImageModel alloc] init];
                            staticImage.height = atof( ArticleStaticImageEle->Attribute("height"));
                            staticImage.type = PMArticleImageTypeContentStaticImage;
                            staticImage.colspan = atoi( ArticleStaticImageEle->Attribute("colspan"));
                            staticImage.imageFileName = [frontLocalUrl stringByAppendingString:[NSString stringWithUTF8String:ArticleStaticImageEle->Attribute("imageUrl")]];
                            a.staticImage = staticImage;
                        }
                        else if(strcmp(type, "video") == 0)
                        {
                            PMArticleImageModel * staticImage = [[PMArticleImageModel alloc] init];
                            staticImage.height = atof( ArticleStaticImageEle->Attribute("imageHeight"));
                            staticImage.type = PMArticleImageTypeContentVideo;
                            staticImage.colspan = 2;
                            staticImage.imageFileName = [frontLocalUrl stringByAppendingString:[NSString stringWithUTF8String:ArticleStaticImageEle->Attribute("imageUrl")]];
                            staticImage.cickImageFileName = [frontLocalUrl stringByAppendingString:[NSString stringWithUTF8String:ArticleStaticImageEle->Attribute("url")]];
                            staticImage.imageCaption = [NSString stringWithUTF8String:ArticleStaticImageEle->Attribute("caption")];
                            a.staticImage = staticImage;
                        }
                        
                    }
                    
                }
                [a buildHeaderStr];
                [self createPaperWithArticle:a];
                [self.articles addObject:a];
                
            }
            keyEle = keyEle->NextSiblingElement();
        }
        NSLog(@"%@",self.articles);
        
        double deltaTime = [[NSDate date] timeIntervalSinceDate:tmpStartData];
        NSLog(@"cost time = %f", deltaTime);
        
        [subscriber sendNext:@(YES)];
        [subscriber sendCompleted];
        return nil;
    }];
    
    
}

- (void)createPaperWithArticle:(PMArticleModel*)article
{
    article.papers = [NSMutableArray array];
    CGFloat frameXOffset = 20; //1
    CGFloat frameYOffset = 40;
    
    CGMutablePathRef path = CGPathCreateMutable(); //2
    CGRect textFrame = CGRectMake(frameXOffset, frameYOffset, mScreenWidth-2*frameXOffset, mScreenHeight-2*frameYOffset);
    CGPathAddRect(path, NULL, textFrame );
    
    
    
    
    int columnIndex = 0;
    
    int textPos = 0; //3
    
    int left = -1;
    int right = -1;
    int articleStartColIndex = columnIndex;
    CGRect rect = [article.headerStr boundingRectWithSize:CGSizeMake(mScreenWidth-frameXOffset*2, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading  context:nil];
   
    float TitleHeight = rect.size.height;
    PMArticlePaperModel *paper = nil;
    if(article.staticImage != nil )
    {
        if(article.staticImage.type == PMArticleImageTypeContentHomeImage)
        {
            paper = [[PMArticlePaperModel alloc] initWithType:PMArticlePaperTypeOnlyImage];
            paper.ortherImage = article.staticImage;
           
            [article.papers addObject:paper];
            return;
        }
        else if(article.staticImage.type == PMArticleImageTypeContentStaticImage || article.staticImage.type == PMArticleImageTypeContentVideo)
        {
            
            if(article.staticImage.colspan == 1)
            {
                
                int c = columnIndex+1;
                right = c;
                paper = [[PMArticlePaperModel alloc] initWithType:PMArticlePaperTypeFisrtPagerSmallImage];
                paper.ortherImage = article.staticImage;
                paper.titleHeight = TitleHeight;
                paper.title = article.headerStr;
            }
            else if(article.staticImage.colspan == 2)
            {
                left = columnIndex;
                right = columnIndex+1;
                
                paper = [[PMArticlePaperModel alloc] initWithType:PMArticlePaperTypeFisrtPagerBigImage];
                paper.ortherImage = article.staticImage;
                paper.titleHeight = TitleHeight;
                paper.title = article.headerStr;
            }
        }
    }
    else
    {
        paper = [[PMArticlePaperModel alloc] initWithType:PMArticlePaperTypeFisrtPagerNormal];
        paper.titleHeight = TitleHeight;
        paper.title = article.headerStr;
    }
    
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)article.content);
    while (textPos < [article.content length])
    { //4
    
        CGRect colRect ;
        float firstPageDeleteHeight = 0.0;
        if(columnIndex == left || columnIndex == right)
            firstPageDeleteHeight += article.staticImage.height;
        if((articleStartColIndex+1) == columnIndex || articleStartColIndex == columnIndex)
        {
            
            firstPageDeleteHeight +=  TitleHeight;
        }
        
        colRect = CGRectMake(0, 0 , textFrame.size.width/2-frameXOffset, textFrame.size.height-2*frameYOffset-firstPageDeleteHeight);
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, colRect);
        
        //use the column path
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(textPos, 0), path, NULL);
        CFRange frameRange = CTFrameGetVisibleStringRange(frame); //5
    
        if(columnIndex%2==0)
        {
            if(article.papers.count != 0)
                paper = [[PMArticlePaperModel alloc] initWithType:PMArticlePaperTypeNormal];
            paper.leftCTFrame = (__bridge id)frame;
        }
        else
        {
            paper.rightCTFrame = (__bridge id)frame;
            [article.papers addObject:paper];
        }
        
        //prepare for next frame
        textPos += frameRange.length;
        
        //CFRelease(frame);
        CFRelease(path);
        
        columnIndex++;
    }
    
    if(columnIndex%2 == 1)
        [article.papers addObject:paper];
    
}

- (void)addImageToPagperWithArticle:(PMArticleModel*)article
{
    CGFloat frameXOffset = 20; //1
    CGFloat frameYOffset = 40;
    for (PMArticlePaperModel *paper in article.papers) {
        if(paper.leftImageArray != nil)
            return;
        for (int i = 0; i<2; i++) {
            if(i == 0)
                paper.leftImageArray = [NSMutableArray array];
            else
                paper.rightImageArray = [NSMutableArray array];
            CTFrameRef f = (__bridge CTFrameRef)(i ==0?paper.leftCTFrame:paper.rightCTFrame);
            //drawing images
            NSArray *lines = (NSArray *)CTFrameGetLines(f); //1
            
            CGPoint origins[[lines count]];
            CTFrameGetLineOrigins(f, CFRangeMake(0, 0), origins); //2
            
            int imgIndex = 0; //3
            NSMutableArray * articleImages = article.images;
            if(articleImages.count == 0)
                return;
            PMArticleImageModel* nextImage = [articleImages objectAtIndex:imgIndex];
            int imgLocation = nextImage.location;
            
            //find images for the current column
            CFRange frameRange = CTFrameGetVisibleStringRange(f); //4
            while ( imgLocation < frameRange.location ) {
                imgIndex++;
                if (imgIndex>=[articleImages count]) return; //quit if no images for this column
                nextImage = [articleImages objectAtIndex:imgIndex];
                imgLocation = nextImage.location;
            }
            
            NSUInteger lineIndex = 0;
            for (id lineObj in lines) { //5
                CTLineRef line = (__bridge CTLineRef)lineObj;
                
                for (id runObj in (NSArray *)CTLineGetGlyphRuns(line)) { //6
                    CTRunRef run = (__bridge CTRunRef)runObj;
                    CFRange runRange = CTRunGetStringRange(run);
                    
                    if ( runRange.location <= imgLocation && runRange.location+runRange.length > imgLocation ) { //7
                        CGRect runBounds;
                        CGFloat ascent;//height above the baseline
                        CGFloat descent;//height below the baseline
                        runBounds.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL); //8
                        runBounds.size.height = ascent + descent;
                        
                        CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL); //9
                        runBounds.origin.x = origins[lineIndex].x  + xOffset + frameXOffset;
                        runBounds.origin.y = origins[lineIndex].y + frameYOffset;
                        runBounds.origin.y -= descent;
                        
                        UIImage *img = [UIImage imageWithContentsOfFile: nextImage.imageFileName ];
                        CGPathRef pathRef = CTFrameGetPath(f); //10
                        CGRect colRect = CGPathGetBoundingBox(pathRef);
                        
                        CGRect imgBounds = CGRectOffset(runBounds, colRect.origin.x - frameXOffset , colRect.origin.y - frameYOffset);
                        [(i==0?paper.leftImageArray:paper.rightImageArray) addObject: //11
                         [NSArray arrayWithObjects:img, NSStringFromCGRect(imgBounds) , nil]
                         ];
                        //load the next image //12
                        imgIndex++;
                        if (imgIndex < [articleImages count]) {
                            nextImage = [articleImages objectAtIndex: imgIndex];
                            imgLocation = nextImage.location;
                        }
                        
                    }
                }
                lineIndex++;
            }

        }
    }
    
    
}

- (NSInteger)numOfArticle
{
    return self.articles.count;
}

- (NSInteger)numOfPaperWithArticleIndex:(NSInteger)articleIndex
{
    PMArticleModel * model = [self.articles objectAtIndex:articleIndex];
    return model.papers.count;
}

- (void)addImageToPaperWithArticleIndex:(NSInteger)articleIndex
{
    PMArticleModel * model = [self.articles objectAtIndex:articleIndex];
    [self addImageToPagperWithArticle:model];
    
}

- (PMArticlePaperModel*)paperWithPaperInde:(NSInteger)paperIndex articleIndex:(NSInteger)articleIndex
{
    PMArticleModel * model = [self.articles objectAtIndex:articleIndex];
    return model.papers[paperIndex];
}

@end
