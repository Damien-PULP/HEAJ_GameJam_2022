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

    public GameObject[] m_PartsOfTower;

    public void UpdateTower()
    {
        for (int i = 0; i < m_PartsOfTower.Length; i++)
        {
            if(i <= GameManager.s_Instance.m_CurrentLevel)
            {
                m_PartsOfTower[i].SetActive(true);
            }
            else
            {
                m_PartsOfTower[i].SetActive(false);
            }
        }
    }
}
