//
//  ViewController.swift
//  MidiConnect
//
//  Created by George Markham on 06/03/2019.
//  Copyright © 2019 George Markham. All rights reserved.
//

import Cocoa
import CoreBluetooth
import CoreMIDI

class MainViewController: NSViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    var centralManager: CBCentralManager?
    var peripherals = Array<CBPeripheral>()
    var connectedDevice: CBPeripheral?
    var isConnectedToPeripheral: Bool = false

    var midiController: MCMidi?
    
    @IBOutlet var connectedStatusLabel: NSTextField!

    @IBOutlet var bluetoothStatusLabel: NSTextField!

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if error != nil {
            print(error.debugDescription)
        }
        for service in peripheral.services ?? []{
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }

    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        print("Listening to \(characteristic.uuid.uuidString)")
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else {return}
        for characteristic in characteristics{
            peripheral.setNotifyValue(true, for: characteristic)
            peripheral.readValue(for: characteristic)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let data = characteristic.value else {return}
        let dataStr = String(bytes: data, encoding: .utf8)
        let dataArr = dataStr?.split(separator: "\r\n")
        let pad: MCMidi.padStates = calcMode(arr: dataArr ?? [])
        print("Pad:\t\(pad)")
        midiController?.sendNoteOn(note: midiController?.padNote(pad: pad) ?? 0x00, velocity: 100)
        usleep(5000)
        midiController?.sendNoteOff()
        usleep(500000) // Wait half a second
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            bluetoothStatusLabel.textColor = NSColor(calibratedRed: 1.0, green: 1.0, blue: 1.0, alpha: 0.0)
            bluetoothStatusLabel.stringValue = ""
            bluetoothStatusLabel.isHidden = true
            central.scanForPeripherals(withServices: nil, options: nil)
            break;
        case .unknown:
            bluetoothStatusLabel.isHidden = false
            bluetoothStatusLabel.textColor = NSColor(calibratedRed: 1.0, green: 0.1, blue: 0.1, alpha: 1.0)
            bluetoothStatusLabel.stringValue = "Unknown"
        case .resetting:
            bluetoothStatusLabel.isHidden = false
            bluetoothStatusLabel.textColor = NSColor(calibratedRed: 1.0, green: 0.1, blue: 0.1, alpha: 1.0)
            bluetoothStatusLabel.stringValue = "Resetting"
        case .unsupported:
            bluetoothStatusLabel.isHidden = false
            bluetoothStatusLabel.textColor = NSColor(calibratedRed: 1.0, green: 0.1, blue: 0.1, alpha: 1.0)
            bluetoothStatusLabel.stringValue = "Unsupported"
        case .unauthorized:
            bluetoothStatusLabel.isHidden = false
            bluetoothStatusLabel.textColor = NSColor(calibratedRed: 1.0, green: 0.1, blue: 0.1, alpha: 1.0)
            bluetoothStatusLabel.stringValue = "Unauthorized"
        case .poweredOff:
            bluetoothStatusLabel.isHidden = false
            bluetoothStatusLabel.textColor = NSColor(calibratedRed: 1.0, green: 0.1, blue: 0.1, alpha: 1.0)
            bluetoothStatusLabel.stringValue = "Bluetooth is off"
        }
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to \(peripheral.name ?? "")")
        connectedStatusLabel.stringValue = "Connected"
        connectedStatusLabel.textColor = NSColor(calibratedRed: 0.1, green: 1.0, blue: 0.2, alpha: 1.0)
        peripheral.delegate = self
        isConnectedToPeripheral = true
        central.stopScan()
        peripheral.discoverServices(nil)
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected from \(peripheral.name ?? "")")
        connectedStatusLabel.stringValue = "Not connected"
        connectedStatusLabel.textColor = NSColor(calibratedRed: 1.0, green: 0.1, blue: 0.1, alpha: 1.0)
        isConnectedToPeripheral = false
        if !(centralManager?.isScanning ?? true) {
            centralManager?.scanForPeripherals(withServices: nil, options: nil)
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        print("Found:\t\(peripheral.name ?? "")")
        
        if peripheral.name == "DSD TECH"{
            //Connect
            central.connect(peripheral, options: nil)
            connectedDevice = peripheral
        }
    }

    func calcMode(arr:Array<Substring>) -> MCMidi.padStates{
        var hist : Array<Int> = [0,0,0,0,0, 0]
        for val in arr {
            let n: Int = Int(val) ?? 100
            if n <= 6 {
                hist[n] += 1
            }
        }
        var largestVal = 0
        var largestIdx = 0
        for idx in (0...5){
            let val = hist[idx]
            if val > largestVal {
                largestVal = val
                largestIdx = idx
            }
        }
        switch largestIdx {
        case 0:
            return MCMidi.padStates.pad_0
        case 1:
            return MCMidi.padStates.pad_1
        case 2:
            return MCMidi.padStates.pad_2
        case 3:
            return MCMidi.padStates.pad_3
        case 4:
            return MCMidi.padStates.pad_4
        case 5:
            return MCMidi.padStates.pad_5
        default:
            return MCMidi.padStates.no_pad
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//         Do any additional setup after loading the view.
        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
        midiController = MCMidi.mcMidiInstance
        midiController?.setup(clientRefName: "MCClient" as CFString, outPortRefName: "MCOut" as CFString, midiClientRefNum: 0, midiOutPortRefNum: 0, destinationNum: 0)
    }

    func getMC() -> MCMidi? {
        if self.midiController != nil {
            return self.midiController!
        } else {
            return nil
        }
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

