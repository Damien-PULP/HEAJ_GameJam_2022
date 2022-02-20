using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class GameManager : MonoBehaviour
{
    public enum E_State
    {
        Start,
        InGame,
        Paused,
        UpgradeLevel,
        EndGame,
        GameOver
    }
    public E_State m_CurrentState;
    public static GameManager s_Instance;
    [Header("Party Settings")]
    public float m_MaxTimeInvasion = 600f;

    [Header("Party Values")]
    public int m_CurrentLevel;
    public int m_MaxLevel = 6;
    public int m_CurrentAdvencementLevel = 0;
    public int m_CurrentStepAdvencementNextLevel = 500;
    public float m_FactorStepAdvencementLevel = 1.5f;
    public float m_MinDistanceToDropEnergyCollected = 2f;
    public int m_MaxEnergyToTransport = 500;
    public int m_CurrentEnergyCollected = 0;
    public int m_MaxAttackEnemySimultaneous = 2;

    public int CurrentNbEnemyWhyAttack;

    [Header("Player Values")]
    public float m_CurrentHealth = 100f;
    public float m_MaxHealth = 100f;
    public float m_FactorRegenerationHealth = 1.2f;
    [Space]
    public float m_CurrentMana = 100f;
    public float m_MaxMana = 100f;
    public float m_FactorRegenerationMana = 1.2f;
    public float m_DistanceToTowerFactor = 1f;
    public float m_MinDistanceToRegenerateMana = 100f;

    public float m_RestartTime = 3f;
    [Header("Component Required")]
    public TowerOfPower m_TowerOfPower;
    public Transform m_TowerTransform;
    public Transform m_TransformToDropEnergy;
    public Transform m_Player;
    public PlayerMovement m_PlayerMovement;
    public ParasiteAI m_ParasiteAI;
    public CanvasManager m_CanvasManager;

    [HideInInspector]
    public float CurrentTimerParty;

    private bool IsPossibleToDropEnergy;
    private bool IsPlayerInZone;

    private float Timer;


    private void Awake()
    {
        if (s_Instance)
        {
            Destroy(gameObject);
            return;
        }
        else
        {
            s_Instance = this;
        }
        m_CurrentHealth = m_MaxHealth;
    }

    private void Start()
    {
        SwitchState(E_State.Start);
    }
    private void Update()
    {
        CurrentTimerParty += Time.deltaTime;
        UpdateState();
    }

    #region State Methods
    private void UpdateState()
    {
        switch (m_CurrentState)
        {
            case E_State.Start:
                break;
            case E_State.InGame:
                RegenerateHealth();
                RegenerateMana();
                CheckDistanceToDropEnergy();
                CheckIsPlayerInZone();
                break;
            case E_State.Paused:
                break;
            case E_State.UpgradeLevel:
                break;
            case E_State.EndGame:
                RestartGame();
                break;
            case E_State.GameOver:
                RestartGame();
                break;
            default:
                break;
        }
    }
    private void EnterNewState()
    {
        switch (m_CurrentState)
        {
            case E_State.Start:
                m_TowerOfPower.UpdateTower();
                m_CanvasManager.UpdateLevelTower(m_CurrentLevel);
                m_CanvasManager.UpdateAdvencementLevel(0f);
                m_CanvasManager.UpdateEnergyPickup(m_CurrentEnergyCollected, m_MaxEnergyToTransport);
                SwitchState(E_State.InGame);
                break;
            case E_State.InGame:
                break;
            case E_State.Paused:
                break;
            case E_State.UpgradeLevel:
                m_TowerOfPower.UpdateTower();
                SwitchState(E_State.InGame);
                break;
            case E_State.EndGame:
                m_TowerOfPower.UpdateTower();
                m_CanvasManager.ShowWin();
                // END GAME WIN
                break;
            case E_State.GameOver:
                m_PlayerMovement.SwitchState(PlayerMovement.E_State.Dead);
                m_CanvasManager.ShowGameOver();
                break;
            default:
                break;
        }
    }
    private void ExitState()
    {
        switch (m_CurrentState)
        {
            case E_State.Start:
                break;
            case E_State.InGame:
                break;
            case E_State.Paused:
                break;
            case E_State.UpgradeLevel:
                break;
            case E_State.EndGame:
                break;
            case E_State.GameOver:
                break;
            default:
                break;
        }
    }
    public void SwitchState(E_State newState)
    {
        ExitState();
        m_CurrentState = newState;
        EnterNewState();
    }
    #endregion
    #region Level Methods
    public void UpgradeLevel()
    {
        m_CurrentLevel++;
        if(m_CurrentLevel >= m_MaxLevel)
        {
            SwitchState(E_State.EndGame);
        }
        else
        {
            m_CurrentStepAdvencementNextLevel = (int) (m_CurrentStepAdvencementNextLevel * m_FactorStepAdvencementLevel);
            SwitchState(E_State.UpgradeLevel);
        }
        m_CanvasManager.UpdateLevelTower(m_CurrentLevel);
        // CHANGE TOWER
    }
    public bool CollectEnergy(int point)
    {
        if( (m_CurrentEnergyCollected + point) <= m_MaxEnergyToTransport)
        {
            m_CurrentEnergyCollected += point;
            m_CanvasManager.UpdateEnergyPickup(m_CurrentEnergyCollected, m_MaxEnergyToTransport);
            return true;
        }
        else
        {
            // To mutch energy collected
            return false;
        }
    }
    [ContextMenu("ForceAddLevel")]
    public void ForceAddLevel()
    {
        UpgradeLevel();
    }
    public void AddEnergyLevel()
    {
        if (!IsPossibleToDropEnergy) return;

        m_CurrentAdvencementLevel += m_CurrentEnergyCollected;
        m_CurrentEnergyCollected = 0;
        if(m_CurrentAdvencementLevel >= m_CurrentStepAdvencementNextLevel)
        {
            m_CurrentAdvencementLevel -= m_CurrentStepAdvencementNextLevel;
            UpgradeLevel();
        }
        float percentLevel = Mathf.Clamp01(m_CurrentAdvencementLevel / m_CurrentStepAdvencementNextLevel);
        m_CanvasManager.UpdateAdvencementLevel(percentLevel);
        m_CanvasManager.UpdateEnergyPickup(m_CurrentEnergyCollected, m_MaxEnergyToTransport);
    }
    private void CheckDistanceToDropEnergy()
    {
        float distanceToDrop = Vector3.Distance(m_Player.position, m_TransformToDropEnergy.position);
        if(distanceToDrop <= m_MinDistanceToDropEnergyCollected && m_CurrentEnergyCollected > 0f)
        {
            //POSSIBLE TO DROP ENERGY
            IsPossibleToDropEnergy = true;
        }
        else
        {
            IsPossibleToDropEnergy = false;
        }
        m_CanvasManager.ActiveOrDisableMessageDropEnergy(IsPossibleToDropEnergy);
    }
    #endregion
    #region Player Methods
    public void PlayerOnEnterInZone()
    {
        IsPlayerInZone = true;
    }
    public void PlayerOnExitZone()
    {
        IsPlayerInZone = false;
    }
    private void CheckIsPlayerInZone()
    {
        if (IsPlayerInZone)
        {
            ApplyDamage(m_ParasiteAI.m_DamageZoneParasite * m_ParasiteAI.m_FactorDamageInZone * Time.deltaTime);
        }
    }
    public void ApplyDamage(float damage)
    {
        m_CurrentHealth -= damage;
        if(m_CurrentHealth <= 0f)
        {
            m_CurrentHealth = 0f;
            SwitchState(E_State.GameOver);
        }
        else
        {
            m_PlayerMovement.SwitchState(PlayerMovement.E_State.Impacted);
        }
        float percentHealth = Mathf.Clamp01(m_CurrentHealth / m_MaxHealth);
        m_CanvasManager.UpdateHealth(percentHealth);
    }
    public bool UseMana(float power)
    {
        if(m_CurrentMana >= power)
        {
            m_CurrentMana -= power;
            float percentMana = Mathf.Clamp01(m_CurrentMana / m_MaxMana);
            m_CanvasManager.UpdateHealth(percentMana);
            return true;
        }
        else
        {
            return false;
        }
    }
    private void RegenerateHealth()
    {
        if(m_CurrentHealth < m_MaxHealth)
        {
            m_CurrentHealth += Time.deltaTime * m_FactorRegenerationHealth;
        }else if(m_CurrentHealth > m_MaxHealth)
        {
            m_CurrentHealth = m_MaxHealth;
        }
    }
    private void RegenerateMana()
    {
        Vector3 posTower = m_TowerOfPower.transform.position;
        Vector3 posPlayer = m_Player.position;

        float distanceToTower = Vector3.Distance(posTower, posPlayer);

        if(distanceToTower <= m_MinDistanceToRegenerateMana)
        {
            m_DistanceToTowerFactor = 1f -(distanceToTower / m_MinDistanceToRegenerateMana);
        }
        else
        {
            m_DistanceToTowerFactor = 0f;
        }

        if(m_CurrentMana < m_MaxMana)
        {
            m_CurrentMana += Time.deltaTime * m_FactorRegenerationMana * m_DistanceToTowerFactor;
        }
        else if(m_CurrentMana > m_MaxMana)
        {
            m_CurrentMana = m_MaxMana;
        }
    }
    #endregion

    public void IndicEnemyStartAttack()
    {
        CurrentNbEnemyWhyAttack++;
    }
    public void IndicEnemyStopAttack()
    {
        CurrentNbEnemyWhyAttack--;
    }
    public bool CheckIfCanBeAttack()
    {
        if(CurrentNbEnemyWhyAttack < m_MaxAttackEnemySimultaneous)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    public void RestartGame()
    {
        Timer += Time.deltaTime;

        if(Timer >= m_RestartTime)
        {
            SceneManager.LoadScene(1);
        }
        
    }
}
