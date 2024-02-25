using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RadialTrigger : MonoBehaviour
{
    [SerializeField] private Transform pointA;
    [SerializeField] private Transform pointB;
    [SerializeField] private double radius;
    
    private void OnDrawGizmos()
    {
        Gizmos.color = Color.cyan;
        Gizmos.DrawSphere(pointB.position, 1);

        Gizmos.color = new Color(1, 0, 0, 0.2f);
        Gizmos.DrawSphere(pointB.position, float.Parse(radius.ToString()));
        
        bool isInside = CheckForRadius();
        if (isInside)
        {
            Gizmos.color = Color.red;
        }
        else
        {
            Gizmos.color = Color.green;
        }
        Gizmos.DrawSphere(pointA.position, 1);
    }

    private bool CheckForRadius()
    {
        Vector3 posA = pointA.position;
        Vector3 posB = pointB.position;

        Vector3 bToA = posA - posB;
        double distance = Math.Sqrt((bToA.x * bToA.x) + (bToA.y * bToA.y) + (bToA.z * bToA.z));

        double difference = distance - radius;
        int sign = (int)(difference / Math.Abs(difference));

        if (sign == -1 || sign == 0)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
}
