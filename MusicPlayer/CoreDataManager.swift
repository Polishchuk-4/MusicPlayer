//
//  CoreDataManager.swift
//  MusicPlr
//
//  Created by Denis Polishchuk on 16.09.2022.
//

import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "MusicPlr")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

//MARK: - Create -
extension CoreDataManager {
    func createModalSong(name: String) {
        let modalSong = ModelSong(context: persistentContainer.viewContext)
        modalSong.name = name
        self.saveContext()
    }
    
    func createPlaylist(name: String, image: UIImage?) {
        let playlist = Playlist(context: persistentContainer.viewContext)
        playlist.name = name
        playlist.image = image?.pngData()
        self.saveContext()
    }
    
    func createModalSongInPlaylist(playlist: Playlist) -> ModelSong {
        let model = ModelSong(context: persistentContainer.viewContext)
        return model
    }
}

//MARK: - Get -
extension CoreDataManager {
    func getModelSong() -> [ModelSong] {
        let fetchRequest = NSFetchRequest<ModelSong>(entityName: "ModelSong")
        let sortDescriptor = NSSortDescriptor(key: #keyPath(ModelSong.name), ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            let modalSongs = try persistentContainer.viewContext.fetch(fetchRequest)
            return modalSongs
        } catch {
            fatalError()
        }
    }
    
    func getIsFavorite() -> [ModelSong] {
        let fetchRequest = NSFetchRequest<ModelSong>(entityName: "ModelSong")
        let predicate = NSPredicate(format: "isFavorite == YES")
        fetchRequest.predicate = predicate
        do {
            let modalSongs = try persistentContainer.viewContext.fetch(fetchRequest)
            return modalSongs
        } catch {
            fatalError()
        }
    }
    
    func getPlaylist() -> [Playlist] {
        let fetchRequest = NSFetchRequest<Playlist>(entityName: "Playlist")
        do {
            let playlist = try persistentContainer.viewContext.fetch(fetchRequest)
            return playlist
        } catch {
            fatalError()
        }
    }
    
    func addSongsInPlaylist(playList: Playlist, songs: [ModelSong]) {
        songs.forEach { song in
            playList.addToModelsSongs(song)
            song.isSelected = false
        }
        self.saveContext()
    }
}

//MARK: - Delete -
extension CoreDataManager {
    func delete(modelSong: ModelSong) {
        persistentContainer.viewContext.delete(modelSong)
        saveContext()
    }
    
    func delete(playlist: Playlist) {
        persistentContainer.viewContext.delete(playlist)
        saveContext()
    }
}

