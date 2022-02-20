using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class CanvasManager : MonoBehaviour
{
    public GameObject m_MessageDropEnergy;

    [Header("HUD")]
    public Image m_HealthBar;
    public Image m_ManaBar;
    public Image m_AdvencementLevelBar;
    public Text m_EnergyPickupText;
    public GameObject[] m_LevelTowerImage;
    public GameObject m_WinPanel;
    public GameObject m_GameOverPanel;

    private void Start()
    {
        m_GameOverPanel.SetActive(false);
        m_WinPanel.SetActive(false);
    }
    public void ActiveOrDisableMessageDropEnergy(bool active)
    {
        m_MessageDropEnergy.SetActive(active);
    }

    public void UpdateHealth(float percent)
    {
        m_HealthBar.fillAmount = percent;
    }
    public void UpdateMana(float percent)
    {
        m_ManaBar.fillAmount = percent;
    }
    public void UpdateLevelTower (int level)
    {
        for (int i = 0; i < m_LevelTowerImage.Length; i++)
        {
            if(i <= level)
            {
                m_LevelTowerImage[i].SetActive(true);
            }
            else
            {
                m_LevelTowerImage[i].SetActive(false);
            }
        }
    }
    public void UpdateEnergyPickup(int energy, int max)
    {
        m_EnergyPickupText.text = energy + " / " + max;
    }
    public void UpdateAdvencementLevel(float percent)
    {
        m_AdvencementLevelBar.fillAmount = percent;
    }
    public void ShowGameOver()
    {
        m_GameOverPanel.SetActive(true);
    }
    public void ShowWin()
    {
        m_WinPanel.SetActive(true);
    }
}
