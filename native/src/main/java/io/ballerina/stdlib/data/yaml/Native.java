/*
 * Copyright (c) 2024, WSO2 LLC. (https://www.wso2.com).
 *
 * WSO2 LLC. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package io.ballerina.stdlib.data.yaml;

import io.ballerina.runtime.api.Environment;
import io.ballerina.runtime.api.types.Type;
import io.ballerina.runtime.api.utils.TypeUtils;
import io.ballerina.runtime.api.values.BArray;
import io.ballerina.runtime.api.values.BError;
import io.ballerina.runtime.api.values.BMap;
import io.ballerina.runtime.api.values.BStream;
import io.ballerina.runtime.api.values.BString;
import io.ballerina.runtime.api.values.BTypedesc;
import io.ballerina.stdlib.data.yaml.parser.YamlParser;
import io.ballerina.stdlib.data.yaml.utils.DiagnosticErrorCode;
import io.ballerina.stdlib.data.yaml.utils.DiagnosticLog;

import java.io.ByteArrayInputStream;
import java.io.InputStreamReader;
import java.io.StringReader;

/**
 * This class is used to convert json inform of string, byte[], byte-stream to record or json type.
 *
 * @since 0.1.0
 */
public class Native {

    public static Object parseString(BString yaml, BMap<BString, Object> options, BTypedesc typed) {
        try {
            Type expType = TypeUtils.getReferredType(typed.getDescribingType());
            return YamlParser.parse(new StringReader(yaml.getValue()), expType);
        } catch (BError e) {
            return e;
        } catch (Exception e) {
            return DiagnosticLog.error(DiagnosticErrorCode.YAML_PARSER_EXCEPTION, e.getMessage());
        }
    }

    public static Object parseBytes(BArray yaml, BMap<BString, Object> options, BTypedesc typed) {
        try {
            Type expType = TypeUtils.getReferredType(typed.getDescribingType());
            return YamlParser.parse(new InputStreamReader(new ByteArrayInputStream(yaml.getBytes())), expType);
        } catch (BError e) {
            return e;
        } catch (Exception e) {
            return DiagnosticLog.error(DiagnosticErrorCode.YAML_PARSER_EXCEPTION, e.getMessage());
        }
    }

    public static Object parseStream(Environment env, BStream json, BMap<BString, Object> options, BTypedesc typed) {
        return null;
    }
}
