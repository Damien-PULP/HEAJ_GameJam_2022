using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Random = UnityEngine.Random;

public class ParasiteAI : MonoBehaviour
{
    public static ParasiteAI s_Instance;
    [Header("Parasite and Dome Settings")]
    public Vector3 m_CenterWorld = Vector3.zero;
    public float m_Radius = 250f;
    public float m_FactorRadiusWorld = 1.6f;
    public float m_OffsetRadiusWorld = 10f;
    public Material m_ParasiteMaterial;
    public Material m_TerrainMaterial;

    [Header("Damage Zone Parasite")]
    public float m_DamageZoneParasite = 10f;
    public float m_FactorDamageInZone = 0.5f;

    [Header("Enemy spawn and wave")]
    public GameObject m_EnemyPrefabs;
    public int m_CurrentWave = 1;
    public int m_EnemySpawnedInFirstWave = 4;
    private int CurrentEnemyToSpawn;
    public float m_TimeStartSpawnFirstWave = 8f;
    public float m_TimeBetweenWave = 4f;
    public float m_FactorNumberEnemySpawnedByWave = 1.5f;
    [Space]
    public float m_YOffsetSpawn = 2f;

    private bool SpawnerActive = false;

    private int CurrentItemInWave = 0;
    private float Timer;

    [Header("Gizmos")]
    public bool m_DrawGizmos;

    private float CurrentRadius;
    private float RealRadiusWorld;
    private float MaxTimeInvasion;
    private float MaxHeightTerrain = 100f;

    private List<GameObject> EnemyWave = new List<GameObject>();

    private void Awake()
    {
        if (s_Instance)
        {
            Destroy(gameObject);
        }
        else
        {
            s_Instance = this;
        }
    }
    private void Start()
    {
        MaxTimeInvasion = GameManager.s_Instance.m_MaxTimeInvasion;
        CurrentEnemyToSpawn = m_EnemySpawnedInFirstWave;
    }

    private void Update()
    {
        UpdateZoneParasite();
        UpdateSpawner();
    }

    private void UpdateSpawner()
    {
        if(CurrentItemInWave <= 0)
        {
            Timer += Time.deltaTime;
        }

        if (!SpawnerActive)
        {
            if(Timer >= m_TimeStartSpawnFirstWave)
            {
                Timer = 0f;
                SpawnerActive = true;
            }
        }
        else
        {
            if(Timer >= m_TimeBetweenWave)
            {
                Spawn();
            }
        }
    }

    private void Spawn()
    {
        for (int i = 0; i < CurrentEnemyToSpawn; i++)
        {
            Vector2 posInCircleRadius = Random.insideUnitCircle.normalized * RealRadiusWorld;
            Vector3 positionToSpawn = new Vector3(posInCircleRadius.x, MaxHeightTerrain, posInCircleRadius.y);
            RaycastHit hit;
            if (Physics.Raycast(positionToSpawn, -Vector3.up, out hit, MaxHeightTerrain + 100f))
            {
                positionToSpawn.y = hit.point.y + m_YOffsetSpawn;
            }
            else
            {
                positionToSpawn.y = 0f;
            }
            GameObject enemyInstance = Instantiate(m_EnemyPrefabs, positionToSpawn, transform.rotation, transform);
            EnemyWave.Add(enemyInstance);
            CurrentItemInWave++;
        }
        Timer = 0f;
    }

    private void UpdateZoneParasite()
    {
        float currentTimer = GameManager.s_Instance.CurrentTimerParty;
        float percentRadius = Mathf.Clamp01(1 - (currentTimer / MaxTimeInvasion));

        CurrentRadius = m_Radius * percentRadius;

        if (percentRadius <= 0f)
        {
            GameManager.s_Instance.SwitchState(GameManager.E_State.GameOver);
        }

        Vector3 playerPos = GameManager.s_Instance.m_Player.position;
        float distancePlayerToCenter = Vector3.Distance(playerPos, m_CenterWorld);
        RealRadiusWorld = (CurrentRadius * m_FactorRadiusWorld) + m_OffsetRadiusWorld;
        if (distancePlayerToCenter >= RealRadiusWorld)
        {
            GameManager.s_Instance.PlayerOnEnterInZone();
        }
        else
        {
            GameManager.s_Instance.PlayerOnExitZone();
        }

        UpdateShader();
    }
    private void UpdateShader()
    {
        m_ParasiteMaterial.SetVector("_CenterPosition", m_CenterWorld);
        m_TerrainMaterial.SetVector("_CenterPositionWorld", m_CenterWorld);
        m_ParasiteMaterial.SetFloat("_Radius", CurrentRadius);
        m_TerrainMaterial.SetFloat("_RadiusInfection", CurrentRadius);
    }

    public void RemoveAEnemy(GameObject enemy)
    {
        EnemyWave.Remove(enemy);
        CurrentItemInWave--;
    }

    private void OnDrawGizmosSelected()
    {
        if (m_DrawGizmos)
        {
            Gizmos.color = Color.cyan;
            //Gizmos.DrawSphere(Vector3.zero, (CurrentRadius * m_FactorRadiusWorld) + m_OffsetRadiusWorld);
            Vector3 posLimit = new Vector3(0f,0f, (CurrentRadius * m_FactorRadiusWorld) + m_OffsetRadiusWorld);
            Gizmos.DrawSphere(posLimit, 1f);
        }
    }
}
