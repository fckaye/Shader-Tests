using UnityEngine;

[ExecuteInEditMode]
public class KYReplacementController : MonoBehaviour
{
    // Replacement shader
    public Shader m_replacementShader;

    private void OnEnable()
    {
        if (m_replacementShader != null)
        {
            // Camera will replace all shaders in the scene
            // with the replacement on render type configuration
            GetComponent<Camera>().SetReplacementShader(m_replacementShader, "RenderType");
        }
    }

    private void OnDisable()
    {
        // Reset the default shader
        GetComponent<Camera>().ResetReplacementShader();
    }
}
