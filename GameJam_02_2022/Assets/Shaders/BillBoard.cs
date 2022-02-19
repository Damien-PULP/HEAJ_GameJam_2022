using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class BillBoard : MonoBehaviour
{
    public enum BillBoardOrientation
    {
        SameAsCamera,
        PointToCamera
    }

    public BillBoardOrientation Orientation = BillBoardOrientation.PointToCamera;
    public bool m_LockYAxis = false;

    Camera m_Camera;
    void Start()
    {
        m_Camera = Camera.main;
    }

    void LateUpdate()
    {

        switch (Orientation)
        {
            case BillBoardOrientation.SameAsCamera:
                transform.rotation = m_Camera.transform.rotation;
                break;
            case BillBoardOrientation.PointToCamera:
                transform.rotation = Quaternion.LookRotation(transform.position - m_Camera.transform.position);
                break;
            default:
                break;
        }
        if (m_LockYAxis)
        {
            transform.rotation = Quaternion.Euler(0.0f, transform.rotation.eulerAngles.y, 0.0f);
        }
    }
}
