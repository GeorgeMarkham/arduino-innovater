//
//  Pad.swift
//  MidiConnect
//
//  Created by George Markham on 19/03/2019.
//  Copyright © 2019 George Markham. All rights reserved.
//

import Foundation

class Pad {
    var padNum:MCMidi.padStates
    var note: uint8
    
    init(padNum:MCMidi.padStates, note: uint8) {
        self.padNum = padNum
        self.note = note // MIDI Note number
    }
    
    func setNote(note: uint8){
        self.note = note
    }
    func getNote() -> uint8 {
        return self.note
    }
}
