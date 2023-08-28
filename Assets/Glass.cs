using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Glass : MonoBehaviour
{
    public AnimationCurve animationCurve;
    // Start is called before the first frame update
    void Start()
    {
        StartCoroutine(MoveAnim());
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    IEnumerator MoveAnim()
    {
        float timer = 0;
        bool dir = true;
        while (true)
        {
            if(dir)
            {
                timer += Time.deltaTime * 0.5f;
                if(timer >= 1)
                {
                    timer = 1;
                    dir = !dir;
                }
            }
            else
            {
                timer -= Time.deltaTime * 0.5f;
                if(timer <= 0)
                {
                    timer = 0;
                    dir = !dir;
                }
            }
            Vector3 pos = transform.localPosition;
            pos.x = Mathf.Lerp(-1, 1,timer);
            transform.localPosition = pos;
            yield return null;
        }
    }
}
