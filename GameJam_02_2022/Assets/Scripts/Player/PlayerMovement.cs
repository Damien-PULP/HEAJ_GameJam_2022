using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Rigidbody))]
public class PlayerMovement : MonoBehaviour
{
    [Header("Movement Attributes")]
    public float m_RunSpeed = 6f;
    public float m_SprintSpeed = 9f;
    public float m_RotationSpeed = 15f;

    [Header("Required Components")]
    public InputManager m_InputManager;
    public AnimatorController m_AnimatorController;
    //Physics
    private Vector3 MovementDir;
    //Components
    private Transform MainCamTransform;
    private Rigidbody Rb;
    // Input
    private float VerticalInput;
    private float HorizontalInput;
    private float MoveValue;
    private bool IsSprinting;

    private void Awake()
    {
        MainCamTransform = Camera.main.transform;
        Rb = GetComponent<Rigidbody>();
    }

    private void FixedUpdate()
    {
        HandleMovement();
        HandleRotation();
    }

    private void Update()
    {
        GetMovementInput();
        UpdateAnimation(0, MoveValue, IsSprinting);
    }

    private void UpdateAnimation(float horMovement, float vertMovement, bool sprint)
    {
        float snappedHor;
        float snappedVert;

        // Snap Horizontal
        if(horMovement > 0f)
        {
            snappedHor = 0.5f;
        }else if (horMovement < 0f)
        {
            snappedHor = -0.5f;
        }
        else
        {
            snappedHor = 0f;
        }

        // Snap Vertical 
        if(vertMovement > 0f)
        {
            snappedVert = 0.5f;
        }else if(vertMovement < 0f)
        {
            snappedVert = -0.5f;
        }
        else
        {
            snappedVert = 0f;
        }

        if (sprint)
        {
            snappedVert = 1f;
            snappedHor = horMovement;
        } 
        if (m_AnimatorController) m_AnimatorController.UpdateAnimator(snappedHor, snappedVert);
    }

    private void GetMovementInput()
    {
        VerticalInput = m_InputManager.GetInputMovement().y;
        HorizontalInput = m_InputManager.GetInputMovement().x;
        IsSprinting = (MoveValue > 0.5f) ? m_InputManager.IsInputSprint() : false;
        // Move Value
        MoveValue = Mathf.Clamp01(Mathf.Abs(HorizontalInput) + Mathf.Abs(VerticalInput));

    }

    public void HandleMovement()
    {
        MovementDir = MainCamTransform.forward * VerticalInput; // Vertical Input
        MovementDir += MainCamTransform.right * HorizontalInput; // Horizontal Input
        MovementDir.Normalize();
        MovementDir.y = 0f;

        if (IsSprinting)
        {
            MovementDir *= m_SprintSpeed;
        }
        else
        {
            if (MoveValue >= 0.5f)
            {
                MovementDir *= m_RunSpeed;
            }
        }


        Vector3 moveVelocity = MovementDir;
        moveVelocity.y = Rb.velocity.y;

        Rb.velocity = moveVelocity;
    }

    public void HandleRotation()
    {
        Vector3 targetDir;
        targetDir = MainCamTransform.forward * m_InputManager.GetInputMovement().y; // Vertical Input
        targetDir += MainCamTransform.right * m_InputManager.GetInputMovement().x; // Horizontal Input
        targetDir.Normalize();
        targetDir.y = 0f;

        if (targetDir == Vector3.zero) targetDir = transform.forward;

        Quaternion targetRot = Quaternion.LookRotation(targetDir);
        Quaternion playerRot = Quaternion.Slerp(transform.rotation, targetRot, m_RotationSpeed * Time.fixedDeltaTime);

        transform.rotation = playerRot;
    }
}
