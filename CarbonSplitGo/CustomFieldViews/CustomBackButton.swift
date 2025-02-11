import SwiftUI

struct CustomBackButton: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Button(action: {
            dismiss()
        }) {
            Image(systemName: "xmark")
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundColor(AppColours.customDarkGrey)
        }
    }
}
#Preview {
    CustomBackButton()
}
