//
//  KYPasterHotKey.swift
//  LYPasteSwift
//
//  Created by user on 2022/5/5.
//

import Cocoa
import Carbon

class LYPasterHotKey {

    class func setupHotKey() {
        let hotKeyId = EventHotKeyID(signature: UTGetOSTypeFromString("LYPaster" as CFString), id: 0)
        var carbonHotKey: EventHotKeyRef?
        let _ = RegisterEventHotKey(UInt32(Keycode.v),
                                        UInt32(cmdKey) | UInt32(shiftKey),
                                        hotKeyId,
                                        GetEventDispatcherTarget(),
                                        0,
                                        &carbonHotKey)
        installHotKeyPressedEventHandler()
    }
    
    class func installHotKeyPressedEventHandler() {
        var pressedEventType = EventTypeSpec()
        pressedEventType.eventClass = OSType(kEventClassKeyboard)
        pressedEventType.eventKind = OSType(kEventHotKeyPressed)
        
        InstallEventHandler(GetEventDispatcherTarget(), { _, inEvent, _ -> OSStatus in
            return LYPasterHotKey.sendPressedKeyboardEvent(inEvent!)
        }, 1, &pressedEventType, nil, nil)
    }

    class func sendPressedKeyboardEvent(_ event: EventRef) -> OSStatus {
         assert(Int(GetEventClass(event)) == kEventClassKeyboard, "Unknown event class")

         var hotKeyId = EventHotKeyID()
         let error = GetEventParameter(event,
                                       EventParamName(kEventParamDirectObject),
                                       EventParamName(typeEventHotKeyID),
                                       nil,
                                       MemoryLayout<EventHotKeyID>.size,
                                       nil,
                                       &hotKeyId)

         guard error == noErr else { return error }

         switch GetEventKind(event) {
         case EventParamName(kEventHotKeyPressed):
             debugPrint("sssssssssssssssssss")
             LYPasterShowManager.instance.toggleWindow()

         default:
             assert(false, "Unknown event kind")
         }
         return noErr
     }
}
