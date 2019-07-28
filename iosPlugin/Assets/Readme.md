# NativeSmsInvite   iOSUnityPlugin
### C# to Native sms, message code back to Unity

Since this is just the assets folder, you should open up a new project and copy it over or take the files and add to existing project. 

##### sharePlugin.mm 

-sendText() which will open the native sms and populate the message as specified. 

-messageComposeViewController() listens for the message result and sends a unitySendMessage

-extern c linker so that pluginTest.cs can access sendText()

##### pluginTest.cs 

-sendText() calls sendText assuming ios platform

-catchTextMessageCallback() receives unitySendMessage and then displays the result to a text value. 

##### postProcessBuild.cs 

-adds frameworks needed to xcode build project. 
