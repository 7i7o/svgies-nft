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

    function fixOpacity2(uint32 i) public pure returns (string memory) {
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

    function getColors2(address _addr) public pure returns(string[4] memory) {
        string[4] memory s;
        uint256 h = uint(keccak256(abi.encodePacked(_addr)));
        uint256 mask = 0x000000000000000000000000ffffffff;
        h = h >> 128;
        s[3] = fixOpacity2(uint32(h & mask));
        h = h >> 32;
        s[2] = fixOpacity2(uint32(h & mask));
        h = h >> 32;
        s[1] = fixOpacity2(uint32(h & mask));
        h = h >> 32;
        s[0] = fixOpacity2(uint32(h & mask));
        return s;
    }
    
    function getPath(address _addr) public pure returns (string memory) {
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

    function getPathGasTest(address _addr) public returns (string memory) {
        test = false;
        return getPath(_addr);
    }

    function getColorsGasTest(address _addr) public returns (string[4] memory) {
        test = false;
        return getColors(_addr);
    }

    function getColors2GasTest(address _addr) public returns (string[4] memory) {
        test = false;
        return getColors2(_addr);
    }

}
