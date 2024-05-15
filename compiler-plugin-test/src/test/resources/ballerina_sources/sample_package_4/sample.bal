import ballerina/data.yaml;

type Person record {|
    string? name;
    table<record {| int a;|}>|map<string> address;
    xml|json company;
|};

string str = string `{
        "name": "John",
        "address": {
            "street": "Main Street",
            "country": "USA"
        },
        "company": {
            "street": "Main Street",
            "country": "USA"
        }
    }`;
Person _ = check yaml:parseString(str);
