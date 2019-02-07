//
// { "photos": { "page": 2, "pages": "18018", "perpage": 12, "total": "216210",
//"photo": [
//{ "id": "46177488294", "owner": "146429194@N05", "secret": "cc76a5644e", "server": "4914", "farm": 5, "title": "Oslo snowfall, january 2019", "ispublic": 1, "isfriend": 0, "isfamily": 0 },
//{ "id": "39937521573", "owner": "146429194@N05", "secret": "c2a64c0470", "server": "7900", "farm": 8, "title": "Oslo snowfall, january 2019", "ispublic": 1, "isfriend": 0, "isfamily": 0 },
//{ "id": "46896359821", "owner": "15711590@N00", "secret": "36cdc9bd0c", "server": "7860", "farm": 8, "title": "Snow day", "ispublic": 1, "isfriend": 0, "isfamily": 0 },
//{ "id": "46844295572", "owner": "15711590@N00", "secret": "4cf00ce9a4", "server": "4916", "farm": 5, "title": "", "ispublic": 1, "isfriend": 0, "isfamily": 0 },
//{ "id": "46844294182", "owner": "15711590@N00", "secret": "cf84237550", "server": "4869", "farm": 5, "title": "", "ispublic": 1, "isfriend": 0, "isfamily": 0 },
//{ "id": "31955039867", "owner": "15711590@N00", "secret": "7636c57a14", "server": "4904", "farm": 5, "title": "", "ispublic": 1, "isfriend": 0, "isfamily": 0 },
//{ "id": "45981666445", "owner": "15711590@N00", "secret": "dc47a90bfd", "server": "7841", "farm": 8, "title": "", "ispublic": 1, "isfriend": 0, "isfamily": 0 },
//{ "id": "46171443974", "owner": "15711590@N00", "secret": "1bfcb86ae5", "server": "4865", "farm": 5, "title": "Wait Until Spring, Bandini", "ispublic": 1, "isfriend": 0, "isfamily": 0 },
//{ "id": "45981665165", "owner": "15711590@N00", "secret": "5d24971079", "server": "4851", "farm": 5, "title": "", "ispublic": 1, "isfriend": 0, "isfamily": 0 },
//{ "id": "31955034797", "owner": "15711590@N00", "secret": "a0a7b6b22c", "server": "7838", "farm": 8, "title": "Den dagen det var så mørkt", "ispublic": 1, "isfriend": 0, "isfamily": 0 },
//{ "id": "46892162311", "owner": "125367296@N06", "secret": "ab9ab72c0a", "server": "7819", "farm": 8, "title": "", "ispublic": 1, "isfriend": 0, "isfamily": 0 },
//{ "id": "33053896118", "owner": "17079401@N07", "secret": "b9c5fe1bb0", "server": "7863", "farm": 8, "title": "Aaron Lee Tasjan @ Vulkan", "ispublic": 1, "isfriend": 0, "isfamily": 0 }
//] }, "stat": "ok" }
//

import Foundation

struct PhotosSearchResult: Codable {
    let photos: PhotosSearchDetails?
    let stat: String
    let message: String?
}

struct PhotosSearchDetails: Codable {
    let page: Int
    let pages: Int
    let perpage: Int
    let total: String
    let photo: [PhotoDetails]
    
}

struct PhotoDetails: Codable {
    let id: String
    let secret: String
    let server: String
    let farm: Int
}
