import Array "mo:base-0.7.3/Array";
import Nat "mo:base-0.7.3/Nat";
import Nat8 "mo:base-0.7.3/Nat8";
import Nat32 "mo:base-0.7.3/Nat32";
import Nat64 "mo:base-0.7.3/Nat64";
import Result "mo:base-0.7.3/Result";
import Char "mo:base-0.7.3/Char";

module Base64 {
    public module StdEncoding {
        private let encodeStd = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

        private let encodeMap : [Nat8] = [
             65,  66,  67,  68,  69,  70,  71,  72,
             73,  74,  75,  76,  77,  78,  79,  80,
             81,  82,  83,  84,  85,  86,  87,  88,
             89,  90,  97,  98,  99, 100, 101, 102,
            103, 104, 105, 106, 107, 108, 109, 110,
            111, 112, 113, 114, 115, 116, 117, 118,
            119, 120, 121, 122,  48,  49,  50,  51,
             52,  53,  54,  55,  56,  57,  43,  47,
        ];

        public func encode(data : [Nat8]) : Text = Base64.encode(data, encodeMap);
    };

    private func encodeLen(n : Nat) : Nat {
        (n * 8 + 5) / 6;
    };

    public func encode(data : [Nat8], encodeMap : [Nat8]) : Text {
        if (data.size() == 0) { return ""; };

        var i = 0;
        var s = 0;
        let n = (data.size() / 3) * 3;
        let dst:[var Nat8] = Array.init<Nat8>(encodeLen(data.size()), 0);
        while (s < n) {
            let v = nat8to32(data[s]) << 16 | nat8to32(data[s+1]) << 8 | nat8to32(data[s+2]);
            dst[i  ] := encodeMap[Nat32.toNat(v >> 18 & 0x3F)];
            dst[i+1] := encodeMap[Nat32.toNat(v >> 12 & 0x3F)];
            dst[i+2] := encodeMap[Nat32.toNat(v >> 6  & 0x3F)];
            dst[i+3] := encodeMap[Nat32.toNat(v       & 0x3F)];

            i += 4; s += 3;
        };

        let r : Nat = data.size() - s;
        if (r == 0) return "";
        var v = nat8to32(data[s]) << 16;
        if (r == 2) v |= nat8to32(data[s+1]) << 8;
        dst[i  ] := encodeMap[Nat32.toNat(v >> 18 & 0x3F)];
        dst[i+1] := encodeMap[Nat32.toNat(v >> 12 & 0x3F)];
        if (r == 2) dst[i+2] := encodeMap[Nat32.toNat(v >> 6  & 0x3F)];

        
        var res: Text = "";
        i := 0;
        let size = dst.size();
        while ( size > i) {
             res := res # "" # Char.toText(Char.fromNat32(Nat32.fromNat (Nat8.toNat(dst[i]))));
            i += 1;
        };

        res # "=";
    };

    private func nat8to32(n : Nat8) : Nat32 {
        Nat32.fromNat(Nat8.toNat(n));
    };

    private func decodeLen(n : Nat) : Nat {
        n * 6 / 8;
    };

};