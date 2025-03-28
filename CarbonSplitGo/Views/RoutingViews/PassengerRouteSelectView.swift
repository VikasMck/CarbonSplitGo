import SwiftUI
import CoreLocation

struct PassengerRouteSelectView: View {
    @StateObject private var socialViewModel = SocialViewModel()
    @StateObject private var routeGroupViewModel = RouteGroupViewModel()

    @State private var selectedDate: Date? = nil
    @State private var isCalenderShown = false
    @State private var alertPublished = false
    @State private var groups: [String] = []
    @State private var distances: [Int] = [1, 3, 5, 10, 15, 20, 30, 50]
    @State private var selectedDistance = 1
    @State private var selectedGroup = ""
    @State private var drivers: [(userId: Int, groupName: String, routeDay: String, userName: String, feedbackRating: Double, feedbackRatingCount: Int)] = []

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

                Menu {
                    ForEach(groups, id: \.self) { group in
                        Button(group) {
                            selectedGroup = group
                        }
                    }
                }label: {
                    HStack {
                        Text("Group: \(selectedGroup)")
                            .font(.custom("Sen", size: 17))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.leading, 20)
                            .foregroundColor(AppColours.customMediumGreen)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(AppColours.customMediumGreen)
                    }
                    .padding()
                    .background(AppColours.customWhite.opacity(0.9))
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
                
                Menu {
                    ForEach(distances, id: \.self) { distance in
                        Button("\(distance)km") {
                            selectedDistance = distance
                        }
                    }
                }label: {
                    HStack {
                        Text("Area: \(selectedDistance)km")
                            .font(.custom("Sen", size: 17))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.leading, 20)
                            .foregroundColor(AppColours.customMediumGreen)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(AppColours.customMediumGreen)
                    }
                    .padding()
                    .background(AppColours.customWhite.opacity(0.9))
                    .cornerRadius(30)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color(AppColours.customLightGrey), lineWidth: 1)
                    )
                }
                .padding(.horizontal, 20)

                
                Button(action: {
                    Task{
                        await routeGroupViewModel.insertPlannedRoute(
                            groupName: selectedGroup,
                            longitude: coordinates.longitude,
                            latitude: coordinates.latitude,
                            routeDate: String(DateFormat.dateFormatDayAndTime(selectedDate!)),
                            whichDriverInvited: 0
                        )
                        drivers = await routeGroupViewModel.fetchUserInfoFromRouteGroup(groupName: selectedGroup, userRole: "Driver", routeDay: DateFormat.dateFormatDayWildcard(selectedDate!), longitude: coordinates.latitude, latitude: coordinates.longitude, maxDistance: selectedDistance * 1000) ?? []
                        
                        alertPublished = true
                    }

                }) {
                    Text("Search for Drivers")
                        .foregroundColor(AppColours.customWhite)
                        .frame(maxWidth: 300)
                        .padding()
                        .background(AppColours.customMediumGreen)
                        .cornerRadius(30)
                }.alert(isPresented: $alertPublished) {
                    Alert(title: Text("Published"), message: Text("Your route has been advertised"), dismissButton: .default(Text("OK")))
                }

                ScrollView {
                    if drivers.isEmpty {
                        Text("No drivers found with current filters")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .foregroundColor(AppColours.customBlack)
                            .padding()
                    }
                    else{
                        ForEach(drivers.indices, id: \.self) { index in
                            let driver = drivers[index]
                            
                            CustomDriverSelectionView(userId: driver.userId, userName: driver.userName, groupName: driver.groupName, routeDay: driver.routeDay, feedbackRating: driver.feedbackRating, feedbackRatingCount: driver.feedbackRatingCount)
                        }
                        .padding(10)
                    }
                }
            }
            .padding()
            //magic part so it covers 50% of the screen
            .frame(width: geometry.size.width, height: geometry.size.height / 2)
            .background(AppColours.customWhite)
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
