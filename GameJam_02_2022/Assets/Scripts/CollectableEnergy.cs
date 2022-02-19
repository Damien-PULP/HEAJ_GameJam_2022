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
            GameManager.s_Instance.AddEnerrgyLevel(m_Point);
            if (m_DestroyParticle)
            {
                Instantiate(m_DestroyParticle, transform.position, transform.rotation);    
            }
            Destroy(gameObject);
        }
    }
}
