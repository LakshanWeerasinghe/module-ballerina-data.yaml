// Copyright (c) 2024, WSO2 LLC. (https://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied. See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/io;
import ballerina/test;

const PROJECTION_OPTIONS_PATH = FILE_PATH + "projection_options/";

final Options & readonly options1 = {
    allowDataProjection: {
        nilAsOptionalField: true,
        absentAsNilableType: false,
        enableYamlStreamReorder: false
    }
};

final Options & readonly options2 = {
    allowDataProjection: {
        nilAsOptionalField: false,
        absentAsNilableType: true,
        enableYamlStreamReorder: false
    }
};

final Options & readonly options3 = {
    allowDataProjection: {
        nilAsOptionalField: true,
        absentAsNilableType: true,
        enableYamlStreamReorder: false
    }
};

type Sales record {|
    @Name {
        value: "sales_data"
    }
    SalesData[] salesData;
    @Name {
        value: "total_sales"
    }
    record {|
        @Name {
            value: "date_range"
        }
        string dataRange?;
        @Name {
            value: "total_revenue"
        }
        string totalRevenue;
    |} totalSales;
|};

type SalesData record {|
    @Name {
        value: "transaction_id"
    }
    string transactionId;
    string date;
    @Name {
        value: "customer_name"
    }
    string customerName;
    string product;
    @Name {
        value: "unit_price"
    }
    string unitPrice;
    @Name {
        value: "total_price"
    }
    string totalPrice?;
|};

@test:Config {
    groups: ["options"]
}
isolated function testNilAsOptionalFieldForParseString() returns error? {
    string data = check io:fileReadString(PROJECTION_OPTIONS_PATH + "sales.yaml");
    Sales sales = check parseBytes(data.toBytes(), options1);
    test:assertEquals(sales.salesData[0].length(), 5);
    test:assertEquals(sales.salesData[0].transactionId, "TXN001");
    test:assertEquals(sales.salesData[0].date, "2024-03-25");
    test:assertEquals(sales.salesData[0].customerName, "ABC Corporation");
    test:assertEquals(sales.salesData[0].product, "InnovateX");
    test:assertEquals(sales.salesData[0].unitPrice, "$499");

    test:assertEquals(sales.salesData[1].length(), 6);
    test:assertEquals(sales.salesData[1].transactionId, "TXN002");
    test:assertEquals(sales.salesData[1].date, "2024-03-25");
    test:assertEquals(sales.salesData[1].customerName, "XYZ Enterprises");
    test:assertEquals(sales.salesData[1].product, "SecureTech");
    test:assertEquals(sales.salesData[1].unitPrice, "$999");
    test:assertEquals(sales.salesData[1].totalPrice, "$4995");

    test:assertEquals(sales.salesData[2].length(), 5);
    test:assertEquals(sales.salesData[2].transactionId, "TXN003");
    test:assertEquals(sales.salesData[2].date, "2024-03-26");
    test:assertEquals(sales.salesData[2].customerName, "123 Inc.");
    test:assertEquals(sales.salesData[2].product, "InnovateX");
    test:assertEquals(sales.salesData[2].unitPrice, "$499");

    test:assertEquals(sales.totalSales.length(), 1);
    test:assertEquals(sales.totalSales.totalRevenue, "$21462");
}

@test:Config {
    groups: ["options"]
}
isolated function testNilAsOptionalFieldForParseStringNegative() returns error? {
    string data = check io:fileReadString(PROJECTION_OPTIONS_PATH + "sales.yaml");
    Sales|Error err = parseBytes(data.toBytes());
    test:assertTrue(err is Error);
    test:assertEquals((<Error>err).message(), "incompatible value 'null' for type 'string' in field 'salesData.totalPrice'");
}


type Response record {|
    string status;
    record {|
        User user;
        Post[] posts;
    |} data;
|};

type User record {|
    int id;
    string username;
    string? email;
|};

type Post record {|
    int id;
    string title;
    string? content;
|};

@test:Config {
    groups: ["options"]
}
isolated function testAbsentAsNilableTypeForParseString() returns error? {
    string data = check io:fileReadString(PROJECTION_OPTIONS_PATH + "response.yaml");
    Response response = check parseBytes(data.toBytes(), options2);
    test:assertEquals(response.status, "success");

    test:assertEquals(response.data.user.length(), 3);
    test:assertEquals(response.data.user.id, 123);
    test:assertEquals(response.data.user.username, "example_user");
    test:assertEquals(response.data.user.email, ());

    test:assertEquals(response.data.user.length(), 3);
    test:assertEquals(response.data.posts[0].id, 1);
    test:assertEquals(response.data.posts[0].title, "First Post");
    test:assertEquals(response.data.posts[0].content, "This is the content of the first post.");

    test:assertEquals(response.data.user.length(), 3);
    test:assertEquals(response.data.posts[1].id, 2);
    test:assertEquals(response.data.posts[1].title, "Second Post");
    test:assertEquals(response.data.posts[1].content, ());
}

type Specifications record {
    string storage?;
    string display?;
    string? processor;
    string? ram;
    string? graphics;
    string? camera;
    string? battery;
    string os?;
    string 'type?;
    boolean wireless?;
    string battery_life?;
    boolean noise_cancellation?;
    string? color;
};

type ProductsItem record {
    int id;
    string name;
    string brand?;
    decimal price;
    string? description;
    Specifications specifications?;
};

type Data record {
    ProductsItem[] products;
};

type ResponseEcom record {
    string status;
    Data data;
};

@test:Config {
    groups: ["options"]
}
isolated function testAbsentAsNilableTypeAndAbsentAsNilableTypeForParseString() returns error? {
    string data = check io:fileReadString(PROJECTION_OPTIONS_PATH + "product_list_response.yaml");
    ResponseEcom response = check parseBytes(data.toBytes(), options3);

    test:assertEquals(response.status, "success");
    test:assertEquals(response.data.products[0].length(), 6);
    test:assertEquals(response.data.products[0].id, 1);
    test:assertEquals(response.data.products[0].name, "Laptop");
    test:assertEquals(response.data.products[0].brand, "ExampleBrand");
    test:assertEquals(response.data.products[0].price, 999.99d);
    test:assertEquals(response.data.products[0].description, "A powerful laptop for all your computing needs.");
    test:assertEquals(response.data.products[0].specifications?.storage, "512GB SSD");
    test:assertEquals(response.data.products[0].specifications?.display, "15.6-inch FHD");
    test:assertEquals(response.data.products[0].specifications?.processor, "Intel Core i7");
    test:assertEquals(response.data.products[0].specifications?.ram, "16GB DDR4");
    test:assertEquals(response.data.products[0].specifications?.graphics, "NVIDIA GeForce GTX 1650");
    test:assertEquals(response.data.products[0].specifications?.camera, ());
    test:assertEquals(response.data.products[0].specifications?.battery, ());
    test:assertEquals(response.data.products[0].specifications?.color, ());

    test:assertEquals(response.data.products[1].length(), 5);
    test:assertEquals(response.data.products[1].id, 2);
    test:assertEquals(response.data.products[1].name, "Smartphone");
    test:assertEquals(response.data.products[1].price, 699.99d);
    test:assertEquals(response.data.products[1].description, ());
    test:assertEquals(response.data.products[1].specifications?.storage, "256GB");
    test:assertEquals(response.data.products[1].specifications?.display, "6.5-inch AMOLED");
    test:assertEquals(response.data.products[1].specifications?.processor, ());
    test:assertEquals(response.data.products[1].specifications?.ram, ());
    test:assertEquals(response.data.products[1].specifications?.graphics, ());
    test:assertEquals(response.data.products[1].specifications?.camera, "Quad-camera setup");
    test:assertEquals(response.data.products[1].specifications?.battery, "4000mAh");
    test:assertEquals(response.data.products[1].specifications?.color, ());

    test:assertEquals(response.data.products[2].length(), 6);
    test:assertEquals(response.data.products[2].id, 3);
    test:assertEquals(response.data.products[2].name, "Headphones");
    test:assertEquals(response.data.products[2].brand, "AudioTech");
    test:assertEquals(response.data.products[2].price, 149.99d);
    test:assertEquals(response.data.products[2].description, "Immerse yourself in high-quality sound with these headphones.");
    test:assertEquals(response.data.products[2].specifications?.processor, ());
    test:assertEquals(response.data.products[2].specifications?.ram, ());
    test:assertEquals(response.data.products[2].specifications?.graphics, ());
    test:assertEquals(response.data.products[2].specifications?.camera, ());
    test:assertEquals(response.data.products[2].specifications?.battery, ());
    test:assertEquals(response.data.products[2].specifications?.'type, "Over-ear");
    test:assertEquals(response.data.products[2].specifications?.wireless, true);
    test:assertEquals(response.data.products[2].specifications?.noise_cancellation, true);
    test:assertEquals(response.data.products[2].specifications?.color, "Black");

    test:assertEquals(response.data.products[3].length(), 5);
    test:assertEquals(response.data.products[3].id, 4);
    test:assertEquals(response.data.products[3].name, "Wireless Earbuds");
    test:assertEquals(response.data.products[3].brand, "SoundMaster");
    test:assertEquals(response.data.products[3].price, 99.99d);
    test:assertEquals(response.data.products[3].description, "Enjoy freedom of movement with these wireless earbuds.");
}

@test:Config {
    groups: ["options"]
}
isolated function testDisableOptionsOfProjectionTypeForParseString1() returns error? {
    string data = check io:fileReadString(PROJECTION_OPTIONS_PATH + "sales.yaml");
    Sales|Error err = parseBytes(data.toBytes());
    test:assertTrue(err is Error);
    test:assertEquals((<Error>err).message(), "incompatible value 'null' for type 'string' in field 'salesData.totalPrice'");
}

@test:Config {
    groups: ["options"]
}
isolated function testDisableOptionsOfProjectionTypeForParseString2() returns error? {
    string data = check io:fileReadString(PROJECTION_OPTIONS_PATH + "response.yaml");

    Response|Error err = parseBytes(data.toBytes());
    test:assertTrue(err is Error);
    test:assertEquals((<Error>err).message(), "required field 'email' not present in YAML");
}

@test:Config
isolated function testAbsentAsNilableTypeAndAbsentAsNilableTypeForParseString3() returns error? {
    record {|
        string name;
    |}|Error val1 = parseString(string `{"name": null}`, options3);
    test:assertTrue(val1 is Error);
    test:assertEquals((<Error>val1).message(), "incompatible value 'null' for type 'string' in field 'name'");

    record {|
        string? name;
    |} val2 = check parseString(string `{"name": null}`, options3);
    test:assertEquals(val2.name, ());

    record {|
        string name?;
    |} val3 = check parseString(string `{"name": null}`, options3);
    test:assertEquals(val3, {});

    record {|
        string? name?;
    |} val4 = check parseString(string `{"name": null}`, options3);
    test:assertEquals(val4?.name, ());

    record {|
        string name;
    |}|Error val5 = parseString(string `{}`, options3);
    test:assertTrue(val5 is Error);
    test:assertEquals((<Error>val5).message(), "required field 'name' not present in YAML");

    record {|
        string? name;
    |} val6 = check parseString(string `{}`, options3);
    test:assertEquals(val6.name, ());

    record {|
        string name?;
    |} val7 = check parseString(string `{}`, options3);
    test:assertEquals(val7, {});

    record {|
        string? name?;
    |} val8 = check parseString(string `{}`, options3);
    test:assertEquals(val8?.name, ());
}
