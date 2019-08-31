//
//  MasterViewController.swift
//  reddit-reader
//
//  Created by Javier Loucim on 22/08/2019.
//  Copyright © 2019 Javier Loucim. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var posts = [Post]() {
        didSet {
            self.tableView.tableFooterView = footerView()
        }
    }
    var postService: PostService? = PostService()
    var isInitializing: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavigationBar()
        setupSplitViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController?.isCollapsed ?? false
        super.viewWillAppear(animated)
        readPosts()
    }

    // MARK : - Functions
    func setupViews() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: "PostTableViewCell")
    }
    func setupNavigationBar() {
        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem = editButtonItem
        self.navigationController?.navigationBar.tintColor = UIColor.highLightedText
        self.navigationController?.navigationBar.backgroundColor = UIColor.mainBackground
        self.navigationController?.navigationBar.barTintColor = UIColor.mainBackground
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.mainText]
        self.navigationItem.title = "Reddit Top Posts"
    }
    func setupSplitViews() {
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }
    @objc
    func insertNewObject(_ sender: Any) {
//        posts.insert(, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    func footerView() -> UIView? {
        guard !self.posts.isEmpty else { return nil }
        let button = UIButton()
        button.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: tableView.bounds.width, height: 80))
        button.backgroundColor = UIColor.mainBackground
        button.setTitle("Dismiss all", for: .normal)
        button.setTitleColor(UIColor.highLightedText, for: .normal)
        button.addTarget(self, action: #selector(didTapDismissAll), for: .touchUpInside)
        return button
    }
    // MARK: - User Actions
    @objc
    func didPullToRefresh() {
        getMorePosts()
    }
    @objc
    func didTapDismissAll() {
        removeAllPosts()
    }
    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.post = posts[indexPath.row]
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell")!

        return cell
    }
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let postCell = cell as? PostTableViewCell {
            postCell.configure(with: posts[indexPath.row])
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        markPostAsRead(post: posts[indexPath.row])
        performSegue(withIdentifier: "showDetail", sender: self)
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            posts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}
extension MasterViewController: PostsHandler {
    
    func didRemoveAllPosts() {
        readPosts()
    }
    
    func didFetchMorePosts() {
        refreshControl?.endRefreshing()
        readPosts()
    }
    
    func didReceive(posts: [Post]) {
        if posts.isEmpty && isInitializing {
            isInitializing = false
            getMorePosts()
            return
        }
        isInitializing = false
        let oldPosts = self.posts
        self.posts = posts
        //here I would use IGListKit or DifferenceKit but for the sake of doing this without any library I'll go with a local implementation
        self.tableView.reloadData(with: compare(oldValues: oldPosts, newValues: posts))
    }
    
    func postHandlerHasAnError(error: Error) {
        #warning("Create AlertHandler protocol to show an error")
        print(error.localizedDescription)
    }
    func didMarkPostAsRead(post: Post) {
        if let index = posts.firstIndex(of: post) {
            posts[index] = post
            if let indexPath = tableView.indexPathForSelectedRow, let cell = tableView.cellForRow(at: indexPath) as? PostTableViewCell {
                cell.configure(with: post)
            }
        }
    }
    
}
