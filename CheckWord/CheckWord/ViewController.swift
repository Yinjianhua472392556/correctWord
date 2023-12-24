//
//  ViewController.swift
//  CheckWord
//
//  Created by admin on 2023/12/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // 示例用法
        let userInput1 = "handsome"
        let userInput2 = "handsme"
        let userInput3 = "handsomes"
        let userInput4 = "handsame"
        let userInput5 = "hsdsomefdh"

        let correctWord = "handsome"

        let attributedText1 = highlightErrors(userInput: userInput1, correctWord: correctWord)
        print(attributedText1)

        let attributedText2 = highlightErrors(userInput: userInput2, correctWord: correctWord)
        print(attributedText2)

        let attributedText3 = highlightErrors(userInput: userInput3, correctWord: correctWord)
        print(attributedText3)

        let attributedText4 = highlightErrors(userInput: userInput4, correctWord: correctWord)
        print(attributedText4)
        
        let attributedText5 = highlightErrors(userInput: userInput5, correctWord: correctWord)
        print(attributedText5)

//        let attributedText = highlightErrors(userInput: userInput, correctWord: correctWord)

        // 创建一个UILabel来显示带有颜色标识的文本
        let label = UILabel(frame: CGRect(x: 100, y: 100, width: 200, height: 40))
        label.attributedText = attributedText1

        // 添加label到视图中
        view.addSubview(label)
        
        // 创建一个UILabel来显示带有颜色标识的文本
        let label2 = UILabel(frame: CGRect(x: 100, y: CGRectGetMaxY(label.frame) + 10, width: 200, height: 40))
        label2.attributedText = attributedText2

        // 添加label到视图中
        view.addSubview(label2)

        
        // 创建一个UILabel来显示带有颜色标识的文本
        let label3 = UILabel(frame: CGRect(x: 100, y: CGRectGetMaxY(label2.frame) + 10, width: 200, height: 40))
        label3.attributedText = attributedText3

        // 添加label到视图中
        view.addSubview(label3)

        
        // 创建一个UILabel来显示带有颜色标识的文本
        let label4 = UILabel(frame: CGRect(x: 100, y: CGRectGetMaxY(label3.frame) + 10, width: 200, height: 40))
        label4.attributedText = attributedText4

        // 添加label到视图中
        view.addSubview(label4)

        
        // 创建一个UILabel来显示带有颜色标识的文本
        let label5 = UILabel(frame: CGRect(x: 100, y: CGRectGetMaxY(label4.frame) + 10, width: 200, height: 40))
        label5.attributedText = NSAttributedString(string: "正确单词:\(correctWord)")

        // 添加label到视图中
        view.addSubview(label5)


        // 创建一个UILabel来显示带有颜色标识的文本
        let label6 = UILabel(frame: CGRect(x: 100, y: CGRectGetMaxY(label5.frame) + 10, width: 200, height: 40))
        label6.attributedText = attributedText5

        // 添加label到视图中
        view.addSubview(label6)

    }
    

    
    // 高亮编辑错误的部分并返回带有属性的NSAttributedString
    func highlightErrors(userInput: String, correctWord: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: "")
        
        let distance = levenshteinDistance(correctWord, userInput)
        
        
        for object in distance {
            
            let currentAttributedString = NSMutableAttributedString(string: "")

            switch object.edit {
            case .unchanged:
                currentAttributedString.append(NSAttributedString(string: "\(String(describing: object.char1!))"))
                let range = NSRange(location: 0, length: currentAttributedString.length)
                currentAttributedString.addAttribute(.foregroundColor, value: UIColor.green, range: range)
            case .deletion:
                currentAttributedString.append(NSAttributedString(string: "_"))
                let range = NSRange(location: 0, length: currentAttributedString.length)
                currentAttributedString.addAttribute(.foregroundColor, value: UIColor.red, range: range)
            case .insertion:
                currentAttributedString.append(NSAttributedString(string: "\(String(describing: object.char2!))"))
                let range = NSRange(location: 0, length: currentAttributedString.length)
                currentAttributedString.addAttribute(.foregroundColor, value: UIColor.red, range: range)
            case .substitution:
                currentAttributedString.append(NSAttributedString(string: "\(String(describing: object.char2!))"))
                let range = NSRange(location: 0, length: currentAttributedString.length)
                currentAttributedString.addAttribute(.foregroundColor, value: UIColor.red, range: range)
            }
            
            attributedString.append(currentAttributedString)
        }
        
        return attributedString
    }

    // 计算两个字符串之间的Levenshtein距离
    func levenshteinDistance(_ word1: String, _ word2: String) -> [(edit: Edit, char1: Character?, char2: Character?)] {
        let m = word1.count
        let n = word2.count
        var distance: [[Int]] = Array(repeating: Array(repeating: 0, count: n + 1), count: m + 1)
        
        for i in 0...m {
            distance[i][0] = i
        }
        
        for j in 0...n {
            distance[0][j] = j
        }
        
        for i in 1...m {
            for j in 1...n {
                let index1 = word1.index(word1.startIndex, offsetBy: i - 1)
                let index2 = word2.index(word2.startIndex, offsetBy: j - 1)
                
                if word1[index1] == word2[index2] {
                    distance[i][j] = distance[i - 1][j - 1]
                } else {
                    distance[i][j] = min(
                        distance[i - 1][j] + 1, // 删除
                        distance[i][j - 1] + 1, // 插入
                        distance[i - 1][j - 1] + 1 // 替换
                    )
                }
            }
        }
        
        var i = m
        var j = n
        var edits: [(edit: Edit, char1: Character?, char2: Character?)] = []
        
        while i > 0 || j > 0 {
            if i > 0 && j > 0 && word1[word1.index(word1.startIndex, offsetBy: i - 1)] == word2[word2.index(word2.startIndex, offsetBy: j - 1)] {
                edits.insert((.unchanged, word1[word1.index(word1.startIndex, offsetBy: i - 1)], word2[word2.index(word2.startIndex, offsetBy: j - 1)]), at: 0)
                i -= 1
                j -= 1
            } else if i > 0 && distance[i][j] == distance[i - 1][j] + 1 {
                edits.insert((.deletion, word1[word1.index(word1.startIndex, offsetBy: i - 1)], nil), at: 0)
                i -= 1
            } else if j > 0 && distance[i][j] == distance[i][j - 1] + 1 {
                edits.insert((.insertion, nil, word2[word2.index(word2.startIndex, offsetBy: j - 1)]), at: 0)
                j -= 1
            } else if i > 0 && j > 0 {
                edits.insert((.substitution, word1[word1.index(word1.startIndex, offsetBy: i - 1)], word2[word2.index(word2.startIndex, offsetBy: j - 1)]), at: 0)
                i -= 1
                j -= 1
            }
        }
        
        while i > 0 {
            edits.insert((.deletion, word1[word1.index(word1.startIndex, offsetBy: i - 1)], nil), at: 0)
            i -= 1
        }
        
        while j > 0 {
            edits.insert((.insertion, nil, word2[word2.index(word2.startIndex, offsetBy: j - 1)]), at: 0)
            j -= 1
        }
        
        return edits
    }

    // 编辑操作类型
    enum Edit {
        case unchanged
        case deletion
        case insertion
        case substitution
    }

}

