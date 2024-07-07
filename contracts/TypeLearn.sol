
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.17;

contract TypeLearn {
    
    function staticBytes() external pure returns (bytes4){
        bytes4 a = "abcd";
        return a;
    }

    function literal() external pure returns (uint256){
        uint256  p = (2 ** 800 + 1) - 2 ** 800;
        return p;
    }

    function literal2() external pure returns (uint128){
        uint128 a = 1;
        uint128 b;
        // error
        // b = 2.5 + a + 1;
        // error
        // b = a + 2.5 + 1.5;
        // ok
        b = 2.5 + 1.5 + a;
        return b;
    }

    enum ActionChoices {
        GoLeft,     // 0
        GoRight,    // 1
        GoUp,       // 2
        GoDown      // 3
    }

    ActionChoices choice;

    function getChoice() external view returns (ActionChoices) {
        return choice;
    }

    /*
    * -------------自定义值类型开始-------------------------
    */ 

    type Weight is uint128;
    type Price is uint128;

    Weight w = Weight.wrap(10);
    Price p = Price.wrap(5);
     // Weight wp = w + p ; // error
    // Price  pw = p + w ; // error

    Weight w1 = Weight.wrap(100);
    uint128 u = Weight.unwrap(w1);

    // Weight sum = w + w1;  // error
    function add(Weight x1, Weight x2) external pure returns (Weight){
        return Weight.wrap(Weight.unwrap(x1) + Weight.unwrap(x2));
    }
    /*
    * -------------自定义值类型结束-------------------------
    */ 

     /*
    * -------------数组开始-------------------------
    */ 
    // 全局变量声明，不能指定memory？

    // uint[3]   nftArr = [uint(1000), uint(1001), uint(1002)] ;

    function arr() public pure {
        uint[3] memory nftArr = [uint(1000), 1001, 1002];

        // uint size = 2;   
        // uint[size][size] memory array; // 非法，size 是变量，不能用来指定数组大小
        // uint[3] memory nftArr1 = [uint(1000), 1001];  //编译错误，长度不匹配


        // // 编译报错，类型不匹配
        // uint[3] memory nftArr2 = [1000, 1001, 1002]; 

        // uint[3] memory nftArr3 = [uint(1000), 1001];  //编译错误，长度不匹配


        // // 动态数组
        uint n = 3;
        uint[] memory nftArr4 = new uint[](n);

        // uint[] storage storageArr = new uint[](2); // 动态数组只有在storage位置才能用数组字面值初始化

    }


    uint[5] storageArr = [uint(0), 1, 2, 3, 4];
    function foo(string calldata payload) public pure  {
        // uint[3] storage s1 = storageArr[1:4]; // 编译错误，不能对 storage 位置的数组进行切片

        uint[5] memory memArr = [uint(0), 1, 2, 3, 4];
        // uint[3] memory s2 = memArr[1:4]; // 编译错误，不能对 memory 位置的数组进行切片

        string memory leading4Bytes = payload[1:4]; 

        // console.log("leading 4 bytes: %s", leading4Bytes);
    }

    uint[][3]  arrMem2; // 行为3，列任意的动态多维数组
    uint[][]  arrStorage; // 行列数任意的动态多维数组
    

    uint[][]  storageArr2;
    function initArray() public {
        uint n = 2;
        uint m = 3;
        for(uint i = 0; i < n; i++){
            storageArr2.push(new uint[](m));
        }
        storageArr3[0][1] = 1;  // this ok
        uint[3][2] memory arr = [[uint(1), 2, 3], [uint(4), 5, 6]];
        arr[0][0] = 1; // ok
        arr[1][0] = 2;  // 01
    }

    uint[3][2] storageArr3 = [[uint(1), 2, 3], [uint(4), 5, 6]];
    // storageArr3[0][0] = 1; // error 

    function bytesFunc() public {
        bytes memory bstr = new bytes(10);
        string memory message = string(bstr);

        string memory message1 = "hello world";
        bytes memory bstr1 = bytes(message1); //使用bytes()函数转换

        // uint len = message1.length; // 不合法，不能获取长度
        // bytes1 b = message1[0]; // 不合法，不能进行下标访问

        uint len = bytes(message1).length; // 合法
        bytes1 b = bytes(message1)[0]; // 合法

    }

    struct Book {
        string title; // 书名
        uint price;   // 价格
    }

    function structFunc() public pure {
        Book memory book;
        Book memory book1 = Book({title: "mybook1", price: 100}) ;
        Book memory book2 = Book("title2", 200);

    }

    mapping(address => uint) airDrop; // 只能定义和声明在storage

    // 映射类型作为入参和返回值时，函数可见性必须是 private 或 internal

    function mappingFunc() public  {
       airDrop[0xe68D0c3F462E53c5985f2d49988FCa154c7f143a] = 100;
    }
    mapping(uint => Book) lib;

}