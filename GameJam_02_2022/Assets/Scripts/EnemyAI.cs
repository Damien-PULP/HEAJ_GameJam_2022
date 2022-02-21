using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

[RequireComponent(typeof(NavMeshAgent))]
public class EnemyAI : MonoBehaviour
{
    #region Variables 
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
    public GameObject m_DropCollectableDeath;

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
    public float m_TimeImpacted = 1.5f;
    public float m_DestroyDead = 4f;
    [Space]
    public LayerMask m_IgnoreLayerAttack;

    [Header("Animation")]
    public EnemyAnimationController m_AnimationController;
    private bool IsAttackNow;


    private Transform PlayerTarget;
    private Transform TowerTarget;
    private Vector3 LastPostTarget = new Vector3();

    private NavMeshAgent NavAgent;
    private Transform CurrentTarget;
    private float DistanceToTarget;

    private bool CanBeAttack = true;
    private float Timer;
    #endregion

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
        // Calcul Distance to player
        float distanceToPlayer = Vector3.Distance(PlayerTarget.position, transform.position);

        // Calcul if the target is the player or the tower
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

        // Calcul Distance to target
        DistanceToTarget = Vector3.Distance(CurrentTarget.position, transform.position);

        switch (m_CurrentState)
        {
            case E_State.Spawn:
                break;
            case E_State.Chase:
                CheckIfAttackIsPossible();
                ChaseTarget();
                break;
            case E_State.Impact:
                // Enemy has impacted
                Timer += Time.deltaTime;
                if(Timer >= m_TimeImpacted)
                {
                    if(DistanceToTarget <= m_DistanceAttack)
                    {
                        CheckIfAttackIsPossible();
                        if (CanBeAttack)
                        {
                            SwitchState(E_State.Attack);
                        }
                        else
                        {
                            SwitchState(E_State.Idle);
                        }
                    }
                    else
                    {
                        SwitchState(E_State.Chase);
                    }
                }
                break;
            case E_State.Attack:
                AttackTarget();
                break;
            case E_State.Idle:
                CheckIfAttackIsPossible();
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

    private void CheckIfAttackIsPossible()
    {
        // Check if the player is not alredy attacked by other enemy 
        CanBeAttack = GameManager.s_Instance.CheckIfCanBeAttack();
    }

    private void EnterState()
    {
        Timer = 0f;
        switch (m_CurrentState)
        {
            case E_State.Spawn:
                // Direct switch to chase
                SwitchState(E_State.Chase);
                break;
            case E_State.Chase:
                //PLAY RUN
                m_AnimationController.UpdateRunAnimation(true);
                break;
            case E_State.Impact:
                //PLAY IMPACT
                m_AnimationController.PlayImpacted();
                break;
            case E_State.Attack:
                // Registre last position
                LastPostTarget = CurrentTarget.position;
                NavAgent.SetDestination(LastPostTarget);
                GameManager.s_Instance.IndicEnemyStartAttack();
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

        Instantiate(m_DropCollectableDeath, transform.position, transform.rotation);
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
                m_AnimationController.UpdateRunAnimation(false);
                break;
            case E_State.Impact:
                break;
            case E_State.Attack:
                NavAgent.ResetPath();
                LastPostTarget = CurrentTarget.position;
                NavAgent.SetDestination(LastPostTarget);
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
        LastPostTarget = CurrentTarget.position;
        NavAgent.SetDestination(LastPostTarget);

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
}
