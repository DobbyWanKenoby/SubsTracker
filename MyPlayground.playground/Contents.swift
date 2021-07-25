import UIKit



//1
typealias Coordinates = (alpha: Character?, num: Int?)
//2
typealias Chessman = [String:Coordinates]
//3
var figures:Chessman = [:]
figures["White King"] = (alpha: "B", num: 1)
figures["White Queen"] = (alpha: nil, num: nil)
figures["Black King"] = (alpha: "F", num: 6)
//4
for oneFigure in figures {
    if oneFigure.value.0 != nil && oneFigure.value.1 != nil {
        print("Фигура на поле")
    }else{
        print("Фигура не на поле")
    }
}


func searchMaxSequenceLength(inputArray: [Int], firstIndex: Int, maxSequenceCount: inout Int) -> Int {
    
    guard inputArray.count > 0 else {
        return 0
    }
    
    for (index, _) in inputArray.enumerated() {
        print(index, firstIndex)
        guard index >= firstIndex else {
            continue
        }
        let array = inputArray[firstIndex...index]
        if array.count == Set(array).count {
            if maxSequenceCount < array.count {
                maxSequenceCount = array.count
            }
        } else {
            searchMaxSequenceLength(inputArray: inputArray, firstIndex: firstIndex+1, maxSequenceCount: &maxSequenceCount)
        }
    }
    return maxSequenceCount
}

var count = 0

searchMaxSequenceLength(inputArray: [1,23,4,5,1,4,57,23,4,1,23,6,7,1,2,4], firstIndex:0, maxSequenceCount: &count)


protocol aa {
    var a: String { get }
}

class bb: aa {
    var a: String { return "asd" }
    
}

