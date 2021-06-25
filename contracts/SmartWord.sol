//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract SmartWord is ERC721Enumerable, ERC721URIStorage, AccessControl {
    using Counters for Counters.Counter;
    using Strings for uint256; // pour convertir un uint256 en string facilement

    struct Text {
        uint256 textId; // id de notre item dans le jeu. id connu des développeurs.
        string title;
        string content;
    }
        bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    Counters.Counter private _textIds;
    mapping(uint256 => Text) private _texts;

    constructor() ERC721("SmartWord", "Text") {
        _setupRole(MINTER_ROLE, msg.sender);
    }

    function getTextById(uint256 id) public view returns (Text memory) {
        return _texts[id];
    }

    function tokenURI(uint256 tokenId) public view virtual override(ERC721URIStorage, ERC721) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    // Modifions _baseURI afin de retourner l'url de base
    // Cette fonction est utilisée par tokenURI pour retourner une url complète.
    // En fonction de l'item id (et pas du NFT id), nous aurons une url pour chacun de nos loots
    function _baseURI() internal view virtual override(ERC721) returns (string memory) {
        return "https://www.magnetgame.com/nft/";
    }

    // Il existe 2 définitions de supportsInterface, il faut aider le compilateur à gérer ce conflit.
    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC721Enumerable, ERC721, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    // Il existe 2 définitions de _beforeTokenTransfer, il faut aider le compilateur à gérer ce conflit.
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override(ERC721Enumerable, ERC721) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    // Il existe 2 définitions de _burn il faut aider le compilateur à gérer ce conflit.
    function _burn(uint256 tokenId) internal virtual override(ERC721URIStorage, ERC721) {
        super._burn(tokenId);
    }
}
