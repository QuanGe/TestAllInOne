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
@interface PMBookDetailViewModel ()
@property (nonatomic,readwrite,copy) NSString * bookLocalUrl;
@property (nonatomic,readwrite,strong) NSMutableArray * articles;
@end

@implementation PMBookDetailViewModel

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

- (instancetype)initWithBookLocalUrl:(NSString*)bookLocalUrl
{
    self = [super init];
    if (self) {
        self.bookLocalUrl = bookLocalUrl;
        [self fetchArticleList];
    }
    return self;
}

- (void)fetchArticleList
{
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
                                theImage.cickImageFileName = [NSString stringWithUTF8String:ArticleContentStr->FirstChildElement("me:imageDetail")->Attribute("url")];
                        }
                        else if(strcmp(ArticleContentStr->Attribute("type"), "link") == 0)
                        {
                            theImage.type = PMArticleImageTypeContentCodeLink;
                            theImage.cickImageFileName = [NSString stringWithUTF8String:ArticleContentStr->Attribute("url")];
                        }
                        theImage.imageFileName = [NSString stringWithUTF8String:ArticleContentStr->Attribute("imageUrl")];
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
                        
                        CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, &imgAttr); //3
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
                    staticImage.imageFileName = [NSString stringWithUTF8String:ArticleStaticImageEle->Attribute("imgPortrait")];
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
                        staticImage.imageFileName = [NSString stringWithUTF8String:ArticleStaticImageEle->Attribute("imageUrl")];
                        a.staticImage = staticImage;
                    }
                    else if(strcmp(type, "video") == 0)
                    {
                        PMArticleImageModel * staticImage = [[PMArticleImageModel alloc] init];
                        staticImage.height = atof( ArticleStaticImageEle->Attribute("imageHeight"));
                        staticImage.type = PMArticleImageTypeContentVideo;
                        staticImage.colspan = 2;
                        staticImage.imageFileName = [NSString stringWithUTF8String:ArticleStaticImageEle->Attribute("imageUrl")];
                        staticImage.cickImageFileName = [NSString stringWithUTF8String:ArticleStaticImageEle->Attribute("url")];
                        staticImage.imageCaption = [NSString stringWithUTF8String:ArticleStaticImageEle->Attribute("caption")];
                        a.staticImage = staticImage;
                    }
                    
                }
                
            }
            
            [self.articles addObject:a];
            
        }
        keyEle = keyEle->NextSiblingElement();
    }
    NSLog(@"%@",self.articles);
    
}

@end
