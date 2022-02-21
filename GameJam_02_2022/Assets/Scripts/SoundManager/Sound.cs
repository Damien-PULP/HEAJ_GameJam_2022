using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Audio;
using System;

[Serializable]
public class Sound
{
    public string m_Name;
    public GameObject m_ParentSound;
    [Space]
    public AudioClip m_AudioClip;
    public bool m_Loop;
    public bool m_PlayOnAwake = false;
    [Range(0f, 1f)]
    public float m_Volume = 1;
    [Range(-3f, 3f)]
    public float m_Pitch = 1f;
    [Header("3D Sound Settings")]
    [Range(0f,1f)]
    public float m_SpacialBlend2DTo3D = 0f;
    public float m_MinDistance = 1f;
    public float m_MaxDistance = 100f;
    public AudioRolloffMode m_RollOfMode;
    [HideInInspector]
    public AudioSource m_Source;
}
