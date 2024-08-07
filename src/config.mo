import Text "mo:base/Text";
import Nat "mo:base/Nat";

module {


    private let devConfig = {
        // Define the frontend canister ID used for constructing URLs
        frontendCanisterId= "bkyz2-fmaaa-aaaaa-qaaaq-cai";
        baseUrl= "localhost:8000";
        http= "http://";
    };

    private let liveConfig = {
        // Define the frontend canister ID used for constructing URLs
        frontendCanisterId= "3356i-cqaaa-aaaao-axdqa-cai";
        baseUrl= "icp0.io";
        http= "https://";
    };

    private let config = liveConfig;

    // Function to generate the Stripe success URL for a specific invoice
    public func get_stripe_success_url (invoiceNo:Nat): Text { 
        config.http # config.frontendCanisterId # "." # config.baseUrl # "/stripe/success/" # Nat.toText(invoiceNo)
    };

     // Function to generate the Stripe cancel URL for a specific invoice
    public func get_stripe_cancel_url (invoiceNo:Nat): Text { 
       config.http # config.frontendCanisterId # "." # config.baseUrl #  "/stripe/cancel/" # Nat.toText(invoiceNo)
    };

    // Function to generate the Paypal success URL for a specific invoice
    public func get_paypal_success_url (invoiceNo:Nat): Text { 
       config.http # config.frontendCanisterId # "." # config.baseUrl # "/paypal/success/" # Nat.toText(invoiceNo)
    };

     // Function to generate the Paypal cancel URL for a specific invoice
    public func get_paypal_cancel_url (invoiceNo:Nat): Text { 
       config.http # config.frontendCanisterId # "." # config.baseUrl #  "/paypal/cancel/" # Nat.toText(invoiceNo)
    };

}