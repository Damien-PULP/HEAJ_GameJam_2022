using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BulletSemiHoming : MonoBehaviour
{
    #region Variables
    public float m_TimeLife = 2f;
    private bool IsShooted;
    private float RedirectForce;
    private float DistanceToStopRedirection;

    private Vector3 PositionTargetOrMouse;
    private Quaternion FinalRotation;
    private float Damage;
    private float Speed;
    #endregion

    #region Override Methods
    public void Start()
    {
        Destroy(gameObject, m_TimeLife);
    }
    public void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Enemy")) { 

            EnemyAI enemy = other.transform.GetComponent<EnemyAI>();
            enemy.ApplyDamage(Damage);
            Debug.Log("touched by spell");
        }
    }
    #endregion
    #region Commun Methods
    private void FixedUpdate()
    {
        if (IsShooted)
        {
            float distance = Vector3.Distance(transform.position, PositionTargetOrMouse); ;
            // Redirects projectile toward target position
            if (distance > DistanceToStopRedirection)
            {
                Vector3 lookAtDir = (PositionTargetOrMouse - transform.position).normalized;
                Quaternion rotToTarget = Quaternion.LookRotation(lookAtDir);

                FinalRotation = Quaternion.Slerp(transform.rotation, rotToTarget, RedirectForce * Time.deltaTime);
            }
            transform.rotation = FinalRotation;
            transform.position += transform.forward * Time.fixedDeltaTime * Speed;
        }
    }
    #endregion
    #region Controll Methods
    public void Shoot(Vector3 positionTargetOrMouse, float speed, float redirectForce, float distanceToStopRedirection, float damage)
    {
        Speed = speed;
        PositionTargetOrMouse = positionTargetOrMouse;
        RedirectForce = redirectForce;
        DistanceToStopRedirection = distanceToStopRedirection;
        IsShooted = true;
        Damage = damage;
    }
    #endregion
}