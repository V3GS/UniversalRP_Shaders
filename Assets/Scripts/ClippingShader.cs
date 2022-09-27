using UnityEngine;

[ExecuteInEditMode]
public class ClippingShader : MonoBehaviour
{
    [SerializeField]
    private Transform intersectionPlane;
    [SerializeField]
    private Material[] clippingMaterials;

    void Update()
    {
        if (intersectionPlane == null || clippingMaterials.Length == 0)
        {
            Debug.LogWarning("It's necessary to setup the intersection plane and the materials.");
            return;
        }

        for (int i = 0; i < clippingMaterials.Length; i++)
        {
            clippingMaterials[i].SetVector("_PlanePosition", intersectionPlane.position);
            clippingMaterials[i].SetVector("_PlaneNormal", intersectionPlane.forward);
        }
    }
}
