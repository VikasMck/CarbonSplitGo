import SwiftUI
import CoreLocation
import MapKit

struct DriverRouteSelectView: View {
    @StateObject private var socialViewModel = SocialViewModel()
    @StateObject private var routeGroupViewModel = RouteGroupViewModel()
    @EnvironmentObject var suggestionsViewModel: SuggestionsViewModel
    @ObservedObject var routingViewModel: RoutingViewModel
    
    @Binding var annotations: [MKPointAnnotation]

    @State private var selectedDate: Date? = nil
    @State private var isCalenderShown = false
    @State private var groups: [String] = []
    @State private var selectedGroup = ""
    
    @State private var isAlertOn = false

    //variables to control the screen popup
    @State private var screenOffset: CGFloat = UIScreen.main.bounds.height * 0.95
    @GestureState private var dragOffset: CGFloat = 0

    //closure
    let newCoordinateForAnnotation: (CLLocationCoordinate2D) -> Void

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

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 50) {
                        ForEach(groups, id: \.self) { group in
                            Button {
                                Task {
                                    if let selectedDate = selectedDate {
                                        annotations.removeAll()
                                        await routeGroupViewModel.fetchAndSetLocation(for: group, userRole: "Passenger", routeDay: DateFormat.dateFormatDayWildcard(selectedDate), newCoordinateForAnnotation: newCoordinateForAnnotation
                                        )
                                        selectedGroup = group
                                    } else {
                                        isAlertOn = true
                                    }
                                }
                            } label: {
                                CustomSavedLocationEntryView(icon: "location.fill", text: group)
                            }
                            .alert("Info", isPresented: $isAlertOn) {
                                Button("Understood", role: .cancel) {}
                            } message: {
                                Text("Missing date, please select.")
                            }
                        }

                        NavigationLink(destination: SocialView()
                            .navigationBarBackButtonHidden(true)){
                            CustomSavedLocationEntryView(icon: "plus", text: "Add New")
                        }
                        .navigationBarHidden(true)
                    }
                    .padding(.horizontal, 10)
                }
                .task {
                    groups = await socialViewModel.fetchGroups()
                }
                
                Button(action: {
                    Task{
                        //saving drivers end location to reuse the insert. If I have time it will come in handy
                        await routeGroupViewModel.insertPlannedRoute(
                            groupName: selectedGroup,
                            longitude: routingViewModel.getCoordinatesFromAddress(for: suggestionsViewModel.locationForRouteList[suggestionsViewModel.locationForRouteCount - 1])!.longitude,
                            latitude: routingViewModel.getCoordinatesFromAddress(for: suggestionsViewModel.locationForRouteList[suggestionsViewModel.locationForRouteCount - 1])!.latitude,
                            routeDate: String(DateFormat.dateFormatDayAndTime(selectedDate!)),
                            whichDriverInvited: 0
                            
                        )
                    }
                }) {
                    Text("Advertise for Selected Group")
                        .foregroundColor(.white)
                        .frame(maxWidth: 300)
                        .padding()
                        .background(AppColours.customMediumGreen)
                        .cornerRadius(30)
                }
                NavigationLink(destination: TripInActionView(routingViewModel: routingViewModel)
                    .navigationBarBackButtonHidden(true)){
                        Text("Start the Trip")
                        .foregroundColor(AppColours.customMediumGreen)
                        .frame(maxWidth: 300)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color(AppColours.customLightGrey), lineWidth: 1)
                        )
                }
                Spacer()
            }
            .padding()
            .frame(width: geometry.size.width, height: geometry.size.height / 2)
            .background(.white)
            .cornerRadius(30)
            .shadow(radius: 10)
            .offset(y: min(max(screenOffset + dragOffset, geometry.size.height * 0.60), geometry.size.height * 0.93))
            .gesture(
                DragGesture()
                    .updating($dragOffset) { value, state, _ in
                        state = value.translation.height
                    }
                    .onEnded { value in
                        // how easy to open it
                        let openThreshold = geometry.size.height / 8
                        withAnimation {
                            if value.translation.height > openThreshold {
                                screenOffset = geometry.size.height * 0.93
                            } else if value.translation.height < -openThreshold {
                                screenOffset = geometry.size.height * 0.60
                            } else {
                                screenOffset = screenOffset + dragOffset < (geometry.size.height * 0.8) ? geometry.size.height * 0.60 : geometry.size.height * 0.93
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

