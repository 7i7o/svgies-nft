// SPDX-License-Identifier: MIT
pragma solidity 0.8.12;

import { Base64 } from './Base64.sol';

string constant SVGa = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="8 8 32 32" width="200" height="200">'
                            '<radialGradient id="'; // C0 C1
string constant SVGb = '"><stop stop-color="#'; // C0
string constant SVGc = '" offset="0"></stop><stop stop-color="#'; // C1
string constant SVGd = '" offset="1"></stop></radialGradient>'
                        '<rect x="8" y="8" width="100%" height="100%" opacity="1" fill="white"></rect>'
                        '<rect x="8" y="8" width="100%" height="100%" opacity=".5" fill="url(#'; // C0 C1
string constant SVGe = ')"></rect><linearGradient id="'; // C2 C3 C2
string constant SVGf = '"><stop stop-color="#'; // C2
string constant SVGg = '" offset="0"></stop><stop stop-color="#'; // C3
string constant SVGh = '" offset=".5"></stop><stop stop-color="#'; // C2
string constant SVGi = '" offset="1"></stop></linearGradient><linearGradient id="'; // C3 C2 C3
string constant SVGj = '"><stop stop-color="#'; // C3
string constant SVGk = '" offset="0"></stop><stop stop-color="#'; // C2
string constant SVGl = '" offset=".5"></stop><stop stop-color="#'; // C3
string constant SVGm = '" offset="1"></stop></linearGradient><path fill="url(#'; // C2 C3 C2 
string constant SVGn = ')" stroke-width="0.1" stroke="url(#'; // C3 C2 C3
string constant SVGo = ')" d="'; // PATH
string constant SVGp = '"></path></svg>';

contract TokenURIDescriptor {

    // From OpenZeppelin Contracts utils String.sol
    bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
    function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
        bytes memory buffer = new bytes(2 * length + 2);
        buffer[0] = "0";
        buffer[1] = "x";
        for (uint256 i = 2 * length + 1; i > 1; --i) {
            buffer[i] = _HEX_SYMBOLS[value & 0xf];
            value >>= 4;
        }
        require(value == 0, "Strings: hex length insufficient");
        return string(buffer);
    }

    function fixOpacity(uint32 i) internal pure returns (string memory) {
        bytes16 b = 0x30313233343536373839616263646566;
        bytes memory o = new bytes(8);
        uint32 mask = 0x0000000f;
        uint32 mask16 = 0x000000ff;
        uint32 j = (uint16(i & mask16) * 256) / 1024 + 191;
        o[7] = bytes1(b[j & mask]);
        j = j >> 4;
        o[6] = bytes1(b[j & mask]);
        i = i >> 8;
        o[5] = bytes1(b[i & mask]);
        i = i >> 4;
        o[4] = bytes1(b[i & mask]);
        i = i >> 4;
        o[3] = bytes1(b[i & mask]);
        i = i >> 4;
        o[2] = bytes1(b[i & mask]);
        i = i >> 4;
        o[1] = bytes1(b[i & mask]);
        i = i >> 4;
        o[0] = bytes1(b[i & mask]);
        return string(o);
    }

    function getColors(address _addr) internal pure returns(string[4] memory) {
        string[4] memory s;
        uint256 h = uint(keccak256(abi.encodePacked(_addr)));
        uint256 mask = 0x000000000000000000000000ffffffff;
        h = h >> 128;
        s[3] = fixOpacity(uint32(h & mask));
        h = h >> 32;
        s[2] = fixOpacity(uint32(h & mask));
        h = h >> 32;
        s[1] = fixOpacity(uint32(h & mask));
        h = h >> 32;
        s[0] = fixOpacity(uint32(h & mask));
        return s;
    }
    
    function getPath(address _addr) internal pure returns (string memory) {
        // 40 integers from each hex character of the address (+16 to avoid negatives later)
        uint8[40] memory c;
        uint160 a = uint160(address(_addr));
        uint160 mask = 15;
        for (uint8 i = 40; i > 0; i--) {
            c[i-1] = uint8((a & mask) + 16);
            a = a >> 4;
        }
        // An array of strings with the possible values of each integer
        string[49] memory n = [
        '0 ','1 ','2 ','3 ','4 ','5 ','6 ','7 ','8 ','9 ',
        '10 ','11 ','12 ','13 ','14 ','15 ','16 ','17 ','18 ','19 ',
        '20 ','21 ','22 ','23 ','24 ','25 ','26 ','27 ','28 ','29 ',
        '30 ','31 ','32 ','33 ','34 ','35 ','36 ','37 ','38 ','39 ',
        '40 ','41 ','42 ','43 ','44 ','45 ','46 ','47 ','48 '
        ];
        // The Path is created (here lies all the magic)
        string[8] memory o;
        o[0] = string.concat( 'M', n[c[0]], n[c[1]], 'C', n[c[2]], n[c[3]], n[c[4]], n[c[5]] , n[c[6]], n[c[7]], 'S', n[c[8]], n[c[9]], n[c[10]]);
        o[1] = string.concat( n[c[11]], 'S', n[c[12]], n[c[13]] , n[c[14]], n[c[15]], 'S', n[c[16]], n[c[17]], n[c[18]], n[c[19]], 'S', n[c[20]], n[c[21]] );
        o[2] = string.concat( n[c[22]], n[c[23]], 'S', n[c[24]], n[c[25]], n[c[26]], n[c[27]], 'S', n[c[28]], n[c[29]] , n[c[30]], n[c[31]], 'S', n[c[32]] );
        o[3] = string.concat( n[c[33]], n[c[34]], n[c[35]], 'S', n[c[36]], n[c[37]] , n[c[38]], n[c[39]], 'Q', n[2*c[38]-c[36]], n[2*c[39]-c[37]], n[c[0]], n[c[1]] );

        o[4] = string.concat( 'M', n[48-c[0]], n[c[1]], 'C', n[48-c[2]], n[c[3]], n[48-c[4]], n[c[5]] , n[48-c[6]], n[c[7]], 'S', n[48-c[8]], n[c[9]], n[48-c[10]] );
        o[5] = string.concat( n[c[11]], 'S', n[48-c[12]], n[c[13]], n[48-c[14]], n[c[15]], 'S', n[48-c[16]], n[c[17]], n[48-c[18]], n[c[19]], 'S', n[48-c[20]], n[c[21]] );
        o[6] = string.concat( n[48-c[22]], n[c[23]], 'S', n[48-c[24]], n[c[25]], n[48-c[26]], n[c[27]], 'S', n[48-c[28]], n[c[29]] , n[48-c[30]], n[c[31]], 'S', n[48-c[32]] );
        o[7] = string.concat( n[c[33]], n[48-c[34]], n[c[35]], 'S', n[48-c[36]], n[c[37]] , n[48-c[38]], n[c[39]], 'Q', n[48-(2*c[38]-c[36])], n[2*c[39]-c[37]], n[48-c[0]], n[c[1]], 'z' );

        return string.concat(o[0], o[1], o[2], o[3], o[4], o[5], o[6], o[7]);
    }

    function getSVG(address _addr) internal pure returns (string memory) {
        string[4] memory c = getColors(_addr);
        string memory c01 = string.concat(c[0], c[1]);
        string memory c232 = string.concat(c[2], c[3], c[2]);
        string memory c323 = string.concat(c[3], c[2], c[3]);
        string memory path = getPath(_addr);
        string memory o = string.concat(SVGa, c01, SVGb, c[0], SVGc, c[1], SVGd, c01, SVGe, c232, SVGf);
        o = string.concat(o, c[2], SVGg, c[3], SVGh, c[2], SVGi, c323, SVGj, c[3], SVGk);
        return string.concat(o, c[2], SVGl, c[3], SVGm, c232, SVGn, c323, SVGo, path, SVGp);
    }

    // function getEncodedSVG(address _addr, string calldata name, string calldata symbol) public pure returns (string memory) {
    function tokenURI(address _addr, string calldata _name, string calldata _symbol) public pure returns (string memory) {

        string[9] memory json;
        
        json[0] = '{"name":"';
        json[1] = _name;
        json[2] = ' #';
        json[3] = toHexString(uint256(uint160(_addr)), 20);
        json[4] = '","symbol":"';
        json[5] = _symbol;
        json[6] = '","description":"On-Chain NFT for ETH Address SVG Representation","image": "data:image/svg+xml;base64,';
        json[7] = Base64.encode(bytes(getSVG(_addr)));
        json[8] = '"}';

        string memory output = string.concat(json[0], json[1], json[2], json[3], json[4], json[5], json[6], json[7], json[8]);

        return string.concat("data:application/json;base64,", Base64.encode(bytes(output)));

    }

    bool test = false;
    function tokenURIGasTest(address _addr, string calldata _name, string calldata _symbol) public returns (string memory) {
        test = false;
        return tokenURI(_addr, _name, _symbol);
    }
}
