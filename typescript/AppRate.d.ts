/*
 *
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 *
 */
declare class AppRate {
	static locales:Locales;
	static preferences:AppRatePreferences;
	
	static init():AppRate;
	static promptForRating(immediately?:Boolean):AppRate;
	static navigateToAppStore():AppRate;
}

declare class AppRatePreferences {
	useLanguage:String;
	displayAppName:String;
	promptAgainForEachNewVersion:Boolean;
	usesUntilPrompt:Number;
	openStoreInApp:Boolean;
	useCustomRateDialog:Boolean;
	callbacks:CallbackPreferences;
	storeAppURL:StoreAppURLPreferences;
	customLocale:CustomLocale;
}

declare class StoreAppURLPreferences {
	ios:String;
	android:String;
	blackberry:String;
	windows8:String;
}

declare class CallbackPreferences {
	onButtonClicked:(buttonIndex:Number) => void;
	onRateDialogShow:(rateCallback:(buttonIndex:Number) => void) => void;
}

declare class CustomLocale {
	title:String;
	message:String;
	cancelButtonLabel:String;
	laterButtonLabel:String;
	rateButtonLabel:String;
}

declare class Locales {
	addLocale(localeObject:Locale):Locale;
	getLocale(language:String, applicationTitle?:String):Locale;
	getLocalesNames():Array<String>;
}

declare class Locale {
	constructor(localeOptions:LocaleOptions);
}

declare class LocaleOptions {
	language:String
	title:String;
	message:String;
	cancelButtonLabel:String;
	laterButtonLabel:String;
	rateButtonLabel:String;
}