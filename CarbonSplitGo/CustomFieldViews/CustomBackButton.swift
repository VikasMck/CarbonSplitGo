import SwiftUI

struct CustomBackButton: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Button(action: {
            dismiss()
        }) {
            ZStack {
                Rectangle()
                    .fill(AppColours.customLightGrey.opacity(0.5))
                    .frame(width: 40, height: 40)
                    .cornerRadius(15)
                Image(systemName: "xmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(AppColours.customDarkGrey)
            }
        }
    }
}

#Preview {
    CustomBackButton()
}
