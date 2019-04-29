//
//  GraduationMacro.h
//  GraduationView
//
//  Created by Sword on 11/9/16.
//  Copyright © 2016 sword. All rights reserved.
//

#ifndef GraduationMacro_h
#define GraduationMacro_h

#define SDF_RGBALL(r,g,b,a)   [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define SDF_RGBA(color, a)    SDF_RGBALL( ((color)>>16) & 0xFF, ((color)>>8) & 0xFF, (color) & 0xFF, a )
#define SDF_RGB(color)        SDF_RGBA( color, 1.0f)

#define DEEP_COLOR SDF_RGB(0xFF6208)
#define LIGHT_COLOR SDF_RGB(0xE1E8EC)

#endif /* GraduationMacro_h */
