import Swish
import Quick
import Nimble

class NSURLRequestSpec: QuickSpec {
  override func spec() {
    describe("jsonPayload") {
      context("when given an encodable object") {
        it("serializes and deserializes correctly") {
          let urlRequest = NSMutableURLRequest(URL: NSURL(string: "http://www.example.com")!)
          urlRequest.jsonPayload = ["ids": [0, 1, 2]]

          let payloadFromRequest = urlRequest.jsonPayload
          let ids: [Int]? = payloadFromRequest["ids"] as? [Int]

          expect(ids).to(equal([0, 1, 2]))
        }
      }

      context("when the HTTPBody cannot be decoded") {
        it("returns an empty dictionary") {
          let urlRequest = NSMutableURLRequest(URL: NSURL(string: "http://www.example.com")!)
          urlRequest.HTTPBody = NSData()

          let payloadFromRequest = urlRequest.jsonPayload

          expect(payloadFromRequest.count).to(equal(0))
        }
      }
    }

    describe("jsonPayloadArray") {
      context("when given an encodable object") {
        it("serializes and deserializes correctly") {
          let urlRequest = NSMutableURLRequest(URL: NSURL(string: "http://www.example.com")!)
          urlRequest.jsonPayloadArray = [["ids": [0, 1, 2]]]

          let payloadFromRequest = urlRequest.jsonPayloadArray
          let object = payloadFromRequest.first! as! [String: AnyObject]
          let ids: [Int]? = object["ids"] as? [Int]

          expect(ids).to(equal([0, 1, 2]))
        }
      }

      context("when the HTTPBody cannot be decoded") {
        it("returns an empty dictionary") {
          let urlRequest = NSMutableURLRequest(URL: NSURL(string: "http://www.example.com")!)
          urlRequest.HTTPBody = NSData()

          let payloadFromRequest = urlRequest.jsonPayloadArray

          expect(payloadFromRequest.count).to(equal(0))
        }
      }
    }
  }
}
