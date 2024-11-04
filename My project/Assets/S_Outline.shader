Shader "Unlit/S_Outline"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _OutlineSize("Outline Size", Float) = 2.0
        _Color("Outline Color", Color) = (1, 1, 1, 1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            Cull Front
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _OutlineSize;
            float4 _Color;

            v2f vert (appdata v)
            {
                v2f o;
                float3x3 m = unity_ObjectToWorld;
                float3 objectScale = float3(
                    length(float3(m[0][0], m[1][0], m[2][0])),
                    length(float3(m[0][1], m[1][1], m[2][1])),
                    length(float3(m[0][2], m[1][2], m[2][2]))
                );
                float3 outline = _OutlineSize / objectScale;
                float3 scaledOutline = outline * normalize(v.normal);
                float3 centeredOutline = v.vertex + scaledOutline;
                o.vertex = UnityObjectToClipPos(centeredOutline);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return _Color;
            }
            ENDCG
        }
    }
}
