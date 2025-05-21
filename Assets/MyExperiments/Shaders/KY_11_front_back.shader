Shader "KY/KY_11_front_back"
{
    Properties
    {
        _FrontTexture("Front Texture", 2D) = "white" {}
        _BackTexture("Back Texture", 2D) = "white" {}
    }
    SubShader
    {
//        Tags { "RenderType"="Opaque" }
        Tags{ "Queue"="Transparent" "RenderType"="Transparent" }
        Blend SrcAlpha OneMinusSrcAlpha
        ZWrite Off
        LOD 100
        Cull Off
        
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

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

            sampler2D _FrontTexture;
            sampler2D _BackTexture;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                    o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i, bool face : SV_IsFrontFace) : SV_Target
            {
                fixed4 colFront = tex2D(_FrontTexture, i.uv);
                fixed4 colBack = tex2D(_BackTexture, i.uv);

                return face ? colFront : colBack;
            }
            ENDCG
        }
    }
}
