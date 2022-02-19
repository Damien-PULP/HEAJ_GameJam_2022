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

    [Header("Enemy Attributes")]
    public float m_Health = 100f;
    public float m_DistanceRangeAttack = 2f;
    public float m_Damage = 25f;
    public Transform m_AnchorAttack;

    [Header("Agent Settings")]
    public float m_Speed = 13f;

    [Header("Distance Settings")]
    public float m_DistanceViewPlayer = 50f;
    public float m_DistanceAttack = 4f;

    [Header("Timing Settings")]
    public float m_TimeBetweenAttack = 3f;
    [Space]
    public LayerMask m_IgnoreLayerAttack;

    private bool IsAttackNow;

    private Transform PlayerTarget;
    private Transform TowerTarget;
    private Vector3 CurrentPos = new Vector3();

    private NavMeshAgent NavAgent;
    private Transform CurrentTarget;
    private float DistanceToTarget;

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

        DistanceToTarget = Vector3.Distance(CurrentTarget.position, transform.position);

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
                break;
            case E_State.Impact:
                break;
            case E_State.Attack:
                break;
            case E_State.Idle:
                break;
            case E_State.Dead:
                Debug.Log("EnemyDead");
                Dead();
                break;
            default:
                break;
        }
    }

    private void Dead()
    {
        ParasiteAI.s_Instance.RemoveAEnemy(gameObject);
        Destroy(gameObject);
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

        if(DistanceToTarget <= m_DistanceAttack)
        {
            SwitchState(E_State.Attack);
        }
    }
    private void AttackTarget()
    {
        Vector3 posToLook = new Vector3(CurrentPos.x, transform.position.y, CurrentPos.z);
        transform.LookAt(posToLook);
        if (!IsAttackNow)
        {
            Timer += Time.deltaTime;
        }

        if(Timer >= m_TimeBetweenAttack)
        {
            IsAttackNow = true;
            Timer = 0f;

            RaycastHit hit;
            if(Physics.Raycast(m_AnchorAttack.position, transform.forward, out hit, m_DistanceRangeAttack, ~m_IgnoreLayerAttack))
            {
                if (hit.transform.CompareTag("Player"))
                {
                    Debug.Log("Player is touched");
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
            SwitchState(E_State.Dead);
        }
    }
}
