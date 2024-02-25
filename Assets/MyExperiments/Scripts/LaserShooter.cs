using UnityEngine;

public class LaserShooter : MonoBehaviour
{
    [SerializeField] private LineRenderer _lineRenderer;
    [SerializeField] private int BounceTimes = 5;
    private int bounceIndex;
    
    void Update()
    {
        if (Input.GetMouseButtonDown(0))
        {
            bounceIndex = 0;
            _lineRenderer.positionCount = 0;
            ShootLaser(transform.position, Vector3.forward);
        }
    }   

    private void ShootLaser(Vector3 startPos, Vector3 startDir)
    {
        if (bounceIndex >= BounceTimes)
            return;
        
        int layerMask = 1 << 6;
        layerMask = ~layerMask;
        
        RaycastHit hit;
        if (Physics.Raycast(startPos, startDir, out hit, float.MaxValue, layerMask))
        {
            // Draw Line to hit.
            Debug.DrawLine(startPos, hit.point, Color.red, 2f, false);
            Debug.Log($"ID: {bounceIndex}, startPos: {startPos}");
            _lineRenderer.positionCount++;
            _lineRenderer.SetPosition(bounceIndex, startPos);
            
            // Create the reflection vector
            // R = V - 2 (V . N)N
            float dotProduct = (startDir.x * hit.normal.x) + (startDir.y * hit.normal.y) + (startDir.z * hit.normal.z);
            Vector3 vProj = new Vector3(hit.normal.x * dotProduct, hit.normal.y * dotProduct,
                hit.normal.z * dotProduct);
            vProj *= 2;
            Vector3 reflectedRay = startDir - vProj;
            
            bounceIndex++;
            ShootLaser(hit.point, reflectedRay);
        }
        else
        {
            // Draw Ray to infinity
            Debug.DrawRay(startPos, startDir * int.MaxValue, Color.red, 2f, false);
            _lineRenderer.positionCount += 2;
            _lineRenderer.SetPosition(bounceIndex++, startPos);
            _lineRenderer.SetPosition(bounceIndex++, startPos + (startDir * 100));
        }
    }
}
