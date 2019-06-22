//
//  MemesTableViewController.swift
//  Meme 1.0
//
//  Created by Azza on 5/3/19.
//  Copyright © 2019 Azza. All rights reserved.
//

import UIKit

class MemesTableViewController: UITableViewController {

    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(newMeme))
        navigationItem.leftBarButtonItem = editButtonItem

    }
    override func viewWillAppear(_ animated: Bool) {
        
        tableView?.reloadData()
    }
    
    @objc func newMeme(){
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let resultVC = storyboard.instantiateViewController(withIdentifier: "MemeEditorViewController")as! MemeEditorViewController
        self.present(resultVC, animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 100
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            (UIApplication.shared.delegate as! AppDelegate).memes.remove(at: (indexPath as NSIndexPath).row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            if (UIApplication.shared.delegate as! AppDelegate).memes.count == 0{
                self.setEditing(false, animated: true)
            }
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemesTableViewCell")! as! MemesTableViewCell
        cell.imageView?.image = self.memes[(indexPath as NSIndexPath).row].memedImage

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailController.memeIndex = (indexPath as NSIndexPath).row
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }
    
}
