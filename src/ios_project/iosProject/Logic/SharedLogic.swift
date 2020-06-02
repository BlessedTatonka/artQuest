//  SharedLogic.swift
//  Birthday. (C) Dmitry Alexandrov
//  Business.RF
import Foundation

struct SharedLogic
{
    static var instance: SharedLogic {
        struct Singleton {
            static let instance = SharedLogic()
        }
        return Singleton.instance
    }

    
    let logic = QuestLogic()
    let questionLogic = QuestionLogic()
    let userLogic = UserLogic()
}
