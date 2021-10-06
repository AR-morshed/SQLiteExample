//
//  DatabaseManager.swift
//  SQLiteExample
//
//  Created by Arman Morshed on 5/10/21.
//

import Foundation
import SQLite

enum DatabaseError: Error {
    case connectDatabase(message: String)
    case getAlbumsError(message: String)
    case getAlbumsByArtisIdError(message: String)
}


class DatabaseManager {
    
    var db: Connection!
    
     private init() { }

    static let shared = DatabaseManager()
    
    func connectToDatabase() {
        guard let path = Bundle.main.path(forResource: "chinook", ofType: "db") else {
            print("File not found")
            return
        }
        
        do {
            db = try Connection(path, readonly: true)
            print("Connected")
        } catch {
            print("Not connected")
        }
    }
    
    func getAlbums() -> [Album] {
        var albums: [Album] = []
        
        do {
            
            let albumTable = Table("Album")
            let albumID = Expression<Int>("AlbumId")
            let title = Expression<String>("Title")
            let artistID = Expression<Int>("ArtistId")
            
            for album in try db.prepare(albumTable) {
                albums.append(Album(albunId: album[albumID], title: album[title], artistId: album[artistID]))
            }
            
        } catch let Result.error(message, code, statement) where code == SQLITE_CONSTRAINT {
            print("contriant failed: \(message), in \(statement)")
           
        } catch let error {
            print("\(error)")
        }
        
        return albums
    }
    
    func getAlbumsFor(artistId: Int) -> [Album] {
        var albums: [Album] = []
        
        do {
            for album in try db.prepare("select * FROM album WHERE artistid == \(artistId)") {
                if let albumId = album[0] as? Int64, let title = album[1] as? String, let artistId = album[2] as? Int64 {
                    albums.append(Album(albunId: Int(albumId), title: title, artistId: Int(artistId)))
                }
            }
            
        } catch let Result.error(message, code, statement) {
            print("contriant failed: \(message), in \(code) \(statement)")
           
        } catch let error {
            print("\(error)")
        }
        
        return albums
    }
    
    func getAlbumsUsingFor(search: String) -> [Album] {
        var albums: [Album] = []
        
        let albumTable = Table("Album")
        let albumID = Expression<Int>("AlbumId")
        let title = Expression<String>("Title")
        let artistID = Expression<Int>("ArtistId")
        
        do {
            let all = albumTable.select(artistID, title, artistID)
                .filter(title.like("%\(search)%"))
            
            for album in try db.prepare(all) {
                albums.append(Album(albunId: album[albumID], title: album[title], artistId: album[artistID]))
            }
            
        } catch let Result.error(message, code, statement) {
            
           
        } catch let error {
            print("\(error)")
        }
        
        return albums
    }
    
    func getArtisNameAndAlbumTameUsingFor(albumId: Int) -> [Album] {
        var albums: [Album] = []
        
        let albumTable = Table("Album")
        let artisTable = Table("Artist")
        let albumID = Expression<Int>("AlbumId")
        let title = Expression<String>("Title")
        let artistID = Expression<Int>("ArtistId")
        let artistName = Expression<String>("Name")
        
        do {
            let all = albumTable.join(artisTable, on: albumTable[artistID] == artisTable[artistID])
                .select(title, artistName)
                .filter(albumID == albumId)
            
            for row in try db.prepare(all) {
                print(try row.get(artistID))
                print(try row.get(title))
                print(row[artistName])
//                albums.append(Album(albunId: Int(album[albumID]), title: album[title], artistId: Int(album[artistID])))
            }
            
        } catch let Result.error(message, code, statement) where code == SQLITE_ERROR {
            print("contriant failed: \(message), in \(code) \(statement)")
           
        } catch let error {
            print("\(error)")
        }
        
        return albums
    }
    
}
