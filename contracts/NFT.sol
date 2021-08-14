// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "./StringArrayLib.sol";
import "./stringUtils.sol";
contract OneAndOnly is ERC721, Pausable, Ownable {
    using Counters for Counters.Counter;
    using SafeMath for uint256;
    using StringArrayLib for StringArrayLib.Values;
    string private _baseURIPrefix;
    uint private constant maxTokensPerTransaction = 100;
    uint256 private tokenPrice = 0.05 ether; //0.05 ETH
    mapping(string => address) public registry;
    mapping(string => uint256) public idByWords;
    mapping(uint256 => string) public wordById;
    mapping(address => StringArrayLib.Values) private wordsByOwner;
    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("OneAndOnly", "ONE") public {
        _tokenIdCounter.increment();
    }

    function setBaseURI(string memory baseURIPrefix) public onlyOwner {
        _baseURIPrefix = baseURIPrefix;
    }

    function setTokenPrice(uint256 _price) public onlyOwner {
        tokenPrice = _price;
    }

    function getBaseURIPrefix() internal view returns (string memory) {
        return _baseURIPrefix;
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function withdraw() public onlyOwner {
        uint balance = address(this).balance;
        payable(msg.sender).transfer(balance);
    }

    function isThisWordAvailable(string memory word) public view returns (bool) {
        return registry[word] == address(0x0);
    }

    function getAllRegisteredWordsByOwner( address user )
    public view returns (string[] memory)
    {
        return wordsByOwner[user].getAllValues();
    }

    function tokenURI(uint256 tokenId)
    public
    view
    override(ERC721)
    returns (string memory)
    {
        return string(abi.encodePacked(_baseURIPrefix, "/", wordById[tokenId]));
    }

    event OnBuy(address indexed user, string word, uint256 id);
    function buy(string memory _word) whenNotPaused public payable {
        require( StringUtils.indexOf(_word, "<") == -1 , "invalid char");
        require(tokenPrice <= msg.value, "Ether value sent is too low");
        string memory word = toLower ( _word );
        require( registry[word] == address(0x0), "word already registered");
        registry[word] = msg.sender;
        wordsByOwner[msg.sender].pushValue(word);
        uint256 id = _tokenIdCounter.current();
        idByWords[word] = id;
        wordById[id] = word;
        _safeMint(msg.sender, _tokenIdCounter.current());
        _tokenIdCounter.increment();
        emit OnBuy(msg.sender, word, id);
    }

    event OnBurn(address indexed user, string word, uint256 id);
    function burn(string memory _word) whenNotPaused public payable {
        require(tokenPrice <= msg.value, "Ether value sent is too low");
        string memory word = toLower ( _word );
        require( registry[word] == msg.sender, "not owner");
        uint256 id = idByWords[word];
        idByWords[word] = 0;
        wordById[id] = "";
        require( id > 0, "invalid token id");
        registry[word] = address(0x0);
        wordsByOwner[msg.sender].removeValue(word);
        _burn(id);
        emit OnBuy(msg.sender, word, id);
    }

    function toLower(string memory str) internal pure returns (string memory) {
        bytes memory bStr = bytes(str);
        bytes memory bLower = new bytes(bStr.length);
        for (uint i = 0; i < bStr.length; i++) {
            // Uppercase character...
            if ((uint8(bStr[i]) >= 65) && (uint8(bStr[i]) <= 90)) {
                // So we add 32 to make it lowercase
                bLower[i] = bytes1(uint8(bStr[i]) + 32);
            } else {
                bLower[i] = bStr[i];
            }
        }
        return string(bLower);
    }

}
