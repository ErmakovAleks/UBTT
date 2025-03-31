//
//  PersistenceService.swift
//  RickAndMortyApp
//
//  Created by Alexander Ermakov on 30.03.2025.
//

import CoreData


protocol PersistenceServiceProtocol {
    
    static var shared: Self { get }
    
    func loadCharacters() -> [Character_]
    
    func loadCharacter(by id: Int) -> Character_?
    
    func saveCharacters(_ characters: [Character_])
}

final class PersistenceService: PersistenceServiceProtocol {
    
    // MARK: -
    // MARK: Variables
    
    static let shared = PersistenceService()
    
    private lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "RickAndMortyModel")
        return container
    }()
    
    private var context: NSManagedObjectContext {
        container.viewContext
    }
    
    // MARK: -
    // MARK: Initialization
    
    private init() {
        self.container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("<!> CoreData load failed: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: -
    // MARK: Persistence Service Protocol
    
    func loadCharacters() -> [Character_] {
        let request: NSFetchRequest<CharacterEntity> = CharacterEntity.fetchRequest()
        
        do {
            let entities = try self.context.fetch(request)
            print("<!> Load from CoreData")
            
            return entities.map { $0.toCharacter() }
        } catch {
            print("<!> Failed to fetch characters: \(error)")
            
            return []
        }
    }
    
    func loadCharacter(by id: Int) -> Character_? {
        let request: NSFetchRequest<CharacterEntity> = CharacterEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        request.fetchLimit = 1
        
        do {
            let result = try self.context.fetch(request).first
            print("<!> Load from CoreData")
            
            return result?.toCharacter()
        } catch {
            print("<!> Failed to fetch character by ID \(id): \(error)")
            
            return nil
        }
    }
    
    func saveCharacters(_ characters: [Character_]) {
        let request: NSFetchRequest<CharacterEntity> = CharacterEntity.fetchRequest()
        
        do {
            let existingEntities = try self.context.fetch(request)
            let existingMap = Dictionary(uniqueKeysWithValues: existingEntities.map { (Int($0.id), $0) })
            
            var didInsertNew = false
            
            for character in characters {
                if existingMap.contains(where: { $0.key == character.id}) {
                    continue
                } else {
                    let entity = CharacterEntity(context: context)
                    entity.id = Int64(character.id)
                    entity.name = character.name
                    entity.image = character.image
                    entity.origin = character.origin.name
                    entity.gender = character.gender.rawValue
                    entity.status = character.status.rawValue
                    
                    didInsertNew = true
                }
            }
            
            if didInsertNew {
                try context.save()
                print("<!> Saved to CoreData")
            }
        } catch {
            print("<!> Failed to save characters: \(error)")
        }
    }
}

extension CharacterEntity {
    
    func toCharacter() -> Character_ {
        return Character_(
            id: Int(self.id),
            name: self.name ?? "",
            status: CharacterStatus(rawValue: self.status ?? "") ?? .alive,
            gender: Gender(rawValue: self.gender ?? "") ?? .male,
            origin: Origin(name: self.origin ?? "", url: ""),
            image: self.image ?? ""
        )
    }
}
