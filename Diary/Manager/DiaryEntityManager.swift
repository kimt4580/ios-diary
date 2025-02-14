//
//  DiaryEntityManager.swift
//  Diary
//
//  Created by Donnie, OneTool on 2022/06/22.
//

import Foundation
import CoreData

final class DiaryEntityManager {
    static let shared = DiaryEntityManager()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DiaryEntity")
        container.loadPersistentStores { _ , error in
            if let error = error as NSError? {
                print("컨테이너 생성에 실패하였습니다.")
            }
        }
        return container
    }()
    
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private func saveContext() throws {
        if context.hasChanges {
            do {
                try self.context.save()
            } catch {
                throw CoreDataError.saveContextError
            }
        }
    }
    
    func create(diary: DiaryModel) throws {
        
        let data = DiaryEntity(context: context)
        data.title = diary.title
        data.body = diary.body
        data.createdAt = diary.createdAt
        data.id = diary.id
        data.weatherImage = diary.weatherImage
        try saveContext()
    }
    
    func fetch() throws -> [DiaryModel] {
        var diaryList = [DiaryEntity]()
        
        do {
            let request = DiaryEntity.fetchRequest()
            diaryList = try context.fetch(request)
        } catch {
            throw CoreDataError.fetchError
        }
        
        return diaryList.reversed().map { diaryEntity in
            DiaryModel(
                title: diaryEntity.title,
                body: diaryEntity.body,
                createdAt: diaryEntity.createdAt,
                id: diaryEntity.id,
                weatherImage: diaryEntity.weatherImage
            )
        }
    }
    
    func update(diary: DiaryModel) throws {
        let request = DiaryEntity.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", diary.id)

        request.predicate = predicate
        guard let diaryList = try? context.fetch(request) else {
            return
        }
        if let diaryEntity = diaryList.first {
            diaryEntity.title = diary.title
            diaryEntity.body = diary.body
            diaryEntity.createdAt = diary.createdAt
            diaryEntity.weatherImage = diary.weatherImage
        }
        try saveContext()
    }
    
    func delete(diary: DiaryModel) throws {
        let request = DiaryEntity.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", diary.id)
        request.predicate = predicate
        
        do {
            if let diaryEntity = try context.fetch(request).first {
                context.delete(diaryEntity)
            }
        }  catch {
            throw CoreDataError.deleteError
        }
        try saveContext()
    }
}
