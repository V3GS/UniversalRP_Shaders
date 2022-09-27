using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class VertexDisplacement : MonoBehaviour
{
    private float m_CurrentDisplacementAmount;
    public Material SimpleDisplacementMaterial;

    void Update()
    {
        m_CurrentDisplacementAmount = Mathf.Lerp( m_CurrentDisplacementAmount, 0, Time.deltaTime );

        SimpleDisplacementMaterial.SetFloat("_DisplacementAmount", m_CurrentDisplacementAmount);

        if ( Input.GetKeyDown(KeyCode.Space) )
        {
            m_CurrentDisplacementAmount += 1f;
        }
    }
    
    void OnApplicationQuit()
    {
        SimpleDisplacementMaterial.SetFloat("_DisplacementAmount", 0.0f);
    }
}
