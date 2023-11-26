//
//  LocationManager.swift
//  Urbaton
//
//  Created by Yaroslav Zagumennikov on 25.11.2023.
//

import Foundation
import SwiftUI
import CoreLocation
import MapKit
import Combine

class LocationManager: NSObject, ObservableObject, MKMapViewDelegate, CLLocationManagerDelegate {
    @Published var mapView: MKMapView = .init()
    
    var locationManager = CLLocationManager()
    @Published var userLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 51.78896, longitude: 55.12367)
    // Список точек, которые передаются на карту
    @Published var parkingPlaces: [RoutePoint] = []
    
    // Данные со страницы создания событий
    //--------------------------------------------------------------------///////////////////////////////////////////////////////////////
    @Published var nameEvent: String = ""
    @Published var descriptionEvent: String = ""
    @Published var searchText: String = ""
    
    @Published var latitude: Double = 0
    @Published var longtitude: Double = 0
    
    @Published var images:[UIImage?] = []
    @Published var imagesName:[String] = []
    
    @Published var eventImages: [String : UIImage] = [:]
    @Published var downloadImage: Bool = false
    
    @Published var maxCountPlaces: Int = 0
    @Published var selectedDate: Date = Date()

    //--------------------------------------------------------------------///////////////////////////////////////////////////////////////
    //--------------------------------------------------------------------///////////////////////////////////////////////////////////////
    var cancellable: AnyCancellable?
    @Published var fetchedPlaces: [CLPlacemark]?
        
    @Published var pickedLocation: CLLocation?
    @Published var pickedPlaceMark: CLPlacemark?
    
    @Published var eventAddress: [String : CLPlacemark] = [:]
    
    @Published var userCity: String = ""

    // Имитация запроса на поиск маршрута
    @Published var youtubeShorts = false
    
    //-------------------------------------------------------------
    //перенос с locationViewModel
    @Published var locations : [CreateEventResponse] = [
        CreateEventResponse(
            id: "12",
            name: "Парковка",
            cityName: "Оренбург",
            location: locationRequest(latitude: 51.79225, longitude: 55.12378),
            description: "",
            date: "",
            maxCountPlaces: 10,
            currentCountPlaces: 5,
            images: ["Parking2"]
        ),
        CreateEventResponse(
            id: "13",
            name: "Автостоянка",
            cityName: "Оренбург",
            location: locationRequest(latitude: 51.78826, longitude: 55.12811),
            description: "",
            date: "",
            maxCountPlaces: 10,
            currentCountPlaces: 5,
            images: ["Parking2"]
        )
    ]
    @Published var mapLocation : CreateEventResponse {
        didSet{
            updateLocation(location: CLLocationCoordinate2D(latitude: mapLocation.location.latitude , longitude: mapLocation.location.longitude) )
        }
    }
    @Published var mapRegion = MKCoordinateRegion()
    
    // Показ списка локаций
    @Published var showLocations = false
    
    @Published var planet: Bool = false

    
    
    // Список точек, которые передаются на карту
    @Published var zakazGeo: [RoutePoint] = [
        RoutePoint(coordinate:
                    CLLocationCoordinate2D(
                        latitude: 51.79225,
                        longitude: 55.12811), name: "Парковка"),
        RoutePoint(coordinate:
                    CLLocationCoordinate2D(
                        latitude: 51.78826,
                        longitude: 55.12811), name: "Автостоянка"),
    ]
    
    // Список кэшированных маршрутов, для разгрузки приложения
    private var routeCache = [String: MKRoute]()
    
    
    func addRoute(from pointStart: CreateEventResponse, to point: CreateEventResponse, on mapView: MKMapView) {
        let startPoint = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: pointStart.location.latitude, longitude: pointStart.location.longitude) )
        
        // Святая корова
        let endPoint = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: point.location.latitude, longitude: point.location.longitude))
        
        let key = "\(userLocation.latitude),\(userLocation.longitude)-\(point.location.latitude),\(point.location.longitude)"
        
        if let route = routeCache[key] {
            mapView.addOverlay(route.polyline)
        } else {
            
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: startPoint)
            request.destination = MKMapItem(placemark: endPoint)
            request.transportType = .automobile
            
            let directions = MKDirections(request: request)
            directions.calculate { response, error in
                guard let route = response?.routes.first else {
                    if let error = error {
                        print("Error calculating directions: \(error.localizedDescription)")
                    }
                    return
                }
                
                mapView.addOverlay(route.polyline)
                self.routeCache[key] = route
            }
        }
    }
    
    // Функция для поиска короткого маршрута от точки до точки
    func findShortRoute ( points: [CreateEventResponse] , to point: CreateEventResponse, on mapView: MKMapView) {
        var routesCache = [CreateEventResponse : Double]()

        var pointsO = points
        pointsO.insert(
            CreateEventResponse(
                id: "",
                name: "",
                cityName: "",
                location: locationRequest(latitude: userLocation.latitude, longitude: userLocation.longitude),
                description: "",
                date: "",
                maxCountPlaces: 10,
                currentCountPlaces: 5,
                images: [""]), at: 0)
        pointsO.removeAll{ $0 == point }
        
        // Итерируемся по всем точкам и вычисляем расстояние до нужной точки
        for p in pointsO {
            let loc1 = CLLocation(latitude: point.location.latitude, longitude: point.location.longitude)
            
            let distance = loc1.distance(from: CLLocation(latitude: p.location.latitude, longitude: p.location.longitude))
            
            routesCache[p] = distance
        }
        
        addRoute(from: pointsO[0], to: point, on: mapView)

    }

    
    
    
    
    
    
    
    private func updateLocation (location: CLLocationCoordinate2D){
        mapRegion = MKCoordinateRegion(
            center: location,
            span: MKCoordinateSpan(
                latitudeDelta: 0.1,
                longitudeDelta: 0.1
            )
        )
    }
    
    // Показывать/скрывать список локаций
    func showLocationsList(){
        withAnimation(.easeInOut) {
            showLocations.toggle()
        }
    }
    
    
    // Переключаться на другую локацию
    func nextLocations (location : CreateEventResponse){
        withAnimation(.easeInOut) {
            mapLocation = location
            showLocations = false
        }
    }
    
    // Нажатие на кнопку далее у превью локации
    func nextButtonClicked(location : CreateEventResponse) {
        // Получить текущий индекс выбранной локации
        guard let currentIndex = locations.firstIndex(where: { $0.id == location.id}) else{
            print("Невозможно найти текущий индекс локации")
            return
        }
        let nextIndex = currentIndex + 1
        
        guard locations.indices.contains(nextIndex) else {
            guard let firstLocation = locations.first else { return }
            nextLocations(location: firstLocation)
            return
        }
        let nextLocation = locations[nextIndex]
        nextLocations(location: nextLocation)
    }
    //-------------------------------------------------------------

    override init () {
        mapLocation =
            CreateEventResponse(
                id: "12",
                name: "Парковка",
                cityName: "Orenburg",
                location: locationRequest(latitude: 51.8180255, longitude: 55.1355361),
                description: "",
                date: "",
                maxCountPlaces: 10,
                currentCountPlaces: 5,
                images: [""]
            )
        
        super.init()

        mapView.delegate = self

        updateLocation(location: CLLocationCoordinate2D(latitude: mapLocation.location.latitude, longitude: mapLocation.location.longitude))

        
        cancellable = $searchText
            .debounce(for: .seconds(0.5) , scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink(receiveValue: { [weak self] value in
                if value != "" {
                    self?.fetchPlaces(value: value)
                }else {
                    self?.fetchedPlaces = nil
                }
            })
    }
    
    func fetchPlaces(value: String) {
        Task{
            do {
                let request = MKLocalSearch.Request()
                request.naturalLanguageQuery = value.lowercased()
                
                let response = try await MKLocalSearch(request: request).start()
                
                await MainActor.run {
                    self.fetchedPlaces = response.mapItems.compactMap({ item -> CLPlacemark? in
                        return item.placemark
                    })
                }
            }catch {
                
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.mapLocation = CreateEventResponse(
                id: "",
                name: "",
                cityName: "",
                location: locationRequest(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude),
                description: "",
                date: "",
                maxCountPlaces: 10,
                currentCountPlaces: 5,
                images: [""]
            )
            if locationManager.authorizationStatus == .authorizedWhenInUse {
                self.userLocation = location.coordinate
            }
        }
    
    }
    
    
    func convertToEnglish(_ string: String) -> String {
        let locale = Locale(identifier: "en_US")
        guard let englishString = string.applyingTransform(.toLatin, reverse: false)?.applyingTransform(.stripDiacritics, reverse: false) else {
            return string
        }
        return englishString.capitalized(with: locale)
    }

    func showCityParkings () {
        
//        WebService().getParkingsCity(lat: "", long: "", range: 0) { [weak self] result in
//            switch result{
//                case .success(let eventsInfo):
//                    DispatchQueue.main.async {
//                        self?.locations = eventsInfo
//                        if eventsInfo.isEmpty { print("Не было получено никаких парковок от сервера по этому городу") }
//                        else {
//                            self?.mapLocation = eventsInfo.first ??
//                                CreateEventResponse(
//                                    id: "",
//                                    name: "",
//                                    cityName: "",
//                                    location: locationRequest(
//                                        latitude: LocationsDataService.locations.first!.coordinates.latitude,
//                                        longitude: LocationsDataService.locations.first!.coordinates.longitude
//                                    ),
//                                    description: "",
//                                    date: "",
//                                    maxCountPlaces: 0,
//                                    currentCountPlaces: 0,
//                                    images: [""]
//                                )
//                            self?.updateLocation(location: eventsInfo.first ??
//                                 GetParkingsResponse(data: [
//                                    Datum(idParking: <#T##Int?#>, lat: <#T##String?#>, long: <#T##String?#>, location: <#T##String?#>, hasCam: <#T##Bool?#>, idType: <#T##Int?#>, idOwner: <#T##Int?#>, type: <#T##String?#>, spots: <#T##String?#>)
//                                 ], error: "")
//                            )
//                        }
//                        
//                    }
//                    
//                case .failure(let error):
//                    print("Ошибка c получением событий по городу")
//                    print(error)
//                    print(error.localizedDescription)
//            }
//        }
    }
    
    
    // Запись на событие
    func recordOnEvent (
        eventId: String
    ) {
//        WebService().recordingEvent(Authorization: UserViewModel().tokensAuthorization.first!.accessToken!, eventId: eventId ) { result in
//            switch result {
//            case .success(let success):
//                print(success)
//                if let index = self.locations.firstIndex(where: { $0.id == eventId }) {
//                    self.locations[index].currentCountPlaces += 1
//                }
//            case .failure(let failure):
//                print(failure)
//            }
//        }
    }
    
    func addEventCity(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy" // формат даты
//        let dateString = dateFormatter.string(from: selectedDate) // преобразование в строку
        
//        WebService().createEvent(
//                accessToken: UserViewModel().tokensAuthorization.first!.accessToken!,
//                name: nameEvent,
//                cityName: userCity,
//                location: locationRequest(latitude: latitude, longitude: longtitude),
//                description: descriptionEvent,
//                maxCountPlaces: maxCountPlaces,
//                date: dateString
//        ) { [weak self] result in
//            switch result{
//                case .success(let eventInfo):
//                    if self?.images.count != 0 {
//                        self?.addPhoto(eventId: eventInfo.id, userToken: UserViewModel().tokensAuthorization.first!.accessToken!)
//                        DispatchQueue.main.async {
//                            // Опубликование значения из главного потока
//                            self?.locations.append(eventInfo)
//                        }
//                    }else {
//                        // Выполнение длительной операции в фоновом потоке
//                        DispatchQueue.main.async {
//                            // Опубликование значения из главного потока
//                            self?.locations.append(eventInfo)
//                        }
//
//                    }
//                    
//                case .failure(let error):
//                    print("Ошибка c созданием события по городу")
//                    print(error)
//                    print(error.localizedDescription)
//            }
//        }
            
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()            
        }
    }
    
    // Функция проверки включения доступа определения местоположения
    func checkIFLocationServicesIsEnabled () {
        switch locationManager.authorizationStatus {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                
            case .restricted:
                print("Доступ к вашему местоположению был ограничен, возможно родительским контролем")
            case .denied:
                print("Доступ к вашему местоположению был отклонён")
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager.startUpdatingLocation()
            
            @unknown default:
                break
        }
    }
    
    func handleLocationError() {
         
    }
    
    func addDraggablePin(coordinate: CLLocationCoordinate2D){
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Парковка"
        
        mapView.addAnnotation(annotation)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let marker = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "DELIVERYPIN")
        marker.isDraggable = true
        marker.canShowCallout = false
        
        return marker
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        guard let newLocation = view.annotation?.coordinate else {return}
        self.pickedLocation = .init(latitude: newLocation.latitude, longitude: newLocation.longitude)
        updatePlacemark(location: .init(latitude: newLocation.latitude, longitude: newLocation.longitude))
    }
    
    func updatePlacemark(location: CLLocation) {
        Task {
            do {
                guard let place = try await reverseLocationCoordinates(location: location) else {return}
                await MainActor.run {
                    self.pickedPlaceMark = place
                }
            } catch {
                
            }
        }
    }
    
    func searchAddres (location: CreateEventResponse){
        Task {
            do {
                guard let place = try await reverseLocationCoordinates(location: CLLocation(latitude: location.location.latitude, longitude: location.location.longitude)) else {return}
                await MainActor.run {
                    self.eventAddress[location.id] = place
                }
            } catch {
                
            }
        }
    }
    
    func reverseLocationCoordinates (location: CLLocation) async throws -> CLPlacemark? {
        let place = try await CLGeocoder().reverseGeocodeLocation(location).first
        return place
    }
}
extension Date {
    func toUTC() -> Date {
        let timeZoneOffset = TimeInterval(TimeZone.current.secondsFromGMT())
        return self.addingTimeInterval(timeZoneOffset)
    }
}
