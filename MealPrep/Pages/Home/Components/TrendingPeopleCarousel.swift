import SwiftUI

struct TrendingPeopleCarousel: View {
    let bloggers: [Blogger]
    @State private var showTrendingPeople = false
    @State private var selectedBlogger: Blogger? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            
            HStack {
                Text("Trending Food Bloggers")
                    .font(Theme.Typography.heading)
                    .foregroundStyle(Theme.Colors.textPrimary)
                
                Spacer()
                
                Button("See all →") {
                    showTrendingPeople = true
                }
                .font(Theme.Typography.body)
                .foregroundStyle(Theme.Colors.primary)
            }
            .padding(.horizontal, Theme.Spacing.md)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Theme.Spacing.lg) {
                    ForEach(bloggers) { blogger in
                        BloggerCard(blogger: blogger)
                            .onTapGesture {
                                selectedBlogger = blogger
                            }
                    }
                }
                .padding(.horizontal, Theme.Spacing.md)
            }
        }
        .navigationDestination(isPresented: $showTrendingPeople) {
            TrendingPeoplePage()
        }
        .navigationDestination(item: $selectedBlogger) { blogger in
            BloggerProfileView(blogger: blogger)
        }
    }
}

#Preview {
    NavigationStack {
        TrendingPeopleCarousel(bloggers: BloggerMockData.bloggers)
            .padding(.vertical)
    }
}
