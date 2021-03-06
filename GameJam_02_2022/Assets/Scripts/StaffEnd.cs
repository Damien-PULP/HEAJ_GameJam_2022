using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StaffEnd : MonoBehaviour
{
    public Collider m_Collider;
    private float Damage;
    private bool Active;

    public void SetStaffEnd(float damage)
    {
        Damage = damage;
    }
    public void ActiveOrDisableStaff(bool active)
    {
        Active = active;
        m_Collider.enabled = active;
    }

    private void OnTriggerEnter(Collider other)
    {
        if (Active)
        {
            if (other.transform.CompareTag("Enemy"))
            {
                EnemyAI enemy = other.transform.GetComponent<EnemyAI>();
                enemy.ApplyDamage(Damage);
                Debug.Log("ENemyTouched");
                Active = false;
            }
        }
    }
}
