using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyAnimationController : MonoBehaviour
{
    #region Variables
    public Animator m_Animator;
    public SoundManager m_SoundManager;

    [Space]
    // BOOL
    public string m_RunNameParams = "Run";
    // TRIGGER
    public string m_Attack1NameParams = "Attack1";
    // TRIGGER
    public string m_Attack2NameParams = "Attack2";
    // TRIGGER
    public string m_ImpactedNameParams = "Impacted";
    // TRIGGER
    public string m_DeadNameParams = "Dead";

    private string SoundIdleName = "Idle";
    private string SoundAttackName = "Attack";
    private string SoundRunName = "Run";
    private string SoundImpactedName = "Impacted";
    private string SoundHitName = "Hit";
    private string SoundDeadName = "Dead";

    #endregion

    #region Controls Methods
    public void UpdateIdle(bool active)
    {
        if (active) m_SoundManager.PlaySound(SoundIdleName);
    }
    public void UpdateRunAnimation(bool active)
    {
        if (active)
        {
            m_SoundManager.PlaySound(SoundRunName);
        }
        else
        {
            m_SoundManager.StopSound(SoundRunName);
        }

        m_Animator.SetBool(m_RunNameParams, active); 
    }
    public void PlayAttackRandom()
    {
        int attackIndex = Random.Range(0, 2);
        if(attackIndex == 0)
        {
            PlayAttack1();
        }
        else
        {
            PlayAttack2();
        }
    }
    private void PlayAttack1()
    {
        m_SoundManager.PlaySound(SoundAttackName);
        m_Animator.SetTrigger(m_Attack1NameParams);
    }
    private void PlayAttack2()
    {
        m_SoundManager.PlaySound(SoundAttackName);
        m_Animator.SetTrigger(m_Attack2NameParams);
    }
    public void PlayImpacted()
    {
        m_SoundManager.PlaySound(SoundImpactedName);
        m_SoundManager.PlaySound(SoundHitName);
        m_Animator.SetTrigger(m_ImpactedNameParams);
    }
    public void PlayDead()
    {
        m_SoundManager.PlaySound(SoundDeadName);
        m_SoundManager.PlaySound(SoundHitName);
        m_SoundManager.StopSound(SoundIdleName);
        m_Animator.SetTrigger(m_DeadNameParams);
    }
    #endregion
}
