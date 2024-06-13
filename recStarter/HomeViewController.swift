//
//  ViewController.swift
//  recStarter
//
//  Created by dumbo on 6/13/24.
//

import UIKit

import Foundation
import SwiftUI
import CoreBluetooth

class HomeViewController: UIViewController {
    
    
    // MARK: - BlueTooth var
    private var _centralManager: CBCentralManager!
    private var bluefruitPeripheral: CBPeripheral!
    private var txCharacteristic: CBCharacteristic!
    private var rxCharacteristic: CBCharacteristic!
    private var peripheralArray: [CBPeripheral] = []
    private var rssiArray = [NSNumber]()
    private var timer = Timer()
    
    
    // MARK: - GUI variables
    
    @IBOutlet weak var peripheralFoundLabel: UILabel!
    
    private lazy var textLabel: UILabel = {
        let textLabel = UILabel()
        
        textLabel.text = "Nearby devices:"
        textLabel.font = .boldSystemFont(ofSize: 36)
        textLabel.textColor = .white
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        return textLabel
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        
        view.axis = .vertical
        view.spacing = 10
        view.alignment = .center
        view.distribution = .equalSpacing
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        setupNavigationController()
        setupStackView()
        addSubViews()
        setupConstraints()
        
        _centralManager = CBCentralManager(delegate: self, queue: nil)
        
        
    }
    
    // MARK: - GUI functions
    private func setupStackView(){
        stackView.addArrangedSubview(textLabel)
        
    }
    private func addSubViews(){
        view.addSubview(stackView)
    }
    private func setupConstraints(){
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor
                                       ,constant: 30).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    private func setupNavigationController(){
        navigationItem.title = "Main Page"
        let button = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"),
                                     style: .done,
                                     target: self,
                                     action: #selector(actionfunc))
        button.isEnabled = true
        navigationController?.navigationBar.topItem?.rightBarButtonItem = button
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    @IBAction
    private func actionfunc(_ sender: Any){
        scanForBLEDevices()
    }
    
    func show(){
        let controller = UIAlertController(title: "ERROR", message: "SOME ERROR", preferredStyle: .alert)
        controller.addAction(UIAlertAction(title:"EXIT", style: .default))
        present(controller, animated: true)
        
    }
    
    // MARK: - BLUETOOTH functions
    func connectToDevice() -> Void {
        _centralManager?.connect(bluefruitPeripheral!, options: nil)
    }
    
    func disconnectFromDevice() -> Void {
        if bluefruitPeripheral != nil {
            _centralManager?.cancelPeripheralConnection(bluefruitPeripheral!)
        }
    }
    
    func removeArrayData() -> Void {
        _centralManager.cancelPeripheralConnection(bluefruitPeripheral)
        rssiArray.removeAll()
        peripheralArray.removeAll()
    }
    
    func startScanning() -> Void {
        // Remove prior data
        peripheralArray.removeAll()
        rssiArray.removeAll()
        // Start Scanning
        
        
        if _centralManager.state != .poweredOn
        {
            let controller = UIAlertController(title: "ERROR", message: "Can not scan because bluetooth is disabled", preferredStyle: .alert)
            controller.addAction(UIAlertAction(title:"EXIT", style: .default, handler: doSomething))
            present(controller, animated: true)
        }
        _centralManager?.scanForPeripherals(withServices: [CBUUIDs.BLEService_UUID])
        navigationController?.navigationBar.topItem?.rightBarButtonItem?.isEnabled = false
        Timer.scheduledTimer(withTimeInterval: 15, repeats: false) {_ in
            self.stopScanning()
        }
    }
    
    func scanForBLEDevices() -> Void {
        // Remove prior data
        peripheralArray.removeAll()
        rssiArray.removeAll()
        if _centralManager.state != .poweredOn
        {
            let controller = UIAlertController(title: "ERROR", message: "Can not scan because bluetooth is disabled", preferredStyle: .alert)
            controller.addAction(UIAlertAction(title:"EXIT", style: .default, handler: doSomething))
            present(controller, animated: true)
        }
        // Start Scanning
        _centralManager?.scanForPeripherals(withServices: [] , options: [CBCentralManagerScanOptionAllowDuplicatesKey:true])
        Timer.scheduledTimer(withTimeInterval: 15, repeats: false) {_ in
            self.stopScanning()
        }
    }
    
    func doSomething(action: UIAlertAction) {
        exit(0)
    }
    
    func stopTimer() -> Void {
        // Stops Timer
        self.timer.invalidate()
    }
    
    func stopScanning() -> Void {
        navigationController?.navigationBar.topItem?.rightBarButtonItem?.isEnabled = true
        _centralManager?.stopScan()
    }
    func delayedConnection() -> Void {
        
        BlePeripheral.connectedPeripheral = bluefruitPeripheral
        
        //          DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
        //            //Once connected, move to new view controller to manager incoming and outgoing data
        //            let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //
        //            let detailViewController = storyboard.instantiateViewController(withIdentifier: "ConsoleViewController") as! ConsoleViewController
        //
        //            self.navigationController?.pushViewController(detailViewController, animated: true)
        //          })
    }
    
}






extension HomeViewController: CBCentralManagerDelegate{
    
    // MARK: - Check
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        switch central.state {
        case .poweredOff:
            print("Is Powered Off.")
        case .poweredOn:
            print("Is Powered On.")
        case .unsupported:
            print("Is Unsupported.")
        case .unauthorized:
            print("Is Unauthorized.")
        case .unknown:
            print("Unknown")
        case .resetting:
            print("Resetting")
        @unknown default:
            show()
        }
    }
    
    // MARK: - Discover
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("Function: \(#function),Line: \(#line)")
        
        bluefruitPeripheral = peripheral
        
        if peripheralArray.contains(peripheral) {
            print("Duplicate Found.")
        } else {
            peripheralArray.append(peripheral)
            rssiArray.append(RSSI)
        }
        
        peripheralFoundLabel.text = "Peripherals Found: \(peripheralArray.count)"
        
        bluefruitPeripheral.delegate = self
        
        print("Peripheral Discovered: \(peripheral)")
        
        self.stackView.reloadInputViews()
    }
    
    // MARK: - Connect
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        stopScanning()
        bluefruitPeripheral.discoverServices([CBUUIDs.BLEService_UUID])
    }
}

// MARK: - CBPeripheralDelegate
// A protocol that provides updates on the use of a peripheral’s services.
extension HomeViewController: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        guard let services = peripheral.services else { return }
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
        BlePeripheral.connectedService = services[0]
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        guard let characteristics = service.characteristics else {
            return
        }
        
        print("Found \(characteristics.count) characteristics.")
        
        for characteristic in characteristics {
            
            if characteristic.uuid.isEqual(CBUUIDs.BLE_Characteristic_uuid_Rx)  {
                
                rxCharacteristic = characteristic
                
                BlePeripheral.connectedRXChar = rxCharacteristic
                
                peripheral.setNotifyValue(true, for: rxCharacteristic!)
                peripheral.readValue(for: characteristic)
                
                print("RX Characteristic: \(rxCharacteristic.uuid)")
            }
            
            if characteristic.uuid.isEqual(CBUUIDs.BLE_Characteristic_uuid_Tx){
                txCharacteristic = characteristic
                BlePeripheral.connectedTXChar = txCharacteristic
                print("TX Characteristic: \(txCharacteristic.uuid)")
            }
        }
        delayedConnection()
    }
    
    
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        var characteristicASCIIValue = NSString()
        
        guard characteristic == rxCharacteristic,
              
                let characteristicValue = characteristic.value,
              let ASCIIstring = NSString(data: characteristicValue, encoding: String.Encoding.utf8.rawValue) else { return }
        
        characteristicASCIIValue = ASCIIstring
        
        print("Value Recieved: \((characteristicASCIIValue as String))")
        
        NotificationCenter.default.post(name:NSNotification.Name(rawValue: "Notify"), object: "\((characteristicASCIIValue as String))")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        peripheral.readRSSI()
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        guard error == nil else {
            print("Error discovering services: error")
            return
        }
        print("Function: \(#function),Line: \(#line)")
        print("Message sent")
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        print("*******************************************************")
        print("Function: \(#function),Line: \(#line)")
        if (error != nil) {
            print("Error changing notification state:\(String(describing: error?.localizedDescription))")
            
        } else {
            print("Characteristic's value subscribed")
        }
        
        if (characteristic.isNotifying) {
            print ("Subscribed. Notification has begun for: \(characteristic.uuid)")
        }
    }
    
}



extension HomeViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell();
    }
    
    
    
}

extension HomeViewController: UICollectionViewDelegate{
    
}
