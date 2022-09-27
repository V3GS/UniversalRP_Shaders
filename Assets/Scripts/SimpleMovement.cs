using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SimpleMovement : MonoBehaviour
{
    [SerializeField] private float movementSpeed = 1.0f;
    private Transform m_Transform;
    private Vector3 m_Movement = Vector3.zero;

    void Start()
    {
        m_Transform = GetComponent<Transform>();
    }
    
    void Update()
    {
        Vector3 movementDirection = new Vector3(Input.GetAxis("Horizontal"), 0.0f, Input.GetAxis("Vertical"));
        
        m_Transform.Translate(movementDirection * movementSpeed * Time.deltaTime, Space.Self);
    }
}
