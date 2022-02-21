using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LookAtCamera : MonoBehaviour
{
    private Camera CameraRef;
    private void Start()
    {
        CameraRef = Camera.main;
    }
    private void LateUpdate()
    {
        transform.rotation = Quaternion.LookRotation(transform.position - CameraRef.transform.position);
        transform.rotation = Quaternion.Euler(0.0f, transform.rotation.eulerAngles.y, 0.0f);
    }
}
