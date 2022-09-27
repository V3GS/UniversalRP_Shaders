using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SinMovement : MonoBehaviour
{
    [SerializeField]
    private float amplitude = 1;
    private Transform m_Transform;
    private Vector3 m_InitialPosition;

    void Start()
    {
        m_Transform = transform;
        m_InitialPosition = m_Transform.position;
    }

    void Update()
    {
        m_Transform.position = m_InitialPosition + new Vector3(0.0f, 0.0f, amplitude * Mathf.Sin(Time.time));
    }
}
