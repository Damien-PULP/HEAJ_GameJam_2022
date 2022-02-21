using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AnimatorController : MonoBehaviour
{
    public Animator m_Animator;
    public SoundManager m_SoundManager;

    public string m_HorizontalParams = "Horizontal";
    public string m_VerticalParams = "Vertical";
    public string m_SimpleAttackParams = "SimpleAttack";
    public string m_SpeelAttackParams = "SpeelAttack";
    public string m_DeadParams = "Dead";
    public string m_ImpactedParams = "Impacted";
    public float m_TimeAnimationDead = 2.8f;
    private bool isDead;
    private float Timer;

    private string SoundIdleName = "Idle";
    private string SoundWalkName = "Walk";
    private string SoundRunName = "Run";
    private string SoundAttack1Name = "Attack1";
    private string SoundAttack2Name = "Attack2";
    private string SoundImpactedName = "Impacted";
    private string SoundDeadName = "Dead";

    private bool IsIdle = false;
    private bool IsWalk = false;
    private bool IsRun = false;

    private void Update()
    {
        if (isDead)
        {
            Timer += Time.deltaTime;
            if(Timer >= m_TimeAnimationDead)
            {
                m_Animator.enabled = false;
                isDead = false;
            }
        }
    }
    public void UpdateAnimator(float horizontalMovement, float verticalMovement)
    {
        Debug.Log("h : " + horizontalMovement + " v : " + verticalMovement);
        if(horizontalMovement == 1f || verticalMovement == 1f)
        {
            if (!IsRun)
            {
                m_SoundManager.PlaySound(SoundRunName);
                m_SoundManager.StopSound(SoundWalkName);
                m_SoundManager.StopSound(SoundIdleName);
            }
            IsRun = true;
            IsIdle = false;
            IsWalk = false;
            Debug.Log("Run");
        } else if(horizontalMovement == 0.5f || verticalMovement == 0.5f)
        {
            if (!IsWalk)
            {
                m_SoundManager.PlaySound(SoundWalkName);
                m_SoundManager.StopSound(SoundRunName);
                m_SoundManager.StopSound(SoundIdleName);
            }
            IsWalk = true;
            IsIdle = false;
            IsRun = false;
            Debug.Log("Walk");
        }
        else
        {
            if (!IsIdle)
            {
                m_SoundManager.PlaySound(SoundIdleName);
                m_SoundManager.StopSound(SoundRunName);
                m_SoundManager.StopSound(SoundWalkName);
            }
            IsIdle = true;
            IsWalk = false;
            IsRun = false;
            Debug.Log("Idle");
        }

        m_Animator.SetFloat(m_HorizontalParams, horizontalMovement, 0.1f, Time.deltaTime);
        m_Animator.SetFloat(m_VerticalParams, verticalMovement, 0.1f, Time.deltaTime);
    }
    public void SimpleAttack()
    {
        m_SoundManager.PlaySound(SoundAttack1Name);
        m_Animator.SetTrigger(m_SimpleAttackParams);
    }
    public void SpeelAttack()
    {
        m_SoundManager.PlaySound(SoundAttack2Name);
        m_Animator.SetTrigger(m_SpeelAttackParams);
    }
    public void Impacted()
    {
        m_SoundManager.PlaySound(SoundImpactedName);
        m_Animator.SetTrigger(m_ImpactedParams);
    }
    public void Dead()
    {
        if (!isDead)
        {
            m_SoundManager.PlaySound(SoundDeadName);
            m_SoundManager.StopSound(SoundIdleName);
            m_SoundManager.StopSound(SoundWalkName);
            m_SoundManager.StopSound(SoundRunName);

            m_Animator.SetTrigger(m_DeadParams);
            isDead = true;
        }
    }
}
