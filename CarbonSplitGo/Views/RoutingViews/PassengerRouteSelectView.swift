import SwiftUI
import CoreLocation

struct PassengerRouteSelectView: View {
    @StateObject private var socialViewModel = SocialViewModel()
    @StateObject private var routeGroupViewModel = RouteGroupViewModel()

    @State private var selectedDate: Date? = nil
    @State private var isCalenderShown = false
    @State private var groups: [String] = []
    @State private var selectedGroup = ""
    @State private var drivers: [(groupName: String, routeDay: String, userName: String)] = []

    var coordinates: CLLocationCoordinate2D

    //variables to control the screen popup
    @State private var screenOffset: CGFloat = UIScreen.main.bounds.height * 0.95
    @GestureState private var dragOffset: CGFloat = 0


    var body: some View {
        //geometryreader is magical, gives me pain
        GeometryReader { geometry in
            VStack(spacing: 16) {
                //classic apple capsule to show what is scrollable
                Capsule()
                    .frame(width: 100, height: 4)
                    .foregroundColor(.gray)
                    .padding(.top, 4)

                
                Button(action: {
                    isCalenderShown.toggle()
                }) {
                    HStack {
                        CustomTextField(
                            placeholder: selectedDate.map { DateFormat.dateFormatDayAndTime($0) } ?? "When?",
                            text: .constant("")
                        )

                    }
                    .padding(.horizontal, 20)
                }
                .sheet(isPresented: $isCalenderShown) {
                    VStack {
                        DatePicker(
                            "",
                            selection: Binding(
                                get: { selectedDate ?? Date() },
                                set: { selectedDate = $0 }
                            ),
                            displayedComponents: [.date, .hourAndMinute]
                        )
                        .onAppear {
                            if selectedDate == nil {
                                selectedDate = Date()
                            }
                        }
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .accentColor(AppColours.customDarkGreen)
                        .presentationDetents([.fraction(0.5)])
                        .scaleEffect(0.8)

                        Button("Confirm") {
                            isCalenderShown = false
                        }
                        .padding(.top, -30)
                        .foregroundColor(AppColours.customDarkGreen)
                    }
                }

                //cant reuse my customtextfield for a menu :(
                Menu {
                    ForEach(groups, id: \.self) { group in
                        Button(group) {
                            selectedGroup = group
                        }
                    }
                }label: {
                    HStack {
                        Text("Which Group? \(selectedGroup)")
                            .font(.custom("Sen", size: 17))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.leading, 20)
                            .foregroundColor(AppColours.customMediumGreen)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(AppColours.customMediumGreen)
                    }
                    .padding()
                    .background(Color(.white).opacity(0.9))
                    .cornerRadius(30)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color(AppColours.customLightGrey), lineWidth: 1)
                    )
                }
                .padding(.horizontal, 20)
                .task {
                    groups = await socialViewModel.fetchGroups()
                }

                
                Button(action: {
                    Task{
                        await routeGroupViewModel.insertPlannedRoute(
                            groupName: selectedGroup,
                            longitude: coordinates.longitude,
                            latitude: coordinates.latitude,
                            routeDate: String(DateFormat.dateFormatDayAndTime(selectedDate!))
                        )
                        drivers = await routeGroupViewModel.fetchUserInfoFromRouteGroup(groupName: selectedGroup, userRole: "Driver", routeDay: DateFormat.dateFormatDayWildcard(selectedDate!)) ?? []
                    }

                }) {
                    Text("Search for Drivers")
                        .foregroundColor(.white)
                        .frame(maxWidth: 300)
                        .padding()
                        .background(AppColours.customMediumGreen)
                        .cornerRadius(30)
                }

                ScrollView {
                    if drivers.isEmpty {
                        Text("Search for drivers to request a trip")
                    }
                    else{
                        ForEach(drivers.indices, id: \.self) { index in
                            let driver = drivers[index]
                            
                            CustomDriverSelectionView(userName: driver.userName, groupName: driver.groupName, routeDay: driver.routeDay)
                        }
                    }
                }
            }
            .padding()
            //magic part so it covers 50% of the screen
            .frame(width: geometry.size.width, height: geometry.size.height / 2)
            .background(.white)
            .cornerRadius(30)
            .shadow(radius: 10)
            .offset(y: min(max(screenOffset + dragOffset, geometry.size.height * 0.5), geometry.size.height * 0.93))
            .gesture(
                DragGesture()
                    .updating($dragOffset) { value, state, _ in
                        state = value.translation.height
                    }
                    .onEnded { value in
                        //how easy to open it
                        let openThreshold = geometry.size.height / 8
                        withAnimation {
                            //how much of it seen when closed
                            if value.translation.height > openThreshold {
                                screenOffset = geometry.size.height * 0.95
                            }
                            //when open
                            else if value.translation.height < -openThreshold {
                                screenOffset = geometry.size.height * 0.5
                            }
                            else {
                                screenOffset = screenOffset + dragOffset < (geometry.size.height * 0.7) ? geometry.size.height * 0.5 : geometry.size.height * 0.93
                            }
                        }
                    }
            )
        }
        .edgesIgnoringSafeArea(.bottom)
        .onAppear {
            screenOffset = UIScreen.main.bounds.height * 0.95
        }
    }
   
}
