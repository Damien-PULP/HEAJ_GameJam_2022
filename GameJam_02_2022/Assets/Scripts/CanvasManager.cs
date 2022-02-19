using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class CanvasManager : MonoBehaviour
{
    public GameObject m_MessageDropEnergy;
    [Header("HUD")]
    public Image m_HealthBar;
    public Image m_EnergyMana;

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
        m_EnergyMana.fillAmount = percent;
    }
}
