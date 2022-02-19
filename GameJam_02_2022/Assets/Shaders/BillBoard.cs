using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class BillBoard : MonoBehaviour
{
  public  Transform cam;

    void Awake()
    {
    }

    void Update() // update works better than LateUpdate, but It should be done in LateUpdate...
    {
        transform.LookAt(Camera.main.transform.position, Vector3.up);
        //transform.rotation = Quaternion.LookRotation( transform.position - cam.position );
    }

}
