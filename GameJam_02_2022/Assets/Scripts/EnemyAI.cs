using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

[RequireComponent(typeof(NavMeshAgent))]
public class EnemyAI : MonoBehaviour
{

    private Transform PlayerTarget;
    public Transform TowerTarget;
    public Vector3 CurrentPos = new Vector3();

    [Header("Agent Settings")]
    public float m_Speed = 13f;

    [Header("Distance Settings")]
    public float m_DistanceViewPlayer = 50f;
    public float m_DistanceAttack = 5f;

    [Header("Timing Settings")]
    public float m_TimeBetweenAttack = 3f;

    private NavMeshAgent NavAgent;
    private Transform CurrentTarget;

    private void Start()
    {
        NavAgent = GetComponent<NavMeshAgent>();
        NavAgent.speed = m_Speed;
        PlayerTarget = GameManager.s_Instance.m_Player.transform;
        TowerTarget = GameManager.s_Instance.m_TowerTransform.transform;
    }

    private void Update()
    {
        float distanceToTower = Vector3.Distance(TowerTarget.position, transform.position);
        float distanceToPlayer = Vector3.Distance(PlayerTarget.position, transform.position);

        if(distanceToPlayer <= m_DistanceViewPlayer)
        {
            if (CurrentTarget != PlayerTarget)
            {
                CurrentTarget = PlayerTarget;
                Debug.Log("Change transform target to player");
            }
        }
        else
        {

                CurrentTarget = TowerTarget;
                Debug.Log("Change transform target to tower");
        }
        CurrentPos = CurrentTarget.position;
        NavAgent.destination = CurrentPos;
    }
}
