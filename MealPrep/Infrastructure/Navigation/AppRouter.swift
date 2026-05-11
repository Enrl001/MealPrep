import Combine
import Foundation

enum AppTab: Hashable {
    case potluck
    case grocery
    case home
    case schedule
    case profile
}

final class AppRouter: ObservableObject {
    @Published var selectedTab: AppTab = .home
    @Published var recipeToSchedule: Recipe?

    func startCooking(_ recipe: Recipe) {
        recipeToSchedule = recipe
        selectedTab = .schedule
    }

    func clearRecipeToSchedule() {
        recipeToSchedule = nil
    }
}
