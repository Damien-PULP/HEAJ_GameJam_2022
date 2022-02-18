using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

public class SoundManager : MonoBehaviour
{
    public static SoundManager s_Instance;
    public Sound[] m_Sounds;

    private void Start()
    {
        if (s_Instance)
        {
            Destroy(this);
            return;
        }
        else
        {
            s_Instance = this;
        }
    }

    private void Awake()
    {
        // Add AudioSource
        foreach(Sound s in m_Sounds)
        {
            GameObject parent = s.m_ParentSound;
            if(!parent)
            {
                s.m_ParentSound = gameObject;
                parent = gameObject;
            }
            s.m_Source = parent.AddComponent<AudioSource>();

            s.m_Source.clip = s.m_AudioClip;
            s.m_Source.volume = s.m_Volume;
            s.m_Source.pitch = s.m_Pitch;
            s.m_Source.loop = s.m_Loop;
            s.m_Source.spatialBlend = s.m_SpacialBlend2DTo3D;
            s.m_Source.minDistance = s.m_MinDistance;
            s.m_Source.maxDistance = s.m_MaxDistance;
        }
    }
}
