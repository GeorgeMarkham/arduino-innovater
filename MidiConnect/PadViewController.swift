//
//  PadViewController.swift
//  MidiConnect
//
//  Created by George Markham on 19/03/2019.
//  Copyright © 2019 George Markham. All rights reserved.
//

import Cocoa

class PadViewController: NSViewController {
    @IBOutlet var pad0Btn: NSButton!
    @IBOutlet var pad1Btn: NSButton!
    @IBOutlet var pad2Btn: NSButton!
    @IBOutlet var pad3Btn: NSButton!
    @IBOutlet var pad4Btn: NSButton!
    @IBOutlet var pad5Btn: NSButton!
    
    @IBOutlet var pad0Selector: NSPopUpButton!
    @IBOutlet var pad1Selector: NSPopUpButton!
    @IBOutlet var pad2Selector: NSPopUpButton!
    @IBOutlet var pad3Selector: NSPopUpButton!
    @IBOutlet var pad4Selector: NSPopUpButton!
    @IBOutlet var pad5Selector: NSPopUpButton!
    
    
    let notesNums: [uint8] = [21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108]
    let notesNames: [String] = ["A0", "B0", "C0", "D0", "E0", "F0", "A1", "B1", "C1", "D1", "E1", "F1", "A2", "B2", "C2", "D2", "E2", "F2", "A3", "B3", "C3", "D3", "E3", "F3", "A4", "B4", "C4", "D4", "E4", "F4", "A5", "B5", "C5", "D5", "E5", "F5", "A6", "B6", "C6", "D6", "E6", "F6", "A7", "B7", "C7", "D7", "E7", "F7", "A8", "B8", "C8", "D8", "E8", "F8"]
    
    var midiController: MCMidi?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        pad0Selector.removeAllItems()
        pad1Selector.removeAllItems()
        pad2Selector.removeAllItems()
        pad3Selector.removeAllItems()
        pad4Selector.removeAllItems()
        pad5Selector.removeAllItems()
        
        
        pad0Selector.addItems(withTitles: notesNames)
        pad1Selector.addItems(withTitles: notesNames)
        pad2Selector.addItems(withTitles: notesNames)
        pad3Selector.addItems(withTitles: notesNames)
        pad4Selector.addItems(withTitles: notesNames)
        pad5Selector.addItems(withTitles: notesNames)
        
        midiController = MCMidi.mcMidiInstance
    }
    
    @IBAction func pad0SelectorAction(_ sender: Any) {
        let selected: NSMenuItem = pad0Selector.selectedItem!
        let idx = pad0Selector.index(of: selected)
        let note = notesNums[idx]
        print("Selected: \(notesNames[idx])")
        midiController?.pads[0].setNote(note: note)
    }
    @IBAction func pad1SelectorAction(_ sender: Any) {
        let selected: NSMenuItem = pad1Selector.selectedItem!
        let idx = pad1Selector.index(of: selected)
        let note = notesNums[idx]
        print("Selected: \(notesNames[idx])")
        midiController?.pads[1].setNote(note: note)
    }
    @IBAction func pad2SelectorAction(_ sender: Any) {
        let selected: NSMenuItem = pad2Selector.selectedItem!
        let idx = pad2Selector.index(of: selected)
        let note = notesNums[idx]
        print("Selected: \(notesNames[idx])")
        midiController?.pads[2].setNote(note: note)
    }
    @IBAction func pad3SelectorAction(_ sender: Any) {
        let selected: NSMenuItem = pad3Selector.selectedItem!
        let idx = pad3Selector.index(of: selected)
        let note = notesNums[idx]
        print("Selected: \(notesNames[idx])")
        midiController?.pads[3].setNote(note: note)
    }
    @IBAction func pad4SelectorAction(_ sender: Any) {
        let selected: NSMenuItem = pad4Selector.selectedItem!
        let idx = pad4Selector.index(of: selected)
        let note = notesNums[idx]
        print("Selected: \(notesNames[idx])")
        midiController?.pads[4].setNote(note: note)
    }
    @IBAction func pad5SelectorAction(_ sender: Any) {
        let selected: NSMenuItem = pad5Selector.selectedItem!
        let idx = pad5Selector.index(of: selected)
        let note = notesNums[idx]
        print("Selected: \(notesNames[idx])")
        midiController?.pads[5].setNote(note: note)
    }
    
    @IBAction func pad0BtnAction(_ sender: Any) {
        midiController?.sendNoteOn(note: midiController?.pads[0].getNote() ?? 0x00, velocity: 100)
        usleep(5000)
        midiController?.sendNoteOff()
    }
    @IBAction func pad1BtnAction(_ sender: Any) {
        midiController?.sendNoteOn(note: midiController?.pads[1].getNote() ?? 0x00, velocity: 100)
        usleep(5000)
        midiController?.sendNoteOff()
    }
    @IBAction func pad2BtnAction(_ sender: Any) {
        midiController?.sendNoteOn(note: midiController?.pads[2].getNote() ?? 0x00, velocity: 100)
        usleep(5000)
        midiController?.sendNoteOff()
    }
    @IBAction func pad3BtnAction(_ sender: Any) {
        midiController?.sendNoteOn(note: midiController?.pads[3].getNote() ?? 0x00, velocity: 100)
        usleep(5000)
        midiController?.sendNoteOff()
    }
    @IBAction func pad4BtnAction(_ sender: Any) {
        midiController?.sendNoteOn(note: midiController?.pads[4].getNote() ?? 0x00, velocity: 100)
        usleep(5000)
        midiController?.sendNoteOff()
    }
    @IBAction func pad5BtnAction(_ sender: Any) {
        midiController?.sendNoteOn(note: midiController?.pads[5].getNote() ?? 0x00, velocity: 100)
        usleep(5000)
        midiController?.sendNoteOff()
    }
}
