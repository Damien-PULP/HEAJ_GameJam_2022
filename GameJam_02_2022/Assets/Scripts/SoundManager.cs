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
            Destroy(gameObject);
            return;
        }
        else
        {
            s_Instance = this;
        }
    }

    private void Awake()
    {
        // Add AudioSource and set settings
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
            s.m_Source.playOnAwake = s.m_PlayOnAwake;
            if (s.m_PlayOnAwake)
            {
                s.m_Source.Play();
            }
        }
        DontDestroyOnLoad(gameObject);
    }

    public void PlaySound(string name)
    {
        Sound s = Array.Find(m_Sounds, sound => sound.m_Name == name);
        if (s == null) return;
        s.m_Source.Play();
    }
}
