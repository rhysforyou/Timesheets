//
//  IntentHandler.swift
//  TimesheetPalIntents
//
//  Created by Rhys Powell on 20/9/18.
//  Copyright © 2018 Rhys Powell. All rights reserved.
//

import Intents

class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
        if intent is LogTimesheetEntryIntent {
            return LogTimesheetEntryIntentHandler()
        }
        
        return self
    }
    
}
