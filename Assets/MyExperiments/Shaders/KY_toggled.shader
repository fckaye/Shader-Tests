Shader "KY/KY_toggled"
{
    Properties
    {
        _Color("Color", Color) = (1,1,1,1)
        // Declare drawer Toggle
        [Toggle] _Enable ("Enable ?", Float) = 0
    }
    SubShader
    {
        Tags {"RenderType" = "Opaque"}
        LOD 100
        
        Pass
        {
            CGPROGRAM

            // Declare pragma
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog
            
            #pragma shader_feature _ENABLE_ON

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o, o.vertex);
                return o;
            }
            
            float4 _Color;

            half4 frag(v2f i) : SV_Target
            {
                half4 col = tex2D(_MainTex, i.uv);
                // Generate condition
                #if _ENABLE_ON
                    return col;
                #else
                    return col * _Color;
                #endif
            }
            ENDCG
        }
    }
}
