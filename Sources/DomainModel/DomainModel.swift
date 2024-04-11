struct DomainModel {
    var text = "Hello, World!"
        // Leave this here; this value is also tested in the tests,
        // and serves to make sure that everything is working correctly
        // in the testing harness and framework.
}

////////////////////////////////////
// Money
//
public struct Money {
    var amount: Int
    var currency: String
    
    func convert(_ convert_name: String) -> Money{
        var in_USD = amount
        var newAmount: Int
        switch currency {
            case "GBP":
                in_USD = amount * 2
            case "EUR":
                in_USD = amount * 2 / 3
            case "CAN":
                in_USD = amount * 4 / 5
            default:
                break
        }
        
        switch convert_name {
            case "GBP":
                newAmount = in_USD / 2
            case "EUR":
                newAmount = in_USD * 3 / 2
            case "CAN":
                newAmount = in_USD * 5 / 4
            default:
                newAmount = in_USD
        }
        
        return Money(amount: newAmount, currency: convert_name)
    }
    
    func add(_ inputMoney: Money) -> Money {
        let selfMoney = self.convert(inputMoney.currency)
        return Money(amount: selfMoney.amount + inputMoney.amount, currency: inputMoney.currency)
    }
    
    func subtract(_ inputMoney: Money) -> Money {
        let selfMoney = self.convert(inputMoney.currency)
        return Money(amount: selfMoney.amount - inputMoney.amount, currency: inputMoney.currency)
    }
}

////////////////////////////////////
// Job
//
public class Job {
    var title: String
    var type: JobType
    
    public enum JobType {
        case Hourly(Double)
        case Salary(UInt)
    }
    
    init(title: String, type: JobType) {
        self.title = title
        self.type = type
    }
    
    func calculateIncome(_ num: Int) -> Int {
        switch type {
            case .Hourly(let hourly):
                return Int(hourly * Double(num))
            case .Salary(let salary):
                return Int(salary)
        }
    }
    
    func raise(byAmount: Double) {
        switch type {
            case .Hourly(let hourly):
                self.type = .Hourly(hourly + byAmount)
            case .Salary(let salary):
                self.type = .Salary(salary + UInt(byAmount))
        }
    }
    
    func raise(byPercent: Double) {
        switch type {
            case .Hourly(let hourly):
                self.type = .Hourly(hourly * (1.0 + byPercent))
            case .Salary(let salary):
            self.type = .Salary(UInt(Double(salary) * (1.0 + byPercent)))
        }
    }
}

////////////////////////////////////
// Person
//
public class Person {
    var firstName: String
    var lastName: String
    var age: Int
    var _job: Job?
    var _spouse: Person?
    
    init(firstName: String, lastName: String, age: Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
    func toString() -> String {
        return ("[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(String(describing: job?.title)) spouse:\(String(describing: spouse?.firstName))]")
    }
    
    var job: Job? {
        get {
            return _job
        }
        set {
            if (age < 16) {
                _job = nil
            }
            else {
                _job = newValue
            }
         }
    }
    
    var spouse: Person? {
        get {
            return _spouse
        }
        set {
            if (age < 21) {
                _spouse = nil
            }
            else {
                _spouse = newValue
            }
        }
    }
    
}

////////////////////////////////////
// Family
//
public class Family {
    var members: Array<Person>
    
    init(spouse1: Person, spouse2: Person) {
        spouse1.spouse = spouse2
        spouse2.spouse = spouse1
        self.members = [spouse1, spouse2]
    }
    
    func haveChild(_ Child: Person) {
        if((members[0].age > 21) || (members[1].age > 21)) {
            members.append(Child)
        }
    }
    
    func householdIncome() -> Int {
        var total_income = 0;
        for person in self.members {
            total_income += person.job?.calculateIncome(2000) ?? 0
        }
        return total_income
    }
}
