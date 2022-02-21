using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AttackSystem : MonoBehaviour
{
    public LayerMask m_EnemyMask;
    [Header("Simple Attack")]
    public Transform m_SimpleAttackAnchor;
    public float m_MaxDistanceSimpleAttack = 2f;
    public float m_RadiusSimpleAttack = 2f;
    public float m_DamageSimpleAttack = 25f;
    public float m_TimeBeforeDamage = 0.5f;
    public float m_TimeBetweenSimpleAttack = 1.5f;
    public GameObject m_TrailRenderStaff;
    public float m_MaxAngleAutoAim = 45f;
    public float m_AutoAimSimpleImpactStrenght = 3f;

    private float Timer;
    private bool IsSimpleAttack;
    private bool DamageApply;

    [Header("Spell Attack")]
    public Transform m_AnchorSpellFire;
    public Transform m_AnchorViewFinder;
    public GameObject m_SpellBullet;
    public float m_DamageSpell = 100f;
    public float m_SpeedBullet = 10f;
    public float m_ForceRedirection = 5f;
    public float m_DistanceToStopRedirection = 3f;
    public float m_TimeBeforeFireSpell = 1f;
    public float m_TimeBetweenSpellAttack = 2.6f;
    public float m_MaxDistanceToAim = 100f;
    public LayerMask m_LayerIgnoredByAim;

    private bool IsSpeelAttack;
    private bool AlredyFire;
    private Vector3 PositionTargetFire;
    private Vector3 LookDirToTarget = new Vector3();
    private Transform TargetAimed;

    [Header("Required Component")]
    public PlayerMovement m_PlayerMovement;
    public StaffEnd m_StaffEnd;

    private void Start()
    {
        m_StaffEnd.SetStaffEnd(m_DamageSimpleAttack);
        m_StaffEnd.ActiveOrDisableStaff(false);
        m_TrailRenderStaff.SetActive(false);
    }
    private void FixedUpdate()
    {
        if (TargetAimed && IsSimpleAttack)
        {
            Vector3 dirToTarget = TargetAimed.transform.position - transform.position;
            dirToTarget.Normalize();
            dirToTarget.y = 0f;
            Quaternion targetRotation = Quaternion.LookRotation(dirToTarget);
            Quaternion lookAt = Quaternion.RotateTowards(transform.rotation, targetRotation, m_AutoAimSimpleImpactStrenght * Time.fixedDeltaTime);
            transform.rotation = lookAt;

            //LookDirToTarget = Vector3.Slerp(LookDirToTarget, dirToTarget, m_AutoAimSimpleImpactStrenght * Time.fixedDeltaTime);
            //LookDirToTarget.y = transform.position.y;
            //transform.rotation = Quaternion.Loo(transform.rotation, dirToTarget, m_AutoAimSimpleImpactStrenght * Time.deltaTime);
            //transform.LookAt(LookDirToTarget);
        }
    }
    private void Update()
    {
        if(IsSimpleAttack == true)
        {

            m_TrailRenderStaff.SetActive(true);
            Timer += Time.deltaTime;
            if(Timer >= m_TimeBeforeDamage && !DamageApply)
            {
                /*RaycastHit hit;
                if (Physics.SphereCast(m_SimpleAttackAnchor.position, m_RadiusSimpleAttack , m_SimpleAttackAnchor.forward, out hit, m_MaxDistanceSimpleAttack))
                {
                    if (hit.transform.CompareTag("Enemy"))
                    {
                        EnemyAI enemy = hit.transform.GetComponent<EnemyAI>();
                        enemy.ApplyDamage(m_DamageSimpleAttack);
                        Debug.Log("ENemyTouched");
                    }
                }*/
                m_StaffEnd.ActiveOrDisableStaff(true);
                DamageApply = true;
            } else if(Timer < m_TimeBeforeDamage)
            {
                m_StaffEnd.ActiveOrDisableStaff(false);
            }
            if(Timer >= m_TimeBetweenSimpleAttack)
            {
                Timer = 0f;
                DamageApply = false;
                IsSimpleAttack = false;
                m_StaffEnd.ActiveOrDisableStaff(false);
                m_TrailRenderStaff.SetActive(false);
            }
        }
        if (IsSpeelAttack)
        {
            Timer += Time.deltaTime;
            if (Timer >= m_TimeBeforeFireSpell &&!AlredyFire)
            {
                GameObject bulletInstance = (Instantiate(m_SpellBullet, m_AnchorSpellFire.position, m_SpellBullet.transform.rotation));
                Rigidbody rb = bulletInstance.GetComponent<Rigidbody>();
                Bullet bullet = bulletInstance.GetComponent<Bullet>();
                bullet.SetDamage(m_DamageSpell);
                rb.AddForce(transform.forward * m_SpeedBullet, ForceMode.Impulse);
               // BulletSemiHoming bulletHoming = bulletInstance.GetComponent<BulletSemiHoming>();
               // bulletHoming.Shoot(PositionTargetFire, m_SpeedBullet, m_ForceRedirection, m_DistanceToStopRedirection, m_DamageSpell);

                AlredyFire = true;
            }
            if (Timer >= m_TimeBetweenSpellAttack)
            {
                Timer = 0f;
                IsSpeelAttack = false;
                AlredyFire = false;
            }
        }
        Aim();
    }
    public void AutoAimCloseEnemy()
    {
        Collider[] enemyClose = Physics.OverlapSphere(m_SimpleAttackAnchor.position, m_RadiusSimpleAttack, m_EnemyMask);
        TargetAimed = null;
        //LookDirToTarget = Vector3.zero;

        if (enemyClose.Length > 0)
        {
            float minAngleTarget = 360f;

            for (int i = 0; i < enemyClose.Length; i++)
            {
                Transform target = enemyClose[i].transform;
                Vector3 dirToTarget = (target.position - transform.position).normalized;
                float angle = Vector3.Angle(transform.forward, dirToTarget);
                Debug.Log("angle enemy to player : " + angle);
                if (Mathf.Abs(angle) < m_MaxAngleAutoAim && angle < minAngleTarget)
                {
                    TargetAimed = target;
                    minAngleTarget = angle;
                }
            }
            if (TargetAimed)
            {
                LookDirToTarget = transform.position.normalized;
                LookDirToTarget.y = 0f;
            }
        }
    }
    public void SimpleAttack()
    {   
        if (IsSpeelAttack) return;
        if (!IsSimpleAttack)
        {
            m_PlayerMovement.SimpleAttack();
            AutoAimCloseEnemy();
            Timer = 0f;
        }
        IsSimpleAttack = true;

    }

    public void SpellAttack()
    {
        if (IsSimpleAttack) return;
        if (!IsSpeelAttack)
        {
            m_PlayerMovement.SpeelAttack();
            Timer = 0f;
        }
        IsSpeelAttack = true;

    }

    private void Aim()
    {
        /* // Raycast
         Ray rayMouseScreen = Camera.main.ScreenPointToRay(new Vector3(Screen.width /2f,Screen.height/2f,0f));
         RaycastHit hitOfMouseScreen;

         if (Physics.Raycast(rayMouseScreen, out hitOfMouseScreen, m_MaxDistanceToAim, ~m_LayerIgnoredByAim))
         {
             PositionTargetFire = hitOfMouseScreen.point;
             Debug.Log(hitOfMouseScreen.transform.name);
         }
         else
         {
             // Nothing object aimed : lock the direction to forward
             PositionTargetFire = new Vector3(rayMouseScreen.origin.x, rayMouseScreen.origin.y, transform.position.z + m_MaxDistanceToAim);
         }*/

        Vector3 pos = m_AnchorViewFinder.position + m_AnchorViewFinder.forward * 100f; ;
        Vector3 posInpact = m_AnchorViewFinder.position;
        Vector3 dir = m_AnchorViewFinder.forward * 100f;
        PositionTargetFire = dir;

       /* RaycastHit hitOfMouseScreen;

        if (Physics.Raycast(m_AnchorViewFinder.position, m_AnchorViewFinder.forward, out hitOfMouseScreen, m_MaxDistanceToAim, ~m_LayerIgnoredByAim))
        {
            if (!hitOfMouseScreen.transform.CompareTag("Player"))
            {
                
                PositionTargetFire = hitOfMouseScreen.point;
                Debug.Log(hitOfMouseScreen.transform.name);
            }

        }
        else
        {
            // Nothing object aimed : lock the direction to forward
            PositionTargetFire = new Vector3(m_AnchorViewFinder.position.x, m_AnchorViewFinder.position.y, m_AnchorViewFinder.position.z + m_MaxDistanceToAim);
        }*/
    }
    private void OnDrawGizmos()
    {
        Gizmos.color = Color.red;
        Gizmos.DrawSphere(PositionTargetFire, 1f);
        Gizmos.color = Color.cyan;
        Vector3 pos = m_AnchorViewFinder.position +  m_AnchorViewFinder.forward * 100f ;
        Gizmos.DrawLine(m_AnchorViewFinder.position, pos);
    }
}
