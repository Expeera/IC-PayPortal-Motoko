import Types "types";
import Config "config";
import Utils "utils";
import Http "http";
import Blob "mo:base/Blob";
import Debug "mo:base/Debug";
import Text "mo:base/Text";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Nat8 "mo:base/Nat8";
import Nat64 "mo:base/Nat64";
import Float "mo:base/Float";
import Cycles "mo:base/ExperimentalCycles";
import serdeJson "mo:serde/JSON";
import Result "mo:base/Result";
import Time "mo:base/Time";
import Bool "mo:base/Bool";
import Base64 "lib/Base64";
import Messages "messages";

module {

    let ic : Types.IC = actor ("aaaaa-aa");
    private let api_token = "idVMaJOz4zZ5ebi3SQ8M5oQD8nz6JF8o9AbLkhJgVMdORlna33iRkwaauby6";
    // private let base_url = "https://[2604:a880:4:1d0::6d3:1000]/api/";
    private let base_url = "https://ipv6.mcti.io/api/";

    public type Message = Text;

    public module Stripe {

        private let secret_key = "sk_test_51PjiAfJn7Y4dLWl6TWzmOcWwb3wBEiV3uZeE6k31dKaY9vCzAUX6l3vP3MyZmUuFTYtWDVLdFFxCsy6hIb24h3be00msW4De0O";
        
        public type CreateSessionApi = {
            status: Bool;
            message: Message;
            data: ?CreateSession;
        };

        public type CreateSession = {
            id: Text;
            url: Text;
        };

        public type RetrieveSessionApi = {
            status: Bool;
            message: Message;
            data: ?RetrieveSession;
        };

        public type RetrieveSession = {
            payment_status: Text;
        };


        // public func create_session(invoiceNo:Nat, invoice : Types.Request.CreateInvoiceBody, transform: shared query (Http.IcHttp.TransformArgs) -> async Http.IcHttp.CanisterHttpResponsePayload) : async Result.Result<?CreateSession, ?Message>  {
        public func create_session(invoiceNo:Nat, invoice : Types.Request.CreateInvoiceBody, transform_context: Http.IcHttp.TransformContext) : async Result.Result<?CreateSession, ?Message>  {
            // Set the request headers
            let request_headers = [
                {   name = "Content-Type";      value = "application/x-www-form-urlencoded" },
                {   name = "Accept";            value = "application/json" },
                {   name = "token";             value = api_token },
                {   name = "invoice-number";    value = Nat.toText(invoiceNo)},
            ];

            // Construct the request body string
            let request_body_str: Text = "cancel_url="# Config.get_stripe_cancel_url(invoiceNo) #"&" # 
                "success_url="# Config.get_stripe_success_url(invoiceNo) #"&"#
                "currency="# invoice.currency #"&secret_key="# secret_key #"&unit_amount="# Int.toText(Float.toInt(invoice.amount * 100)) #"&"#
                "quantity=1";

            // Encode the request body as Blob
            let request_body_as_Blob: Blob = Text.encodeUtf8(request_body_str); 

            // Create the HTTP request object
            let http_request : Http.IcHttp.HttpRequest = {
                url = base_url # "stripe/create-session";
                headers = request_headers;
                body = ?request_body_as_Blob; 
                method = #post;
                transform = ?transform_context;
                max_response_bytes= null;
            };

            // Minimum cycles needed to pass the CI tests. Cycles needed will vary on many things, such as the size of the HTTP response and subnet.
            Cycles.add(220_131_200_000); 

            // Send the HTTP request and await the response
            let http_response : Http.IcHttp.HttpResponse = await ic.http_request(http_request);

            // Decode the response body text
            let decoded_text: Text = switch (Text.decodeUtf8(http_response.body)) {
                case (null) { "{\"status\" : \"false\", \"message\" : \"No value returned\", \"data\" : \"null\"}" };
                case (?y) { y };
            };

            // Convert the decoded text to Blob
            let blob = serdeJson.fromText(decoded_text);

            // Deserialize the blob to CreateSession type
            let session : ?CreateSessionApi = from_candid(blob);

            return switch(session){
                case(null) {
                     return #err(null);
                };
                case(?_session) {
                    return switch(_session.status){
                        case (false) {
                            return #err(?_session.message);
                        };
                        case(true) {
                            return #ok(_session.data);
                        };
                    };
                };
            };
        };

        public func retrieve_session(session_id:Text, transform_context: Http.IcHttp.TransformContext) : async Result.Result<?RetrieveSession, ?Message>  {

             // Set the request headers
            let request_headers = [
                {   name = "Content-Type";      value = "application/x-www-form-urlencoded" },
                {   name = "Accept";            value = "application/json" },
                {   name = "token";             value = api_token },
            ];

             // Construct the request body string
            let request_body_str: Text = "secret_key=" # secret_key;

            // Encode the request body as Blob
            let request_body_as_Blob: Blob = Text.encodeUtf8(request_body_str); 

            // Create the HTTP request object
            let http_request : Http.IcHttp.HttpRequest = {
                url = base_url # "stripe/retrieve-session/" # session_id;
                headers = request_headers;
                body = ?request_body_as_Blob; 
                method = #post;
                transform = ?transform_context;
                max_response_bytes= null;
            };

            // Minimum cycles needed to pass the CI tests. Cycles needed will vary on many things, such as the size of the HTTP response and subnet.
            Cycles.add(220_131_200_000); 

            // Send the HTTP request and await the response
            let http_response : Http.IcHttp.HttpResponse = await ic.http_request(http_request);

            // Decode the response body text
            let decoded_text: Text = switch (Text.decodeUtf8(http_response.body)) {
                case (null) { "{\"status\" : \"false\", \"message\" : \"No value returned\", \"data\" : \"null\"}" };
                case (?y) { y };
            };

            // Convert the decoded text to Blob
            let blob = serdeJson.fromText(decoded_text);

            // Deserialize the blob to RetrieveSession type
            let session : ?RetrieveSessionApi = from_candid(blob);

            return switch(session){
                case(null) {
                     return #err(null);
                };
                case(?_session) {
                    return switch(_session.status){
                        case (false) {
                            return #err(?_session.message);
                        };
                        case(true) {
                            return #ok(_session.data);
                        };
                    };
                };
            };
        };
    };

    public module Paypal {
        private let client_id:Text = "AZUPT0s8SzC8SkFaBNRzOnVPIr4cZ6XcgiIaXtWFtTMlp2ePzJlfHvoZp0IaxOvlI9nk8aljvlcaihxR";
        private let client_secret:Text = "EFx8zu_5VtYja8nXx6Xs8BPJOepsALxXHvCIjWlKKOAx8UKIXlXwfWx-8Ai6DaUq4zt9hKsk33keit1x";       

        public type CreateOrderApi = {
            status: Bool;
            message: Message;
            data: ?CreateOrder;
        };

        public type CreateOrder = {
            id: Text;
            url: Text;
        };

        public type RetrieveOrderApi = {
            status: Bool;
            message: Message;
            data: ?RetrieveOrder;
        };

        public type RetrieveOrder = {
            status: Text;
        };

        public func create_order(invoiceNo:Nat, invoice : Types.Request.CreateInvoiceBody, transform_context: Http.IcHttp.TransformContext): async Result.Result<?CreateOrder, ?Message> {
            
            let request_headers = [
                {   name = "Content-Type";      value = "application/x-www-form-urlencoded" },
                {   name = "Accept";            value = "application/json" },
                {   name = "token";             value = api_token },
                {   name = "invoice-number";    value = Nat.toText(invoiceNo)},
            ];

            let request_body_str: Text = "client_id=" # client_id # "&client_secret=" # client_secret # "&cancel_url="# Config.get_paypal_cancel_url(invoiceNo) #
                "&success_url="# Config.get_paypal_success_url(invoiceNo) # "&currency="# invoice.currency #"&amount="# Utils.convertNumber(invoice.amount);

            let request_body_as_Blob: Blob = Text.encodeUtf8(request_body_str);


            let http_request : Http.IcHttp.HttpRequest = {
                url = base_url # "paypal/create-order";
                headers = request_headers;
                body = ?request_body_as_Blob; 
                method = #post;
                transform = ?transform_context;
                max_response_bytes= null;
            };

            Cycles.add(220_131_200_000); 

            // Send the HTTP request and await the response
            let http_response : Http.IcHttp.HttpResponse = await ic.http_request(http_request);


            // Decode the response body text
            let decoded_text: Text = switch (Text.decodeUtf8(http_response.body)) {
                case (null) { "{\"status\" : \"false\", \"message\" : \"No value returned\", \"data\" : \"null\"}" };
                case (?y) { y };
            };

            //  Debug.print(decoded_text);

            let blob = serdeJson.fromText(decoded_text);

            // Deserialize the blob to CreateSession type
            let checkout : ?CreateOrderApi = from_candid(blob);

            return switch(checkout){
                case(null) {
                     return #err(null);
                };
                case(?_checkout) {
                    return switch(_checkout.status){
                        case (false) {
                            return #err(?_checkout.message);
                        };
                        case(true) {
                            return #ok(_checkout.data);
                        };
                    };
                };
            };
        };   

        public func retrieve_order(order_id:Text, transform_context: Http.IcHttp.TransformContext) : async Result.Result<?RetrieveOrder, ?Message>  {

            // Set the request headers
            let request_headers = [
                {   name = "Content-Type";      value = "application/x-www-form-urlencoded" },
                {   name = "Accept";            value = "application/json" },
                {   name = "token";             value = api_token },
            ];

            let request_body_str: Text = "client_id=" # client_id # "&client_secret=" # client_secret # "&order_id=" # order_id;

            let request_body_as_Blob: Blob = Text.encodeUtf8(request_body_str);

            // Create the HTTP request object
            let http_request : Http.IcHttp.HttpRequest = {
                url = base_url # "paypal/retrieve-order";
                headers = request_headers;
                body = ?request_body_as_Blob; 
                method = #post;
                transform = ?transform_context;
                max_response_bytes= null;
            };

            // Minimum cycles needed to pass the CI tests. Cycles needed will vary on many things, such as the size of the HTTP response and subnet.
            Cycles.add(220_131_200_000); 

            // Send the HTTP request and await the response
            let http_response : Http.IcHttp.HttpResponse = await ic.http_request(http_request);

            // Decode the response body text
            let decoded_text: Text = switch (Text.decodeUtf8(http_response.body)) {
                case (null) { "{\"status\" : \"false\", \"message\" : \"No value returned\", \"data\" : \"null\"}" };
                case (?y) { y };
            };

            // Convert the decoded text to Blob
            let blob = serdeJson.fromText(decoded_text);

            // Deserialize the blob to RetrieveSession type
            let order : ?RetrieveOrderApi = from_candid(blob);

            return switch(order){
                case(null) {
                     return #err(null);
                };
                case(?_order) {
                    return switch(_order.status){
                        case (false) {
                            return #err(?_order.message);
                        };
                        case(true) {
                            return #ok(_order.data);
                        };
                    };
                };
            };

        };
    };
}