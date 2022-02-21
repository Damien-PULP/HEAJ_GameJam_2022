using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyAnimationController : MonoBehaviour
{
    #region Variables
    public Animator m_Animator;
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
    #endregion

    #region Controls Methods
    public void UpdateRunAnimation(bool active)
    {
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
        m_Animator.SetTrigger(m_Attack1NameParams);
    }
    private void PlayAttack2()
    {
        m_Animator.SetTrigger(m_Attack2NameParams);
    }
    public void PlayImpacted()
    {
        m_Animator.SetTrigger(m_ImpactedNameParams);
    }
    public void PlayDead()
    {
        m_Animator.SetTrigger(m_DeadNameParams);
    }
    #endregion
}
