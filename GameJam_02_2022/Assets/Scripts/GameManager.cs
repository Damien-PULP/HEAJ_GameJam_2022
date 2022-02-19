using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameManager : MonoBehaviour
{
    public enum E_State
    {
        Start,
        InGame,
        Paused,
        UpgradeLevel,
        EndGame,
        GameOver
    }
    public E_State m_CurrentState;
    public static GameManager s_Instance;
    [Header("Party Settings")]
    public float m_MaxTimeInvasion = 600f;

    [Header("Party Value")]
    public int m_CurrentLevel;
    public int m_MaxLevel = 6;

    [Header("Component Required")]
    public TowerOfPower m_TowerOfPower;

    [HideInInspector]
    public float CurrentTimerParty;

    private void Awake()
    {
        if (s_Instance)
        {
            Destroy(gameObject);
            return;
        }
        else
        {
            s_Instance = this;
        }
    }
    private void Update()
    {
        CurrentTimerParty += Time.deltaTime;
        UpdateState();
    }

    private void UpdateState()
    {
        switch (m_CurrentState)
        {
            case E_State.Start:
                break;
            case E_State.InGame:
                break;
            case E_State.Paused:
                break;
            case E_State.UpgradeLevel:
                break;
            case E_State.EndGame:
                break;
            case E_State.GameOver:
                break;
            default:
                break;
        }
    }

    public void SwitchState()
    {

    }
}
