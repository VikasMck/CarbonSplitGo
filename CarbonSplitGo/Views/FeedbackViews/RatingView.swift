import SwiftUI

struct RatingView: View {
    @Binding var rating: Double

    var body: some View {
        HStack(spacing: 5) {
            ForEach(1...5, id: \.self) { index in
                Image(systemName: ratingIcon(for: Double(index)))
                    .foregroundColor(AppColours.customMediumGreen)
                    .onTapGesture {
                        if rating == Double(index) {
                            rating = Double(index) - 0.5
                        } else {
                            rating = Double(index)
                        }
                    }
            }
        }
    }
    
    private func ratingIcon(for index: Double) -> String {
        if index <= rating {
            return "rectangle.fill"
        } else if index - 0.5 == rating {
            return "rectangle.lefthalf.filled"
        } else {
            return "rectangle"
        }
    }
}
