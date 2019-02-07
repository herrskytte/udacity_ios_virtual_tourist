//  Created by Frederik Skytte

import Foundation

class FlickrClient {

    static let apiKey = "ddf4743c704765a5d4a2c41543c19c65"
    
    enum Endpoints {

        case getPhotos(Double, Double, Int)
        case getPhotoData(PhotoDetails)
        
        var stringValue: String {
            switch self {
                
            case .getPhotos(let lat, let lon, let page): return
                "https://api.flickr.com/services/rest/?api_key=\(FlickrClient.apiKey)" +
                "&method=flickr.photos.search&lat=\(lat)&lon=\(lon)&per_page=12&page=\(page)&format=json&nojsoncallback=1"
                
            case .getPhotoData(let photo): return
                "https://farm\(photo.farm).staticflickr.com/\(photo.server)/\(photo.id)_\(photo.secret)_m.jpg"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func getPhotoList(lat:Double, lon:Double, page:Int, completion: @escaping (PhotosSearchDetails?, String?) -> Void) {
        taskForGETRequest(url: Endpoints.getPhotos(lat, lon, page).url, responseType: PhotosSearchResult.self) { (responseObject, error) in
            guard let responseObject = responseObject else {
                completion(nil, error?.localizedDescription ?? "Error")
                return
            }
            if responseObject.stat == "ok" {
                completion(responseObject.photos, nil)
            }
            else {
                completion(nil, responseObject.message ?? "Failed to get photos")
            }
        }
    }
    
    class func getPhotoData(_ photo: PhotoDetails, completion: @escaping (Data?, Error?) -> Void) {
        
        let task = URLSession.shared.dataTask(with: Endpoints.getPhotoData(photo).url) {
            (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            DispatchQueue.main.async {
                completion(data, nil)
            }
        }
        task.resume()
    }
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void){
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            do {
                let responseObject = try JSONDecoder().decode(responseType, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            }
            catch {
                print("error: ", error)
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
}
