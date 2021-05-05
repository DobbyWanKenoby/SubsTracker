import UIKit

var str = "Hello, playground"

let template = "yMMMMd"
let usDateFormat = DateFormatter.dateFormat(fromTemplate: template, options: 0, locale: Locale.current)!

let locale = Locale.current
