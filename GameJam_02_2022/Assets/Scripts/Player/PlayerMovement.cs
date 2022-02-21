using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Rigidbody))]
public class PlayerMovement : MonoBehaviour
{
    public enum E_State
    {
        InGame,
        Impacted,
        Dead
    }
    public E_State m_CurrentState;
    [Header("Movement Attributes")]
    public float m_RunSpeed = 6f;
    public float m_SprintSpeed = 9f;
    public float m_RotationSpeed = 15f;
    public float m_HorizontalFactorSpeed = 0.5f;
    public float m_TimeImpacted = 0.8f;

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
    private float Timer;

    private void Awake()
    {
        MainCamTransform = Camera.main.transform;
        Rb = GetComponent<Rigidbody>();
    }

    private void FixedUpdate()
    {
        switch (m_CurrentState)
        {
            case E_State.InGame:
                HandleMovement();
                HandleRotation();
                break;
            case E_State.Impacted:
                break;
            case E_State.Dead:
                break;
            default:
                break;
        }
    }

    private void Update()
    {
        GetMovementInput();
        switch (m_CurrentState)
        {
            case E_State.InGame:
                UpdateMoveAnimation(0, MoveValue, IsSprinting);
                break;
            case E_State.Impacted:
                Timer += Time.deltaTime;
                if(Timer >= m_TimeImpacted)
                {
                    SwitchState(E_State.InGame);
                }
                break;
            case E_State.Dead:
                break;
            default:
                break;
        }
    }

    private void UpdateMoveAnimation(float horMovement, float vertMovement, bool sprint)
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
        MovementDir += MainCamTransform.right * HorizontalInput * m_HorizontalFactorSpeed; // Horizontal Input
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
    private void EnterState()
    {
        Timer = 0f;
        switch (m_CurrentState)
        {
            case E_State.InGame:
                break;
            case E_State.Impacted:
                if (m_AnimatorController) m_AnimatorController.Impacted();
                break;
            case E_State.Dead:
                Dead();
                break;
            default:
                break;
        }
    }
    private void ExitState()
    {
        switch (m_CurrentState)
        {
            case E_State.InGame:
                break;
            case E_State.Impacted:
                break;
            case E_State.Dead:
                break;
            default:
                break;
        }
    }
    public void SwitchState(E_State newState)
    {
        ExitState();
        m_CurrentState = newState;
        EnterState();
    }

    public void SimpleAttack()
    {
        if (m_AnimatorController) m_AnimatorController.SimpleAttack();
    }
    public void SpeelAttack()
    {
        if (m_AnimatorController) m_AnimatorController.SpeelAttack();
    }
    public void Dead()
    {
        if (m_AnimatorController) m_AnimatorController.Dead();
    }
}
