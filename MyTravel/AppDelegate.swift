//
//  AppDelegate.swift
//  MyTravel
//
//  Created by 江宗益 on 2017/9/28.
//  Copyright © 2017年 江宗益. All rights reserved.
//

import UIKit
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var db:OpaquePointer? = nil
    var stmt:OpaquePointer? = nil
    var i = 0
    var nowId = ""
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let fmgr = FileManager.default
        let srcDB = Bundle.main.path(forResource: "iii", ofType: "db")
        let tagDB = NSHomeDirectory() + "/Documents/iii.db"
        if !fmgr.fileExists(atPath: tagDB) {
            try? fmgr.copyItem(atPath: srcDB!, toPath: tagDB)
            sqlite3_open(tagDB, &db)
            importRemoteData()
        }else{
//            try? fmgr.copyItem(atPath: srcDB!, toPath: tagDB)
//            try? fmgr.removeItem(atPath: tagDB)
            sqlite3_open(tagDB, &db)
           // importRemoteData()
        }
        print("count:\(self.i)")
        print(NSHomeDirectory())
        return true
    }
    
    private func importRemoteData(){
        Alamofire.request("http://data.coa.gov.tw/Service/OpenData/ODwsv/ODwsvAttractions.aspx").responseJSON { response in
            if let data = response.data {
                let sql = "insert into travel (tid,name,tel,intro,addr,city,town,lat,lng,photo) values (?,?,?,?,?,?,?,?,?,?)"
                
                sqlite3_prepare(self.db, sql, -1, &self.stmt, nil)
                
                let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                
                for row in json as! [[String:String]] {
//                    print("\(row["ID"] ?? "xx") : \(row["Name"] ?? "xx") : \(row["Coordinate"] ?? "xx")")
////
                    sqlite3_reset(self.stmt)
                    sqlite3_prepare(self.db, sql, -1, &self.stmt, nil)
                    let temp = row["Coordinate"]
                    let latlng = temp?.characters.split(separator: ",").map(String.init)
                    let lat = latlng!.count<1 ? "" : latlng![0]
                    let lng = latlng!.count<2 ? "" : latlng![1]
                    
                    self.insertData(tid: row["ID"] ?? "XX", name: row["Name"] ?? "XX", tel: row["Tel"] ?? "XX", intro: row["Introduction"] ?? "XX", addr: row["Address"] ?? "XX", city: row["City"] ?? "XX", town: row["Town"] ?? "XX", lat: lat ?? "XX", lng: lng ?? "XX", photo: row["Photo"] ?? "XX")
                    
                }
                print("count:\(self.i)")
                
               // print("\(pow["ID"] ?? "xx") : \(row["Name"] ?? "xx") : \(row["Coordinate"] ?? "xx")")
            }
        }
    }
    
    //insert into
private func insertData(tid:String, name:String, tel:String, intro:String, addr:String, city:String, town:String, lat:String, lng:String, photo:String){
    
    let ctid = tid.cString(using: .utf8)
    let cname = name.cString(using: .utf8)
    let ctel = tel.cString(using: .utf8)
    let intro = intro.cString(using: .utf8)
    let addr = addr.cString(using: .utf8)
    let city = city.cString(using: .utf8)
    let town = town.cString(using: .utf8)
    let lat = lat.cString(using: .utf8)
    let lng = lng.cString(using: .utf8)
    let photo = photo.cString(using: .utf8)
    
    sqlite3_bind_text(stmt!, 1, ctid, -1, nil)
    sqlite3_bind_text(stmt!, 2, cname, -1, nil)
    sqlite3_bind_text(stmt!, 3, ctel, -1, nil)
    sqlite3_bind_text(stmt!, 4, intro, -1, nil)
    sqlite3_bind_text(stmt!, 5, addr, -1, nil)
    sqlite3_bind_text(stmt!, 6, city, -1, nil)
    sqlite3_bind_text(stmt!, 7, town, -1, nil)
    sqlite3_bind_text(stmt!, 8, lat, -1, nil)
    sqlite3_bind_text(stmt!, 9, lng, -1, nil)
    sqlite3_bind_text(stmt!, 10, photo, -1, nil)
//    print("ID:\(town!)")
    if sqlite3_step(stmt!) == SQLITE_DONE{
        i += 1
    }
}

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

