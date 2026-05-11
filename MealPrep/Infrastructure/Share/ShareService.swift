//
//  ShareService.swift
//  
//
//  Created by Enerel Tsolmonbayar on 8/5/2026.
//

import UIKit
import SwiftUI

struct ShareService {
    
    static func shareRecipe(_ recipe: Recipe, sourceRect: CGRect = .zero) {
        let message = "Check out this recipe: \(recipe.name)"
        let url = URL(string: "mealprepapp://recipe/\(recipe.id)") ?? URL(string: "https://mealprep.app")!
        
        let activityVC = UIActivityViewController(
            activityItems: [message, url],
            applicationActivities: nil
        )
        
        present(activityVC, sourceRect: sourceRect)
    }
    
    static func shareBlogger(_ blogger: Blogger, sourceRect: CGRect = .zero) {
        let message = "Check out \(blogger.name) on MealPrep!"
        let url = URL(string: "mealprepapp://blogger/\(blogger.id)") ?? URL(string: "https://mealprep.app")!
        
        let activityVC = UIActivityViewController(
            activityItems: [message, url],
            applicationActivities: nil
        )
        
        present(activityVC, sourceRect: sourceRect)
    }
    
    private static func present(_ activityVC: UIActivityViewController, sourceRect: CGRect) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootVC = window.rootViewController else { return }
        
        var topVC = rootVC
        while let presented = topVC.presentedViewController {
            topVC = presented
        }
        
        if let popover = activityVC.popoverPresentationController {
            popover.sourceView = window
            popover.sourceRect = sourceRect == .zero
                ? CGRect(x: window.bounds.maxX - 60, y: 100, width: 0, height: 0)
                : sourceRect
            popover.permittedArrowDirections = .up
        }
        
        topVC.present(activityVC, animated: true)
    }
}
