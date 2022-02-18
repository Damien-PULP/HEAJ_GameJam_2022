using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

[Serializable]
public class Sound
{
    public string m_Name;
    public GameObject m_ParentSound;
    [Space]
    public AudioClip m_AudioClip;
    public bool m_Loop;
    [Range(0f, 1f)]
    public float m_Volume;
    [Range(1f, 3f)]
    public float m_Pitch;
    [Header("3D Sound Settings")]
    [Range(0f,1f)]
    public float m_SpacialBlend2DTo3D;
    public float m_MinDistance = 1f;
    public float m_MaxDistance = 100f;
    [HideInInspector]
    public AudioSource m_Source;
}
