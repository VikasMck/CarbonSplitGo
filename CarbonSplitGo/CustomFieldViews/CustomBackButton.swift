import SwiftUI

struct CustomBackButton: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Button(action: {
            dismiss()
        }) {
            ZStack {
                Circle()
                    .fill(AppColours.customLightGrey.opacity(0.5))
                    .frame(width: 40, height: 40)
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
