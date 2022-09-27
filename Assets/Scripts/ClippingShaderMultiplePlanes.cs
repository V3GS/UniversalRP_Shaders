using UnityEngine;

[ExecuteInEditMode]
public class ClippingShaderMultiplePlanes : MonoBehaviour
{
    [SerializeField]
    private Transform initialPlanePosition;
    [SerializeField]
    private Transform finalPlanePosition;
    [SerializeField]
    private Material clippingMaterial;

    void Update()
    {
        if (initialPlanePosition == null || finalPlanePosition == null || clippingMaterial == null)
        {
            Debug.LogWarning("It's necessary to setup the intersection planes and material property.");
            return;
        }

        clippingMaterial.SetVector("_InitialPlanePosition", initialPlanePosition.position);
        clippingMaterial.SetVector("_InitialPlaneNormal", initialPlanePosition.forward);

        clippingMaterial.SetVector("_FinalPlanePosition", finalPlanePosition.position);
        clippingMaterial.SetVector("_FinalPlaneNormal", finalPlanePosition.forward);
    }
}