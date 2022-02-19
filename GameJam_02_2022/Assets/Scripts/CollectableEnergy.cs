using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CollectableEnergy : MonoBehaviour
{
    public int m_Point;
    public GameObject m_DestroyParticle;

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            bool isPossibleToCollect = GameManager.s_Instance.CollectEnergy(m_Point);
            if (!isPossibleToCollect) return;
            if (m_DestroyParticle)
            {
                Instantiate(m_DestroyParticle, transform.position, transform.rotation);    
            }
            Destroy(gameObject);
        }
    }
}
