using System.Collections;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using UnityEngine;
using UnityEngine.UI;

public class pluginTest : MonoBehaviour
{
	// Start is called before the first frame update
#if UNITY_IOS
	[DllImport("__Internal")]
	private static extern double IOSgetElapsedTime();
    [DllImport("__Internal")]
    private static extern void IOSsendText();
#endif
	private int fCounter = 0;
	public Text text;
    void Start()
    {
		Debug.Log("Elapsed Time: " + getElapsedTime());
    }

    // Update is called once per frame
    void Update()
    {
        if(fCounter >= 60)
		{
			Debug.Log("Tick: " + getElapsedTime());
			fCounter = 0;
		}
		fCounter++;
    }

    double getElapsedTime()
	{
		if (Application.platform == RuntimePlatform.IPhonePlayer)
			return IOSgetElapsedTime();
		Debug.LogWarning("wrong platform!");
		return 0;
	}
    public void sendText()
	{
		if (Application.platform == RuntimePlatform.IPhonePlayer)
			IOSsendText();
			//Debug.Log("Pressed Send Text");

		else
			Debug.LogWarning("wrong platform!");
	}

    public void catchTextMessageCallback(string _case)
	{
        if(_case == "0")
		{
			text.text = "sent successfuly";
		}
        else if (_case == "1")
		{
			text.text = "message cancelled";
		}
		else
		{
			text.text = "message failed";
		}
	}
}
