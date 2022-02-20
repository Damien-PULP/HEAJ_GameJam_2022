using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TowerOfPower : MonoBehaviour
{
    public enum E_State
    {
        Activate,
        Upgrade,
        EndWin,
        EndLose
    }
    public E_State m_CurrentState;

    public Animator m_Animator;

    public void UpdateTower()
    {
        switch (GameManager.s_Instance.m_CurrentLevel)
        {
            case 0:

                break;
            case 1:
                m_Animator.SetTrigger("TourSpawn1");
                break;
            case 2:
                m_Animator.SetTrigger("TourSpawn2");
                break;
            case 3:
                m_Animator.SetTrigger("TourSpawn3");
                break;
            case 4:
                m_Animator.SetTrigger("TourSpawn4");
                break;
            case 5:
                m_Animator.SetTrigger("TourSpawn5");
                break;
            default:
                break;
        }
    }
}
