//
//  FontDefine.h
//  Demo
//
//  Created by FengDongsheng on 15/5/28.
//  Copyright (c) 2015年 FengDongsheng. All rights reserved.
//

#ifndef Demo_FontDefine_h
#define Demo_FontDefine_h

#define ScreenWithRateFor6                          SCREEN_WIDTH/375.0

#define FontSystem(f)                               [UIFont systemFontOfSize:f]
#define FontBoldSystem(f)                           [UIFont boldSystemFontOfSize:f]

//Navigationbar 字体大小
#define Font_Navigationbar_Title                    FontBoldSystem(18.0f)

//Tabbar
#define Font_Tabbar_Title                           FontSystem(11.0f)

//文字大小
#define Font_Title                                  FontSystem(15.0f)
#define Font_SubTitle                               FontSystem(13.0f)
#define Font_Focus                                  FontSystem(12.0f)

//cell
#define Font_Cell_TextLabel                         FontSystem(16.0f)
#define Font_Cell_DetailTextLabel                   FontSystem(14.0f)
#define Font_Text_Label                             FontSystem(14.0f)

//还款页面
#define Repayment_Title                             FontSystem(15.0f)
#define Repayment_SubTitle                          FontSystem(13.0f)
#define Repayment_Money                             FontSystem(25.0f)
#define Repayment_BackTitle                         FontSystem(16.0f)

#endif
