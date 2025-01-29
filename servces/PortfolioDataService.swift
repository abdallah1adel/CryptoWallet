//
//  PortfolioDataService.swift
//  CryptoWallet
//
//  Created by pcpos on 08/01/2025.
//
import Foundation
import Combine
import CoreData

class PortfolioDataService {
    
    private let container: NSPersistentContainer
    private let containerName: String = "PortfolioContainer"  // Make sure this matches your .xcdatamodeld file name
    private let entityName: String = "PortfolioEntity"
    
    @Published var savedEntities: [PortfolioEntity] = []

    init() {
        container = NSPersistentContainer(name: containerName)

        // Load persistent stores with lightweight migration enabled
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Error loading persistent stores: \(error.localizedDescription)")
                // Optionally, alert the user or handle the error gracefully
                return
            } else {
                description.shouldInferMappingModelAutomatically = true
                description.shouldMigrateStoreAutomatically = true
                print("Persistent stores loaded successfully with lightweight migration.")
                
                self.container.viewContext.automaticallyMergesChangesFromParent = true
                self.getPortfolio()
            }
        }

    }

    // Fetch Portfolio Entities with background thread for better performance
    private func getPortfolio() {
        let request = NSFetchRequest<PortfolioEntity>(entityName: "PortfolioEntity")   // Ensure this matches the name of the entity in the model
        do {
            let entities = try container.viewContext.fetch(request)
            print("Entities: \(entities)")
        } catch {
            print("Fetch error: \(error)")
        }
        container.viewContext.perform {
            do {
                let entities = try self.container.viewContext.fetch(request)
                DispatchQueue.main.async {
                    self.savedEntities = entities
                    print("Fetched Portfolio: \(self.savedEntities)")  // Debugging output
                }
            } catch let error {
                print("Error fetching portfolio: \(error)->getPortfolioEntity")
            }
        }
    }

    // Example of updating portfolio with debugging
    func updatePortfolio(coin: CoinModel, amount: Double) {
        print("Updating portfolio with coinID: \(coin.id), amount: \(amount)")
        
        if let entity = savedEntities.first(where: { $0.coinID == coin.id }) {
            if amount > 0 {
                update(entity: entity, amount: amount)
                print("Updated entity: \(entity)")
            } else {
                delete(entity: entity)
                print("Deleted entity: \(entity)")
            }
        } else {
            add(coin: coin, amount: amount)
            print("Added new entity with coinID: \(coin.id), amount: \(amount)")
        }
    }

    
    // Add, update, and delete methods with debugging
    private func add(coin: CoinModel, amount: Double) {
        let entity = PortfolioEntity(context: container.viewContext)
        entity.coinID = coin.id
        entity.amount = amount
        applyChanges()
    }
    
    private func update(entity: PortfolioEntity, amount: Double) {
        entity.amount = amount
        applyChanges()
    }
    
    private func delete(entity: PortfolioEntity) {
        container.viewContext.delete(entity)
        applyChanges()
    }

    private func applyChanges() {
        save()
        getPortfolio()
    }
    
    // Test Core Data (add an entity and fetch it back)
    private func testCoreData() {
        // Test adding a new PortfolioEntity
        let entity = PortfolioEntity(context: container.viewContext)
        entity.coinID = "bitcoin"
        entity.amount = 5.0
        save()

        // Fetch it back
        let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)
        do {
            let entities = try container.viewContext.fetch(request)
            print("Fetched entities: \(entities)") // Should print the added entity
        } catch let error {
            print("Failed to fetch: \(error)")
        }
    }

    private func save() {
        do {
            try container.viewContext.save()
            print("Successfully saved context.")
        } catch let error {
            print("Error saving context: \(error)")
        }
    }
}
