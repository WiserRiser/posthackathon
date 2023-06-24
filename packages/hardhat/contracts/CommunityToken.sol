pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract CommunityToken is ERC721, ERC721URIStorage, ERC721Burnable, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    struct Community {
        uint site;
        string name;
        string rules; //IPFS hash
        bool restrictPosting;
        bool restrictVoting;
        bool sponsorPosts;
        address gateAddress;
    }

    // The internal ID tracker
    uint256 private _currentMaxId;

    mapping(uint256 => Community) public details;

    constructor() ERC721("CommunityToken", "YUNE") {
        //msg.sender;
    }

    function makeNew(
        address modMultiSig,
        uint site,
        string calldata name,
        string calldata rules, //IPFS hash
        bool restrictPosting,
        bool restrictVoting,
        bool sponsorPosts,
        address gateAddress
    ) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        details[tokenId] = Community(
            site,
            name,
            rules, //IPFS hash
            restrictPosting,
            restrictVoting,
            sponsorPosts,
            gateAddress
        );
        _safeMint(modMultiSig, tokenId);
        //_setTokenURI(tokenId, uri);
    }

    // The following function is an override required by Solidity for ERC721URIStorage.

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }
}
