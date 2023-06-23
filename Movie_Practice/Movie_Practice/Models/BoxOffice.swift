//
//  BoxOffice.swift
//  Movie_Practice
//
//  Created by 박진형 on 2023/05/21.
//

import Foundation

// MARK: - BoxOffice
struct BoxOffice: Codable {
    let boxOfficeResult: BoxOfficeResult
}

// MARK: - BoxOfficeResult
struct BoxOfficeResult: Codable {
    let boxofficeType, showRange: String
    let dailyBoxOfficeList: [DailyBoxOfficeList]
}

// MARK: - DailyBoxOfficeList
struct DailyBoxOfficeList: Codable  {
    let rnum, rank, rankInten: String
    let rankOldAndNew: String
    let movieCd, movieNm, openDt, salesAmt: String
    let salesShare, salesInten, salesChange, salesAcc: String
    let audiCnt, audiInten, audiChange, audiAcc: String
    let scrnCnt, showCnt: String
}
