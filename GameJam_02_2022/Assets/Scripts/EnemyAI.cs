using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

[RequireComponent(typeof(NavMeshAgent))]
public class EnemyAI : MonoBehaviour
{
    public enum E_State
    {
        Spawn,
        Chase,
        Impact,
        Attack,
        Idle,
        Dead,
    }
    public E_State m_CurrentState;
    public GameObject m_Collectable;

    [Header("Enemy Attributes")]
    public float m_Health = 100f;
    public float m_DistanceRangeAttack = 2f;
    public float m_Damage = 25f;
    public Transform m_AnchorAttack;

    [Header("Agent Settings")]
    public float m_Speed = 13f;
    public Collider m_Collider;

    [Header("Distance Settings")]
    public float m_DistanceViewPlayer = 50f;
    public float m_DistanceAttack = 4f;
    public float m_DistanceToWait = 10f;

    [Header("Timing Settings")]
    public float m_TimeBetweenAttack = 3f;
    public float m_DestroyDead = 4f;
    [Space]
    public LayerMask m_IgnoreLayerAttack;

    [Header("Animation")]
    public Animator m_Animator;
    public string m_RunNameParams;
    public string m_Attack1NameParams = "Attack1";
    public string m_Attack2NameParams = "Attack2";
    public string m_ImpactedNameParams = "Impacted";
    public string m_DeadNameParams = "Dead";
    private bool isRunAnim;
    private bool IsAttackNow;


    private Transform PlayerTarget;
    private Transform TowerTarget;
    private Vector3 CurrentPos = new Vector3();

    private NavMeshAgent NavAgent;
    private Transform CurrentTarget;
    private float DistanceToTarget;

    private bool CanBeAttack = true;
    private float Timer;

    private void Start()
    {
        NavAgent = GetComponent<NavMeshAgent>();
        NavAgent.speed = m_Speed;
        PlayerTarget = GameManager.s_Instance.m_Player.transform;
        TowerTarget = GameManager.s_Instance.m_TowerTransform.transform;
        SwitchState(E_State.Spawn);
    }

    private void Update()
    {
        UpdateState();
    }

    private void UpdateState()
    {
        float distanceToPlayer = Vector3.Distance(PlayerTarget.position, transform.position);

        if (distanceToPlayer <= m_DistanceViewPlayer)
        {
            if (CurrentTarget != PlayerTarget)
            {
                CurrentTarget = PlayerTarget;
            }
        }
        else
        {
            CurrentTarget = TowerTarget;
        }

        UpdateAnimation();

        DistanceToTarget = Vector3.Distance(CurrentTarget.position, transform.position);
        CanBeAttack = GameManager.s_Instance.CheckIfCanBeAttack();

        switch (m_CurrentState)
        {
            case E_State.Spawn:
                break;
            case E_State.Chase:
                ChaseTarget();
                break;
            case E_State.Impact:
                break;
            case E_State.Attack:
                AttackTarget();
                break;
            case E_State.Idle:
                if (CanBeAttack)
                {
                    SwitchState(E_State.Chase);
                }
                break;
            case E_State.Dead:
                break;
            default:
                break;
        }
    }
    private void EnterState()
    {
        switch (m_CurrentState)
        {
            case E_State.Spawn:
                SwitchState(E_State.Chase);
                break;
            case E_State.Chase:
                isRunAnim = true;
                break;
            case E_State.Impact:
                m_Animator.SetTrigger(m_ImpactedNameParams);
                Debug.Log("impacted");
                SwitchState(E_State.Chase);
                isRunAnim = false;
                break;
            case E_State.Attack:
                isRunAnim = false;
                CurrentPos = CurrentTarget.position;
                NavAgent.SetDestination(CurrentPos);
                GameManager.s_Instance.IndicEnemyStartAttack();
                break;
            case E_State.Idle:
                isRunAnim = false;
                break;
            case E_State.Dead:
                isRunAnim = false;
                Debug.Log("EnemyDead");
                Dead();
                break;
            default:
                break;
        }
        UpdateAnimation();
    }

    private void Dead()
    {
        ParasiteAI.s_Instance.RemoveAEnemy(gameObject);
        m_Animator.SetTrigger(m_DeadNameParams);
        Instantiate(m_Collectable, transform.position, transform.rotation);
        m_Collider.enabled = false;
        Destroy(gameObject, m_DestroyDead);
    }

    private void ExitState()
    {
        switch (m_CurrentState)
        {
            case E_State.Spawn:
                break;
            case E_State.Chase:
                break;
            case E_State.Impact:
                break;
            case E_State.Attack:
                NavAgent.ResetPath();
                CurrentPos = CurrentTarget.position;
                NavAgent.SetDestination(CurrentPos);
                GameManager.s_Instance.IndicEnemyStopAttack();
                break;
            case E_State.Idle:
                break;
            case E_State.Dead:
                break;
            default:
                break;
        }
    }
    private void SwitchState(E_State newState)
    {
        ExitState();
        m_CurrentState = newState;
        EnterState();
    }

    private void ChaseTarget()
    {
        CurrentPos = CurrentTarget.position;
        NavAgent.SetDestination(CurrentPos);

        if (CanBeAttack)
        {
            if (DistanceToTarget <= m_DistanceAttack)
            {
                SwitchState(E_State.Attack);
            }
        }
        else
        {
            SwitchState(E_State.Idle);
            if (DistanceToTarget <= m_DistanceToWait)
            {
                SwitchState(E_State.Idle);
            }
        }


    }
    private void AttackTarget()
    {

        Vector3 posToLook = new Vector3(CurrentTarget.position.x, transform.position.y, CurrentTarget.position.z);
        transform.LookAt(posToLook);
        if (!IsAttackNow)
        {
            Timer += Time.deltaTime;
        }

        if(Timer >= m_TimeBetweenAttack)
        {
            IsAttackNow = true;
            Timer = 0f;

            int animAttack = UnityEngine.Random.Range(0, 2);
            if(animAttack == 0)
            {
                m_Animator.SetTrigger(m_Attack1NameParams);
            }
            else
            {
                m_Animator.SetTrigger(m_Attack2NameParams);
            }


            RaycastHit hit;
            if(Physics.Raycast(m_AnchorAttack.position, transform.forward, out hit, m_DistanceRangeAttack, ~m_IgnoreLayerAttack))
            {
                if (hit.transform.CompareTag("Player"))
                {
                    GameManager.s_Instance.ApplyDamage(m_Damage);
                }     
            }

            IsAttackNow = false;
            Debug.Log("IsAttack");
        }
        // Check Distance
        if (DistanceToTarget > m_DistanceAttack && !IsAttackNow)
        {
            SwitchState(E_State.Chase);
        }
    }
    public void ApplyDamage(float damage)
    {
        m_Health -= damage;
        if(m_Health <= 0)
        {
            if(m_CurrentState != E_State.Dead) SwitchState(E_State.Dead);
        }
        else
        {
            SwitchState(E_State.Impact);
        }
    }

    private void UpdateAnimation()
    {
        Debug.Log("Update Run");
        m_Animator.SetBool(m_RunNameParams, isRunAnim);
    }
}
