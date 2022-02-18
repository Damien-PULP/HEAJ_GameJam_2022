using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AnimatorController : MonoBehaviour
{
    public Animator m_Animator;
    public string m_HorizontalParams = "Horizontal";
    public string m_VerticalParams = "Vertical";

    public void UpdateAnimator(float horizontalMovement, float verticalMovement)
    {
        m_Animator.SetFloat(m_HorizontalParams, horizontalMovement, 0.1f, Time.deltaTime);
        m_Animator.SetFloat(m_VerticalParams, verticalMovement, 0.1f, Time.deltaTime);
    }
}
