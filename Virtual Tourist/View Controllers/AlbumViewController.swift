//
//  AlbumViewController.swift
//  Virtual Tourist
//
//  Created by Frederik Skytte on 31/01/2019.
//  Copyright © 2019 Frederik Skytte. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class AlbumViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var collectionFlowLayout: UICollectionViewFlowLayout!
    
    var fetchedResultsController:NSFetchedResultsController<Photo>!
    
    /// The pin for the album in this view
    var currentPin: Pin!
    let space:CGFloat = 8.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showLocationPin()
        setupFetchedResultsController()
        updateNewCollectionButtonState()
        
        if currentPin.photos?.count == 0 {
            downloadNewPhotoCollection()
        }
        
        self.collectionFlowLayout?.minimumInteritemSpacing = space
        self.collectionFlowLayout?.minimumLineSpacing = space
        
        let horizontalWidth = UIDevice.current.orientation.isPortrait ?
            view.frame.size.width : view.frame.size.height
        
        updateFlowLayoutProperties(toWidth: horizontalWidth)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupFetchedResultsController()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        fetchedResultsController = nil
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        updateFlowLayoutProperties(toWidth: size.width)
    }
    
    func showLocationPin() {
        let coordinate = CLLocationCoordinate2D(latitude: currentPin.latitude, longitude: currentPin.longitude)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.mapView.addAnnotation(annotation)
        self.mapView.setCenter(coordinate, animated: true)
    }
    
    // MARK: Private helper fuctions
    
    fileprivate func updateFlowLayoutProperties(toWidth width: CGFloat){
        let imagesPerRow: CGFloat = UIDevice.current.orientation.isPortrait ? 3.0 : 4.0
        let dimension = (width - ((imagesPerRow - 1.0) * self.space)) / imagesPerRow
        
        print("Setting size for images to \(dimension)")
        self.collectionFlowLayout?.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    fileprivate func setupFetchedResultsController() {
        let fetchRequest:NSFetchRequest<Photo> = Photo.fetchRequest()
        let predicate = NSPredicate(format: "locationPin == %@", currentPin)
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "flickrId", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    fileprivate func downloadNewPhotoCollection() {
        if let photos = self.currentPin?.photos {
            for photo in photos {
                self.deletePhoto(photo as! Photo)
            }
        }
        
        FlickrClient.getPhotoList(lat: currentPin.latitude, lon: currentPin.longitude, page: 1) {result, error in
            print(result ?? "no result")
            print(error  ?? "no error")
            if let photos = result?.photo {
                for photoDetails in photos {
                    self.addPhoto(id: photoDetails.id)
                }
            }
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Editing
    
    // Adds a new Photo to the location album
    func addPhoto(id:String) {
        print("Adding photo id \(id)")
        let p = Photo(context: dataController.viewContext)
        p.flickrId = id
        p.locationPin = currentPin
        try? dataController.viewContext.save()
    }
    
    // Deletes the Photo at the specified index path
    func deletePhoto(at indexPath: IndexPath) {
        let toDelete = fetchedResultsController.object(at: indexPath)
        self.deletePhoto(toDelete)
    }
    
    // Deletes the Photo
    func deletePhoto(_ toDelete: Photo) {
        print("Deleting photo \(toDelete.flickrId ?? "x")")
        dataController.viewContext.delete(toDelete)
        try? dataController.viewContext.save()
    }
    
    func updateNewCollectionButtonState() {
        //TODO navigationItem.rightBarButtonItem?.isEnabled = fetchedResultsController.sections![0].numberOfObjects > 0
    }
}
extension AlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Size of collection \(fetchedResultsController.sections?[0].numberOfObjects ?? 0)")
        return fetchedResultsController.sections?[0].numberOfObjects ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("Dequeing cell")
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionCell", for: indexPath) as! PhotoCollectionCell
        
        let p = fetchedResultsController.object(at: indexPath)
        
        // Set the image
        if let data = p.photoData {
            cell.photoImageView?.image = UIImage(data: data)
        }
        else {
            cell.photoImageView?.image = UIImage(imageLiteralResourceName: "placeholder")
        }
    
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        print("Item selected for deleting")
        self.deletePhoto(at: indexPath)
    }
}

extension AlbumViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        print("Controller change of type: \(type)")
        
        switch type {
        case .insert:
            collectionView.insertItems(at: [newIndexPath!])
            break
        case .delete:
            collectionView.deleteItems(at: [indexPath!])
            break
        case .update:
            collectionView.reloadItems(at: [indexPath!])
        case .move:
            collectionView.moveItem(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        print("Controller section change of type: \(type)")
        
        let indexSet = IndexSet(integer: sectionIndex)
        switch type {
        case .insert: collectionView.insertSections(indexSet)
        case .delete: collectionView.deleteSections(indexSet)
        case .update, .move:
            fatalError("Invalid change type in controller(_:didChange:atSectionIndex:for:). Only .insert or .delete should be possible.")
        }
    }
    
    /**
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView.
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView.endUpdates()
    }
 **/
    
}
