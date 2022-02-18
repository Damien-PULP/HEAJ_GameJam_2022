using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameManager : MonoBehaviour
{
    public static GameManager s_Instance;
    [Header("Party Settings")]
    public float m_MaxTimeInvasion = 600f;

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
    }
}
