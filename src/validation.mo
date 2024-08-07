import Array "mo:base/Array";
import Text "mo:base/Text";
import Trie "mo:base/Trie";
import Principal "mo:base/Principal";
import Types "types";
import Prim "mo:⛔";


module {

    // Define arrays of supported payment methods and currencies
    let supportedPaymentMethods  : [Text] = ["Stripe", "PayPal"];
    let supportedCurrencies : [Text] = ["USD", "EUR"];

     // Function to check if the caller is anonymous
    public func isAnonymous (caller : Principal) : Bool {
         // Compare the caller's principal to a predefined value
        Principal.toText(caller) == "2vxsx-fae";
    };

    public func isAnonymousCallerText (caller : Text) : Bool {
         // Compare the caller's Text to a predefined value
        caller == "2vxsx-fae";
    };

    // Function to check if a text is empty
    public func isEmpty(text: Text): Bool {
        // Trim leading and trailing whitespace from the text and compare it to an empty string
        Text.equal(Text.trim(text, #char ' '), "");
    };

    public func isEqual(text1: Text, text2: Text): Bool {
        // Trim leading and trailing whitespace from the text and compare it to an empty string
        Text.equal(Text.map(text1, Prim.charToLower), Text.map(text2, Prim.charToLower))
    };

    // Function to check if a number is greater than zero
    public func isGreaterThanZero(number: Float): Bool {
        // Compare the number to zero
        number > 0;
    };

    // Function to check if a currency is found in the supported currencies array
    public func checkIfTheCurrencyIsFound(currency: Text): Bool {
        // Filter the supported currencies array based on a case-insensitive comparison
        let ele = Array.filter<Text>(supportedCurrencies, func x = Text.equal(Text.map(x, Prim.charToLower), Text.map(currency, Prim.charToLower)));
        // Check if the filtered array is empty, indicating that the currency is not found
        ele.size() == 0;
    };
    
    // Function to check if a payment method is found in the supported payment methods array
    public func checkIfThePaymentMethodIsFound(paymentMethod: Text): Bool {
        // Filter the supported payment methods array based on a case-insensitive comparison
        let ele = Array.filter<Text>(supportedPaymentMethods, func x = Text.equal(Text.map(x, Prim.charToLower), Text.map(paymentMethod, Prim.charToLower)));
        // Check if the filtered array is empty, indicating that the payment method is not found
        ele.size() == 0;
    };
}