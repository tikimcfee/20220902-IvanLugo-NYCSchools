//
//  TestBundle.swift
//  NYSCV Unit Tests
//
//  Created by Ivan Lugo on 8/31/22.
//

class TestBundle {
    
}

let lineSpace = Array(repeating: "\n", count: 3).joined()

func printStartDivider() {
    print(Array(repeating: "+", count: 32).joined(), lineSpace)
}

func printEndDivider() {
    print(lineSpace, Array(repeating: "-", count: 32).joined())
}
