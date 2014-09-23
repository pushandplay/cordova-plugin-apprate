/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
*/

#import "CDVAppRate.h"
#import <Cordova/CDV.h>

@implementation CDVAppRate

- (void)getAppVersion:(CDVInvokedUrlCommand*)command
{
    [self.commandDelegate runInBackground:^{
		NSString* versionString = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
		CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:versionString];

		[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
	}];
}

- (void)getAppTitle:(CDVInvokedUrlCommand*)command
{
	[self.commandDelegate runInBackground:^{
		NSString* appNameString = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
		CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:appNameString];

		[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
	}];
}

@end