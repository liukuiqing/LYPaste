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
//                                    UInt32(cmdKey) | UInt32(optionKey),
                                        hotKeyId,
                                        GetEventDispatcherTarget(),
                                        0,
                                        &carbonHotKey)
        
        let escHotKeyId = EventHotKeyID(signature: UTGetOSTypeFromString("LYPaster_ESC" as CFString), id: 1)
        let _ = RegisterEventHotKey(UInt32(Keycode.escape),
                                    UInt32(kNullCharCode),
                                    escHotKeyId,
                                    GetApplicationEventTarget(),
                                    0,
                                    &carbonHotKey)
        installHotKeyPressedEventHandler()
        /*
//        let escape = NSEvent.EventTypeMask(rawValue: UInt64(Keycode.escape))
        let escape = NSEvent.EventTypeMask.flagsChanged
        NSEvent.addLocalMonitorForEvents(matching: escape) { event in
            print("modifierFlags==> \(event.modifierFlags.rawValue) ")
            return event
        }
        NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { event in
            print("keyUp3242==> \(event.modifierFlags.rawValue) ")
//            return event
        }
//        UIApplicationDidReceiveKeyDownNotification
//        NSUserNotificationCenter.default.addObserver(<#T##observer: NSObject##NSObject#>, forKeyPath: <#T##String#>, context: <#T##UnsafeMutableRawPointer?#>)
         */
    }
//    模拟键盘事件
    class func postKeyboardEvent(_ virtualKey:CGKeyCode, keyDown:Bool,flags:CGEventFlags) {
        let source = CGEventSource(stateID: .privateState)
        let push = CGEvent(keyboardEventSource: source, virtualKey: virtualKey, keyDown: keyDown)
//        push?.flags = flags
//        CGEvent.tapPostEvent(push!)
//        let source = CGEventSourceCreate(.privateState)
//        let push = CGEventCreateKeyboardEvent(source, virtualKey, keyDown)
//        push.post(tap: kCGHIDEventTap)
        push?.post(tap: .cghidEventTap)
        
//        CGEventSetFlags(push, flags);
//        CGEventPost(kCGHIDEventTap, push);
//        CFRelease(push);
//        CFRelease(source);
        // 模拟按下键盘按键
               let keyDownEvent = NSEvent.keyEvent(
                   with: .keyDown,
                   location: NSPoint(x: 0, y: 0),
                   modifierFlags: [],
                   timestamp: 0,
                   windowNumber: 0,
                   context: nil,
                   characters: "",
                   charactersIgnoringModifiers: "",
                   isARepeat: false,
                   keyCode: virtualKey
               )
               NSApplication.shared.postEvent(keyDownEvent!, atStart: true)
               
        
        // 获取其他应用程序的输入框元素
//                let inputField = AXUIElementCreateApplication(
//                    ProcessSerialNumber(highLongOfPSN: 0, lowLongOfPSN: UInt32(kCurrentProcess)),
//                    pid_t(YourAppProcessID)
//                ).getElement()
        
        var appBundleIdentifier = "com.example.targetapp" // 目标应用程序的 Bundle Identifier
        let workspace = NSWorkspace.shared
        if let frontApp = workspace.frontmostApplication {
            print("Bundle Identifier: \(frontApp.bundleIdentifier ?? "")")
            print("LocalizedName: \(frontApp.localizedName ?? "")")
            appBundleIdentifier = frontApp.bundleIdentifier ?? ""
        }
        
        // 获取其他应用程序的输入框元素
        let targetApp = NSRunningApplication.runningApplications(withBundleIdentifier: appBundleIdentifier).first
        // 模拟粘贴操作
        if ((targetApp?.activate(options: .activateAllWindows)) != nil) {
            // 使用辅助功能 API 模拟键盘操作
            let pasteEvent = NSAppleScript(source: """
                        tell application "System Events"
                        keystroke "v" using {command down}
                        end tell
                        """)
            pasteEvent?.executeAndReturnError(nil)
        }
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
            if hotKeyId.id == 1{
                LYPasterShowManager.instance.hideWindow()
//                postKeyboardEvent( Keycode.v | Keycode.command, keyDown: true, flags: CGEventFlags.init(rawValue: 0))
            }else{
                LYPasterShowManager.instance.toggleWindow()
            }
            break
            
        default:
            assert(false, "Unknown event kind")
        }
         return noErr
     }
}
