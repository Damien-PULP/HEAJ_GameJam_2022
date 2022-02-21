using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyAIManager : MonoBehaviour
{
    public Transform m_Target;
    public int m_MaxNumberEnemyAttack = 2;

    public int m_CurrentEnemyInChase;
    public int m_CurrentEnemyInAttack;
    public List<EnemyAI> m_EnemyAIInGame;
}
