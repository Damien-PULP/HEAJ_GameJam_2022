using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ParasiteAI : MonoBehaviour
{
    public Vector3 m_CenterWorld = Vector3.zero;
    public float m_Radius = 250f;

    private float CurrentRadius;
    private float MaxTimeInvasion;

    private void Awake()
    {
        MaxTimeInvasion = GameManager.s_Instance.m_MaxTimeInvasion;
    }

    private void Update()
    {
        float currentTimer = GameManager.s_Instance.CurrentTimerParty;
        float percentRadius = Mathf.Clamp01(1 -(MaxTimeInvasion / currentTimer));
        CurrentRadius = m_Radius * percentRadius;

    }
}
