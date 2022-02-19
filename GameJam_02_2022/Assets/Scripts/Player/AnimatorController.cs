using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AnimatorController : MonoBehaviour
{
    public Animator m_Animator;

    public string m_HorizontalParams = "Horizontal";
    public string m_VerticalParams = "Vertical";
    public string m_SimpleAttackParams = "SimpleAttack";
    public string m_SpeelAttackParams = "SpeelAttack";


    public void UpdateAnimator(float horizontalMovement, float verticalMovement)
    {
        m_Animator.SetFloat(m_HorizontalParams, horizontalMovement, 0.1f, Time.deltaTime);
        m_Animator.SetFloat(m_VerticalParams, verticalMovement, 0.1f, Time.deltaTime);
    }
    public void SimpleAttack()
    {
        m_Animator.SetTrigger(m_SimpleAttackParams);
    }
    public void SpeelAttack()
    {
        Debug.Log("Speel");
        m_Animator.SetTrigger(m_SpeelAttackParams);
    }
}
