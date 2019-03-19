//
//  MCMidi.swift
//  MidiConnect
//
//  Created by George Markham on 17/03/2019.
//  Copyright © 2019 George Markham. All rights reserved.
//

import Foundation
import CoreMIDI

class MCMidi {
    
    public static let mcMidiInstance = MCMidi()
    
    var clientRefName: CFString?
    var outPortRefName: CFString?
    var midiClientRef: MIDIClientRef = MIDIClientRef(0)
    var midiOutPortRef: MIDIPortRef = MIDIPortRef(0)
    var destination: MIDIEndpointRef = MIDIGetDestination(0)
    
    var pads:[Pad] = [Pad(padNum: .pad_0, note: 21), Pad(padNum: .pad_1, note: 21), Pad(padNum: .pad_2, note: 21), Pad(padNum: .pad_3, note: 21), Pad(padNum: .pad_4, note: 21), Pad(padNum: .pad_5, note: 21)]
    
    
    /* PAD ENUM, support up to 6 pads (0..5) */
    enum padStates {
        case pad_0
        case pad_1
        case pad_2
        case pad_3
        case pad_4
        case pad_5
        case no_pad
    }
    
    init() {
        
    }
    
    func setup(clientRefName: CFString, outPortRefName: CFString, midiClientRefNum: MIDIClientRef, midiOutPortRefNum: MIDIPortRef, destinationNum: Int) {
        self.clientRefName = clientRefName
        self.outPortRefName = outPortRefName
        self.midiClientRef = MIDIClientRef(midiClientRefNum)
        self.midiOutPortRef = midiOutPortRefNum
        self.destination = MIDIGetDestination(destinationNum)
        
        MIDIClientCreate(self.clientRefName ?? "MCClient" as CFString, nil, nil, &self.midiClientRef)
        MIDIOutputPortCreate(self.midiClientRef, self.outPortRefName ?? "MCOutPort" as CFString, &self.midiOutPortRef)
    }
    
    static func getDestinations() -> [MIDIEndpointRef] {
        let n = MIDIGetNumberOfDestinations()
        var destinations = [MIDIEndpointRef]()
        for i in 0...n-1 {
            destinations.append(MIDIGetDevice(i))
        }
        return destinations
    }
    
    func sendNoteOn(note:UInt8, velocity: UInt8) {
        var packet: MIDIPacket = MIDIPacket()
        packet.length = 4
        packet.timeStamp = 0
        packet.data.0 = 0x90 // Note On
        packet.data.1 = note
        packet.data.2 = velocity
        
        var packetList = MIDIPacketList(numPackets: 1, packet: packet)
        
        MIDISend(self.midiOutPortRef, self.destination, &packetList)
        print("Sending note: \(note)...")
    }
    
    func sendNoteOff() {
        var packet: MIDIPacket = MIDIPacket()
        packet.data.0 = 0x80 // Note On
        packet.data.2 = 0
        
        var packetList = MIDIPacketList(numPackets: 1, packet: packet)
        
        MIDISend(self.midiOutPortRef, self.destination, &packetList)
        
    }
    
    func setPadNote(padIdx:Int, note: uint8){
        self.pads[padIdx].setNote(note: note)
    }
    
    func padNote(pad:padStates) -> uint8 {
        switch pad {
            case .pad_0:
                return self.pads[0].getNote()
            case .pad_1:
                return self.pads[1].getNote()
            case .pad_2:
                return self.pads[2].getNote()
            case .pad_3:
                return self.pads[3].getNote()
            case .pad_4:
                return self.pads[4].getNote()
            case .pad_5:
                return self.pads[5].getNote()
            default:
                return 0x00
        }
    }
    
}
