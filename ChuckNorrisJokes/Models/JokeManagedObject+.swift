//
//  JokeManagedObject+.swift
//  ChuckNorrisJokes
//
//  Created by yanjixian on 2021/8/24.
//  Copyright © 2021 Scott Gardner. All rights reserved.
//

import Foundation
import SwiftUI
import CoreData
import ChuckNorrisJokesModel

extension JokeManagedObject {
    static func save(joke: Joke, inViewContext viewContext: NSManagedObjectContext) {
        // 4
            guard joke.id != "error" else { return }
            // 5
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: JokeManagedObject.self))
            // 6
            fetchRequest.predicate = NSPredicate(format: "id = %@", joke.id)
            
            // 7
            if let results = try? viewContext.fetch(fetchRequest),
               let existing = results.first as? JokeManagedObject {
              existing.value = joke.value
              existing.categories = joke.categories as NSArray
            } else {
              // 8
              let newJoke = self.init(context: viewContext)
              newJoke.id = joke.id
              newJoke.value = joke.value
              newJoke.categories = joke.categories as NSArray
            }
            
            // 9
        do {
              try viewContext.save()
            } catch {
              fatalError("\(#file), \(#function), \(error.localizedDescription)")
            }
    }
}

extension Collection where Element == JokeManagedObject, Index == Int {
  // 1
  func delete(at indices: IndexSet, inViewContext viewContext: NSManagedObjectContext) {
    // 2
    indices.forEach { index in
      viewContext.delete(self[index])
    }
    
    // 3
    do {
      try viewContext.save()
    } catch {
      fatalError("\(#file), \(#function), \(error.localizedDescription)")
    }
  }
}
