//
//  CSVHelper.swift
//  MinorDianping
//
//  Created by Apple on 2017/5/23.
//  Copyright © 2017年 NJU.EE. All rights reserved.
//

import Foundation
class CSVHelper{
    // MARK: CSV File Functions
    private func cleanRows(file:String) -> String{
        // use a uniform \n for end of lines
        var cleanFile = file
        cleanFile = cleanFile.replacingOccurrences(of: "\r", with: "\n")
        cleanFile = cleanFile.replacingOccurrences(of: "\n\n", with: "\n")
        return cleanFile
    }

    private func getStringFieldsForRow(row: String, delimiter:String) -> [String]{
        return row.components(separatedBy: delimiter)
    }

    func convertCSV(file:String) -> [[String:String]]?{
        let rows = cleanRows(file: file).components(separatedBy: "\n")
        if rows.count > 0 {
            var data = [[String:String]]()
            let columnTitles = getStringFieldsForRow(row: rows.first!, delimiter: ",")
            for row in rows{
                let fields = getStringFieldsForRow(row: row, delimiter: ",")
                if fields.count != columnTitles.count{continue}
                var dataRow = [String:String]()
                for (index, field) in fields.enumerated(){
                    dataRow[columnTitles[index]] = field
                }
                data += [dataRow]
            }
            return data
        }
        else {
            print("No data in file")
        }
        return nil
    }

    // MARK: Data reading and writing functions
    func readDataFromFile(file:String, type: String) -> String!{
        guard let filepath = Bundle.main.path(forResource: file, ofType: type)
            else{
                return nil
        }
        do {
            let contents = try String(contentsOfFile: filepath, encoding: String.Encoding.utf8)
            return contents
        } catch {
            print("File Read Error")
            return nil
        }
    }
}
