//
//  FeedViewController.swift
//  Instagram
//
//  Created by Sanzida Sultana on 10/21/20.
//

import UIKit
import Parse
import AlamofireImage
import MessageInputBar

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MessageInputBarDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    
    // Cocopod MessageInputBar
    let commentBar = MessageInputBar()
    var showCommentBar = false
    var selectedPost: PFObject!
    
    
    var posts = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentBar.inputTextView.placeholder = "Add a comment...."
        commentBar.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self

        tableView.keyboardDismissMode = .interactive
       
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillBeHidden(note:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillBeHidden(note: Notification){
        commentBar.inputTextView.text = nil
        showCommentBar = false
        becomeFirstResponder()
    }
    
    // MessageBar Functions
    
    override var inputAccessoryView: UIView?{
        return commentBar
    }
    
    override var canBecomeFirstResponder: Bool{
        return showCommentBar
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        
        let query = PFQuery(className: "Posts")
        query.includeKeys(["author", "comments", "comments.Author"])
        query.limit = 20
        
        query.findObjectsInBackground{ (posts, Error) in
            
            if posts != nil {
                self.posts = posts!
                self.tableView.reloadData()
            }
    
        }
    }
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        
        // Create the comment
        let comment = PFObject(className: "Comments")
        comment["text"] = "This is a random comment"
        comment["post"] = selectedPost
        comment["Author"] = PFUser.current()!

        selectedPost.add(comment, forKey: "comments")
    // Saving the comment in the backend server
        selectedPost.saveInBackground { (success, error) in
            if(success){
                print("Comment saved!")
            } else {
                print("Error when saving comment")
            }
       
       }
        tableView.reloadData()
        
        // Clear and dismiss the input bar
        commentBar.inputTextView.text = nil
        showCommentBar = false
        becomeFirstResponder()
        commentBar.inputTextView.resignFirstResponder()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let post = posts[section]
        
        // When whatever is on the left is nil set it as this
        let comments = (post["comments"] as? [PFObject]) ?? []
        
        return comments.count + 2
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let post = posts[indexPath.section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        
        // This is if its a post cell
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "postCell") as! PostedTableViewCell
            
            let user = post["author"] as! PFUser
            cell.username.text = user.username
            
            cell.caption.text = post["caption"] as! String
            
            let imageFile = post["image"] as! PFFileObject
            let urlString = imageFile.url!
            let url = URL(string: urlString)!
            
            cell.postedImage.af_setImage(withURL: url)
            
            
            return cell
            
        } else if indexPath.row <= comments.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCellTableViewCell
            
            let comment = comments[indexPath.row - 1]
            cell.userComment.text = comment["text"] as? String

            let user = comment["Author"] as! PFUser
            cell.nameLabel.text = user.username
        
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCommentCell")!
            return cell
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Tap the Image
        let post = posts[indexPath.section]
        
//        // Creating the PF object
        let comments = (post["comments"] as? [PFObject]) ?? []
        
        if indexPath.row == comments.count + 1 {
            showCommentBar = true
            becomeFirstResponder()
            commentBar.inputTextView.becomeFirstResponder()
            
            selectedPost = post
        }
    }
    
    @IBAction func onLogOutButton(_ sender: Any) {
        // Clear Pashe Cahse 
        PFUser.logOut()
        
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(identifier: "LogInViewController")
        
        let delegate = self.view.window?.windowScene?.delegate as! SceneDelegate
        delegate.window?.rootViewController = loginViewController
        
    }
    
}
