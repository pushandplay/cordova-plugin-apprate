using System;
using System.Windows;
using System.Windows.Navigation;
using Microsoft.Phone.Controls;
using WPCordovaClassLib.Cordova;
using WPCordovaClassLib.Cordova.Commands;
using WPCordovaClassLib.Cordova.JSON;
using Windows.ApplicationModel;
using System.Xml.Linq;

namespace Cordova.Extension.Commands
{
    public class AppRate : BaseCommand
    {
        public void getAppVersion(string empty)
        {
            String version= XDocument.Load("WMAppManifest.xml").Root.Element("App").Attribute("Version").Value;

            this.DispatchCommandResult(new PluginResult(PluginResult.Status.OK, version));
        }
        public void getAppTitle(string empty)
        {
        	String title= XDocument.Load("WMAppManifest.xml").Root.Element("App").Attribute("Title").Value;

        	this.DispatchCommandResult(new PluginResult(PluginResult.Status.OK, title));
        }
    }
}