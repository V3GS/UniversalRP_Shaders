using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Rotate : MonoBehaviour
{
    [SerializeField]
    private float rotationSpeed;
    private Transform m_Transform;
    void Start()
    {
        m_Transform = GetComponent<Transform>();
    }

    void Update()
    {
        m_Transform.Rotate(Vector3.up * rotationSpeed * Time.deltaTime, Space.World);
    }
}
