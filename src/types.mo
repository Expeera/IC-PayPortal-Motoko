import Principal "mo:base/Principal";
import Float "mo:base/Float";
import Http "http";

module {

    public type Invoice = {
        id: Nat;
        owner: Principal;
        amount: Float;
        status: Text;
        items: [Item];
        transactionId: Text;
        paymentLink: Text;
        paymentMethod: Text;
        currency: Text;
        createdAt: Int;
    };

    public type Item = {
        id: Nat;
        name: Text;
        quantity: Int;
        price: Float;
    };
    
    public module InvoiceStatus = {
        public let Pending              : Text = "Pending";
        public let Completed            : Text = "Completed";
        public let Cancelled            : Text = "Cancelled";
        public let CancelledByAdmin     : Text = "Cancelled by admin";
        public let CancelledBySystem     : Text = "Cancelled by system";
    };

    public type CreateSession = {
        id: Text;
        url: Text;
    };

    public module Request {
        public type CreateInvoiceBody = {
            amount: Float;
            paymentMethod: Text;
            currency: Text;
            items: [Item];
        }; 

        public type ConfirmInvoiceBody = {
            invoiceNo: Nat;
            paymentMethod: Text;
            isSuccess: Bool;
        }; 

        public type ConfirmInvoiceAdminBody = {
            invoiceNo: Nat;
            paymentMethod: Text;
            isCompleted: Bool;
        }; 
    };

     public module Response {
        public type CreateInvoiceBody = {
            id: Nat;
            payment: {
                transactionId: Text;
                redirectUrl: Text;
            };
        }; 

        public type ConfirmInvoiceBody = {
            invoiceNo: Nat;
            transactionId: Text;
            paymentMethod: Text;
            status: Text;
        }; 
    };

    public type IC = actor {
        http_request : Http.IcHttp.HttpRequest -> async Http.IcHttp.HttpResponse;
    };
    
}