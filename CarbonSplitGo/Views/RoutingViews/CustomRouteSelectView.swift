import SwiftUI

struct CustomRouteSelectView: View {
    @Binding var selectedRouteIndex: Int?
    let selectedRouteDistance: Double?
    let selectedRouteTravelTime: Double?
    let selectedRouteHasTolls: Bool?
    let selectedRouteCo2Emissions: Double?
    let onSelectMainRoute: () -> Void
    let onSelectAlternateRoute: () -> Void

    var body: some View {
        VStack(spacing: -10) {
            HStack(spacing: 0) {
                Button("Quickest") {
                    selectedRouteIndex = 0
                    onSelectMainRoute()
                }
                .frame(width: 100)
                .padding()
                .background(selectedRouteIndex == 0 ? AppColours.customDarkGrey : AppColours.customLightGrey)
                .foregroundColor(selectedRouteIndex == 0 ? AppColours.customWhite : AppColours.customDarkGrey)

                Button("Extra") {
                    selectedRouteIndex = 1
                    onSelectAlternateRoute()
                }
                .frame(width: 100)
                .padding()
                .background(selectedRouteIndex == 1 ? AppColours.customMediumGreen : AppColours.customLightGrey)
                .foregroundColor(selectedRouteIndex == 1 ? AppColours.customWhite : AppColours.customDarkGrey)
            }
            .cornerRadius(30)

            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(AppColours.customDarkGrey, lineWidth: 1)
                        .fill(AppColours.customLightGrey .opacity(0.7))
                        .frame(maxWidth: .infinity)
                    Grid(alignment: .leading, horizontalSpacing: 30, verticalSpacing: 10) {
                        GridRow {
                            RouteDetailRow(
                                icon: "location",
                                label: "Dist.",
                                value: "\(String(format: "%.2f", selectedRouteDistance ?? 0)) km."
                            )
                            RouteDetailRow(
                                icon: "clock",
                                label: "Time",
                                value: "~\(String(format: "%.0f", selectedRouteTravelTime ?? 0)) min."
                            )
                        }
                        GridRow {
                            RouteDetailRow(
                                icon: "car.fill",
                                label: "Tolls",
                                value: selectedRouteHasTolls == true ? "Yes" : "No"
                            )
                            RouteDetailRow(
                                icon: "leaf.fill",
                                label: "CO₂",
                                value: "\(String(format: "%.2f", selectedRouteCo2Emissions ?? 0)) kg."
                            )
                        }
                    }
                    .padding(15)
                }
                .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.vertical, 20)

            Spacer()
        }
        .padding()
    }
}


//not bothered creating another file for this
struct RouteDetailRow: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        HStack() {
            Image(systemName: icon)
                .foregroundColor(AppColours.customBlack)
                .font(.custom("Sen", size: 18))
                .frame(width: 25, height: 25)
            
            Text(label + ":")
                .foregroundColor(AppColours.customDarkGrey)
                .font(.custom("Sen", size: 15))

            Text(value)
                .foregroundColor(AppColours.customDarkGreen)
                .font(.custom("Sen", size: 17))
        }
    }
}

