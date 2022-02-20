using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Bullet : MonoBehaviour
{
    public float m_MaxTimeLife = 2f;

    private float Damage;
    private void Start()
    {
        Destroy(gameObject, m_MaxTimeLife);
    }
    public void SetDamage(float damage)
    {
        Damage = damage;
    }
    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Enemy"))
        {
            EnemyAI enemy = other.transform.GetComponent<EnemyAI>();
            enemy.ApplyDamage(Damage);
        }
    }
}
