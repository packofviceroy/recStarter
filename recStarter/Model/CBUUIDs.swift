//
//  CBUUIDs.swift
//  recStarter
//
//  Created by dumbo on 6/13/24.
//

import Foundation
import CoreBluetooth

struct CBUUIDs{

    static let kBLEService_UUID = "84c82c43-dead-beef-9eb9-2dcac4c36ee3"
    static let kBLE_Characteristic_uuid_Tx = "5657fb55-49ba-4cee-80da-654dcdf89af0"
    static let kBLE_Characteristic_uuid_Rx = "5657fb55-49ba-4cee-80da-654dcdf89af0"
    static let MaxCharacters = 20

    static let BLEService_UUID = CBUUID(string: kBLEService_UUID)
    static let BLE_Characteristic_uuid_Tx = CBUUID(string: kBLE_Characteristic_uuid_Tx)//(Property = Write without response)
    static let BLE_Characteristic_uuid_Rx = CBUUID(string: kBLE_Characteristic_uuid_Rx)// (Property = Read/Notify)

}
