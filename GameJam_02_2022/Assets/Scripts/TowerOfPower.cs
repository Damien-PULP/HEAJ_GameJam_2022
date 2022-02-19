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
}
