using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BouncingEffect : MonoBehaviour
{
    public LayerMask layerMask;
    [Range(0.0F, 5.0F)]
    public float Radius = 0.0f;
    [Range(0.0F, 1.0F)]
    public float ImpactStrenght = 0.0f;
    public AnimationCurve BounceAnimationCurve;

    private Material m_BouncingMaterial;
    private float m_CurrentTime = 0.0f;
    private Vector3 m_ImpactValue = Vector3.zero; 
    private Vector3 m_CurrentImpactValue = Vector3.zero;

    void Update()
    {
        if ( Input.GetKeyDown(KeyCode.Mouse0) )
        {
            RaycastHit hit;
            Ray ray = Camera.main.ScreenPointToRay( Input.mousePosition );

            if ( Physics.Raycast(ray, out hit, 10, layerMask) )
            {
                m_BouncingMaterial = hit.transform.GetComponent<Renderer>().material;
                
                if (!m_BouncingMaterial)
                {
                    Debug.LogWarning("Please assign a Material to performing this effect.");
                    return;
                }
                
                m_CurrentTime = 0.0f;
                m_ImpactValue = ray.direction * ImpactStrenght;
                
                m_BouncingMaterial.SetVector("_HitPosition", hit.point);
                m_BouncingMaterial.SetFloat("_RadiusEffect", Radius);
            }
        }

        m_CurrentTime += Time.deltaTime;
        m_CurrentImpactValue = m_ImpactValue * BounceAnimationCurve.Evaluate(m_CurrentTime);

        if (m_BouncingMaterial)
        {
            m_BouncingMaterial.SetVector("_HitImpact", m_CurrentImpactValue );
        }
    }
}
