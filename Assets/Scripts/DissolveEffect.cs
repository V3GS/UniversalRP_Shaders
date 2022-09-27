using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DissolveEffect : MonoBehaviour
{
    public Material DissolveMaterial;
    private bool m_Dissolve = true;

    // Start is called before the first frame update
    void Start()
    {
        DissolveMaterial.SetFloat("_Dissolve", m_Dissolve ? 1.0f : 0.0f);
        m_Dissolve = !m_Dissolve;
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            DissolveMaterial.SetFloat("_VFXTime", Time.time);
            DissolveMaterial.SetFloat("_Dissolve", m_Dissolve ? 1.0f : 0.0f);

            m_Dissolve = !m_Dissolve;
        }
    }

    void OnApplicationQuit()
    {
        DissolveMaterial.SetFloat("_VFXTime", 0.0f);
        DissolveMaterial.SetFloat("_Dissolve", 1.0f);
    }
}
