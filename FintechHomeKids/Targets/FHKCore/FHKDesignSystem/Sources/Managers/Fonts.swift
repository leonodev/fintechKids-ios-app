//
//  Fonts.swift
//  FHKDesignSystem
//
//  Created by Fredy Leon on 22/11/25.
//

import SwiftUI

// Minimalist
public extension Font {
    
    struct Minimalist {
        
        @MainActor
        static func simpleRegular(_ size: CGFloat = FHKSize.size16) -> Font {
            FontManager.registerFontsIfNeeded()
            return Font.custom("SimpleMinimalistRegular", fixedSize: size)
        }
        
        @MainActor
        static func simpleBold(_ size: CGFloat = FHKSize.size16) -> Font {
            FontManager.registerFontsIfNeeded()
            return Font.custom("SimpleMinimalistRegular", fixedSize: size).weight(.bold)
        }
    }
}


// PangramSans
public extension Font {
    
    
    struct PangramSans {
        
        public struct Narrow {
            
            @MainActor
            public static func extraboldItalic(_ size: CGFloat = FHKSize.size16) -> Font {
                FontManager.registerFontsIfNeeded()
                return Font.custom("PPPangramSansRounded-NarrowExtraboldItalic", fixedSize: size)
            }
            
            @MainActor
            public static func extralightReclined(_ size: CGFloat = FHKSize.size16) -> Font {
                FontManager.registerFontsIfNeeded()
                return Font.custom("PPPangramSansRounded-NarrowExtralightReclined", fixedSize: size)
            }
            
            @MainActor
            public static func semiboldItalic(_ size: CGFloat = FHKSize.size16) -> Font {
                FontManager.registerFontsIfNeeded()
                return Font.custom("PPPangramSansRounded-NarrowSemiboldItalic", fixedSize: size)
            }
            
            @MainActor
            public static func semibold(_ size: CGFloat = FHKSize.size16) -> Font {
                FontManager.registerFontsIfNeeded()
                return Font.custom("PPPangramSansRounded-NarrowSemibold", fixedSize: size)
            }
        }
        
        public struct Condensed {
            
            @MainActor
            public static func thin(_ size: CGFloat = FHKSize.size16) -> Font {
                FontManager.registerFontsIfNeeded()
                return Font.custom("PPPangramSansRounded-CondensedThin", fixedSize: size)
            }
        }
        
        public struct Compact {
            
            @MainActor
            public static func regular(_ size: CGFloat = FHKSize.size16) -> Font {
                FontManager.registerFontsIfNeeded()
                return Font.custom("PPPangramSansRounded-CompactRegular", fixedSize: size)
            }
            
            @MainActor
            public static func extralightReclined(_ size: CGFloat = FHKSize.size16) -> Font {
                FontManager.registerFontsIfNeeded()
                return Font.custom("PPPangramSansRounded-CompactExtralightReclined", fixedSize: size)
            }
            
            @MainActor
            public static func thinItalic(_ size: CGFloat = FHKSize.size16) -> Font {
                FontManager.registerFontsIfNeeded()
                return Font.custom("PPPangramSansRounded-CompactThinItalic", fixedSize: size)
            }
        }
        
        public struct Compressed {
            
            @MainActor
            public static func mediumReclined(_ size: CGFloat = FHKSize.size16) -> Font {
                FontManager.registerFontsIfNeeded()
                return Font.custom("PPPangramSansRounded-CompressedMediumReclined", fixedSize: size)
            }
            
            @MainActor
            public static func extrabold(_ size: CGFloat = FHKSize.size16) -> Font {
                FontManager.registerFontsIfNeeded()
                return Font.custom("PPPangramSansRounded-CompressedExtrabold", fixedSize: size)
            }
        }
        
        @MainActor
        public static func medium(_ size: CGFloat = FHKSize.size16) -> Font {
            FontManager.registerFontsIfNeeded()
            return Font.custom("PPPangramSansRounded-Medium", fixedSize: size)
        }

        @MainActor
        public static func slimSemiboldItalic(_ size: CGFloat = FHKSize.size16) -> Font {
            FontManager.registerFontsIfNeeded()
            return Font.custom("PPPangramSansRounded-SlimSemiboldItalic", fixedSize: size)
        }

        @MainActor
        public static func light(_ size: CGFloat = FHKSize.size16) -> Font {
            FontManager.registerFontsIfNeeded()
            return Font.custom("PPPangramSansRounded-Light", fixedSize: size)
        }
        
        @MainActor
        public static func bold(_ size: CGFloat = FHKSize.size16) -> Font {
            FontManager.registerFontsIfNeeded()
            return Font.custom("PPPangramSansRounded-Bold", fixedSize: size)
        }
        
        @MainActor
        public static func extraboldItalic(_ size: CGFloat = FHKSize.size16) -> Font {
            FontManager.registerFontsIfNeeded()
            return Font.custom("PPPangramSansRounded-ExtraboldItalic", fixedSize: size)
        }
        
        @MainActor
        public static func slimExtralight(_ size: CGFloat = FHKSize.size16) -> Font {
            FontManager.registerFontsIfNeeded()
            return Font.custom("PPPangramSansRounded-SlimExtralight", fixedSize: size)
        }
        
        @MainActor
        public static func semibold(_ size: CGFloat = FHKSize.size16) -> Font {
            FontManager.registerFontsIfNeeded()
            return Font.custom("PPPangramSansRounded-Semibold", fixedSize: size)
        }

        @MainActor
        public static func thin(_ size: CGFloat = FHKSize.size16) -> Font {
            FontManager.registerFontsIfNeeded()
            return Font.custom("PPPangramSansRounded-Thin", fixedSize: size)
        }
        
        @MainActor
        public static func slimMediumReclined(_ size: CGFloat = FHKSize.size16) -> Font {
            FontManager.registerFontsIfNeeded()
            return Font.custom("PPPangramSansRounded-SlimMediumReclined", fixedSize: size)
        }
    }
}

