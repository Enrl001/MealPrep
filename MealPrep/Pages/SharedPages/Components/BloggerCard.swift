//
//  BloggerCard.swift
//  
//
//  Created by Enerel Tsolmonbayar on 8/5/2026.
//

import SwiftUI

struct BloggerCard: View {
    let blogger: Blogger
    
    var body: some View {
        VStack(spacing: Theme.Spacing.xs) {
            
            AsyncImage(url: URL(string: blogger.imageURL)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Circle()
                    .fill(Theme.Colors.surface)
                    .overlay {
                        Image(systemName: "person.fill")
                            .foregroundStyle(Theme.Colors.textTertiary)
                            .font(.system(size: 24))
                    }
            }
            .frame(width: 64, height: 64)
            .clipShape(Circle())
            .overlay {
                Circle()
                    .stroke(Theme.Colors.divider, lineWidth: 1)
            }
            
            Text(blogger.name)
                .font(Theme.Typography.micro)
                .foregroundStyle(Theme.Colors.textPrimary)
                .lineLimit(1)
        }
        .frame(width: 70)
    }
}

#Preview {
    BloggerCard(blogger: BloggerMockData.bloggers[0])
}
