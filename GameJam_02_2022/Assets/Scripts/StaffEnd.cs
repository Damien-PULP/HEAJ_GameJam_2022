using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StaffEnd : MonoBehaviour
{
    private float Damage;
    private bool Active;

    public void SetStaffEnd(float damage)
    {
        Damage = damage;
    }
    public void ActiveOrDisableStaff(bool active)
    {
        Active = active;
    }
}
