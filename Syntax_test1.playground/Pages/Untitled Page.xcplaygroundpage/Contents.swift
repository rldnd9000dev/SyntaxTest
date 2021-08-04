import UIKit

var greeting = "Hello, playground"
print(greeting)

var minValue = UInt8.min
var maxValue = UInt8.max


// 'Call Stack' 이해 1
func stack3() {
    print("stack3 입니다.")
}
func stack2() {
    stack3()
}
func stack1() {
    stack2()
}

stack1()


// 'Call Stack' 이해 2 (재귀함수)
func recursiveFunc(num: Int) {
    
    guard num <= 3 else {
        return
    }
    
    print("num 값 : \(num)")
    recursiveFunc(num: num + 1)
}

recursiveFunc(num: 1)


// 클래스 비교

class Person {
    
    var name: String?
    
    init(name: String) {
        self.name = name
    }
}

let minsu = Person(name: "minsu")

if minsu is Person {
    print("minsu is person")
}


struct Animal {
    
    var name: String?
    
    init(name: String) {
        self.name = name
    }
}

let bb = Animal(name: "bb")

if bb.name is String {
    print("bb is Animal")
}


// UpCasting
class Figure {
    
    var name: String?
    
    init(name: String) {
        self.name = name
    }
    
    func draw() {
        print("draw\(name)")
    }
    
}


class Rectangle: Figure {
    
    var width = 0.0
    var height = 0.0
    
    override func draw() {
        super.draw()
        //print("\(width) , \(height)")
    }
}


class Square: Rectangle {}

let f = Figure(name: "figure")
//f.draw()

let r = Rectangle(name: "Rect")
r.name
//r.draw()

let s = Square(name: "square")
//s.draw()


// as = Up Casting, 'Figure' 함수만 사용 가능, 'Rectangle' 의 'width', 'height' 프로퍼티 호출 불가능
let asRectangle = Rectangle(name: "asRectangle") as Figure
asRectangle.draw()



// String => Int 형 변환
// Int() : 숫자가 아닌 값이 있을 수 있으므로, Optional 반환
var count = "5"
let intCount = Int(count)
print(intCount)

// Int => String 형 변환
// Int 로 변환된 Optional 값을 활용하려면, Optional binding 을 해야함
let strCount = String(intCount!)
print(strCount)





class Drawable {
    var draws: [Drawable] = []
    
    func drawing(){
        print("i'm \(self)")
    }
}

class Paint: Drawable {
    
}

class Pen: Drawable {
    
}

class ApplePen: Drawable {
    
}

let draw = Drawable()
let pen = Paint()
draw.draws = [pen, Pen(), ApplePen()]
//draw.drawing()

// '===' : 메모리주소가 같으면 true
// 자바에서 String '==' 비교하는것과 같음
// 자바에서 String '==' 비교는, 메모리 주소를 비교함, 값 자체를 비교하는 것은 'A.equals(B)'

for item in draw.draws {
    if item === pen {
        item.drawing()
    }
}

 
for item in draw.draws {
    if item is ApplePen {
        item.drawing()
    }
}




// 'Codable' 파싱을 위한 Json String 예시

let str = """
{
 "result": "0000",
 "messages": "Success",
 "data": {
 "health_point": 8,
 "shop_point": 0,
 "history": [
 {
 "type": 2,
 "point": 2,
 "description": "혈압 측정",
 "time": 1627029849
 },
 {
 "type": 4,
 "point": 1,
 "description": "음식 촬영",
 "time": 1626936669
 },
 {
 "type": 1,
 "point": 5,
 "description": "혈당 측정",
 "time": 1626680446
 }
 ]
 }
}
"""

//{} = struct
//[] = Array
// Struct 안에 enum CodingKeys 으로 프로퍼티의 이름을 바꿀 수 있음

struct JsonResponse: Codable {
    let result: String
    let messages: String
    let data: GetData?
    struct GetData: Codable {
        let healthPoint: Int
        let shopPoint: Int
        let history: [GetHistory]
        
        //"health_point" 라는 명칭으로 넘어오는 키를, healthPoint 가 받아올 수 있게
        //"shop_point" 라는 명칭으로 넘어오는 키를, shopPoint 가 받아올 수 있게
        // camel case 를 준수하기위해 이름 변경
        enum CodingKeys: String, CodingKey {
            case healthPoint = "health_point"
            case shopPoint = "shop_point"
            case history
        }
    }
 
    struct GetHistory: Codable {
        let type: Int
        let point: Int
        let skwDescription: String
        let time: Int
        
        enum CodingKeys: String, CodingKey {
            case type
            case point
            case skwDescription = "description"
            case time
        }
        
    }
}



func parse(jsonString: String){
    let data = jsonString.data(using: .utf8)!

    do {
        // decode(A, B) 인자값으로 A에 해당하는 값은, Decodable 을 준수하는 제네릭 타입 이므로, .self
        // B에 해당하는 값은, Data 타입으로 변환한 Json
        // decode 함수를 "jump definition" 해보면 에러를 리턴 할 수도 있는 함수(throws)임을 확인 할 수 있으므로, try 와 같이 써야함.
        let parsing = try JSONDecoder().decode(JsonResponse.self, from: data)
        guard let data = parsing.data else { return }
        print(data.healthPoint)
        
    } catch {
        print(error)
    }
}

parse(jsonString: str)








// 에러 처리

// 에러 명세
enum ErrorCode: Error {
    case testError
}

// 'inStr' 파라미터에 "test" 라는 문자열을 전달받으면, 에러 발생
// 'throws' 키워드로, 'getOptionalString' 함수는 에러를 발생시킬 수 있다.
// 'throws' 키워드가 있는 함수의 리턴값을 받으려면, do - catch 또는 try?, try! 를 활용해야 한다.
func getOptionalString(inStr: String) throws -> String {
    
    let str = inStr
    
    if str == "test" {
        throw ErrorCode.testError
    }
    
    return str
}


// do - catch 를 활용한 에러 핸들링, 발생된 에러에 따라 코드를 분기하므로, 에러에 따른 처리 가능
do {
    let a = try getOptionalString(inStr: "test")
    print("getOptionalString() 값 : \(a)")
    
}catch ErrorCode.testError {
    print("testError 확인")
}catch {
    print("error 코드 : \(error)")
}


//try? : 'getOptionalString' 함수에서 에러 발생시, nil 반환
//try! : 'getOptionalString' 함수에서 에러 발생시, 'Execution was interrupted' 에러 발생, 런타임중 앱 종료
let b = try? getOptionalString(inStr: "test")
print("b : \(b)")


// 'Variadic Parameter(가변 매개변수)' 함수

func sums(_ numbers: Int...) -> Int {
    
    var result = 0
    
    for num in numbers {
        result += num
    }
    
    return result
}

print("Variadic Parameter : \(sums(1, 2, 3, 4, 5))")



// 'Any' 타입
let arrayAny: [Any] = ["" ,"" ,1 ,3 ,3.5]
print(arrayAny)


// 'AnyObject' 타입
class c1 {}
class c2 {}
class c3 {}

let arrayAnyObject: [AnyObject] = [c1(), c2(), c3()]
print(arrayAnyObject)



// 'class' 인스턴스 생성 방법 2가지
class ABC {
    var name: String?

    init(name: String) {
        self.name = name
    }
}


let abc1 = ABC(name: "minsu")
let abc2 = ABC.init(name: "hi")




// TypeCasting
class Human {
    let name: String = "Kim"
}
class Teacher: Human {
    let subject: String = "English"
}
class Student: Human {
    let grade: Int = 2
}

let dcTest1 = Teacher() as Human
print("dcTest1 : \(dcTest1)")

let dcTest2 = Human() as? Teacher
print("dcTest2 : \(dcTest2)")




// 클로저 응용, 강의참고

// 부가세 함수
func addVAT(source: Double) -> Double{
    return source * 1.1
}

// 'additional' 파라미터에 '(Double) -> Double' 타입이 들어간다.(함수 또는 클로저가 들어갈 수 있다.)
func finalPrice(source: Double, additional: (Double) -> Double) -> Double {
    let price = additional(source)
    return price
}


// 'additional' 파라미터에 'addVAT' 함수 전달 (강의참고)
let transaction1 = finalPrice(source: 38.5, additional: addVAT)
print("transaction1 : \(transaction1)")


// 'additional' 파라미터는 '(Double) -> Double' 타입을 요구하므로, closure 를 전달하는 방법으로 응용
let transaction2 = finalPrice(source: 38.5, additional: { (source: Double) -> Double in
    return source * 1.1
})
print("transaction2 : \(transaction2)")


// closure 를 전달받는 'additional' 파라미터는 'finalPrice' 함수의 마지막 파라미터 이므로,
// 'Trailing Closure(후행 클로저)' 적용
let transaction3 = finalPrice(source: 38.5) { (source: Double) -> Double in
    return source * 1.1
}
print("transaction3 : \(transaction3)")





// 'adder' 라는 함수를 return 하는 함수
func makeAdder(x: Int) -> (Int) -> Int {
    func adder(a: Int) -> Int {
        return x + a
    }
    return adder
}

let add5 = makeAdder(x: 5)
let add10 = makeAdder(x: 10)

print(add5(2))
print(add10(2))

print(makeAdder(x: 5)(2))




// 함수 기본 표현식
func func1(x: Int, y: Int) -> Int {
    return x * y
}
print("함수 기본 : \(func1(x: 3, y: 5))")


// 클로저 기본 표현식
let closure1 = { (x: Int, y: Int) -> Int in
    return x * y
}
print("클로저 기본1 : \(closure1(3, 5))")


// 클로저 표현식
let sayHello = { print("sayHello 호출") }
sayHello()

// 클로저 기본 표현식
let closure2 = { (x: Int, y: Int, z: Int) -> Int in
    return x * y * z
}


let mul1 = { (val1: Int, val2: Int) -> Int in
    return val1 * val2
}
print("mul1 : \(mul1(10, 20))")

let add1 = { (val1: Int, val2: Int) -> Int in
    return val1 + val2
}
print("add1 : \(add1(10, 10))")



