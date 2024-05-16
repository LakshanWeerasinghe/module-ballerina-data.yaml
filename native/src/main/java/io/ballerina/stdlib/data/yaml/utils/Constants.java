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

package io.ballerina.stdlib.data.yaml.utils;

import io.ballerina.runtime.api.utils.StringUtils;
import io.ballerina.runtime.api.values.BString;

public class Constants {

    public static final BString INDENTATION_POLICY = StringUtils.fromString("indentationPolicy");
    public static final BString BLOCK_LEVEL = StringUtils.fromString("blockLevel");
    public static final BString CANONICAL = StringUtils.fromString("canonical");
    public static final BString USE_SINGLE_QUOTES = StringUtils.fromString("useSingleQuotes");
    public static final BString FORCE_QUOTES = StringUtils.fromString("forceQuotes");
    public static final BString SCHEMA = StringUtils.fromString("schema");
    public static final BString IS_STREAM = StringUtils.fromString("isStream");
    public static final BString FLOW_STYLE = StringUtils.fromString("flowStyle");
    public static final BString ALLOW_ANCHOR_REDEFINITION = StringUtils.fromString("allowAnchorRedefinition");
    public static final BString ALLOW_MAP_ENTRY_REDEFINITION = StringUtils.fromString("allowMapEntryRedefinition");
    public static final BString ALLOW_DATA_PROJECTION = StringUtils.fromString("allowDataProjection");
    public static final BString NIL_AS_OPTIONAL_FIELD = StringUtils.fromString("nilAsOptionalField");
    public static final BString ABSENT_AS_NILABLE_TYPE = StringUtils.fromString("absentAsNilableType");
}
