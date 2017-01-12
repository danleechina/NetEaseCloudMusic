//
//  FilterSongSheetViewController.swift
//  NetEaseCloudMusic
//
//  Created by Dan.Lee on 2017/1/11.
//  Copyright © 2017年 Ampire_Dan. All rights reserved.
//

import UIKit

class FilterSongSheetViewController: BaseViewController {
    var selectedText = "全部歌单" {
        didSet {
            selectedSection = selectedText == "全部歌单"
            if selectedSection {
                return
            }
            for oidx in 0..<titlesForEachCell.count {
                for iidx in 0..<titlesForEachCell[oidx].count {
                    if titlesForEachCell[oidx][iidx] == selectedText {
                        selectedIndexPath = IndexPath.init(row: iidx, section: oidx)
                        break
                    }
                }
            }
        }
    }
    
    fileprivate var selectedSection = true
    fileprivate var selectedIndexPath = IndexPath.init(row: -1, section: -1)
    fileprivate lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView.init(frame: self.view.bounds, collectionViewLayout: self.collectionViewFlowLayout)
        collectionView.frame = CGRect(x: 0, y: 64, width: self.view.bounds.width, height: self.view.bounds.height - 64 - 49)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
        let contentInsetValue: CGFloat = 0
        collectionView.contentInset = UIEdgeInsetsMake(contentInsetValue, contentInsetValue, contentInsetValue, contentInsetValue)
        collectionView.register(FilterSongSheetViewCell.self, forCellWithReuseIdentifier: FilterSongSheetViewCell.identifier)
        collectionView.register(FilterSongSheetViewSection.self, forSupplementaryViewOfKind: FilterSongSheetViewSection.kind, withReuseIdentifier: FilterSongSheetViewSection.identifier)
        return collectionView
    }()
    
    fileprivate lazy var collectionViewFlowLayout: UICollectionViewGridLayout = {
        let layout = UICollectionViewGridLayout()
        layout.delegate = self
        layout.sectionMargin = 10
        layout.separateLineHeight = 0.5
        let inset: CGFloat = 15 - layout.separateLineHeight * (4 + 1)
        layout.insets = UIEdgeInsetsMake(inset, inset, inset, inset)
        return layout
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(self.collectionView)
        makeACommonNavigationBar(isBlackIcon: true)
        navigationBar.titleString = "筛选歌单"
        automaticallyAdjustsScrollViewInsets = false
    }
    
    fileprivate let sectionSize = [(4,1), (4,2), (4,7), (4,4), (4,4), (4,5),]
    fileprivate let titlesForEachCell: Array<Array<String>> = [["",],
                                         
                                         ["华语", "欧美", "日语",
                                         "韩语", "粤语", "小语种",],
                                         
                                         ["流行", "摇滚", "民谣",
                                         "电子", "舞曲", "说唱",
                                         "轻音乐", "爵士", "乡村", "R&B/Soul",
                                         "古典", "民族", "英伦", "金属",
                                         "朋克", "蓝调", "雷鬼", "世界音乐",
                                         "拉丁", "另类/独立", "New Age", "古风",
                                         "后摇", "Bossa Nova",],
                                         
                                         ["清晨", "夜晚", "学习",
                                         "工作", "午休", "下午茶",
                                         "地铁", "驾车", "运动", "旅行",
                                         "散步", "酒吧",],
                                         
                                         ["怀旧", "清新", "浪漫",
                                         "性感", "伤感", "治愈",
                                         "放松", "孤独", "感动", "兴奋",
                                         "快乐", "安静", "思念",],
                                         
                                         ["影视原声", "ACG", "校园",
                                         "游戏", "70后", "80后",
                                         "90后", "网络歌曲", "KTV", "经典",
                                         "翻唱", "吉他", "钢琴", "器乐",
                                         "儿童", "榜单", "00后",],
    ]
    fileprivate let titlesForEachSection = ["全部歌单", "语种", "风格", "场景", "情感", "主题", ]
    fileprivate let imageForEachSection = ["", "cm2_discover_icn_lang", "cm2_discover_icn_style",
                                           "cm2_discover_icn_scene", "cm2_discover_icn_emo", "cm2_discover_icn_theme",]
    fileprivate var isHotCell = [[false,],
                                 
                                 [true, false, false,
                                 false, false, false,],
                                 
                                 [true, true, true,
                                 true, false, false,
                                 true, false, false, false,
                                 false, false, false, false,
                                 false, false, false, false,
                                 false, false, false, false,
                                 false, false,],
                                 
                                 [false, true, true,
                                 false, false, false,
                                 false, false, true, false,
                                 false, false,],
                                 
                                 [true, true, false,
                                 false, false, true,
                                 false, false, false, false,
                                 false, false, false,],
                                 
                                 [true, true, false,
                                 false, false, false,
                                 false, false, false, false,
                                 false, false, false, false,
                                 false, false, false,],
                                 ]
    
    fileprivate func tapSectionOne() {
        if let cell = collectionView.cellForItem(at: selectedIndexPath) as? FilterSongSheetViewCell {
            cell.cellSelected = false
        }
        selectedSection = true
        UserDefaults.standard.setValue("全部", forKey: SongSheetViewController.SongSheetCategory)
        _ = self.navigationController?.popViewController(animated: true)
    }
}

extension FilterSongSheetViewController: UICollectionViewGridLayoutDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    // MARK: DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionSize.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        }
        let ret = sectionSize[section].0 * sectionSize[section].1 - 2
        return ret
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterSongSheetViewCell.identifier, for: indexPath) as! FilterSongSheetViewCell
        if titlesForEachCell[indexPath.section].count <= indexPath.row {
            cell.label.text = ""
        } else {
            cell.label.text = titlesForEachCell[indexPath.section][indexPath.row]
            cell.label.textColor = UIColor.black
            cell.label.font = UIFont.systemFont(ofSize: 12)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let fCell = cell as! FilterSongSheetViewCell
        fCell.cellSelected = selectedSection ? false : selectedIndexPath == indexPath
        fCell.isHot = false
        if indexPath.row < isHotCell[indexPath.section].count {
            fCell.isHot = isHotCell[indexPath.section][indexPath.row]
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        guard let sView = view as? FilterSongSheetViewSection else { return }
        if indexPath == IndexPath.init(row: 0, section: 0) {
            sView.isUserInteractionEnabled = true
            sView.tapActionForOutUse = tapSectionOne
            sView.sectionSelected = selectedSection
        } else {
            sView.isUserInteractionEnabled = false
            sView.tapActionForOutUse = nil
            sView.sectionSelected = false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: FilterSongSheetViewSection.kind, withReuseIdentifier: FilterSongSheetViewSection.identifier, for: indexPath) as! FilterSongSheetViewSection
        view.label.text = titlesForEachSection[indexPath.section]
        if indexPath.section == 0 {
            view.label.textColor = UIColor.black
            view.label.font = UIFont.systemFont(ofSize: 16)
        } else {
            view.label.textColor = FixedValue.mainRedColor
            view.label.font = UIFont.systemFont(ofSize: 13)
        }
        view.imageView.image = UIImage.init(named: imageForEachSection[indexPath.section])
        return view
    }
    
    // MARK: Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! FilterSongSheetViewCell
        if cell.label.text == "" {
            return
        }
        cell.cellSelected = true
        
        if let sectionOneView = collectionView.supplementaryView(forElementKind: FilterSongSheetViewSection.kind, at: IndexPath.init(row: 0, section: 0)) as? FilterSongSheetViewSection {
            sectionOneView.sectionSelected = false
        }
        
        if indexPath == selectedIndexPath {
            return
        }
        
        if let preSelectedCell = collectionView.cellForItem(at: selectedIndexPath) as? FilterSongSheetViewCell {
            preSelectedCell.cellSelected = false
        }
        selectedIndexPath = indexPath
        selectedSection = false
        
        UserDefaults.standard.setValue(cell.label.text, forKey: SongSheetViewController.SongSheetCategory)
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: UICollectionViewGridLayoutDelegate
    func numberOfColumnAndRow(inSection section: Int) -> (col: Int, row: Int) {
        return sectionSize[section]
    }
    
    func unitSize(inSection section: Int) -> CGSize {
        return CGSize(width: (self.view.width - 30)/4, height: 40)
    }
    
    func sectionPostion(inSection section: Int) -> (startPosition: UnitPosition, endPosition: UnitPosition) {
        if section == 0 {
            return (UnitPosition(x: 0, y: 0), UnitPosition(x: 4, y: 1))
        }
        return (UnitPosition(x: 0, y: 0), UnitPosition(x: 1, y: 2))
    }
}

class FilterSongSheetViewCell: UICollectionViewCell {
    static let identifier = "FilterSongSheetViewCell"
    let label = UILabel()
    var isHot = true {
        didSet {
            hotImageView.isHidden = !isHot
        }
    }
    var cellSelected = false {
        didSet {
            imageView.isHidden = !cellSelected
            if cellSelected {
                self.borderWidth = 2
                self.borderColor = FixedValue.mainRedColor
            } else {
                self.borderWidth = 0
            }
        }
    }
    
    fileprivate let hotImageView = UIImageView()
    fileprivate let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        addSubview(imageView)
        addSubview(hotImageView)
        
        imageView.image = UIImage.init(named: "cm2_pro_icn_check")
        hotImageView.image = UIImage.init(named: "cm2_lists_icn_hot_new")
        hotImageView.contentMode = .scaleAspectFill
        label.textAlignment = .center
        imageView.contentMode = .bottomRight
        imageView.backgroundColor = FixedValue.mainRedColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = self.bounds
        imageView.sizeToFit()
        imageView.bottom = self.bounds.height - 2
        imageView.right = self.bounds.width - 2
        
        hotImageView.sizeToFit()
        let factor = hotImageView.height / hotImageView.width
        hotImageView.width = 15
        hotImageView.height = 15 * factor
        hotImageView.right = self.bounds.width - 4
        hotImageView.top = 4
    }
}

class FilterSongSheetViewSection: UICollectionReusableView {
    static let identifier = "FilterSongSheetViewSection_ID"
    static let kind = "section"
    
    let label = UILabel()
    let imageView = UIImageView()
    var tapActionForOutUse: (()->())? = nil
    
    var sectionSelected = false {
        didSet {
            selectedImageView.isHidden = !sectionSelected
            if sectionSelected {
                self.borderWidth = 2
                self.borderColor = FixedValue.mainRedColor
            } else {
                self.borderWidth = 0
            }
        }
    }
    
    fileprivate let selectedImageView = UIImageView()
    fileprivate var tapGest = UITapGestureRecognizer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        addSubview(label)
        addSubview(selectedImageView)
        
        label.textAlignment = .center
        imageView.contentMode = .center
        selectedImageView.image = UIImage.init(named: "cm2_list_checkbox_ok")
        
        tapGest = UITapGestureRecognizer.init(target: self, action: #selector(tapAction(sender:)))
        self.addGestureRecognizer(tapGest)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let _ = imageView.image {
            selectedImageView.isHidden = true
            imageView.sizeToFit()
            label.sizeToFit()
            
            imageView.top = (self.bounds.height - (imageView.height + label.height))/2
            imageView.centerX = self.bounds.width/2
            label.centerX = imageView.centerX
            label.top = imageView.bottom + 4
        } else {
            imageView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            label.sizeToFit()
            label.top = (self.bounds.height - label.height)/2
            label.centerX = self.bounds.width/2
            
            selectedImageView.sizeToFit()
            selectedImageView.width *= 2/3
            selectedImageView.height *= 2/3
            selectedImageView.left = label.right + 4
            selectedImageView.centerY = label.centerY
        }
    }
    
    @objc fileprivate func tapAction(sender: UITapGestureRecognizer) {
        sectionSelected = true
        tapActionForOutUse?()
    }
}
