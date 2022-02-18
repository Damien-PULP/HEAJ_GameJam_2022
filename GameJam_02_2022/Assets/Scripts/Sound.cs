using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

[Serializable]
public class Sound
{
    public string m_Name;
    public AudioClip m_AudioClip;
    public GameObject m_ParentSound;
    public float m_Volume;
    public float m_Pitch;
    public float m_SpacialBlend2DTo3D;
    public bool m_Loop;
    [HideInInspector]
    public AudioSource m_Source;
}
