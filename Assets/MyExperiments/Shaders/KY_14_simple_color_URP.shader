Shader "KY/KY_01_simple_color"
{
    
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        // Declare inside Properties so that _Color shows up on Unity Editor
        _Color ("Tint", Color) = (1, 1, 1, 1)
        _SecondaryColor("Secondary Color", Color) = (1,1,1,1)
        _SecondaryTexture("Secondary Texture", 2D) = "red" {}
    }
    SubShader
    {
        Tags 
        { 
            "RenderType"="Transparent"
            "Queue"="Transparent"
            "RenderPipeline"="UniversalRenderPipeline"
        }
        Blend SrcAlpha OneMinusSrcAlpha
        LOD 100
        
        Pass
        {
            //Note: No CGPROGRAM, but HLSLPROGRAM
            HLSLPROGRAM
            // Upgrade NOTE: excluded shader from DX11 because it uses wrong array syntax (type[size] name)
            #pragma exclude_renderers d3d11
            // Allows us to use the vertex stage, see around line 50
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "HLSLSupport.cginc"
            
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 normal :  NORMAL;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            // Define 4 dimensions vector with same name as variable inside Properties
            // Now we can connect _Color to things inside shader.
            float4 _Color;

            // This is the stage where verts are projected from 3D to 2D
            // v2f = "vertex to fragment"
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = TransformObjectToHClip(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }
            
            void FakeLight_float(in float3 Normal, out float3 Out)
            {
                float3 operation = Normal;
                Out = operation;
            }

            half3 FakeLight(float3 Normal)
            {
                float3 operation = Normal;
                return operation;
            }

            // Fragment stage: color each individual 2D pixel
            // 2. use function
            fixed4 frag(v2f i) : SV_Target
            {
                // declare normals
                float3 n = i.normal;
                // declare output
                float3 col = 0;
                // pass values as arguments
                FakeLight_float(n, col);

                // return float4(col.rgb, 1);
                
                // old
                fixed4 col2 = tex2D(_MainTex, i.uv);
                // apply fog
                return col2 * _Color;
            }
            ENDHLSL
        }
    }
}
