using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraTPSManager : MonoBehaviour
{
    public Transform m_Target;
    public Transform m_CameraPivot;
    public Transform m_CameraTransform;
    [Space]
    public float m_Speed = 0.2f;
    public float m_RotationSpeed = 0.2f;
    [Space]
    public float m_HorizontalSensivity = 0.9f;
    public float m_VerticalSensivity = 0.2f;
    [Space]
    public float m_MinVertAngle = -35f;
    public float m_MaxVertAngle = 35f;
    public float m_LeftAngleHorizontal = -35f;
    public float m_RightAngleHorizontal = 35f;
    [Space]
    public float m_RadiusCollision = 0.5f;
    public float m_CollisionOffset = 0.2f;
    public float m_MinCollisionOffset = 0.2f;
    public float m_InterpolationAvoidCollision = 0.2f;
    public LayerMask m_LayerCollision;
    public bool m_InverseYAxeCam;
    private float DefaultZPosition;
    private float HorAngle;
    private float VertAngle;
    private Vector3 CameraPos;
    [Space]
    public InputManager m_InputManager;

    private Vector3 VelocityCam;

    private void Start()
    {
        Cursor.visible = false;
        Cursor.lockState = CursorLockMode.Confined;

        DefaultZPosition = m_CameraTransform.localPosition.z;
    }
    private void LateUpdate()
    {
        FollowTarget();
        RotateCamera();
        AvoidCollision();
    }
    private void FollowTarget()
    {
        Vector3 targetPos = Vector3.SmoothDamp(transform.position,m_Target.position, ref VelocityCam, m_Speed);
        transform.position = targetPos;
    }
    private void RotateCamera()
    {
        HorAngle += m_InputManager.GetInputCamera().x * m_RotationSpeed * m_HorizontalSensivity;
        if (m_InverseYAxeCam)
        {
            VertAngle -= m_InputManager.GetInputCamera().y * m_RotationSpeed * m_VerticalSensivity;
        }
        else
        {
            VertAngle += m_InputManager.GetInputCamera().y * m_RotationSpeed * m_VerticalSensivity;
        }

        VertAngle = Mathf.Clamp(VertAngle, m_MinVertAngle, m_MaxVertAngle);
        //HorAngle = Mathf.Clamp(HorAngle, m_LeftAngleHorizontal, m_RightAngleHorizontal);

        Vector3 rot;
        Quaternion targetRot;

        rot = Vector3.zero;
        rot.y = HorAngle;
        targetRot = Quaternion.Euler(rot);
        transform.localRotation = targetRot;

        rot = Vector3.zero;
        rot.x = VertAngle;
        targetRot = Quaternion.Euler(rot);
        m_CameraPivot.localRotation = targetRot;
    }

    private void AvoidCollision()
    {
        float zTargetPos = DefaultZPosition;
        RaycastHit hit;
        Vector3 dir = (m_CameraTransform.position - m_CameraPivot.position).normalized;

        if(Physics.SphereCast(m_CameraPivot.transform.position, m_RadiusCollision, dir, out hit, Mathf.Abs(zTargetPos), m_LayerCollision))
        {
            Debug.Log("ObstacleDetected");
            float distance = Vector3.Distance(m_CameraPivot.position, hit.point);
            zTargetPos = -(distance - m_CollisionOffset);
        }
        if(Mathf.Abs(zTargetPos) < m_MinCollisionOffset)
        {
            zTargetPos -= m_MinCollisionOffset;
        }
        CameraPos.z = Mathf.Lerp(m_CameraTransform.localPosition.z, zTargetPos, m_InterpolationAvoidCollision);
        m_CameraTransform.localPosition = CameraPos;
    }
}
