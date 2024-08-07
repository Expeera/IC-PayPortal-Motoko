import Array "mo:base/Array";
import Iter "mo:base/Iter";
import Result "mo:base/Result";
import Text "mo:base/Text";
import HashMap "mo:base/HashMap";

module {

    public module IcHttp {
        public type HttpHeader = {
            name : Text;
            value : Text;
        };

        public type HttpRequest = {
            method : HttpMethod;
            url : Text;
            headers : [HttpHeader];
            body : ?Blob;
            max_response_bytes : ?Nat64;
            transform : ?TransformRawResponseFunction;
        };

        public type TransformRawResponseFunction = {
            function : shared query TransformArgs -> async HttpResponsePayload;
            context : Blob;
        };

        public type TransformArgs = {
            response : HttpResponsePayload;
            context : Blob;
        };

        public type TransformContext = {
            function : shared query TransformArgs -> async HttpResponsePayload;
            context : Blob;
        };

        public type HttpResponsePayload = {
            status : Nat;
            headers : [HttpHeader];
            body : [Nat8];
        };


        public type CanisterHttpResponsePayload = {
            status : Nat;
            headers : [HttpHeader];
            body : [Nat8];
        };

        public type HttpMethod = {
            #get;
            #post;
            #head;
        };

        public type HttpResponse = {
            status: StatusCode;
            headers: [?HttpHeader];
            body: Blob;
        };
    };



    public type HeaderField = (Text, Text);

    public type HttpRequest = {
        method : Text;
        url : Text;
        headers : [HeaderField];
        body : Blob;
    };

    public type HttpResponse = {
        status_code: Nat16;
        headers: [HeaderField];
        body: Blob;
        upgrade: Bool; 
    };

    public type ResponseStatus<success, err> = {
        #success : success;
        #err : err
    };

    public type Response<ResponseStatus> = {
        status          : Bool;
        message         : Text;
        body            : ResponseStatus;
        // headers         : [HeaderField];
        status_code     : StatusCode;
    };

    public type Method = Text;

    // // Common HTTP methods.
    public module Method {
        public let Get     : Method = "GET";
        public let Head    : Method = "HEAD";
        public let Post    : Method = "POST";
        public let Put     : Method = "PUT";
        public let Patch   : Method = "PATCH";
        public let Delete  : Method = "DELETE";
        public let Connect : Method = "CONNECT";
        public let Options : Method = "OPTIONS";
        public let Trace   : Method = "TRACE";
    };

    

    public type StatusCode = Nat;

    // HTTP status codes as registered with IANA. 
    public module Status {
        public let Continue                     : StatusCode = 100;
        public let SwitchingProtocols           : StatusCode = 101;
        public let Processing                   : StatusCode = 102;
        public let EarlyHints                   : StatusCode = 103; 
        public let OK                           : StatusCode = 200;
        public let Created                      : StatusCode = 201;
        public let Accepted                     : StatusCode = 202;
        public let NonAuthoritativeInfo         : StatusCode = 203;
        public let NoContent                    : StatusCode = 204;
        public let ResetContent                 : StatusCode = 205;
        public let PartialContent               : StatusCode = 206;
        public let MultiStatus                  : StatusCode = 207;
        public let AlreadyReported              : StatusCode = 208;
        public let IMUsed                       : StatusCode = 226;

        public let MultipleChoices              : StatusCode = 300;
        public let MovedPermanently             : StatusCode = 301;
        public let Found                        : StatusCode = 302;
        public let SeeOther                     : StatusCode = 303;
        public let NotModified                  : StatusCode = 304;
        public let UseProxy                     : StatusCode = 305;

        public let TemporaryRedirect            : StatusCode = 307;
        public let PermanentRedirect            : StatusCode = 308;

        public let BadRequest                   : StatusCode = 400;
        public let Unauthorized                 : StatusCode = 401;
        public let PaymentRequired              : StatusCode = 402;
        public let Forbidden                    : StatusCode = 403;
        public let NotFound                     : StatusCode = 404;
        public let MethodNotAllowed             : StatusCode = 405;
        public let NotAcceptable                : StatusCode = 406;
        public let ProxyAuthRequired            : StatusCode = 407;
        public let RequestTimeout               : StatusCode = 408;
        public let Conflict                     : StatusCode = 409;
        public let Gone                         : StatusCode = 410;
        public let LengthRequired               : StatusCode = 411;
        public let PreconditionFailed           : StatusCode = 412;
        public let RequestEntityTooLarge        : StatusCode = 413;
        public let RequestURITooLong            : StatusCode = 414;
        public let UnsupportedMediaType         : StatusCode = 415;
        public let RequestedRangeNotSatisfiable : StatusCode = 416;
        public let ExpectationFailed            : StatusCode = 417;
        public let Teapot                       : StatusCode = 418;
        public let MisdirectedRequest           : StatusCode = 421;
        public let UnprocessableEntity          : StatusCode = 422;
        public let Locked                       : StatusCode = 423;
        public let FailedDependency             : StatusCode = 424;
        public let TooEarly                     : StatusCode = 425;
        public let UpgradeRequired              : StatusCode = 426;
        public let PreconditionRequired         : StatusCode = 428; 
        public let TooManyRequests              : StatusCode = 429; 
        public let RequestHeaderFieldsTooLarge  : StatusCode = 431; 
        public let UnavailableForLegalReasons   : StatusCode = 451; 

        public let InternalServerError           : StatusCode = 500;
        public let NotImplemented                : StatusCode = 501;
        public let BadGateway                    : StatusCode = 502;
        public let ServiceUnavailable            : StatusCode = 503;
        public let HTTPVersionNotSupported       : StatusCode = 505;
        public let GatewayTimeout                : StatusCode = 504;
        public let VariantAlsoNegotiates         : StatusCode = 506; 
        public let InsufficientStorage           : StatusCode = 507;
        public let LoopDetected                  : StatusCode = 508;
        public let NotExtended                   : StatusCode = 510;
        public let NetworkAuthenticationRequired : StatusCode = 511;
    };

};