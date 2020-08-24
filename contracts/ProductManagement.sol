pragma solidity ^0.5.2;

contract ProductManagement {
  struct Part {
    address manufacturer;
    string serial_number;
    string part_type;
    string creation_date;
  }

  struct Product {
    address manufacturer;
    string serial_number;
    string product_type;
    string creation_date;
    bytes32[6] parts;
  }

  mapping(bytes32 => Part) public parts;
  mapping(bytes32 => Product) public products;

  function buildPart(
    string calldata serial_number,
    string calldata part_type,
    string calldata creation_date,
    bytes32 part_hash
  ) external returns (bytes32) {
    require(
      parts[part_hash].manufacturer == address(0),
      "Part ID should be unique"
    );

    Part memory new_part = Part(
      msg.sender,
      serial_number,
      part_type,
      creation_date
    );
    parts[part_hash] = new_part;
    return part_hash;
  }

  function buildProduct(
    string calldata serial_number,
    string calldata product_type,
    string calldata creation_date,
    bytes32[6] calldata part_array,
    bytes32 product_hash
  ) external returns (bytes32) {
    uint256 index;
    for (index = 0; index < part_array.length; index++) {
      require(
        parts[part_array[index]].manufacturer != address(0),
        "All parts must be registered before being used ina product"
      );
    }

    require(
      products[product_hash].manufacturer == address(0),
      "Product ID already used"
    );

    Product memory new_product = Product(
      msg.sender,
      serial_number,
      product_type,
      creation_date,
      part_array
    );
    products[product_hash] = new_product;
    return product_hash;
  }

  function getParts(bytes32 product_hash)
    external
    view
    returns (bytes32[6] memory)
  {
    require(
      products[product_hash].manufacturer != address(0),
      "Product not present"
    );
    return products[product_hash].parts;
  }
}
