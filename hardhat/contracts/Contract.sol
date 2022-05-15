// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.12;



contract Contract {

    bool private test;

    function uint8tohexchar(uint8 i) public pure returns (uint8) {
        return (i > 9) ? (i + 87) : (i + 48); // (i > 9) ? (ascii a-f) : (ascii 0-9)
    }

    function fixOpacity(uint32 i) public pure returns (string memory) {
        bytes memory o = new bytes(8);
        uint32 mask = 0x0000000f;
        uint32 mask16 = 0x000000ff;
        uint32 j = (uint16(i & mask16) * 256) / 1024 + 191;
        o[7] = bytes1(uint8tohexchar(uint8(j & mask)));
        j = j >> 4;
        o[6] = bytes1(uint8tohexchar(uint8(j & mask)));
        i = i >> 8;
        o[5] = bytes1(uint8tohexchar(uint8(i & mask)));
        i = i >> 4;
        o[4] = bytes1(uint8tohexchar(uint8(i & mask)));
        i = i >> 4;
        o[3] = bytes1(uint8tohexchar(uint8(i & mask)));
        i = i >> 4;
        o[2] = bytes1(uint8tohexchar(uint8(i & mask)));
        i = i >> 4;
        o[1] = bytes1(uint8tohexchar(uint8(i & mask)));
        i = i >> 4;
        o[0] = bytes1(uint8tohexchar(uint8(i & mask)));
        return string(o);
    }

    function getColors(address _addr) public pure returns(string[4] memory) {
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

    function toString(uint8 value) internal pure returns (string memory) {
        // Inspired by OpenZeppelin's implementation - MIT licence
        // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
        bytes memory buffer = new bytes(2);
        buffer[1] = bytes1(uint8(48 + value % 10));
        buffer[0] = bytes1(uint8(48 + (value/10) % 10));
        return string(buffer);
    }

    function toAscii(uint8 value) internal pure returns (bytes memory) {
        // Inspired by OpenZeppelin's implementation - MIT licence
        // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
        return bytes.concat(bytes1(uint8(48 + (value/10) % 10)), bytes1(uint8(48 + value % 10)));
    }

    function getCoordinates(address _addr) internal pure returns (uint8[40] memory) {
        uint8[40] memory o;
        uint160 a = uint160(address(_addr));
        uint160 mask = 15;
        for (uint8 i = 40; i > 0; i--) {
            o[i-1] = uint8((a & mask) + 16);
            a = a >> 4;
        }
        return o;
    }

    // function getPathBytes(address _addr) public pure returns (string memory) {
    //     // uint8[40] memory c = getCoordinates(_addr);
    //     uint8[40] memory c;
    //     uint160 a = uint160(address(_addr));
    //     uint160 mask = 15;
    //     for (uint8 i = 40; i > 0; i--) {
    //         c[i-1] = uint8((a & mask) + 16);
    //         a = a >> 4;
    //     }
    //     bytes memory y1 = toAscii(c[1]);
    //     bytes memory y2 = toAscii(c[3]);
    //     bytes memory o = bytes.concat('M',toAscii(c[0]),' ',y1,'C',toAscii(c[2]),' ',y2,' ');
    //     bytes memory q = bytes.concat('M',toAscii(48-c[0]),' ',y1,'C',toAscii(48-c[2]),' ',y2,' ');
    //     y1 = toAscii(c[5]);
    //     y2 = toAscii(c[7]);
    //     o = bytes.concat(o,toAscii(c[4]),' ',y1,' ',toAscii(c[6]),' ',y2);
    //     q = bytes.concat(q,toAscii(48-c[4]),' ',y1,' ',toAscii(48-c[6]),' ',y2);
    //     for (uint8 i = 8; i < 40; i+=4) {
    //         y1 = toAscii(c[i+1]);
    //         y2 = toAscii(c[i+3]);
    //         o = bytes.concat(o,'S',toAscii(c[i]),' ',y1,' ',toAscii(c[i+2]),' ',y2);
    //         q = bytes.concat(q,'S',toAscii(48-c[i]),' ',y1,' ',toAscii(48-c[i+2]),' ',y2);
    //     }
    //     y1 = toAscii(2*c[39]-c[37]);
    //     y2 = toAscii(c[1]);
    //     o = bytes.concat(o,'Q',toAscii(2*c[38]-c[36]),' ',y1,' ',toAscii(c[0]),' ',y2);
    //     q = bytes.concat(q,'Q',toAscii(48-(2*c[38]-c[36])),' ',y1,' ',toAscii(48-c[0]),' ',y2);
    //     return string(bytes.concat(o,q,"z"));
    // }

    // function getPathStr01(address _addr) public pure returns (string memory) {
    //     // uint8[40] memory c = getCoordinates(_addr);
    //     uint8[40] memory c;
    //     uint160 a = uint160(address(_addr));
    //     uint160 mask = 15;
    //     for (uint8 i = 40; i > 0; i--) {
    //         c[i-1] = uint8((a & mask) + 16);
    //         a = a >> 4;
    //     }
    //     string memory y1 = toString(c[1]);
    //     string memory y2 = toString(c[3]);
    //     string memory o = string.concat('M',toString(c[0]),' ',y1,'C',toString(c[2]),' ',y2,' ');
    //     string memory q = string.concat('M',toString(48-c[0]),' ',y1,'C',toString(48-c[2]),' ',y2,' ');
    //     y1 = toString(c[5]);
    //     y2 = toString(c[7]);
    //     o = string.concat(o,toString(c[4]),' ',y1,' ',toString(c[6]),' ',y2);
    //     q = string.concat(q,toString(48-c[4]),' ',y1,' ',toString(48-c[6]),' ',y2);
    //     for (uint8 i = 8; i < 40; i+=4) {
    //         y1 = toString(c[i+1]);
    //         y2 = toString(c[i+3]);
    //         o = string.concat(o,'S',toString(c[i]),' ',y1,' ',toString(c[i+2]),' ',y2);
    //         q = string.concat(q,'S',toString(48-c[i]),' ',y1,' ',toString(48-c[i+2]),' ',y2);
    //     }
    //     y1 = toString(2*c[39]-c[37]);
    //     y2 = toString(c[1]);
    //     o = string.concat(o,'Q',toString(2*c[38]-c[36]),' ',y1,' ',toString(c[0]),' ',y2);
    //     q = string.concat(q,'Q',toString(48-(2*c[38]-c[36])),' ',y1,' ',toString(48-c[0]),' ',y2);
    //     return string.concat(o,q,"z");
    // }

    // function getPathStr02(address _addr) public pure returns (string memory) {
    //     // uint8[40] memory c = getCoordinates(_addr);
    //     uint8[40] memory c;
    //     uint160 a = uint160(address(_addr));
    //     uint160 mask = 15;
    //     for (uint8 i = 40; i > 0; i--) {
    //         c[i-1] = uint8((a & mask) + 16);
    //         a = a >> 4;
    //     }
    //     string[22] memory o;
    //     o[0] = string.concat('M',toString(c[0]),' ',toString(c[1]),'C',toString(c[2]),' ',toString(c[3]),' ');
    //     o[1] = string.concat(toString(c[4]),' ',toString(c[5]),' ',toString(c[6]),' ',toString(c[7]));
    //     o[2] = string.concat('S',toString(c[8]),' ',toString(c[9]),' ',toString(c[10]),' ',toString(c[11]));
    //     o[3] = string.concat('S',toString(c[12]),' ',toString(c[13]),' ',toString(c[14]),' ',toString(c[15]));
    //     o[4] = string.concat('S',toString(c[16]),' ',toString(c[17]),' ',toString(c[18]),' ',toString(c[19]));
    //     o[5] = string.concat('S',toString(c[20]),' ',toString(c[21]),' ',toString(c[22]),' ',toString(c[23]));
    //     o[6] = string.concat('S',toString(c[24]),' ',toString(c[25]),' ',toString(c[26]),' ',toString(c[27]));
    //     o[7] = string.concat('S',toString(c[28]),' ',toString(c[29]),' ',toString(c[30]),' ',toString(c[31]));
    //     o[8] = string.concat('S',toString(c[32]),' ',toString(c[33]),' ',toString(c[34]),' ',toString(c[35]));
    //     o[9] = string.concat('S',toString(c[36]),' ',toString(c[37]),' ',toString(c[38]),' ',toString(c[39]));
    //     o[10] = string.concat('Q',toString(2*c[38]-c[36]),' ',toString(2*c[39]-c[37]),' ',toString(c[0]),' ',toString(c[1]));
    //     o[11] = string.concat('M',toString(48-c[0]),' ',toString(c[1]),'C',toString(48-c[2]),' ',toString(c[3]),' ');
    //     o[12] = string.concat(toString(48-c[4]),' ',toString(c[5]),' ',toString(48-c[6]),' ',toString(c[7]));
    //     o[13] = string.concat('S',toString(48-c[8]),' ',toString(c[9]),' ',toString(48-c[10]),' ',toString(c[11]));
    //     o[14] = string.concat('S',toString(48-c[12]),' ',toString(c[13]),' ',toString(48-c[14]),' ',toString(c[15]));
    //     o[15] = string.concat('S',toString(48-c[16]),' ',toString(c[17]),' ',toString(48-c[18]),' ',toString(c[19]));
    //     o[16] = string.concat('S',toString(48-c[20]),' ',toString(c[21]),' ',toString(48-c[22]),' ',toString(c[23]));
    //     o[17] = string.concat('S',toString(48-c[24]),' ',toString(c[25]),' ',toString(48-c[26]),' ',toString(c[27]));
    //     o[18] = string.concat('S',toString(48-c[28]),' ',toString(c[29]),' ',toString(48-c[30]),' ',toString(c[31]));
    //     o[19] = string.concat('S',toString(48-c[32]),' ',toString(c[33]),' ',toString(48-c[34]),' ',toString(c[35]));
    //     o[20] = string.concat('S',toString(48-c[36]),' ',toString(c[37]),' ',toString(48-c[38]),' ',toString(c[39]));
    //     o[21] = string.concat('Q',toString(48-(2*c[38]-c[36])),' ',toString(2*c[39]-c[37]),' ',toString(48-c[0]),' ',toString(c[1]),'z');

    //     string memory y1 = string.concat(o[0], o[1], o[2], o[3], o[4], o[5], o[6], o[7], o[8]);
    //     y1 = string.concat(y1, o[9], o[10], o[11], o[12], o[13], o[14], o[15], o[16]);
    //     y1 = string.concat(y1, o[17], o[18], o[19], o[20], o[21]);

    //     return y1;
    // }

    function getPathStr03(address _addr) public pure returns (string memory) {
        // uint8[40] memory c = getCoordinates(_addr);
        uint8[40] memory c;
        uint160 a = uint160(address(_addr));
        uint160 mask = 15;
        for (uint8 i = 40; i > 0; i--) {
            c[i-1] = uint8((a & mask) + 16);
            a = a >> 4;
        }
        string[22] memory o;
        string memory y1 = toString(c[1]);
        string memory y2 = toString(c[3]);
        o[0] = string.concat('M',toString(c[0]),' ',y1,'C',toString(c[2]),' ',y2,' ');
        o[11] = string.concat('M',toString(48-c[0]),' ',y1,'C',toString(48-c[2]),' ',y2,' ');
        y1 = toString(c[5]);
        y2 = toString(c[7]);
        o[1] = string.concat(toString(c[4]),' ',y1,' ',toString(c[6]),' ',y2);
        o[12] = string.concat(toString(48-c[4]),' ',y1,' ',toString(48-c[6]),' ',y2);
        y1 = toString(c[9]);
        y2 = toString(c[11]);
        o[2] = string.concat('S',toString(c[8]),' ',y1,' ',toString(c[10]),' ',y2);
        o[13] = string.concat('S',toString(48-c[8]),' ',y1,' ',toString(48-c[10]),' ',y2);
        y1 = toString(c[13]);
        y2 = toString(c[15]);
        o[3] = string.concat('S',toString(c[12]),' ',y1,' ',toString(c[14]),' ',y2);
        o[14] = string.concat('S',toString(48-c[12]),' ',y1,' ',toString(48-c[14]),' ',y2);
        y1 = toString(c[17]);
        y2 = toString(c[19]);
        o[4] = string.concat('S',toString(c[16]),' ',y1,' ',toString(c[18]),' ',y2);
        o[15] = string.concat('S',toString(48-c[16]),' ',y1,' ',toString(48-c[18]),' ',y2);
        y1 = toString(c[21]);
        y2 = toString(c[23]);
        o[5] = string.concat('S',toString(c[20]),' ',y1,' ',toString(c[22]),' ',y2);
        o[16] = string.concat('S',toString(48-c[20]),' ',y1,' ',toString(48-c[22]),' ',y2);
        y1 = toString(c[25]);
        y2 = toString(c[27]);
        o[6] = string.concat('S',toString(c[24]),' ',y1,' ',toString(c[26]),' ',y2);
        o[17] = string.concat('S',toString(48-c[24]),' ',y1,' ',toString(48-c[26]),' ',y2);
        y1 = toString(c[29]);
        y2 = toString(c[31]);
        o[7] = string.concat('S',toString(c[28]),' ',y1,' ',toString(c[30]),' ',y2);
        o[18] = string.concat('S',toString(48-c[28]),' ',y1,' ',toString(48-c[30]),' ',y2);
        y1 = toString(c[33]);
        y2 = toString(c[35]);
        o[8] = string.concat('S',toString(c[32]),' ',y1,' ',toString(c[34]),' ',y2);
        o[19] = string.concat('S',toString(48-c[32]),' ',y1,' ',toString(48-c[34]),' ',y2);
        y1 = toString(c[37]);
        y2 = toString(c[39]);
        o[9] = string.concat('S',toString(c[36]),' ',y1,' ',toString(c[38]),' ',y2);
        o[20] = string.concat('S',toString(48-c[36]),' ',y1,' ',toString(48-c[38]),' ',y2);
        y1 = toString(2*c[39]-c[37]);
        y2 = toString(c[1]);
        o[10] = string.concat('Q',toString(2*c[38]-c[36]),' ',y1,' ',toString(c[0]),' ',y2);
        o[21] = string.concat('Q',toString(48-(2*c[38]-c[36])),' ',y1,' ',toString(48-c[0]),' ',y2,'z');

        y1 = string.concat(o[0], o[1], o[2], o[3], o[4], o[5], o[6], o[7], o[8]);
        y1 = string.concat(y1, o[9], o[10], o[11], o[12], o[13], o[14], o[15], o[16]);
        y1 = string.concat(y1, o[17], o[18], o[19], o[20], o[21]);

        return y1;
    }

    function getPathStr04(address _addr) public pure returns (string memory) {
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

    // function testPathBytes(address _addr) public returns (string memory) {
    //     test = false;
    //     return getPathBytes(_addr);
    // }
    // function testPathStr01(address _addr) public returns (string memory) {
    //     test = false;
    //     return getPathStr01(_addr);
    // }
    // function testPathStr02(address _addr) public returns (string memory) {
    //     test = false;
    //     return getPathStr02(_addr);
    // }
    function testPathStr03(address _addr) public returns (string memory) {
        test = false;
        return getPathStr03(_addr);
    }
    function testPathStr04(address _addr) public returns (string memory) {
        test = false;
        return getPathStr04(_addr);
    }


}
