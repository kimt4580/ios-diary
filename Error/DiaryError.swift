//
//  DiaryError.swift
//  Diary
//
//  Created by 김태훈 on 2022/06/20.
//

import Foundation

enum DiaryError: String, Error{
    case decodeError
    case invalidFileName
    
    var errorDescription: String? {
        switch self {
        case .decodeError:
            return "디코드 오류"
        case .invalidFileName:
            return "파일명 오류"
        }
    }
}
