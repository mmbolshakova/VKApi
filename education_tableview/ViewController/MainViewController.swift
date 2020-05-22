//
//  ViewController.swift
//  education_tableview
//
//  Created by OUT-Bolshakova-MM on 12.05.2020.
//  Copyright © 2020 OUT-Bolshakova-MM. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    private let networkService: Networking = NetworkService()
    private var fetcher: DataFetcer = NetworkDataFetcher(networking: NetworkService())
    @IBOutlet weak var tableView: UITableView!
    private var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
    private var didRefresh: Bool = false
    private var newFromInProcess: String?
    private var feedViewModel = FeedViewModel.init(cells: [])
    private var cellCalculator: NewsCellCalculatorProtocol = NewsCellCalculator()
    let dateFormatter: DateFormatter = {
        let dF = DateFormatter()
        dF.locale = Locale(identifier: "ru_RU")
        dF.dateFormat = "d MMM 'в' HH:mm"
        return dF
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chooseRequest(from: Requests.RequestType.getNewsFeed)
        setupTableView()
    }
    
    
    private func setupTableView() {
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        view.backgroundColor = #colorLiteral(red: 0.689327538, green: 0.8426131606, blue: 0.9422802329, alpha: 1)
        tableView.register(NewsTableViewCell.nib, forCellReuseIdentifier: NewsTableViewCell.cellId)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.addSubview(refreshControl)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
    }
    
    @objc private func refresh() {
        print ("refresh")
        chooseRequest(from: Requests.RequestType.getNewsFeed)
        refreshControl.endRefreshing()
    }
    
    private func cellViewModel(from feedItem: FeedItem, profiles: [Profile], groups: [Group]) -> FeedViewModel.Cell {
        let profile = self.profile(for: feedItem.sourceId, profile: profiles, group: groups)
        let date = Date(timeIntervalSince1970: feedItem.date)
        let dateTitle = dateFormatter.string(from: date)
        let photoAttach = self.photoAttach(feedItem: feedItem)
        let sizes = cellCalculator.sizes(postText: feedItem.text, photoAttach: photoAttach)
        
        return FeedViewModel.Cell.init(photoAttach: photoAttach,
                                       getIconUrl: profile.photo,
                                       getName: profile.name,
                                       getDate: dateTitle,
                                       getNewsText: feedItem.text,
                                       getLike: formatCounter(feedItem.likes?.count),
                                       getComment: formatCounter(feedItem.comments?.count),
                                       getShare: formatCounter(feedItem.reposts?.count),
                                       getViews: formatCounter(feedItem.views?.count),
                                       sizes: sizes)
    }
    
    private func photoAttach(feedItem: FeedItem) -> FeedViewModel.FeedCellPhotoAttach? {
        guard let photos = feedItem.attachments?.compactMap({ (attachment)  in
            attachment.photo
        }), let firstPhoto = photos.first else { return nil }
        return FeedViewModel.FeedCellPhotoAttach.init(photoUrl: firstPhoto.srcBig,
                                                      photoHeight: firstPhoto.height,
                                                      photoWidth: firstPhoto.width)
    }
    
    private func formatCounter(_ counter: Int?) -> String? {
        guard let counter = counter, counter > 0 else { return nil }
        var counterString = String(counter)
        if 4...6 ~= counterString.count {
            counterString = String(counterString.dropLast(3)) + "K"
        } else if counterString.count > 6 {
            counterString = String(counterString.dropLast(5)) + "M"
        }
        return counterString
    }
    
    private func makeRequest(from type: String?) {
        fetcher.getFeed(nextBatchFrom: type) { (feedResponse) in
            guard let feedResponse = feedResponse else { return }
            self.newFromInProcess = feedResponse.nextFrom
            let cells = feedResponse.items.map { (feedItem) in
                self.cellViewModel(from: feedItem, profiles: feedResponse.profiles, groups: feedResponse.groups)
            }
            if type != nil {
                self.feedViewModel.cells.append(contentsOf: cells)
            } else {
                self.feedViewModel = FeedViewModel.init(cells: cells)
            }
            self.tableView.reloadData()
        }
        didRefresh = false
    }
    
    
    private func chooseRequest (from type: Requests.RequestType) {
        var startFrom: String? = nil
        switch type {
            case .getNewsFeed:
                startFrom = nil
            case .getNextBatch:
                startFrom = self.newFromInProcess
            }
        makeRequest(from: startFrom)
    }
    
    private func profile(for sourceId: Int, profile: [Profile], group: [Group]) -> ProfileRepresentable {
        let profilesOrGroups: [ProfileRepresentable] = sourceId >= 0 ? profile : group
        let normalSourceId = sourceId >= 0 ? sourceId : -sourceId
        let profileRepresentable = profilesOrGroups.first { (profileRepres) -> Bool in
            profileRepres.id == normalSourceId
        }
        return profileRepresentable!
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > scrollView.contentSize.height / 1.1 && !didRefresh {
            didRefresh = true
            chooseRequest(from: Requests.RequestType.getNextBatch)
        }
    }
}

extension MainViewController: UITableViewDelegate {
    
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedViewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.cellId, for: indexPath) as! NewsTableViewCell
        let cellViewModel = feedViewModel.cells[indexPath.row]
        cell.set(viewModel: cellViewModel)
        return cell
    }
}

