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
    
    var tableView: UITableView!
//    = {
//        let table =  UITableView()
//        table.backgroundColor = .white
//        table.translatesAutoresizingMaskIntoConstraints = false
//        return table
//    }()
    
    lazy var peripheralFoundLabel: UILabel = {
        let textLabel = UILabel()
        
        textLabel.text = ""
        textLabel.font = .boldSystemFont(ofSize: 17)
        textLabel.textColor = .white
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        return textLabel
    }()
    
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
        setupTableView()
        addSubViews()
        setupConstraints()
        print(navigationController?.children)
        _centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    
    // MARK: - GUI functions
    private func setupStackView(){
        stackView.addArrangedSubview(peripheralFoundLabel)
        stackView.addArrangedSubview(textLabel)
        
    }
    
    private func setupTableView(){
        self.tableView = UITableView()
//            frame: CGRect(origin: CGPoint(x: 0,
//                                                                   y: Int(stackView.frame.maxY)),
//                                                   size: view.frame.size),
//                                     style: .plain)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.backgroundColor = .black
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.cellID)
        self.tableView.rowHeight = 55
        self.tableView.reloadData()

    }
    
    private func addSubViews(){
        view.addSubview(stackView)
        view.addSubview(tableView)
    }
    
    private func setupConstraints(){
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor
                                       ,constant: 30).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 15).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
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
    
    @objc
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
        navigationController?.navigationBar.topItem?.rightBarButtonItem?.isEnabled = false
        
        if _centralManager.state != .poweredOn
        {
            let controller = UIAlertController(title: "ERROR", message: "Can not scan because bluetooth is disabled", preferredStyle: .alert)
            controller.addAction(UIAlertAction(title:"EXIT", style: .default, handler: exitNoBluetooth))
            present(controller, animated: true)
        }
        
        // Start Scanning
        _centralManager?.scanForPeripherals(withServices: [CBUUIDs.BLEService_UUID])
        Timer.scheduledTimer(withTimeInterval: 7, repeats: false) {_ in
            self.stopScanning()
        }
    }
    
    func scanForBLEDevices() -> Void {
        // Remove prior data
        peripheralArray.removeAll()
        rssiArray.removeAll()
        navigationController?.navigationBar.topItem?.rightBarButtonItem?.isEnabled = false
        
        if _centralManager.state != .poweredOn
        {
            let controller = UIAlertController(title: "ERROR", message: "Can not scan because bluetooth is disabled", preferredStyle: .alert)
            controller.addAction(UIAlertAction(title:"EXIT", style: .default, handler: exitNoBluetooth))
            present(controller, animated: true)
        }
        
        // Start Scanning
        _centralManager?.scanForPeripherals(withServices: [] , options: [CBCentralManagerScanOptionAllowDuplicatesKey:true])
        Timer.scheduledTimer(withTimeInterval: 7, repeats: false) {_ in
            self.stopScanning()
        }
    }
    
    func exitNoBluetooth(action: UIAlertAction) {
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


// MARK: - CBCentralManagerDelegate
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
        
        self.view.reloadInputViews()
        self.tableView.reloadData()
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


extension HomeViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.peripheralArray.count != 0{
            print("self.peripheralArray count: \(self.peripheralArray.count)")
        }
        return self.peripheralArray.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: TableViewCell.cellID,for: indexPath) as! TableViewCell
        
        let peripheralFound = self.peripheralArray[indexPath.row]
        let rssiFound = self.rssiArray[indexPath.row]
        
        if peripheralFound == nil {
            cell.peripheralLabel.text = "Unknown"
        }else {
            if (peripheralFound.name ?? "").isEmpty{
                cell.peripheralLabel.text = "Name not Known"
            }else{
                cell.peripheralLabel.text = peripheralFound.name
            }
            cell.rssiLabel.text = "RSSI: \(rssiFound)"
        }
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate
// Methods for managing selections, deleting and reordering cells and performing other actions in a table view.
extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        bluefruitPeripheral = peripheralArray[indexPath.row]
//        
//        BlePeripheral.connectedPeripheral = bluefruitPeripheral
//        
//        connectToDevice()
        
    }
}
