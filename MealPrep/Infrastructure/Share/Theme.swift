//
//  Theme.swift
//  MealPrep
//
//  Created by Enerel Tsolmonbayar on 8/5/2026.
//

import SwiftUI

struct Theme {

    // MARK: — Colors
    struct Colors {
        static let primary        = Color(hex: "#FE9900")   // orange
        static let primaryLight   = Color(hex: "#FFF3D6")
        static let tertiary       = Color(hex: "#8B104E")   // burgundy
        static let tertiaryLight  = Color(hex: "#FAE8F0")

        static let background     = Color(hex: "#FFFFFF")
        static let surface        = Color(hex: "#F8F6F2")
        static let divider        = Color(hex: "#EBEBEB")

        static let textPrimary    = Color(hex: "#1A1A1A")
        static let textSecondary  = Color(hex: "#6B6B6B")
        static let textTertiary   = Color(hex: "#B0B0B0")

        static let success        = Color(hex: "#2D9E6B")

        // Meal schedule block colors
        struct Meal {
            static let breakfast  = Color(hex: "#FE9900")
            static let lunch      = Color(hex: "#3B7DD8")
            static let dinner     = Color(hex: "#8B104E")
            static let snack      = Color(hex: "#2D9E6B")
        }
    }

    // MARK: — Typography
    struct Typography {
        static let hero     = Font.system(.largeTitle,  design: .rounded, weight: .bold)
        static let heading  = Font.system(.title2,      design: .default, weight: .semibold)
        static let subhead  = Font.system(.headline,    design: .default, weight: .medium)
        static let body     = Font.system(.body,        design: .default, weight: .regular)
        static let caption  = Font.system(.caption,     design: .default, weight: .regular)
        static let micro    = Font.system(.caption2,    design: .default, weight: .regular)
    }

    // MARK: — Spacing
    struct Spacing {
        static let xs:  CGFloat = 4
        static let sm:  CGFloat = 8
        static let md:  CGFloat = 16
        static let lg:  CGFloat = 24
        static let xl:  CGFloat = 32
        static let xxl: CGFloat = 48
    }

    // MARK: — Corner Radius
    struct Radius {
        static let sm:  CGFloat = 6
        static let md:  CGFloat = 12
        static let lg:  CGFloat = 16
        static let pill: CGFloat = 999
    }

    // MARK: — Icon Sizes
    struct IconSize {
        static let sm:  CGFloat = 16
        static let md:  CGFloat = 22
        static let lg:  CGFloat = 28
    }
}
