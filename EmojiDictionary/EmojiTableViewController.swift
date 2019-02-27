//
//  EmojiTableViewController.swift
//  EmojiDictionary
//
//  Created by Eliana Boado on 2/21/19.
//  Copyright © 2019 Eliana Boado. All rights reserved.
//

import UIKit

class EmojiTableViewController: UITableViewController {
    
    var emojis: [Emoji] = [
        Emoji(symbol: "😀", name: "Grinning Face", description: "A typical smiley face.", usage: "happiness"),
        Emoji(symbol: "😕", name: "Confused Face", description: "A confused, puzzled face.", usage: "unsure what to think; displeasure"),
        Emoji(symbol: "😍", name: "Heart Eyes", description: "A smiley face with hearts for eyes.", usage: "love of something; attractive"),
        Emoji(symbol: "👮", name: "Police Officer", description: "A police officer wearing a blue cap with a gold badge.", usage: "person of authority"),
        Emoji(symbol: "🐢", name: "Turtle", description: "A cute turtle.", usage: "Something slow"),
        Emoji(symbol: "🐘", name: "Elephant", description: "A gray elephant.", usage: "good memory"),
        Emoji(symbol: "🍝", name: "Spaghetti",description: "A plate of spaghetti.", usage: "spaghetti"),
        Emoji(symbol: "🎲", name: "Die", description: "A single die.", usage: "taking a risk, chance; game"),
        Emoji(symbol: "⛺️", name: "Tent", description: "A small tent.", usage: "camping"),
        Emoji(symbol: "📚", name: "Stack of Books", description: "Three colored books stacked on each other.", usage: "homework, studying"),
        Emoji(symbol: "💔", name: "Broken Heart", description: "A red, broken heart.", usage: "extreme sadness"),
        Emoji(symbol: "💤", name: "Snore", description: "Three blue 'z's.", usage: "tired, sleepiness"),
        Emoji(symbol: "🏁", name: "Checkered Flag", description: "A black-and-white checkered flag.", usage: "completion")
    ];

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableView.automaticDimension;
        tableView.estimatedRowHeight = 44.0;
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem;       //p. 618
    }

    // MARK: - Table view data source p.611

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData();
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard section == 0 else {
            fatalError("This UITableView has no section number \(section)");
        }
        return emojis.count;        //p. 613
    }
    
    
    
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        let tableViewEditingMode: Bool = tableView.isEditing;
        tableView.setEditing(!tableViewEditingMode, animated: true);
        
        //Toggle the bar button between the words Edit and Done.
        let systemItem: UIBarButtonItem.SystemItem = tableView.isEditing ? .done : .edit;
        let barButtonItem: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: systemItem, target: self, action: #selector(editButtonTapped(_:)));
        navigationItem.leftBarButtonItem = barButtonItem;
    }

    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let movedEmoji: Emoji = emojis.remove(at: fromIndexPath.row);
        emojis.insert(movedEmoji, at: to.row);
        tableView.reloadData();
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard indexPath.section == 0 else {
            fatalError("This UITableView has no section number \(indexPath.section).");
        }
        //Step 1: Dequeue cell
        let cell: EmojiTableViewCell = tableView.dequeueReusableCell(withIdentifier: "EmojiCell", for: indexPath) as! EmojiTableViewCell
        
        //Step 2: Fetch model object to display
        let emoji: Emoji = emojis[indexPath.row];
        
        //Step 3: Configure the cell
        cell.update(with: emoji)
        cell.showsReorderControl = true
        
        //Step 4: Return cell
        return cell
    }
    
    override func tableView(_ tableView: UITableView,editingStyleForRowAt indexPath: IndexPath) ->UITableViewCell.EditingStyle {
            return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            emojis.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender);
        print("prepare");
        
        guard segue.identifier == "EditEmoji" else {
            return;
        }
        
        // Get the new view controller using segue.destination.
        
        guard let navigationController: UINavigationController = segue.destination as? UINavigationController else {
            fatalError("EditEmoji segue is supposed to go to a UINavigationController");
        }
        
        guard let addEditEmojiTableViewController: AddEditEmojiTableViewController = navigationController.topViewController as? AddEditEmojiTableViewController else {
            fatalError("EditEmoji segue is supposed to go to an AddEditEmojiTableViewController");
        }
        
        // Pass the selected object to the new view controller.
        
        guard let indexPath: IndexPath = tableView.indexPathForSelectedRow else {
            fatalError("prepare(for:sender:) called when no cell is selected");
        }
        
        addEditEmojiTableViewController.emoji = emojis[indexPath.row];
    }
    
    @IBAction func unwindToEmojiTableView(segue: UIStoryboardSegue)
    {
        guard segue.identifier == "saveUnwind" else { return }
        let sourceViewController = segue.source as!
        AddEditEmojiTableViewController
        
        if let emoji = sourceViewController.emoji {
            if let selectedIndexPath =
                tableView.indexPathForSelectedRow {
                emojis[selectedIndexPath.row] = emoji
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
                //arrive here if we are coming from a trip because user selected a cell
            } else {
                //arrive here because the user pressed the plus sign
                let newIndexPath = IndexPath(row: emojis.count,
                                             section: 0)
                emojis.append(emoji)
                tableView.insertRows(at: [newIndexPath],
                                     with: .automatic)
            }
        }
    }

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
