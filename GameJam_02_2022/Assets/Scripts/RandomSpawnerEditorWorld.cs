using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RandomSpawnerEditorWorld : MonoBehaviour
{
    public GameObject[] m_ItemToSpawn;
    public Transform m_Parent;
    public int m_NbItemToSpawn = 10;

    public float m_RadiusToSpawn = 250f;
    public LayerMask m_LayerToSpawn;
    public float m_YOffset = -0.1f;

    public float m_MinSize = 0.8f;
    public float m_MaxSize = 1.2f;

    private float MaxYOriginSpawn = 100f;

    [ContextMenu("Spawn")]
    public void Spawn()
    {
        for (int i = 0; i < m_NbItemToSpawn; i++)
        {
            Vector2 pos2DintoCircle = Random.insideUnitCircle.normalized * (Random.Range(0f, m_RadiusToSpawn));
            Vector3 posRayCast = new Vector3(pos2DintoCircle.x, MaxYOriginSpawn, pos2DintoCircle.y);

            RaycastHit hit;
            if(Physics.Raycast(posRayCast, -Vector3.up, out hit, MaxYOriginSpawn + 100f, m_LayerToSpawn))
            {
                int rdmIndex = Random.Range(0, m_ItemToSpawn.Length);
                Vector3 posInstance = hit.point;
                Quaternion rot = Quaternion.Euler(new Vector3(0f, Random.Range(0f, 1f), 0f));
                GameObject instance = Instantiate(m_ItemToSpawn[rdmIndex], posInstance, rot, m_Parent);
                float size = Random.Range(m_MinSize, m_MaxSize);
                instance.transform.localScale *= size; 
            }
        }
    }
}
