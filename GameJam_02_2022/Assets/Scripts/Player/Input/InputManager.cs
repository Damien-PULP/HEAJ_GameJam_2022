using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class InputManager : MonoBehaviour
{
    public static PlayerControls s_PlayerControls;
    public PlayerMovement m_PlayerMovement;

    private Vector2 InputMovement;
    private Vector2 InputCamera;

    private bool B_Input;

    private void OnEnable()
    {
        if(s_PlayerControls == null)
        {
            s_PlayerControls = new PlayerControls();
            s_PlayerControls.PlayerMouvement.Movement.performed += i => InputMovement = i.ReadValue<Vector2>();
            s_PlayerControls.PlayerMouvement.Camera.performed += i => InputCamera = i.ReadValue<Vector2>();
            s_PlayerControls.PlayerActions.B.performed += i => B_Input = true;
            s_PlayerControls.PlayerActions.B.canceled += i => B_Input = false;
            s_PlayerControls.PlayerActions.Drop.performed += i => PickUpInput();
            s_PlayerControls.PlayerActions.Fire1.performed += i => Fire1();
            s_PlayerControls.PlayerActions.Fire2.performed += i => Fire2();
        }
        s_PlayerControls.Enable();
    }
    public void PickUpInput()
    {
        GameManager.s_Instance.AddEnergyLevel();
    }
    public void Fire1()
    {
        m_PlayerMovement.SimpleAttack();
    }
    public void Fire2()
    {
        m_PlayerMovement.SpeelAttack();
    }
    public Vector2 GetInputMovement()
    {
        return InputMovement;
    }
    public Vector2 GetInputCamera()
    {
        return InputCamera;
    }

    public bool IsInputSprint()
    {
        return B_Input;
    }

    private void OnDisable()
    {
        s_PlayerControls.Disable();
    }
}
