// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.12;

contract Contract {
    function uint8tohexchar(uint8 i) private pure returns (uint8) {
        return (i > 9) ? (i + 87) : (i + 48); // (i > 9) ? (ascii a-f) : (ascii 0-9)
    }

    function fixOpacity(uint32 i) private pure returns (string memory) {
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
        if (value == 0) {
            return "0";
        }
        if (value < 10) {
            bytes memory buffer1 = new bytes(1);
            buffer1[0] = (bytes1(uint8(48 + value)));
            return string(buffer1);
        }
        if (value < 100) {
            bytes memory buffer2 = new bytes(2);
            buffer2[1] = bytes1(uint8(48 + value % 10));
            buffer2[0] = bytes1(uint8(48 + (value/10) % 10));
            return string(buffer2);
        }
        bytes memory buffer3 = new bytes(3);
        buffer3[2] = bytes1(uint8(48 + value % 10));
        buffer3[1] = bytes1(uint8(48 + (value/10) % 10));
        buffer3[0] = bytes1(uint8(48 + (value/100) % 10));
        return string(buffer3);
    }

    function getCoordinates(address _addr) internal pure returns (uint8[40] memory) {
        uint8[40] memory o;
        uint160 a = uint160(address(_addr));
        uint160 mask = 15;
        for (uint256 i = 39; i > 0; i--) {
            o[i] = uint8((a & mask) + 16);
            a = a >> 4;
        }
        return o;
    }

    function getPath(address _addr) public pure returns (string memory) {
        uint8[40] memory c = getCoordinates(_addr);
        string memory y1 = toString(c[1]);
        string memory y2 = toString(c[3]);
        string memory o = string.concat('M',toString(c[0]),' ',y1,'C',toString(c[2]),' ',y2,' ');
        string memory q = string.concat('M',toString(48-c[0]),' ',y1,'C',toString(48-c[2]),' ',y2,' ');
        y1 = toString(c[5]);
        y2 = toString(c[7]);
        o = string.concat(o,toString(c[4]),' ',y1,' ',toString(c[6]),' ',y2);
        q = string.concat(q,toString(48-c[4]),' ',y1,' ',toString(48-c[6]),' ',y2);
        for (uint8 i = 8; i < 40; i+=4) {
            y1 = toString(c[i+1]);
            y2 = toString(c[i+3]);
            o = string.concat(o,'S',toString(c[i]),' ',y1,' ',toString(c[i+2]),' ',y2);
            q = string.concat(q,'S',toString(48-c[i]),' ',y1,' ',toString(48-c[i+2]),' ',y2);
        }
        y1 = toString(2*c[39]-c[37]);
        y2 = toString(c[1]);
        o = string.concat(o,'Q',toString(2*c[38]-c[36]),' ',y1,' ',toString(c[0]),' ',y2);
        q = string.concat(q,'Q',toString(48-(2*c[38]-c[36])),' ',y1,' ',toString(48-c[0]),' ',y2);
        return string.concat(o,q,"z");
    }

}
